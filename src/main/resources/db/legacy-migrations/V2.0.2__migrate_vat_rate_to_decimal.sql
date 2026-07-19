-- Convert vat_rate_percent from integer percent ('15') to decimal multiplier ('0.15').
-- Key name is unchanged. TaxService reads the value as a decimal multiplier — no division required.
UPDATE store_settings
SET setting_value = '0.15',
    description   = 'VAT rate as a decimal multiplier (e.g. 0.15 = 15%)'
WHERE setting_key = 'vat_rate_percent';
