-- Trigram indexes for the admin product search (ProductRepository.findAdminProductPage /
-- findProductIdsMatchingSearch).
--
-- The search predicate is `LOWER(name) LIKE '%term%'` / `LOWER(sku) LIKE '%term%'` — a
-- leading wildcard, which a plain btree index cannot serve at all (a btree can only seek
-- a known prefix). Every search was therefore a full sequential scan of both products and
-- product_variants, on every keystroke, regardless of how selective the term was: a search
-- matching one row cost the same as a search matching thousands, because the whole table
-- is read either way.
--
-- pg_trgm's GIN operator class is what makes an unanchored substring match indexable at
-- all. The indexed expressions are `lower(name)` / `lower(sku)`, matching the query
-- exactly — Postgres will not use an expression index unless the indexed expression is
-- textually the same as what the query computes.
--
-- These indexes alone are not sufficient. The original query combined both halves as
-- `LOWER(name) LIKE :search OR EXISTS (SELECT 1 FROM product_variants ... LIKE :search)` —
-- Postgres cannot push an index scan through one branch of an OR when the other branch is
-- a correlated subquery against a different table, so that shape kept sequentially
-- scanning products regardless of any index on name (verified directly: with both indexes
-- in place, the unrewritten query still chose a full seq scan of products; only the
-- variant-SKU subplan sped up, since it is independently planned). ProductRepository's
-- search now resolves matching ids via two separate single-table queries instead, each a
-- simple predicate either index can serve directly.
--
-- Measured on a 20 000-product / 40 000-variant synthetic catalogue, a term matching a
-- single row:
--     before (no index)                    ~12 ms, full seq scan of both tables
--     after index only, query unchanged    ~31 ms — WORSE: same seq scan on products,
--                                           plus the added cost of building the now-indexed
--                                           SKU subplan up front
--     after index + query rewrite         <0.3 ms, index scan on both tables
-- The middle row is the reason both halves of this change ship together — an index that
-- the query can't reach is not a fix.
CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX IF NOT EXISTS idx_products_name_trgm
    ON products USING gin (lower(name) gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_product_variants_sku_trgm
    ON product_variants USING gin (lower(sku) gin_trgm_ops);

COMMENT ON INDEX idx_products_name_trgm IS
    'Admin product search by name — a leading-wildcard LIKE cannot use a btree, only a trigram GIN index.';

COMMENT ON INDEX idx_product_variants_sku_trgm IS
    'Admin product search by SKU — same leading-wildcard constraint as idx_products_name_trgm; the existing unique btree on sku only serves exact-match lookups.';

-- Plain CREATE INDEX rather than CONCURRENTLY: this takes a lock that blocks writes to
-- both tables for the duration, which is free on today's catalogues and would not be once
-- a client's store is live with a large one. If either table is ever large when this runs
-- somewhere new, build these concurrently by hand instead — CONCURRENTLY cannot run inside
-- Flyway's transaction.
