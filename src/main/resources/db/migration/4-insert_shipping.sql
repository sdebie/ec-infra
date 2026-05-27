INSERT INTO shipping_methods (name, is_active, base_fee, estimated_days) VALUES
         ('In-Store Pickup', true, 0.00, 'Same Day'),
         ('Standard Courier (National)', true, 115.00, '2-4 Working Days'),
         ('Express Overnight', true, 250.00, '1 Working Day');

-- 3. Shipping Zones (Specific Country Rules)
-- Assuming Method 2 is Standard Courier
INSERT INTO shipping_zones (country_code, additional_fee) VALUES
          ('ZA', 0.00),   -- No extra fee for South Africa
          ('NA', 450.00);
