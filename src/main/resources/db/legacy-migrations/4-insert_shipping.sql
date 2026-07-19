INSERT INTO shipping_methods (id, name, is_active, base_fee, estimated_days)
VALUES (gen_random_uuid(), 'In-Store Pickup', true, 0.00, 'Same Day'),
       (gen_random_uuid(), 'Standard Courier (National)', true, 115.00, '2-4 Working Days'),
       (gen_random_uuid(), 'Express Overnight', true, 250.00, '1 Working Day');

-- 3. Shipping Zones (Specific Country Rules)
-- Assuming Method 2 is Standard Courier
INSERT INTO shipping_zones (id, country_code, additional_fee)
VALUES (gen_random_uuid(), 'ZA', 0.00), -- No extra fee for South Africa
       (gen_random_uuid(), 'NA', 450.00);
