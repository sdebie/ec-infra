-- Checkout idempotency (.kiro/specs/checkout-idempotency): a client-generated key
-- that lets a retried POST /api/orders return the order already placed instead of
-- creating a second one and reserving its stock again.

ALTER TABLE orders ADD COLUMN IF NOT EXISTS idempotency_key UUID;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS cart_fingerprint VARCHAR(64);

-- Partial: many orders legitimately carry no key (every order created before this
-- shipped, and any created during the window between the client shipping and the
-- server flipping to required), and a plain UNIQUE would treat every NULL as
-- distinct anyway — being explicit documents that the absence of a key is normal
-- rather than a gap to be backfilled.
CREATE UNIQUE INDEX IF NOT EXISTS ux_orders_idempotency_key
    ON orders (idempotency_key) WHERE idempotency_key IS NOT NULL;
