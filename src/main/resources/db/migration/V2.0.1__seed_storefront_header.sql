INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
  'storefront.header',
  '{"announcement":{"enabled":false,"text":"","backgroundColor":"#1a1f35","textColor":"#ffffff"}}',
  'Storefront header config — announcement banner'
) ON CONFLICT (setting_key) DO NOTHING;
