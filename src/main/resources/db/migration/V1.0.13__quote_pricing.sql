-- Itemized staff-generated pricing for a quote request.
--
-- A quote is priced per line rather than as one lump figure: quoted_amount is the sum of
-- each item's unit_price * quantity at the moment the quote is generated, stored (not
-- recomputed on read) so the figure a customer was actually sent never drifts if a product's
-- price changes afterward — the same "snapshot the money" reasoning as orders'
-- vat_amount/shipping_cost (V1.0.11).
--
-- quoted_by is a real FK, not a display-name string, because it needs to answer "which
-- staff account did this" for accountability, not just render a name in a timeline.

ALTER TABLE quote_requests
    ADD COLUMN IF NOT EXISTS quoted_amount DECIMAL(12,2),
    ADD COLUMN IF NOT EXISTS quoted_notes  TEXT,
    ADD COLUMN IF NOT EXISTS quoted_by     UUID REFERENCES staff_users(id);

ALTER TABLE quote_request_items
    ADD COLUMN IF NOT EXISTS unit_price DECIMAL(12,2);

COMMENT ON COLUMN quote_requests.quoted_amount IS
    'Sum of item unit_price * quantity at generation time. Null until a quote has been sent.';
COMMENT ON COLUMN quote_requests.quoted_notes IS
    'Staff-authored terms shown in the quote email (e.g. validity period, delivery exclusions). Free text, optional.';
COMMENT ON COLUMN quote_requests.quoted_by IS
    'Staff account that generated and sent the quote. Null until sent; never cleared afterward.';
COMMENT ON COLUMN quote_request_items.unit_price IS
    'Per-unit price staff quoted for this line. Null until the parent request has been quoted.';
