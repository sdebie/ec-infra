-- Add status column to products table
ALTER TABLE products ADD COLUMN status VARCHAR(20) DEFAULT 'ACTIVE';

-- Add status column to product_variants table
ALTER TABLE product_variants ADD COLUMN status VARCHAR(20) DEFAULT 'ACTIVE';

-- Create indexes on status columns for query performance
CREATE INDEX idx_products_status ON products(status);
CREATE INDEX idx_product_variants_status ON product_variants(status);

