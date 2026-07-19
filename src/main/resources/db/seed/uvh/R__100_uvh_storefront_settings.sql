-- =============================================================================
-- R__100_uvh_storefront_settings — UVH Holdings storefront identity
-- =============================================================================
-- Seeds: storefront.config, storefront.branding, storefront.theme,
--        storefront.header, storefront.navigation
-- Merged from legacy V1.0.9 + V2.9.0/V2.9.9 (Specials nav link added then
-- removed — net zero; final navigation matches the original V1.0.9 items).
--
-- Semantics: ON CONFLICT DO UPDATE — these keys are SEED-OWNED. Editing this
-- file changes its checksum and Flyway re-applies it, overwriting any manual
-- edits to these keys. Operator-owned keys (storefront.contact) live in
-- R__140 with DO NOTHING guards instead.
-- =============================================================================

-- ─────────────────────────────────────────────────────────────────────────────
-- STOREFRONT CONFIG
-- Fields read by StorefrontConfigResource.applyConfigSection():
--   clientId, clientName, currency, locale, stickyHeader
-- ─────────────────────────────────────────────────────────────────────────────

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES ('storefront.config',
        '{
            "clientId": "uvh",
            "clientName": "UVH Holdings",
            "currency": "ZAR",
            "locale": "en-ZA",
            "stickyHeader": true
        }',
        'Core identity for the UVH storefront')
ON CONFLICT (setting_key) DO UPDATE
    SET setting_value = EXCLUDED.setting_value,
        description   = EXCLUDED.description;

-- ─────────────────────────────────────────────────────────────────────────────
-- BRANDING
-- Fields read by StorefrontConfigResource.applyBranding():
--   name, tagline, logoSrc, logoAlt, logoWidth, logoHeight
-- ─────────────────────────────────────────────────────────────────────────────

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES ('storefront.branding',
        '{
            "name": "UVH Holdings",
            "tagline": "Wholesale and retail supplier for PPE, medical, cleaning, safety, hospitality and household products.",
            "logoSrc": "storefront/uvh-logo.png",
            "logoAlt": "UVH Holdings logo",
            "logoWidth": 50,
            "logoHeight": 50
        }',
        'Branding and logo for UVH storefront')
ON CONFLICT (setting_key) DO UPDATE
    SET setting_value = EXCLUDED.setting_value,
        description   = EXCLUDED.description;

-- ─────────────────────────────────────────────────────────────────────────────
-- THEME
-- Passed through as-is to the frontend as CSS token values.
-- ─────────────────────────────────────────────────────────────────────────────

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES ('storefront.theme',
        '{
            "background":       "#f3f4f6",
            "panel":            "#ffffff",
            "text":             "#111111",
            "mutedText":        "#666666",
            "accent":           "#7a0019",
            "accentText":       "#ffffff",
            "border":           "#e5e7eb",
            "navBackground":    "#111111",
            "navText":          "#ffffff",
            "navTextHover":     "#7a0019",
            "navBorder":        "#1f1f1f",
            "navIconText":      "#d4d4d4",
            "navIconTextHover": "#ffffff",
            "surfaceMuted":     "#f8fafc",
            "ring":             "#7a0019",
            "radius":           "1rem",
            "shadowSm":         "0 10px 24px -18px rgba(17, 17, 17, 0.45)",
            "shadowLg":         "0 26px 50px -30px rgba(17, 17, 17, 0.5)"
        }',
        'CSS token values for the UVH storefront theme')
ON CONFLICT (setting_key) DO UPDATE
    SET setting_value = EXCLUDED.setting_value,
        description   = EXCLUDED.description;

-- ─────────────────────────────────────────────────────────────────────────────
-- HEADER
-- Passed through as-is. Matches HeaderConfig: { announcement: {...} }
-- ─────────────────────────────────────────────────────────────────────────────

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES ('storefront.header',
        '{
            "announcement": {
                "enabled": true,
                "text": "Free delivery on orders over R1 500 — nationwide.",
                "backgroundColor": "#7a0019",
                "textColor": "#ffffff"
            }
        }',
        'Header announcement banner for UVH storefront')
ON CONFLICT (setting_key) DO UPDATE
    SET setting_value = EXCLUDED.setting_value,
        description   = EXCLUDED.description;

-- ─────────────────────────────────────────────────────────────────────────────
-- NAVIGATION
-- Fields read by StorefrontConfigResource.applyNavigation():
--   items[].id, items[].label, items[].path, items[].external, items[].sortOrder
-- Output: nav[] on StorefrontConfig
-- ─────────────────────────────────────────────────────────────────────────────

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES ('storefront.navigation',
        '{
            "items": [
                { "id": "home",     "label": "Home",       "path": "/",           "external": false, "sortOrder": 0 },
                { "id": "products", "label": "Products",   "path": "/products",   "external": false, "sortOrder": 1 },
                { "id": "about",    "label": "About Us",   "path": "/about-us",   "external": false, "sortOrder": 2 },
                { "id": "contact",  "label": "Contact Us", "path": "/contact-us", "external": false, "sortOrder": 3 }
            ]
        }',
        'Top navigation links for UVH storefront')
ON CONFLICT (setting_key) DO UPDATE
    SET setting_value = EXCLUDED.setting_value,
        description   = EXCLUDED.description;

