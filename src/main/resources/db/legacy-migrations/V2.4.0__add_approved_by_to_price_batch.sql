ALTER TABLE product_price_upload_batches ADD COLUMN approved_by UUID REFERENCES staff_users(id);
