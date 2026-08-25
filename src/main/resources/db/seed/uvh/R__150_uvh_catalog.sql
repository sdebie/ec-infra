-- =============================================================================
-- R__150_uvh_catalog — UVH brands, categories and shipping
-- =============================================================================
-- Merged from the legacy loose scripts 1-insert_brands.sql,
-- 2-insert_categories.sql, 3-insert_categories_parents.sql and
-- 4-insert_shipping.sql (previously unversioned files Flyway never ran —
-- they were applied by hand).
--
-- Semantics: gap-filling only. Brand/category inserts are ON CONFLICT DO
-- NOTHING; parent mapping is idempotent; shipping inserts are guarded by
-- NOT EXISTS on name. Catalog content (names, logos) is owner-managed via
-- the admin UI after first seed.
--
-- Fix carried in from legacy 4-insert_shipping.sql: shipping_zones rows are
-- now linked to the Standard Courier method — the legacy script inserted
-- them with a NULL shipping_method_id.
-- =============================================================================

-- ── Brands ───────────────────────────────────────────────────────────────────

INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'UNDEFINED', 'UNDEFINED', NULL, '') ON CONFLICT (slug) DO NOTHING;

INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), '3D', '3d', NULL, '/brands/car-wash-auto-detailing-cadillac-escalade-3d-products-car-300x300.jpg') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Bathroom Products', 'bathroom-products', NULL, '/brands/6-300x180.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Catering', 'catering', NULL, '/brands/2-1-300x180.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Cleaning Supplies', 'cleaning-supplies', NULL, '/brands/3-2-300x180.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Cornices', 'cornices', NULL, '/brands/4-300x180.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Dromex', 'dromex', NULL, '/brands/dromex-logo-300x100.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Duraglove', 'duraglove', NULL, '/brands/DuraGlove_logo-300x180.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Durawipe', 'durawipe', NULL, '/brands/5-300x180.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Everest Safety', 'everest-safety', NULL, '/brands/Everest_Safety_Logo-300x180.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Evergreen', 'evergreen', NULL, '/brands/Evergreen-logo-300x59.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'First Aid', 'first-aid', NULL, '/brands/7-300x180.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Golden Hands', 'golden-hands', NULL, '/brands/Golden-Hands-300x112.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Household', 'household', NULL, '/brands/8-300x180.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Hygiene Protection', 'hygiene-protection', NULL, '/brands/9-300x180.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Industrial Cleaning', 'industrial-cleaning', NULL, '/brands/12-300x180.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Kiddies Corner', 'kiddies-corner', NULL, '/brands/10-300x180.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Masks', 'masks', NULL, '/brands/16-300x180.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Medical Disposal', 'medical-disposal', NULL, '/brands/11-300x180.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Nomex', 'nomex', NULL, '/brands/dupont-nomex-logo-png_seeklogo-388698-300x300.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Pinnacle', 'pinnacle', NULL, '/brands/Black-Logo-WEBP-300x135.webp') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Pioneer', 'pioneer', NULL, '/brands/Prioneer-Safety-300x32.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'PPE', 'ppe', NULL, '/brands/14-300x180.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Pride', 'pride', NULL, '/brands/UVH-site-image.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Proflex', 'proflex', NULL, '/brands/UVH-site-image.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Road Equipment', 'road-equipment', NULL, '/brands/13-300x180.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Safety', 'safety', NULL, '/brands/15-300x180.png') ON CONFLICT (slug) DO NOTHING;
INSERT INTO brands (id, name, slug, description, logo_url) VALUES (gen_random_uuid(), 'Superweld', 'superweld', NULL, '/brands/images-1.png') ON CONFLICT (slug) DO NOTHING;
-- ── Categories ───────────────────────────────────────────────────────────────

