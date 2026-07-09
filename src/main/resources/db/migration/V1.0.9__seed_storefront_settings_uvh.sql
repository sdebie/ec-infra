-- =============================================================================
-- UVH Holdings — Full deployment seed script
-- =============================================================================
-- Safe to re-run: all inserts use ON CONFLICT DO UPDATE.
-- Run order: after all Flyway migrations have executed.
-- Does NOT seed: products, brands, categories, customers, orders.
-- =============================================================================

-- ─────────────────────────────────────────────────────────────────────────────
-- STOREFRONT CONFIG
-- Fields read by StorefrontConfigResource.applyConfigSection():
--   clientId, clientName, currency, locale, stickyHeader
-- ─────────────────────────────────────────────────────────────────────────────

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
           'storefront.config',
           '{
               "clientId": "uvh",
               "clientName": "UVH Holdings",
               "currency": "ZAR",
               "locale": "en-ZA",
               "stickyHeader": true
           }',
           'Core identity for the UVH storefront'
       )
ON CONFLICT (setting_key) DO UPDATE
    SET setting_value = EXCLUDED.setting_value,
        description   = EXCLUDED.description;

-- ─────────────────────────────────────────────────────────────────────────────
-- BRANDING
-- Fields read by StorefrontConfigResource.applyBranding():
--   name, tagline, logoSrc, logoAlt, logoWidth, logoHeight
-- ─────────────────────────────────────────────────────────────────────────────

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
           'storefront.branding',
           '{
               "name": "UVH Holdings",
               "tagline": "Wholesale and retail supplier for PPE, medical, cleaning, safety, hospitality and household products.",
               "logoSrc": "/static/images/uvh-logo.png",
               "logoAlt": "UVH Holdings logo",
               "logoWidth": 50,
               "logoHeight": 50
           }',
           'Branding and logo for UVH storefront'
       )
ON CONFLICT (setting_key) DO UPDATE
    SET setting_value = EXCLUDED.setting_value,
        description   = EXCLUDED.description;

-- ─────────────────────────────────────────────────────────────────────────────
-- THEME
-- Passed through as-is to the frontend as CSS token values.
-- ─────────────────────────────────────────────────────────────────────────────

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
           'storefront.theme',
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
           'CSS token values for the UVH storefront theme'
       )
ON CONFLICT (setting_key) DO UPDATE
    SET setting_value = EXCLUDED.setting_value,
        description   = EXCLUDED.description;

-- ─────────────────────────────────────────────────────────────────────────────
-- HEADER
-- Passed through as-is. Matches HeaderConfig: { announcement: {...} }
-- ─────────────────────────────────────────────────────────────────────────────

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
           'storefront.header',
           '{
               "announcement": {
                   "enabled": true,
                   "text": "Free delivery on orders over R1 500 — nationwide.",
                   "backgroundColor": "#7a0019",
                   "textColor": "#ffffff"
               }
           }',
           'Header announcement banner for UVH storefront'
       )
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

-- ─────────────────────────────────────────────────────────────────────────────
-- HOME SECTIONS
-- Array passed through by StorefrontConfigResource.applyHomeSections().
-- Only sections with "enabled": true are included in the response.
-- Output: sections[] on StorefrontConfig — must match SectionConfig discriminated union.
-- ─────────────────────────────────────────────────────────────────────────────

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
           'storefront.home_sections',
           '[
               {
                   "id": "hero-1",
                   "type": "hero",
                   "enabled": true,
                   "props": {
                       "title": "South Africa''s Trusted Wholesale Supplier",
                       "subtitle": "PPE, medical, cleaning, safety, hospitality and household products — supplied at competitive wholesale and retail prices.",
                       "primaryCta":   { "label": "Shop Now",   "to": "/products" },
                       "secondaryCta": { "label": "Contact Us", "to": "/contact-us" },
                       "backgroundImageUrl": "/static/images/hero-warehouse.jpg",
                       "overlayOpacity": 0.55,
                       "contentAlignment": "left",
                       "darkStyle": true
                   }
               },
               {
                   "id": "featured-1",
                   "type": "featured-products",
                   "enabled": true,
                   "props": {
                       "title": "Featured Products",
                       "limit": 3
                   }
               },
               {
                   "id": "categories-1",
                   "type": "category-preview",
                   "enabled": true,
                   "props": {
                       "title": "Shop by Category",
                       "subtitle": "Browse our full range of wholesale and retail product lines.",
                       "layout": "tiles",
                       "columns": 4,
                       "items": [
                           { "id": "cat-ppe",         "label": "PPE",                "to": "/products?category=ppe",         "description": "Gloves, masks, coveralls and more" },
                           { "id": "cat-medical",     "label": "Medical",            "to": "/products?category=medical",     "description": "First aid, diagnostics and consumables" },
                           { "id": "cat-cleaning",    "label": "Cleaning & Hygiene", "to": "/products?category=cleaning",    "description": "Industrial and household cleaning supplies" },
                           { "id": "cat-safety",      "label": "Safety",             "to": "/products?category=safety",      "description": "Hard hats, signage, fire safety" },
                           { "id": "cat-hospitality", "label": "Hospitality",        "to": "/products?category=hospitality", "description": "Linen, kitchenware and guest amenities" },
                           { "id": "cat-household",   "label": "Household",          "to": "/products?category=household",   "description": "Everyday home essentials in bulk" }
                       ]
                   }
               },
               {
                   "id": "benefits-1",
                   "type": "benefits",
                   "enabled": true,
                   "props": {
                       "title": "Why Choose UVH Holdings",
                       "items": [
                           { "title": "Nationwide Delivery",       "description": "Fast, reliable delivery to all major centres across South Africa." },
                           { "title": "Wholesale & Retail",        "description": "Competitive pricing for bulk orders — no minimum order quantity required." },
                           { "title": "Dedicated Account Manager", "description": "Registered wholesale customers receive a dedicated account manager." },
                           { "title": "Quality Assured Products",  "description": "All products meet South African quality and safety standards." }
                       ]
                   }
               },
               {
                   "id": "cta-1",
                   "type": "cta",
                   "enabled": true,
                   "props": {
                       "title": "Ready to Place an Order?",
                       "description": "Register as a wholesale customer to unlock bulk pricing and account credit.",
                       "cta": { "label": "Register as Wholesale", "to": "/account/register" }
                   }
               }
           ]',
           'Home page section layout and content for UVH storefront'
       )
ON CONFLICT (setting_key) DO UPDATE
    SET setting_value = EXCLUDED.setting_value,
        description   = EXCLUDED.description;