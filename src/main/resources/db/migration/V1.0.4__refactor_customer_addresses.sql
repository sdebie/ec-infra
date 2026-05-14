ALTER TABLE customers
    ADD COLUMN IF NOT EXISTS physical_address_line1 VARCHAR(255),
    ADD COLUMN IF NOT EXISTS physical_address_line2 VARCHAR(255),
    ADD COLUMN IF NOT EXISTS physical_suburb VARCHAR(100),
    ADD COLUMN IF NOT EXISTS physical_city VARCHAR(100),
    ADD COLUMN IF NOT EXISTS physical_province VARCHAR(100),
    ADD COLUMN IF NOT EXISTS physical_postal_code VARCHAR(20),
    ADD COLUMN IF NOT EXISTS postal_address_line1 VARCHAR(255),
    ADD COLUMN IF NOT EXISTS postal_address_line2 VARCHAR(255),
    ADD COLUMN IF NOT EXISTS postal_suburb VARCHAR(100),
    ADD COLUMN IF NOT EXISTS postal_city VARCHAR(100),
    ADD COLUMN IF NOT EXISTS postal_province VARCHAR(100),
    ADD COLUMN IF NOT EXISTS postal_postal_code VARCHAR(20);

-- Backfill new physical/postal columns from legacy customer address fields.
UPDATE customers
SET
    physical_address_line1 = COALESCE(physical_address_line1, address_line_1),
    physical_address_line2 = COALESCE(physical_address_line2, address_line_2),
    physical_city = COALESCE(physical_city, city),
    physical_province = COALESCE(physical_province, province),
    physical_postal_code = COALESCE(physical_postal_code, postal_code),
    postal_address_line1 = COALESCE(postal_address_line1, address_line_1),
    postal_address_line2 = COALESCE(postal_address_line2, address_line_2),
    postal_city = COALESCE(postal_city, city),
    postal_province = COALESCE(postal_province, province),
    postal_postal_code = COALESCE(postal_postal_code, postal_code);