-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'cleaning-equipment-automotive-cleaning-equipment', 'Automotive', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'automotive-2', 'Automotive', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'roadworks-barriers', 'Barriers', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'bathroom-products', 'Bathroom Products', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'cleaning-equipment-bins', 'Bins', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'storage-bins-bins', 'Bins', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'boots', 'Boots', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'brooms', 'Brooms', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'camping-outdoor', 'Camping', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'household-catering', 'Catering', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'catering-food-products', 'Catering', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'kids-products-catering', 'Catering', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'catering', 'Catering', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'hospitality-hospitality', 'Catering', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'automotive-chemicals', 'Chemicals', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'cleaning-equipment-chemicals', 'Chemicals', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'household-chemicals', 'Chemicals', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'cleaning', 'Cleaning', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'hospitality-cleaning-equipment', 'Cleaning & Equipment', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'cleaning-equipment', 'Cleaning & Equipment', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'household-cleaning-equipment', 'Cleaning & Equipment', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'disposables-cleaning-equipment', 'Cleaning & Equipment', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'automotive-cleaning-accessories', 'Cleaning Accessories', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'cleaning-equipment-equipment', 'Cleaning equipment', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'cleaning-liquid', 'Cleaning Liquid', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'cleaning-safety', 'Cleaning Safety', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'cleaning-supplies-cleaning-equipment', 'Cleaning Supplies', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'automotive-cloths-wipes', 'Cloths & Wipes', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'cleaning-equipment-cloths-wipes', 'Cloths & Wipes', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'cooler-boxes-outdoor', 'Cooler Boxes', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'cornices', 'Cornices', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'cleaning-equipment-dispensers', 'Dispensers', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'disposable-bags', 'Disposable bags', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'disposables', 'Disposables', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'disposables-2', 'Disposables', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'ear-protection-safety-wear-equipment', 'Ear Protection', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'emergency-kits', 'Emergency Kits', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'eye-protection', 'Eye Protection', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'fire-safety-and-protection', 'Fire Safety and Protection', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'safety-equipment-first-aid', 'First Aid', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'first-aid', 'First Aid', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'food-products', 'Food Products', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'foot-protection-workwear-ppe', 'Foot protection', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'ppe-gloves-ppe', 'Gloves', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'gloves-medical', 'Gloves', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'hospitality-gloves', 'Gloves', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'gloves', 'Gloves', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'disposables-gloves', 'Gloves', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'medical-gowns', 'Gowns', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'disposables-gowns', 'Gowns', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'ppe-gowns', 'Gowns', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'gum-boots-workwear-ppe', 'Gum boots', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'gumboots', 'Gumboots', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'hand-cleaner', 'Hand Cleaner', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'hand-cleaner-household-industrial-clearner-cleaning-equipment', 'Hand Cleaner Household Industrial Clearner', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'hand-soap', 'Hand Soap', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'head-protection', 'Head Protection', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'kids-products-hospitality', 'Hospitality', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'hospitality', 'Hospitality', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'household', 'Household', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'household-cleaning-equipment-2', 'Household', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'kids-products-household', 'Household', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'household-2', 'Household', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'hygiene-protection', 'Hygiene Protection', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'cleaning-equipment-industrial-cleaning', 'Industrial Cleaning', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'industrial-cleaning-paper-products', 'Industrial Cleaning', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'industrial-safety', 'Industrial Safety', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'kids-products', 'Kids Products', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'ppe-lab-coats', 'Lab Coats', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'medical-lab-coats', 'Lab Coats', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'lockout-devices', 'Lockout Devices', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'masks', 'Masks', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'disposables-masks', 'Masks', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'hospitality-masks', 'Masks', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'ppe-masks', 'Masks', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'safety-wear-equipment-masks', 'Masks', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'disposable-medical', 'Medical', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'medical-medical', 'Medical', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'medical-ppe-2', 'Medical', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'medical', 'Medical', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'mops', 'Mops', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'nappies', 'Nappies', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'outdoor', 'Outdoor', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'packaging', 'Packaging', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'paper-products', 'Paper Products', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'ppe-medical-2', 'PPE', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'ppe', 'PPE', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'safety-wear-equipment-ppe', 'PPE', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'ppe-ppe', 'PPE', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'workwear-ppe-ppe', 'PPE', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'ppe-ppe-2', 'PPE', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'disposables-ppe', 'PPE', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'automotive-ppe', 'PPE', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'roadworks-safety-ppe', 'PPE', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'hospitality-ppe', 'PPE', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'protective-wear', 'Protective Wear', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'protective-wear-medical', 'Protective Wear', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'automotive-rags', 'Rags', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'rags', 'Rags', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'roadworks-and-safety', 'Roadworks and safety', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'safety', 'Safety', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'ppe-safety-equipment', 'Safety & Equipment', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'safety-equipment-medical', 'Safety & Equipment', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'safety-equipment', 'Safety & Equipment', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'hospitality-safety-workwear', 'Safety & Workwear', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'safety-accessories', 'Safety Accessories', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'safety-boots-workwear-ppe', 'Safety Boots', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'safety-equipment-workwear-ppe', 'Safety Equipment', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'safety-harnesses-safety-wear-equipment', 'Safety Harnesses', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'safety-harnesses', 'Safety Harnesses', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'safety-shoes-workwear-ppe', 'Safety Shoes', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'safety-wear-equipment', 'Safety Wear & Equipment', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'sanitary-pads', 'Sanitary Pads', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'security', 'Security', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'security-accessories', 'Security Accessories', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'security-defence', 'Security Defence', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'security-footwear', 'Security Footwear', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'security-wear', 'Security Wear', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'shade', 'Shade', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'shoes', 'Shoes', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'roadworks-signals', 'Signals', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'roadworks-speed-bumps', 'Speed bumps', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'storage-bins-storage', 'Storage', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'storage-bins', 'Storage & Bins', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'household-storage-bins', 'Storage & Bins', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'hospitality-storage-bins', 'Storage & Bins', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'household-storage-bins-household-2', 'Storage & Bins', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'tool-boxes', 'Tool Boxes', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'kids-products-toys', 'Toys', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'roadworks-traffic-safety', 'Traffic Safety', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'uncategorized', 'Uncategorized', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'waste-bins', 'Waste Bins', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'workwear', 'Workwear', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'workwear-security', 'Workwear', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'workwear-ppe-2', 'Workwear', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'workwear-medical', 'Workwear', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
-- INSERT INTO categories (id, slug, name, description, parent_id) VALUES (gen_random_uuid(), 'workwear-ppe', 'Workwear & PPE', NULL, NULL) ON CONFLICT (slug) DO NOTHING;
--
-- -- ── Category parent mapping ──────────────────────────────────────────────────
--
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'cleaning-equipment') WHERE slug = 'cleaning-equipment-automotive-cleaning-equipment';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'roadworks-and-safety') WHERE slug = 'roadworks-barriers';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'paper-products') WHERE slug = 'bathroom-products';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'cleaning-equipment') WHERE slug = 'cleaning-equipment-bins';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'storage-bins') WHERE slug = 'storage-bins-bins';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'workwear-ppe') WHERE slug = 'boots';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'cleaning') WHERE slug = 'brooms';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'outdoor') WHERE slug = 'camping-outdoor';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'household-2') WHERE slug = 'household-catering';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'food-products') WHERE slug = 'catering-food-products';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'kids-products') WHERE slug = 'kids-products-catering';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'paper-products') WHERE slug = 'catering';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'hospitality') WHERE slug = 'hospitality-hospitality';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'automotive-2') WHERE slug = 'automotive-chemicals';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'cleaning-equipment') WHERE slug = 'cleaning-equipment-chemicals';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'household-2') WHERE slug = 'household-chemicals';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'hospitality') WHERE slug = 'hospitality-cleaning-equipment';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'household-2') WHERE slug = 'household-cleaning-equipment';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'disposables-2') WHERE slug = 'disposables-cleaning-equipment';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'automotive-2') WHERE slug = 'automotive-cleaning-accessories';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'cleaning-equipment') WHERE slug = 'cleaning-equipment-equipment';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'cleaning') WHERE slug = 'cleaning-liquid';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'cleaning') WHERE slug = 'cleaning-safety';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'cleaning-equipment') WHERE slug = 'cleaning-supplies-cleaning-equipment';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'automotive-2') WHERE slug = 'automotive-cloths-wipes';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'cleaning-equipment') WHERE slug = 'cleaning-equipment-cloths-wipes';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'outdoor') WHERE slug = 'cooler-boxes-outdoor';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'household-2') WHERE slug = 'cornices';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'cleaning-equipment') WHERE slug = 'cleaning-equipment-dispensers';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'packaging') WHERE slug = 'disposable-bags';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'ppe') WHERE slug = 'disposables';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'safety-wear-equipment') WHERE slug = 'ear-protection-safety-wear-equipment';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'fire-safety-and-protection') WHERE slug = 'emergency-kits';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'safety-wear-equipment') WHERE slug = 'eye-protection';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'safety-equipment') WHERE slug = 'safety-equipment-first-aid';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'medical') WHERE slug = 'first-aid';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'workwear-ppe') WHERE slug = 'foot-protection-workwear-ppe';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'ppe') WHERE slug = 'ppe-gloves-ppe';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'medical') WHERE slug = 'gloves-medical';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'hospitality') WHERE slug = 'hospitality-gloves';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'workwear-ppe') WHERE slug = 'gloves';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'disposables-2') WHERE slug = 'disposables-gloves';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'medical') WHERE slug = 'medical-gowns';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'disposables-2') WHERE slug = 'disposables-gowns';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'ppe') WHERE slug = 'ppe-gowns';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'workwear-ppe') WHERE slug = 'gum-boots-workwear-ppe';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'workwear-ppe') WHERE slug = 'gumboots';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'cleaning') WHERE slug = 'hand-cleaner';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'cleaning-equipment') WHERE slug = 'hand-cleaner-household-industrial-clearner-cleaning-equipment';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'medical') WHERE slug = 'hand-soap';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'safety-wear-equipment') WHERE slug = 'head-protection';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'kids-products') WHERE slug = 'kids-products-hospitality';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'paper-products') WHERE slug = 'household';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'cleaning-equipment') WHERE slug = 'household-cleaning-equipment-2';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'kids-products') WHERE slug = 'kids-products-household';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'cleaning-equipment') WHERE slug = 'cleaning-equipment-industrial-cleaning';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'paper-products') WHERE slug = 'industrial-cleaning-paper-products';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'lockout-devices') WHERE slug = 'industrial-safety';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'ppe') WHERE slug = 'ppe-lab-coats';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'medical') WHERE slug = 'medical-lab-coats';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'workwear-ppe') WHERE slug = 'masks';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'disposables-2') WHERE slug = 'disposables-masks';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'hospitality') WHERE slug = 'hospitality-masks';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'ppe') WHERE slug = 'ppe-masks';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'safety-wear-equipment') WHERE slug = 'safety-wear-equipment-masks';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'disposables-2') WHERE slug = 'disposable-medical';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'medical') WHERE slug = 'medical-medical';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'ppe') WHERE slug = 'medical-ppe-2';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'cleaning') WHERE slug = 'mops';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'hygiene-protection') WHERE slug = 'nappies';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'medical') WHERE slug = 'ppe-medical-2';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'safety-wear-equipment') WHERE slug = 'safety-wear-equipment-ppe';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'ppe') WHERE slug = 'ppe-ppe';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'workwear-ppe') WHERE slug = 'workwear-ppe-ppe';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'ppe') WHERE slug = 'ppe-ppe-2';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'disposables-2') WHERE slug = 'disposables-ppe';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'automotive-2') WHERE slug = 'automotive-ppe';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'roadworks-and-safety') WHERE slug = 'roadworks-safety-ppe';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'hospitality') WHERE slug = 'hospitality-ppe';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'workwear-ppe') WHERE slug = 'protective-wear';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'medical') WHERE slug = 'protective-wear-medical';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'automotive-2') WHERE slug = 'automotive-rags';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'cleaning') WHERE slug = 'rags';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'safety-equipment') WHERE slug = 'safety';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'ppe') WHERE slug = 'ppe-safety-equipment';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'medical') WHERE slug = 'safety-equipment-medical';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'hospitality') WHERE slug = 'hospitality-safety-workwear';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'safety-wear-equipment') WHERE slug = 'safety-accessories';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'workwear-ppe') WHERE slug = 'safety-boots-workwear-ppe';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'workwear-ppe') WHERE slug = 'safety-equipment-workwear-ppe';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'safety-wear-equipment') WHERE slug = 'safety-harnesses-safety-wear-equipment';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'safety-wear-equipment') WHERE slug = 'safety-harnesses';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'workwear-ppe') WHERE slug = 'safety-shoes-workwear-ppe';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'hygiene-protection') WHERE slug = 'sanitary-pads';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'security') WHERE slug = 'security-accessories';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'security') WHERE slug = 'security-defence';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'security') WHERE slug = 'security-footwear';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'security') WHERE slug = 'security-wear';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'outdoor') WHERE slug = 'shade';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'workwear-ppe') WHERE slug = 'shoes';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'roadworks-and-safety') WHERE slug = 'roadworks-signals';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'roadworks-and-safety') WHERE slug = 'roadworks-speed-bumps';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'storage-bins') WHERE slug = 'storage-bins-storage';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'household-cleaning-equipment-2') WHERE slug = 'household-storage-bins';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'hospitality') WHERE slug = 'hospitality-storage-bins';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'household-2') WHERE slug = 'household-storage-bins-household-2';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'cleaning-equipment') WHERE slug = 'tool-boxes';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'kids-products') WHERE slug = 'kids-products-toys';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'roadworks-and-safety') WHERE slug = 'roadworks-traffic-safety';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'medical') WHERE slug = 'waste-bins';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'workwear-ppe') WHERE slug = 'workwear';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'security') WHERE slug = 'workwear-security';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'ppe') WHERE slug = 'workwear-ppe-2';
-- UPDATE categories SET parent_id = (SELECT id FROM categories WHERE slug = 'medical') WHERE slug = 'workwear-medical';
-- -- ── Shipping methods & zones ─────────────────────────────────────────────────

