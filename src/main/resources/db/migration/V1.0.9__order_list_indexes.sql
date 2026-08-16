-- Indexes the admin order list already assumes it has.
--
-- `OrderRepository.findForAdmin` pages in two queries on purpose: one selects ids so
-- LIMIT/OFFSET are real SQL, the second fetches those ids with their line items. That
-- split is what stops Hibernate paginating a collection fetch in memory. It only pays
-- off if both halves can reach their rows by index, and neither could.
--
-- Measured on a 20 000-order / 160 000-item copy of this schema, one page of the default
-- (unfiltered) list:
--     before   9.215 ms   seq scan of all 160 235 order_items + seq scan of 20 030 orders
--     after    0.089 ms   index scan, 8 items x 10 orders
-- The point is not the ratio, it is the shape: the work stopped growing with the table
-- and started growing with the page.

-- 1. order_items had no index on order_id at all.
--
-- Postgres indexes the referenced side of a foreign key, never the referencing side, so
-- `order_items_order_id_fkey` bought nothing for reads. Every query that fetches an order
-- with its lines was therefore scanning the whole table: the admin list hydrate,
-- `findOrderInfoById` (order detail and every checkout path that loads an order), and
-- `StockRecoveryJob.loadWithLines`, which does it per order every five minutes.
--
-- order_items is also the fastest-growing table in the schema — it grows with lines per
-- order, not with orders — so it was the worst possible table to be scanning.
-- `order_status_history` already had the equivalent index; this closes the gap.
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);

-- 2. The unfiltered list could not use an index for its sort.
--
-- idx_orders_status_created_at is (status, created_at), which needs a status equality to
-- seek. The default view of the order list applies no status filter, so that index cannot
-- serve `order by created_at desc` — confirmed by forcing enable_seqscan = off, which
-- still chose a sequential scan plus a sort. The single most-loaded screen in Order
-- Management was the one case the existing index could not help.
--
-- Deliberately ASC and single-column: Postgres reads a btree backwards, so this serves
-- `order by created_at desc` as an Index Scan Backward (verified in the plan). A DESC
-- index would only matter alongside another column sorted the other way.
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at);

COMMENT ON INDEX idx_order_items_order_id IS
    'Fetching an order with its lines. Without it every such query scans all of order_items.';

COMMENT ON INDEX idx_orders_created_at IS
    'Newest-first paging of the admin order list when no status filter is applied; (status, created_at) cannot seek without one.';

-- Plain CREATE INDEX rather than CONCURRENTLY: this takes a lock that blocks writes to
-- the table for the duration, which is free on today's tables and would not be once the
-- store is live. If either table is ever large when this runs somewhere new, build these
-- concurrently by hand instead — CONCURRENTLY cannot run inside Flyway's transaction.
