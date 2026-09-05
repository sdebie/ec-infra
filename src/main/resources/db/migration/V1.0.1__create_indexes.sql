-- Supporting indexes for catalogue price ordering.
-- Enables index-only scans on the two correlated subqueries that compute the
-- per-product display-price sort key.

CREATE INDEX IF NOT EXISTS idx_variant_prices_variant_type_price ON variant_prices (variant_id, price_type, price, price_start_date, price_end_date);

CREATE INDEX IF NOT EXISTS idx_product_variants_product_status ON product_variants (product_id, status);

CREATE INDEX IF NOT EXISTS idx_orders_status_created_at ON orders (status, created_at);

CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items (order_id);

CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders (created_at);

COMMENT ON INDEX idx_order_items_order_id IS 'Fetching an order with its lines. Without it every such query scans all of order_items.';

COMMENT ON INDEX idx_orders_created_at IS 'Newest-first paging of the admin order list when no status filter is applied; (status, created_at) cannot seek without one.';

CREATE UNIQUE INDEX IF NOT EXISTS idx_orders_idempotency_key ON orders (idempotency_key) WHERE idempotency_key IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_testimonials_published_sort ON testimonials (is_published, sort_order);
