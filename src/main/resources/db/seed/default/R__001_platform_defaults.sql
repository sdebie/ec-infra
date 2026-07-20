-- =============================================================================
-- R__001_platform_defaults — Client-agnostic platform seed
-- =============================================================================
-- Runs on EVERY deployment, before any client seed (repeatable migrations
-- execute in description order: 001_* < 1xx_*).
--
-- Purpose: a database with only db/migration + this file applied must let the
-- application boot and render a generic storefront. Boot-critical keys
-- (verified against StorefrontConfigResource + StorefrontConfigProvider):
--   storefront.config, storefront.branding, storefront.theme,
--   storefront.navigation  — absent rows crash the frontend provider.
--   storefront.home_sections/about_sections/footer/header/contact degrade
--   gracefully but are seeded here so the default store is not blank.
--
-- Semantics: every statement is ON CONFLICT DO NOTHING (or key-absent guarded).
-- This file NEVER overwrites operator- or client-seeded values; client seeds
-- (db/seed/<client>) own their keys via ON CONFLICT DO UPDATE.
-- =============================================================================

-- ── Country & tax ────────────────────────────────────────────────────────────

INSERT INTO country_settings (country_code, country_name, currency_code, locale, decimal_places, is_default, is_active)
VALUES ('ZA', 'South Africa', 'ZAR', 'en-ZA', 2, TRUE, TRUE)
ON CONFLICT (country_code) DO NOTHING;

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES ('store_country_code', 'ZA', 'Default storefront country code used for locale/currency formatting')
ON CONFLICT (setting_key) DO NOTHING;

-- VAT rate as a decimal multiplier (e.g. 0.15 = 15%). TaxService reads the
-- value as a decimal multiplier — no division required.
INSERT INTO store_settings (setting_key, setting_value, description)
VALUES ('vat_rate_percent', '0.15', 'VAT rate as a decimal multiplier (e.g. 0.15 = 15%)')
ON CONFLICT (setting_key) DO NOTHING;

-- ── Payments ─────────────────────────────────────────────────────────────────

-- Read by StorefrontPaymentResource → GET /api/storefront/payment-methods.
-- Value must be a JSON array of payment method keys. Supported: PAYFAST, IN_STORE.
INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
    'payment_methods_allowed',
    '["PAYFAST", "IN_STORE"]',
    'Payment methods available at checkout. PAYFAST redirects to the PayFast hosted payment page. IN_STORE is pay at collection.'
)
ON CONFLICT (setting_key) DO NOTHING;

-- ── Storefront identity (boot-critical) ──────────────────────────────────────

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
    'storefront.config',
    '{
        "clientId": "default",
        "clientName": "Storefront",
        "currency": "ZAR",
        "locale": "en-ZA",
        "stickyHeader": true
    }',
    'Core storefront identity (placeholder — client seed overrides)'
)
ON CONFLICT (setting_key) DO NOTHING;

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
    'storefront.branding',
    '{
        "name": "Storefront",
        "tagline": "Your online store"
    }',
    'Branding placeholder — client seed overrides'
)
ON CONFLICT (setting_key) DO NOTHING;

-- Neutral theme covering every --sf-* token the components consume.
INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
    'storefront.theme',
    '{
        "background":       "#f3f4f6",
        "panel":            "#ffffff",
        "text":             "#111111",
        "mutedText":        "#666666",
        "accent":           "#1f2937",
        "accentText":       "#ffffff",
        "border":           "#e5e7eb",
        "navBackground":    "#111111",
        "navText":          "#ffffff",
        "navTextHover":     "#9ca3af",
        "navBorder":        "#1f1f1f",
        "navIconText":      "#d4d4d4",
        "navIconTextHover": "#ffffff",
        "surfaceMuted":     "#f8fafc",
        "ring":             "#1f2937",
        "radius":           "1rem",
        "shadowSm":         "0 10px 24px -18px rgba(17, 17, 17, 0.45)",
        "shadowLg":         "0 26px 50px -30px rgba(17, 17, 17, 0.5)"
    }',
    'Neutral CSS token values (placeholder — client seed overrides)'
)
ON CONFLICT (setting_key) DO NOTHING;

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
    'storefront.navigation',
    '{
        "items": [
            { "id": "home",     "label": "Home",       "path": "/",           "external": false, "sortOrder": 0 },
            { "id": "products", "label": "Products",   "path": "/products",   "external": false, "sortOrder": 1 },
            { "id": "contact",  "label": "Contact Us", "path": "/contact-us", "external": false, "sortOrder": 2 }
        ]
    }',
    'Top navigation links (placeholder — client seed overrides)'
)
ON CONFLICT (setting_key) DO NOTHING;

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
    'storefront.header',
    '{"announcement":{"enabled":false,"text":"","backgroundColor":"#1a1f35","textColor":"#ffffff"}}',
    'Storefront header config — announcement banner'
)
ON CONFLICT (setting_key) DO NOTHING;

-- Minimal generic home page so a default deployment renders content.
INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
    'storefront.home_sections',
    '[
        {
            "id": "hero-1",
            "type": "hero",
            "enabled": true,
            "props": {
                "title": "Welcome to our store",
                "subtitle": "Browse our full product range at competitive prices.",
                "primaryCta": { "label": "Shop Now", "to": "/products" },
                "contentAlignment": "left"
            }
        },
        {
            "id": "featured-1",
            "type": "featured-products",
            "enabled": true,
            "props": {
                "title": "Featured Products",
                "limit": 8
            }
        }
    ]',
    'Home page sections (placeholder — client seed overrides)'
)
ON CONFLICT (setting_key) DO NOTHING;

-- ── Content pages ────────────────────────────────────────────────────────────

-- Slugs are hard-routed in the frontend (router.tsx): /terms-and-conditions,
-- /privacy-policy, /delivery-and-returns. Rows are seeded with placeholder
-- published content so footer links resolve on a fresh install; operators
-- replace the copy via the admin content editor (draft → publish).
INSERT INTO page_content (slug, title, category, draft_content, published_content, published_at) VALUES
    ('terms-and-conditions', 'Terms & Conditions', 'LEGAL',
     '<p>Placeholder terms and conditions. Replace this content before launch.</p>',
     '<p>Placeholder terms and conditions. Replace this content before launch.</p>',
     now()),
    ('privacy-policy', 'Privacy Policy', 'LEGAL',
     '<p>Placeholder privacy policy. Replace this content before launch.</p>',
     '<p>Placeholder privacy policy. Replace this content before launch.</p>',
     now()),
    ('delivery-and-returns', 'Delivery & Returns', 'LEGAL',
     '<p>Placeholder delivery and returns policy. Replace this content before launch.</p>',
     '<p>Placeholder delivery and returns policy. Replace this content before launch.</p>',
     now())
ON CONFLICT (slug) DO NOTHING;
