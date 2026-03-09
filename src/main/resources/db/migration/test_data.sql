-- 1. Categories
INSERT INTO categories (id, name, slug) VALUES
                                        ('19766fde-2074-496b-b3b5-732db6a1e759','Microcontrollers', 'microcontrollers'),
                                        ('29766fde-2074-496b-b3b5-732db6a1e759', 'LED Lighting', 'led-lighting'),
                                        ('39766fde-2074-496b-b3b5-732db6a1e759', 'Apparel', 't-shirt');

-- 2. Products
INSERT INTO products (id, category_id, name, description, product_type) VALUES
                                                                        ('16862af0-3943-4055-9164-95f88e5155e4','19766fde-2074-496b-b3b5-732db6a1e759', 'ESP32-C3 Super Mini', 'Ultra-small development board with WiFi and Bluetooth.', 'VARIABLE'),
                                                                        ('26862af0-3943-4055-9164-95f88e5155e4','19766fde-2074-496b-b3b5-732db6a1e759', 'Arduino Nano R3', 'Classic ATmega328P microcontroller for prototyping.', 'SIMPLE'),
                                                                        ('36862af0-3943-4055-9164-95f88e5155e4', '29766fde-2074-496b-b3b5-732db6a1e759', 'COB LED Strip 5m', 'High-density flexible LED strip for seamless lighting.', 'VARIABLE'),
                                                                        ('46862af0-3943-4055-9164-95f88e5155e4','29766fde-2074-496b-b3b5-732db6a1e759', 'LED Power Supply', '12V 60W DC transformer for LED strips.', 'SIMPLE'),
                                                                        ('56862af0-3943-4055-9164-95f88e5155e4','39766fde-2074-496b-b3b5-732db6a1e759', 'Essential Heavyweight Tee', 'A premium 240gsm cotton t-shirt with a relaxed fit. Durable, comfortable, and perfect for everyday wear.', 'VARIABLE');

-- 3. Product Variants (The "Nitty-Gritty")
INSERT INTO product_variants (product_id, sku, stock_quantity, attributes, weight_kg) VALUES
-- ESP32 Variants (Soldered vs Unsoldered)
('16862af0-3943-4055-9164-95f88e5155e4', 'ESP32-C3-PIN', 25, '{"headers": "Soldered"}', 0.02),
('16862af0-3943-4055-9164-95f88e5155e4', 'ESP32-C3-NO-PIN', 50, '{"headers": "None"}', 0.01),

-- Arduino Nano (Simple product, usually 1 variant)
('26862af0-3943-4055-9164-95f88e5155e4', 'ARD-NANO-R3', 15, NULL, 0.05),

-- LED Strip Variants (Warm White vs Cool White)
('36862af0-3943-4055-9164-95f88e5155e4', 'COB-5M-WW', 10, '{"color_temp": "3000K", "color": "Warm White"}', 0.20),
('36862af0-3943-4055-9164-95f88e5155e4', 'COB-5M-CW', 12, '{"color_temp": "6000K", "color": "Cool White"}', 0.20),

-- Power Supply
('46862af0-3943-4055-9164-95f88e5155e4', 'PSU-12V-60W', 8, NULL, 0.45),

-- White Variants
('56862af0-3943-4055-9164-95f88e5155e4', 'UT-TEE-WHT-S', 10, '{"color": "White", "size": "S"}', 0.02),
('56862af0-3943-4055-9164-95f88e5155e4', 'UT-TEE-WHT-M', 15, '{"color": "White", "size": "M"}', 0.02),
('56862af0-3943-4055-9164-95f88e5155e4', 'UT-TEE-WHT-L', 12, '{"color": "White", "size": "L"}', 0.02),
('56862af0-3943-4055-9164-95f88e5155e4', 'UT-TEE-WHT-XL', 5,  '{"color": "White", "size": "XL"}', 0.02),

