INSERT INTO store_settings (setting_key, setting_value, description)
VALUES ('vat_rate_percent', '15', 'Default VAT percentage used for ex-VAT to inc-VAT calculations')
ON CONFLICT (setting_key) DO NOTHING;

