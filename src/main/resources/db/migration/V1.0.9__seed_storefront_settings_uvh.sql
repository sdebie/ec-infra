-- Storefront config seed for UVH Holdings deployment.
-- Uses INSERT ... ON CONFLICT DO UPDATE so the script is safe to re-run.
-- Column names: setting_key, setting_value, description.

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
    'storefront.config',
    '{
        "slug": "uvh",
        "displayName": "UVH Holdings",
        "locale": "en-ZA",
        "defaultCountryCode": "ZA",
        "stickyHeader": true,
        "productsLabel": "Products"
    }',
    'Core identity for the UVH storefront'
)
ON CONFLICT (setting_key) DO UPDATE
    SET setting_value = EXCLUDED.setting_value,
        description   = EXCLUDED.description;

-- ─────────────────────────────────────────────────
INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
    'storefront.branding',
    '{
        "name": "UVH Holdings",
        "tagline": "Wholesale and retail supplier for PPE, medical, cleaning, safety, hospitality and household products.",
        "logoSrc": "/img/uvh-logo.png",
        "logoAlt": "UVH Holdings logo",
        "logoWidth": 50,
        "logoHeight": 50
    }',
    'Branding and logo for UVH storefront'
)
ON CONFLICT (setting_key) DO UPDATE
    SET setting_value = EXCLUDED.setting_value,
        description   = EXCLUDED.description;

-- ─────────────────────────────────────────────────
INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
    'storefront.theme',
    '{
        "background": "#f3f4f6",
        "panel": "#ffffff",
        "text": "#111111",
        "mutedText": "#666666",
        "accent": "#7a0019",
        "accentText": "#ffffff",
        "border": "#e5e7eb",
        "navBackground": "#111111",
        "navText": "#ffffff",
        "navTextHover": "#7a0019",
        "navBorder": "#1f1f1f",
        "navIconText": "#d4d4d4",
        "navIconTextHover": "#ffffff",
        "surfaceMuted": "#f8fafc",
        "ring": "#7a0019",
        "radius": "1rem",
        "shadowSm": "0 10px 24px -18px rgba(17, 17, 17, 0.45)",
        "shadowLg": "0 26px 50px -30px rgba(17, 17, 17, 0.5)"
    }',
    'CSS token values for the UVH storefront theme'
)
ON CONFLICT (setting_key) DO UPDATE
    SET setting_value = EXCLUDED.setting_value,
        description   = EXCLUDED.description;

-- ─────────────────────────────────────────────────
INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
    'storefront.navigation',
    '{
        "items": [
            { "id": "home",     "label": "Home",       "path": "/",           "external": false, "sortOrder": 0 },
            { "id": "about",    "label": "About Us",   "path": "/about-us",   "external": false, "sortOrder": 1 },
            { "id": "contact",  "label": "Contact Us", "path": "/contact-us", "external": false, "sortOrder": 2 },
            { "id": "products", "label": "Products",   "path": "/products",   "external": false, "sortOrder": 3 }
        ]
    }',
    'Top navigation links for UVH storefront'
)
ON CONFLICT (setting_key) DO UPDATE
    SET setting_value = EXCLUDED.setting_value,
        description   = EXCLUDED.description;

-- ─────────────────────────────────────────────────
INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
    'storefront.footer',
    '{
        "description": "Wholesale & retail supplier of PPE, medical, cleaning, safety, hospitality and household products.",
        "columns": [
            {
                "id": "col-company",
                "heading": "Company",
                "links": [
                    { "id": "home",    "label": "Home",       "path": "/",          "external": false, "sortOrder": 0 },
                    { "id": "about",   "label": "About Us",   "path": "/about-us",  "external": false, "sortOrder": 1 },
                    { "id": "contact", "label": "Contact Us", "path": "/contact-us","external": false, "sortOrder": 2 }
                ]
            },
            {
                "id": "col-shop",
                "heading": "Shop",
                "links": [
                    { "id": "products", "label": "All Products",      "path": "/products",               "external": false, "sortOrder": 0 },
                    { "id": "quote",    "label": "Get A Quote",        "path": "/contact-us",             "external": false, "sortOrder": 1 },
                    { "id": "bulk",     "label": "Wholesale Support",  "path": "/wholesale-application",  "external": false, "sortOrder": 2 }
                ]
            },
            {
                "id": "col-support",
                "heading": "Support",
                "links": [
                    { "id": "whatsapp",    "label": "WhatsApp Us",              "path": "https://wa.me/27768195245",          "external": true, "sortOrder": 0 },
                    { "id": "email-sales", "label": "sales@uvhholdings.co.za",  "path": "mailto:sales@uvhholdings.co.za",     "external": true, "sortOrder": 1 }
                ]
            }
        ],
        "socialLinks": [
            { "id": "instagram", "label": "Instagram", "path": "https://www.instagram.com/uvh_holdings/",               "icon": "instagram" },
            { "id": "facebook",  "label": "Facebook",  "path": "https://www.facebook.com/profile.php?id=61550112646739","icon": "facebook"  }
        ],
        "legalLinks": [
            { "id": "terms",            "label": "Terms & Conditions",       "path": "/terms-and-conditions"         },
            { "id": "privacy",          "label": "Privacy Policy",           "path": "/privacy-policy"               },
            { "id": "delivery-returns", "label": "Delivery & Returns Policy","path": "/delivery-and-returns-policy"  }
        ]
    }',
    'Footer content, columns, social and legal links for UVH storefront'
)
ON CONFLICT (setting_key) DO UPDATE
    SET setting_value = EXCLUDED.setting_value,
        description   = EXCLUDED.description;

-- ─────────────────────────────────────────────────
-- UVH uses a custom home page variant (pages.variants.home = 'uvh-home') so
-- home sections are not used. Seeding an empty array keeps the key present
-- for the admin UI without overriding the custom page.
INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
    'storefront.home_sections',
    '[]',
    'Home page sections for UVH storefront (not used — custom uvh-home page variant is active)'
)
ON CONFLICT (setting_key) DO UPDATE
    SET setting_value = EXCLUDED.setting_value,
        description   = EXCLUDED.description;
