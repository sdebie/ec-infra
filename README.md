# ec-infra (Flyway migrations)

This module runs database migrations for the ecommerce platform using Flyway.
You can run it in two ways:

- Option A: Run via Quarkus (best for local dev)
- Option B: Run via Docker Compose (Postgres + Flyway)

## Prerequisites
- Java 21+
- Maven Wrapper (included)
- Docker (only required for Option B, or to run Postgres for Option A)

---

## Option A — Run Flyway via Quarkus (one-shot)
This starts a minimal Quarkus application which invokes Flyway once and then exits.

IntelliJ IDEA: you can simply click the green Run icon in the Maven tool window for the ec-infra module (it uses the default goal quarkus:run). The app will run the migrations once and then quit automatically.

1) Start (or ensure you have) Postgres running locally:

   Using Docker quickly:
   
   ```bash
   docker run --name ecommerce-db \
     -e POSTGRES_USER=postgres \
     -e POSTGRES_PASSWORD=postgres \
     -e POSTGRES_DB=ecommerce_db \
     -p 5432:5432 -d postgres:16
   ```

   Enable pgcrypto if you haven’t yet (needed for gen_random_uuid in migrations):
   
   ```bash
   docker exec -it ecommerce-db psql -U postgres -d ecommerce_db -c "CREATE EXTENSION IF NOT EXISTS pgcrypto;"
   ```

2) Run the app:

   ```bash
   cd ec-infra
   ./mvnw quarkus:run
   ```

   Configuration used (see src/main/resources/application.properties):
   - jdbc: postgresql://localhost:5432/ecommerce_db
   - user: postgres
   - pass: postgres
   - Flyway: migrate-at-start=true, repair-at-start=true

3) Stop when you see that migrations have been applied (CTRL+C). The DB will retain the migrated schema.

---

## Option B — Run via Docker Compose (Postgres + Flyway CLI)
This brings up Postgres and then runs Flyway migrations using the official Flyway image.

1) From the project root or ec-infra folder, run:

   ```bash
   cd ec-infra
   docker compose up --abort-on-container-exit flyway
   ```

   What happens:
   - A Postgres 16 container (ecinfra-postgres) starts and is health-checked.
   - A Flyway container starts after Postgres is healthy and runs the SQL from
     `src/main/resources/db/` (mounted read-only) — schema migrations plus the
     default and client seed locations (see "Directory layout" below).
   - An init script enables `pgcrypto` automatically.

2) Verify the results:
   
   ```bash
   docker logs ecinfra-postgres | tail -n 50
   # or connect and list tables
   docker exec -it ecinfra-postgres psql -U postgres -d ecommerce_db -c "\dt"
   ```

3) Tear down when done:

   ```bash
   docker compose down -v
   ```

---

## Troubleshooting
- Build fails with FormatFlagsConversionMismatchException in BannerProcessor
  - Cause: A custom banner is being formatted with String.format and any stray % characters can break it. Fix: we disabled the custom banner by setting `quarkus.banner.enabled=false` and commenting out `quarkus.banner.path` in `application.properties`. You can re-enable later with a safe banner (escape percent signs as `%%`).
- Quarkus dev mode skipped with warning about "support library"
  - Fixed by configuring the quarkus-maven-plugin to not enforce the build goal. You can now run from IntelliJ using either the Maven goal (defaultGoal quarkus:run) or Quarkus dev without it being skipped.
- gen_random_uuid does not exist
  - Fixed by enabling the `pgcrypto` extension. Compose does this automatically via `initdb/001_pgcrypto.sql`.
- Connection refused / wrong host
  - Option A expects Postgres on localhost:5432. Update `application.properties` or pass `-Dquarkus.datasource.jdbc.url=...` if different.
- Migrations already applied / checksum mismatch
  - Use Flyway repair: with Quarkus, set `quarkus.flyway.repair-at-start=true` (already set). With Flyway CLI you can run `flyway repair` similarly.
- Port 5432 already in use
  - Stop other Postgres or change the published port in docker-compose.yml under the `postgres` service.

---

## Directory layout (since the 2026-07-19 re-baseline)

