-- Supporting indexes for catalogue price ordering (Req 8.2, 8.3).
-- Enables index-only scans on the two correlated subqueries that compute the
-- per-product display-price sort key.

CREATE INDEX IF NOT EXISTS variant_prices_variant_type_price
    ON variant_prices (variant_id, price_type, price, price_start_date, price_end_date);

CREATE INDEX IF NOT EXISTS product_variants_product_status
    ON product_variants (product_id, status);
