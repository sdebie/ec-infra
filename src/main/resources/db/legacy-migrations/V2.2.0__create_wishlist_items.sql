CREATE TABLE IF NOT EXISTS customer_wishlist_items (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    variant_id  UUID NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
    created_at  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_customer_variant UNIQUE (customer_id, variant_id)
);

CREATE INDEX IF NOT EXISTS idx_wishlist_customer ON customer_wishlist_items(customer_id);
