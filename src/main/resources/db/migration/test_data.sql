-- 1. Categories
INSERT INTO categories (name, slug) VALUES
                                        ('Microcontrollers', 'microcontrollers'),
                                        ('LED Lighting', 'led-lighting');

-- 2. Products
INSERT INTO products (category_id, name, description, product_type) VALUES
                                                                        (1, 'ESP32-C3 Super Mini', 'Ultra-small development board with WiFi and Bluetooth.', 'VARIABLE'),
                                                                        (1, 'Arduino Nano R3', 'Classic ATmega328P microcontroller for prototyping.', 'SIMPLE'),
                                                                        (2, 'COB LED Strip 5m', 'High-density flexible LED strip for seamless lighting.', 'VARIABLE'),
                                                                        (2, 'LED Power Supply', '12V 60W DC transformer for LED strips.', 'SIMPLE');

-- 3. Product Variants (The "Nitty-Gritty")
INSERT INTO product_variants (product_id, sku, price, stock_quantity, attributes, weight_kg) VALUES
-- ESP32 Variants (Soldered vs Unsoldered)
(1, 'ESP32-C3-PIN', 95.00, 25, '{"headers": "Soldered"}', 0.02),
(1, 'ESP32-C3-NO-PIN', 85.00, 50, '{"headers": "None"}', 0.01),

-- Arduino Nano (Simple product, usually 1 variant)
(2, 'ARD-NANO-R3', 110.00, 15, NULL, 0.05),

-- LED Strip Variants (Warm White vs Cool White)
(3, 'COB-5M-WW', 350.00, 10, '{"color_temp": "3000K", "color": "Warm White"}', 0.20),
(3, 'COB-5M-CW', 350.00, 12, '{"color_temp": "6000K", "color": "Cool White"}', 0.20),

-- Power Supply
(4, 'PSU-12V-60W', 220.00, 8, NULL, 0.45);

-- 4. Product Gallery
INSERT INTO product_images (product_id, image_url, is_featured) VALUES
                                                                    (1, 'https://cdn.example.com/esp32-c3.jpg', TRUE),
                                                                    (2, 'https://cdn.example.com/arduino-nano.jpg', TRUE),
                                                                    (3, 'https://cdn.example.com/cob-led.jpg', TRUE),
                                                                    (4, 'https://cdn.example.com/psu-12v.jpg', TRUE);