```
src/main/resources/db/
├── migration/           Versioned schema DDL only. Starts at V1.0.0__initial_schema.sql
│                        (the squashed legacy history). New DDL = V1.0.1, V1.0.2, …
│                        (the legacy archive reuses these numbers — that's fine;
│                        archived files are outside every Flyway location).
├── seed/default/        R__001_platform_defaults.sql — client-agnostic seed. A DB with
│                        only migration/ + this applied must boot the app (generic store).
│                        Semantics: ON CONFLICT DO NOTHING — never overwrites anything.
├── seed/uvh/            R__1xx_uvh_*.sql — UVH Holdings client content (storefront
│                        settings, home/about sections, footer, contact, catalog).
│                        Most keys are seed-owned (ON CONFLICT DO UPDATE); operator-owned
│                        keys (storefront.contact) use DO NOTHING/absent-key guards.
└── legacy-migrations/   The pre-baseline V1.x/V2.x files + loose scripts, kept for
                         reference only. NOT in any Flyway location; never run these.
```

Rules:
- **Seeds are repeatable migrations** (`R__`). They re-run whenever their file checksum
  changes. Number prefixes control order: `001_*` (defaults) before `1xx_*` (client).
- **Editing a seed-owned key's file re-applies it and overwrites manual edits** to that
  key. Operator-editable values must keep DO NOTHING / key-absent guards.
- **A new client = a new `seed/<client>/` directory + a locations override.** No code.
- Per-deployment client selection: override `QUARKUS_FLYWAY_LOCATIONS` (Quarkus runner)
  or `FLYWAY_LOCATIONS` (compose flyway service). Default wiring includes `seed/uvh`.

## Re-baselining an existing database (one-time, per environment)

A database that already carries the legacy V1.x/V2.x `flyway_schema_history` must NOT
replay the consolidated `V1.0.0` — its schema already matches. Cut it over like this:

1) **Verify schema parity first.** Spin up a scratch Postgres, apply the new set
   (`migration/` + both seed dirs), and diff it against the live schema:

   ```bash
   docker run -d --name rebaseline-check -e POSTGRES_DB=ecommerce_db \
     -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -p 5433:5432 postgres:16-alpine
   flyway -url=jdbc:postgresql://localhost:5433/ecommerce_db -user=postgres -password=postgres \
     -schemas=public \
     -locations="filesystem:$(pwd)/src/main/resources/db/migration,filesystem:$(pwd)/src/main/resources/db/seed/default,filesystem:$(pwd)/src/main/resources/db/seed/uvh" \
     -baselineOnMigrate=true -baselineVersion=1.0.0 migrate

   pg_dump -h localhost -p 5433 -U postgres --schema-only ecommerce_db > /tmp/new-baseline.sql
   pg_dump -h <live-host> -U <user> --schema-only ecommerce_db > /tmp/live.sql
   diff <(grep -v '^--' /tmp/live.sql) <(grep -v '^--' /tmp/new-baseline.sql)
   ```

   Only `flyway_schema_history` itself should differ. Any other drift must be resolved
   (as a fix in `V1.0.0` if the baseline is wrong — only while it has not yet been
   applied anywhere — or a correcting statement run on the live DB if the live schema
   is wrong) **before** continuing.

2) **Back up the live DB** (`pg_dump -Fc`). Non-negotiable.

3) **Reset the history table** on the live DB:

   ```sql
   DROP TABLE flyway_schema_history;
   ```

4) **Run the migrator normally** (Quarkus runner or compose). With
   `baseline-on-migrate=true` and `baseline-version=1.0.0` (already configured), Flyway
   sees a non-empty schema without history, writes a baseline marker at 1.0.0, skips
   `V1.0.0__initial_schema.sql`, and applies the repeatable seeds — which are
   gap-filling/no-op against a populated database.

5) **Verify**: `SELECT version, description, success FROM flyway_schema_history;`
   should show the 1.0.0 baseline marker plus one row per `R__` seed, all `success = t`.

Version bookkeeping notes:
- The legacy burned/reserved versions (V2.9.2/V2.9.3 burned, V2.9.4 and V2.6.1
  reserved) are irrelevant after the cutover — the version line restarts at 1.0.0.
  In-flight specs (e.g. `wholesale-application-review-workflow`) must target V1.0.1+.
- If the history table was rewritten by hand (rather than via the baseline flow) and
  the recorded checksum no longer matches the file, run `flyway repair` (the Quarkus
  runner does this automatically via `repair-at-start=true`; the compose Flyway CLI
  does not).
- Never edit `V1.0.0__initial_schema.sql` once it has been applied anywhere.

## Entrypoint class (Quarkus)
- `org.ecommerce.FlywayMain` (annotated with `@QuarkusMain`).
