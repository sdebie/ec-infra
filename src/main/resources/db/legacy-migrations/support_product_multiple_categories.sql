-- Migration to support many-to-many relationship between products and categories

-- Create the join table for product_categories
CREATE TABLE product_categories (
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    PRIMARY KEY (product_id, category_id)
);

-- Migrate existing data from category_id to the new join table
INSERT INTO product_categories (product_id, category_id)
SELECT id, category_id
FROM products
WHERE category_id IS NOT NULL;

-- Drop the old category_id column from products table
ALTER TABLE products DROP COLUMN category_id;

-- Create index for better query performance
CREATE INDEX idx_product_categories_category_id ON product_categories(category_id);
CREATE INDEX idx_product_categories_product_id ON product_categories(product_id);