-- Black Variants
('56862af0-3943-4055-9164-95f88e5155e4', 'UT-TEE-BLK-S', 8,  '{"color": "Black", "size": "S"}', 0.02),
('56862af0-3943-4055-9164-95f88e5155e4', 'UT-TEE-BLK-M', 20, '{"color": "Black", "size": "M"}', 0.02),
('56862af0-3943-4055-9164-95f88e5155e4', 'UT-TEE-BLK-L', 18, '{"color": "Black", "size": "L"}', 0.02),
('56862af0-3943-4055-9164-95f88e5155e4', 'UT-TEE-BLK-XL', 7,  '{"color": "Black", "size": "XL"}', 0.02),

-- Navy Variants
('56862af0-3943-4055-9164-95f88e5155e4', 'UT-TEE-NVY-S', 5,  '{"color": "Navy", "size": "S"}', 0.02),
('56862af0-3943-4055-9164-95f88e5155e4', 'UT-TEE-NVY-M', 12, '{"color": "Navy", "size": "M"}', 0.02),
('56862af0-3943-4055-9164-95f88e5155e4', 'UT-TEE-NVY-L', 10, '{"color": "Navy", "size": "L"}', 0.02),
('56862af0-3943-4055-9164-95f88e5155e4', 'UT-TEE-NVY-XL', 3,  '{"color": "Navy", "size": "XL"}', 0.02),

-- Olive Variants
('56862af0-3943-4055-9164-95f88e5155e4', 'UT-TEE-OLV-S', 6,  '{"color": "Olive", "size": "S"}', 0.02),
('56862af0-3943-4055-9164-95f88e5155e4', 'UT-TEE-OLV-M', 10, '{"color": "Olive", "size": "M"}', 0.02),
('56862af0-3943-4055-9164-95f88e5155e4', 'UT-TEE-OLV-L', 9,  '{"color": "Olive", "size": "L"}', 0.02),
('56862af0-3943-4055-9164-95f88e5155e4', 'UT-TEE-OLV-XL', 4,  '{"color": "Olive", "size": "XL"}', 0.02),

-- Maroon Variants
('56862af0-3943-4055-9164-95f88e5155e4', 'UT-TEE-MRN-S', 4,  '{"color": "Maroon", "size": "S"}', 0.02),
('56862af0-3943-4055-9164-95f88e5155e4', 'UT-TEE-MRN-M', 8,  '{"color": "Maroon", "size": "M"}', 0.02),
('56862af0-3943-4055-9164-95f88e5155e4', 'UT-TEE-MRN-L', 11, '{"color": "Maroon", "size": "L"}', 0.02),
('56862af0-3943-4055-9164-95f88e5155e4', 'UT-TEE-MRN-XL', 2,  '{"color": "Maroon", "size": "XL"}', 0.02);

-- 3a. Variant Prices (Prices for all price types)
-- Get variant IDs dynamically using WITH CTE for all variants
WITH variant_mapping AS (
    SELECT id, sku FROM product_variants
),
base_prices AS (
    -- ESP32 Variants
    SELECT 'ESP32-C3-PIN' as sku, 95.00 as base_price
    UNION ALL SELECT 'ESP32-C3-NO-PIN', 85.00
    -- Arduino Nano
    UNION ALL SELECT 'ARD-NANO-R3', 110.00
    -- LED Strips
    UNION ALL SELECT 'COB-5M-WW', 350.00
    UNION ALL SELECT 'COB-5M-CW', 350.00
    -- Power Supply
    UNION ALL SELECT 'PSU-12V-60W', 220.00
    -- T-Shirt Variants (Regular sizes S, M, L)
    UNION ALL SELECT 'UT-TEE-WHT-S', 250.00
    UNION ALL SELECT 'UT-TEE-WHT-M', 250.00
    UNION ALL SELECT 'UT-TEE-WHT-L', 250.00
    UNION ALL SELECT 'UT-TEE-WHT-XL', 275.00
    UNION ALL SELECT 'UT-TEE-BLK-S', 250.00
    UNION ALL SELECT 'UT-TEE-BLK-M', 250.00
    UNION ALL SELECT 'UT-TEE-BLK-L', 250.00
    UNION ALL SELECT 'UT-TEE-BLK-XL', 275.00
    UNION ALL SELECT 'UT-TEE-NVY-S', 250.00
    UNION ALL SELECT 'UT-TEE-NVY-M', 250.00
    UNION ALL SELECT 'UT-TEE-NVY-L', 250.00
    UNION ALL SELECT 'UT-TEE-NVY-XL', 275.00
    UNION ALL SELECT 'UT-TEE-OLV-S', 250.00
    UNION ALL SELECT 'UT-TEE-OLV-M', 250.00
    UNION ALL SELECT 'UT-TEE-OLV-L', 250.00
    UNION ALL SELECT 'UT-TEE-OLV-XL', 275.00
    UNION ALL SELECT 'UT-TEE-MRN-S', 250.00
    UNION ALL SELECT 'UT-TEE-MRN-M', 250.00
    UNION ALL SELECT 'UT-TEE-MRN-L', 250.00
    UNION ALL SELECT 'UT-TEE-MRN-XL', 275.00
),
price_combinations AS (
    SELECT v.id as variant_id, bp.sku, bp.base_price,
           pc.price_type, pc.multiplier
    FROM variant_mapping v
    JOIN base_prices bp ON v.sku = bp.sku
    CROSS JOIN (
        SELECT 'RETAIL_PRICE' as price_type, 1.0 as multiplier
        UNION ALL SELECT 'RETAIL_SALE_PRICE', 0.9
        UNION ALL SELECT 'WHOLESALE_PRICE', 0.8
        UNION ALL SELECT 'WHOLESALE_SALE_PRICE', 0.7
    ) pc
)
INSERT INTO variant_prices (variant_id, pricetype, price)
SELECT variant_id, price_type, ROUND(base_price * multiplier, 2)
FROM price_combinations;

