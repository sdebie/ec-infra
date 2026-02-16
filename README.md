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
   - A Flyway container starts after Postgres is healthy and runs the SQL migrations from:
     `src/main/resources/db/migration` (mounted read-only into the container).
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

## Where are the migrations?
- `src/main/resources/db/migration/V1.0.0__initial_schema.sql`

## Entrypoint class (Quarkus)
- `org.ecommerce.FlywayMain` (annotated with `@QuarkusMain`).
