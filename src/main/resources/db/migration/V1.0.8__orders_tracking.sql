-- Courier tracking for a dispatched order.
--
-- The in-transit notification exists to hand the shopper a tracking reference; without
-- somewhere to record one it can only say "it is on its way", which is the least useful
-- version of that email. Staff enter these when they mark an order shipped.
--
-- Both nullable: an order is only tracked once it leaves, collection orders never are,
-- and a courier that issues no reference is a real case rather than a data error.

ALTER TABLE orders
    ADD COLUMN IF NOT EXISTS tracking_number  VARCHAR(100),
    ADD COLUMN IF NOT EXISTS tracking_carrier VARCHAR(100);

COMMENT ON COLUMN orders.tracking_number IS
    'Courier consignment reference, recorded when the order is marked IN_TRANSIT. Null until then, and for collection orders.';

COMMENT ON COLUMN orders.tracking_carrier IS
    'Which courier is carrying the order, so the shopper knows whose tracking reference they hold.';