INSERT INTO product_images (product_id, image_url, is_featured) VALUES
                                                                    ('16862af0-3943-4055-9164-95f88e5155e4', 'https://cdn.example.com/esp32-c3.jpg', TRUE),
                                                                    ('26862af0-3943-4055-9164-95f88e5155e4', 'https://cdn.example.com/arduino-nano.jpg', TRUE),
                                                                    ('36862af0-3943-4055-9164-95f88e5155e4', 'https://cdn.example.com/cob-led.jpg', TRUE),
                                                                    ('46862af0-3943-4055-9164-95f88e5155e4', 'https://cdn.example.com/psu-12v.jpg', TRUE);


INSERT INTO store_settings (setting_key, setting_value, description) VALUES
                                                                         ('site_maintenance_enabled', 'false', 'Toggles maintenance mode overlay on frontend'),
                                                                         ('allow_guest_checkout', 'true', 'Allows users to buy without an account'),
                                                                         ('create_account_post_checkout', 'true', 'Shows password field on Thank You page'),
                                                                         ('payment_methods_allowed', '{
  "IN_STORE": {
    "displayName": "Pay in store",
    "description": "Cash/Card at Pickup",
    "enabled": true
  },
  "PAYFAST": {
    "displayName": "PayFast",
    "description": "Card / Instant EFT / Scan to Pay",
    "enabled": true
  }
}', 'JSON array of active payment gateways'),
                                                                         ('terms_and_conditions_url', '/terms-and-conditions', 'Link to the legal page'),
                                                                         ('store_currency', 'ZAR', 'Base currency for the shop');

-- 5. Shipping Methods
INSERT INTO shipping_methods (id, name, is_active, base_fee, estimated_days) VALUES
                                                                             ('194d9544-b891-4ada-b84f-1c3e3a158ffa', 'In-Store Pickup', true, 0.00, 'Same Day'),
                                                                             ('294d9544-b891-4ada-b84f-1c3e3a158ffa','Standard Courier (National)', true, 115.00, '2-4 Working Days'),
                                                                             ('394d9544-b891-4ada-b84f-1c3e3a158ffa','Express Overnight', true, 250.00, '1 Working Day');

-- 6. Shipping Zones (Specific Country Rules)
-- Assuming Method 2 is Standard Courier
INSERT INTO shipping_zones (shipping_method_id, country_code, additional_fee) VALUES
                                                                                  ('294d9544-b891-4ada-b84f-1c3e3a158ffa', 'ZA', 0.00),   -- No extra fee for South Africa
                                                                                  ('294d9544-b891-4ada-b84f-1c3e3a158ffa', 'NA', 450.00); -- R450 extra for Namibia (International)

