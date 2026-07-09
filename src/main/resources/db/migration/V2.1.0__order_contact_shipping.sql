ALTER TABLE orders
    ADD COLUMN IF NOT EXISTS contact_email       VARCHAR(255),
    ADD COLUMN IF NOT EXISTS contact_first_name  VARCHAR(255),
    ADD COLUMN IF NOT EXISTS contact_last_name   VARCHAR(255),
    ADD COLUMN IF NOT EXISTS shipping_method_id  UUID REFERENCES shipping_methods(id),
    ADD COLUMN IF NOT EXISTS street_address      VARCHAR(500),
    ADD COLUMN IF NOT EXISTS city                VARCHAR(255),
    ADD COLUMN IF NOT EXISTS province            VARCHAR(255),
    ADD COLUMN IF NOT EXISTS postal_code         VARCHAR(20);
