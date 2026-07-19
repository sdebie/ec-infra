-- =============================================================================
-- V2.9.0 — Add Specials nav link to storefront navigation
-- =============================================================================
-- Adds a "/specials" link to the top navigation, positioned after Products.
-- Uses INSERT ... ON CONFLICT DO UPDATE (idempotent) to rewrite the full
-- storefront.navigation JSON with the new item included.
--
-- Since V1.0.9 already seeded storefront.navigation and Flyway won't re-run
-- applied migrations, this migration updates the live row directly.
-- =============================================================================

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
    'storefront.navigation',
    '{
        "items": [
            { "id": "home",     "label": "Home",       "path": "/",           "external": false, "sortOrder": 0 },
            { "id": "products", "label": "Products",   "path": "/products",   "external": false, "sortOrder": 1 },
            { "id": "nav-specials", "label": "Specials", "path": "/specials", "external": false, "sortOrder": 2 },
            { "id": "about",    "label": "About Us",   "path": "/about-us",   "external": false, "sortOrder": 3 },
            { "id": "contact",  "label": "Contact Us", "path": "/contact-us", "external": false, "sortOrder": 4 }
        ]
    }',
    'Top navigation links for UVH storefront'
)
ON CONFLICT (setting_key) DO UPDATE
    SET setting_value = EXCLUDED.setting_value,
        description   = EXCLUDED.description;
