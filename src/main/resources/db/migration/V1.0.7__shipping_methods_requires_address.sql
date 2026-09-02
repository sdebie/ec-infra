-- Whether a shipping method needs a delivery address.
--
-- Without this the storefront had to guess, and guessed wrong: it inferred "delivers"
-- from base_fee > 0 OR estimated_days not being null/'0', which classifies a free
-- same-day collection method as a delivery. Checkout then showed the address block and
-- made all four fields mandatory, so a customer collecting in store could not complete
-- an order at all.
--
-- DEFAULT TRUE is the fail-safe direction: an unclassified method asks for an address,
-- which is recoverable, rather than silently skipping one that a courier needs.
-- Per-client collection methods are set false by that client's seed.
ALTER TABLE shipping_methods
    ADD COLUMN IF NOT EXISTS requires_address BOOLEAN NOT NULL DEFAULT TRUE;
