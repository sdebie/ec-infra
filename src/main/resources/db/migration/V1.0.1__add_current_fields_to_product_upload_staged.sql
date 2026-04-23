-- Add current (live) snapshot fields to product_upload_staged for import comparison
ALTER TABLE product_upload_staged
    ADD COLUMN IF NOT EXISTS current_stock          INTEGER,
    ADD COLUMN IF NOT EXISTS current_images         TEXT,
    ADD COLUMN IF NOT EXISTS current_attributes     TEXT,
    ADD COLUMN IF NOT EXISTS current_name           VARCHAR(255),
    ADD COLUMN IF NOT EXISTS current_description    VARCHAR(255),
    ADD COLUMN IF NOT EXISTS current_short_description VARCHAR(100);