INSERT INTO shipping_methods (id, name, is_active, base_fee, estimated_days, requires_address)
SELECT gen_random_uuid(), v.name, v.is_active, v.base_fee, v.estimated_days, v.requires_address
FROM (VALUES
    ('In-Store Pickup',             true,   0.00, 'Same Day',        false),
    ('Standard Courier (National)', true, 115.00, '2-4 Working Days', true),
    ('Express Overnight',           true, 250.00, '1 Working Day',    true)
) AS v(name, is_active, base_fee, estimated_days, requires_address)
WHERE NOT EXISTS (SELECT 1 FROM shipping_methods m WHERE m.name = v.name);

-- The INSERT above only fires for methods that do not exist yet, so it cannot correct
-- rows seeded before requires_address existed. Whether a method is collection or delivery
-- is client configuration, so it is seed-owned and re-asserted here on every checksum
-- change — restricted to the three seeded names, leaving any method staff added alone.
UPDATE shipping_methods SET requires_address = false WHERE name = 'In-Store Pickup';
UPDATE shipping_methods SET requires_address = true
WHERE name IN ('Standard Courier (National)', 'Express Overnight');

INSERT INTO shipping_zones (id, shipping_method_id, country_code, additional_fee)
SELECT gen_random_uuid(),
       (SELECT id FROM shipping_methods WHERE name = 'Standard Courier (National)'),
       v.country_code, v.additional_fee
FROM (VALUES
    ('ZA',   0.00), -- No extra fee for South Africa
    ('NA', 450.00)
) AS v(country_code, additional_fee)
WHERE NOT EXISTS (SELECT 1 FROM shipping_zones z WHERE z.country_code = v.country_code);
