-- The admin order-detail breakdown was live-recomputing VAT and shipping cost from
-- CURRENT settings instead of showing what was actually charged, so subtotal + VAT +
-- shipping could silently stop summing to the grand total sitting beside them the moment
-- the VAT rate or a shipping method's fee changed after the order was placed. Persisting
-- both at the two points an order is priced (creation, and repricing once a delivery
-- method is chosen) lets the admin detail read them back rather than re-deriving them.
--
-- Nullable: every order placed before this migration carries neither figure, and there is
-- no historical record to backfill them from — the admin detail falls back to a live
-- estimate for those rows only.

ALTER TABLE orders ADD COLUMN IF NOT EXISTS vat_amount DECIMAL(12, 2);
ALTER TABLE orders ADD COLUMN IF NOT EXISTS shipping_cost DECIMAL(12, 2);
