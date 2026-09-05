-- Renames the CSV-upload-era batch/staged tables to the "import" naming used
-- now that batches can come from a file upload or a Sage sync, and records
-- which source produced each batch.

ALTER TABLE product_upload_batches RENAME TO product_import_batches;
ALTER TABLE product_upload_staged RENAME TO product_import_staged;
ALTER TABLE product_price_upload_batches RENAME TO product_price_import_batches;
ALTER TABLE product_price_upload_staged RENAME TO product_price_import_staged;

ALTER TABLE product_import_batches ADD COLUMN type VARCHAR(20) NOT NULL DEFAULT 'FILE';
ALTER TABLE product_price_import_batches ADD COLUMN type VARCHAR(20) NOT NULL DEFAULT 'FILE';
