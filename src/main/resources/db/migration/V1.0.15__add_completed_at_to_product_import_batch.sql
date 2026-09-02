-- Add completed_at column to product_import_batches table
-- This column tracks when an import batch finishes (successfully or failed)

ALTER TABLE product_import_batches
ADD COLUMN IF NOT EXISTS completed_at TIMESTAMP;
