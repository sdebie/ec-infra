-- =============================================================================
-- V2.9.9 — Remove Specials navigation link
-- =============================================================================
-- Navigation is client configuration, not code. The stored JSON must remain
-- valid JSON; removing an item means removing the whole object, never adding a
-- SQL-style comment inside the JSON value.

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
    'storefront.navigation',
    '{
        "items": [
            { "id": "home",     "label": "Home",       "path": "/",           "external": false, "sortOrder": 0 },
            { "id": "products", "label": "Products",   "path": "/products",   "external": false, "sortOrder": 1 },
            { "id": "about",    "label": "About Us",   "path": "/about-us",   "external": false, "sortOrder": 2 },
            { "id": "contact",  "label": "Contact Us", "path": "/contact-us", "external": false, "sortOrder": 3 }
        ]
    }',
    'Top navigation links for UVH storefront'
)
ON CONFLICT (setting_key) DO UPDATE
    SET setting_value = EXCLUDED.setting_value,
        description   = EXCLUDED.description;
