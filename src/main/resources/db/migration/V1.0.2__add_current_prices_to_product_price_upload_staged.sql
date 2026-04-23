-- Add current (live) price snapshot fields to product_price_upload_staged for import comparison
ALTER TABLE product_price_upload_staged
    ADD COLUMN IF NOT EXISTS current_retail_price    DECIMAL(12, 2),
    ADD COLUMN IF NOT EXISTS current_wholesale_price DECIMAL(12, 2);

