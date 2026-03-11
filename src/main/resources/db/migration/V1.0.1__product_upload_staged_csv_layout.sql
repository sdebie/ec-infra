-- Align staged import table with CSV layout:
-- sku,name,category_slug,brand_slug,retail_price,wholesale_price,stock,images,attributes

-- Preserve existing staged category data by renaming when possible.
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'product_upload_staged' AND column_name = 'category_name'
    )
    AND NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'product_upload_staged' AND column_name = 'category_slug'
    ) THEN
        ALTER TABLE product_upload_staged RENAME COLUMN category_name TO category_slug;
    END IF;
END $$;

ALTER TABLE product_upload_staged
    ADD COLUMN IF NOT EXISTS category_slug VARCHAR(255),
    ADD COLUMN IF NOT EXISTS brand_slug VARCHAR(255),
    ADD COLUMN IF NOT EXISTS stock INTEGER,
    ADD COLUMN IF NOT EXISTS images TEXT,
    ADD COLUMN IF NOT EXISTS attributes TEXT;

ALTER TABLE product_upload_staged
    DROP COLUMN IF EXISTS retail_sale_price,
    DROP COLUMN IF EXISTS wholesale_sale_price,
    DROP COLUMN IF EXISTS category_name;

