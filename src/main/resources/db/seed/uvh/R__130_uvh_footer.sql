-- =============================================================================
-- R__130_uvh_footer — UVH storefront footer
-- =============================================================================
-- From legacy V2.5.0. Key format notes:
--   • columns[].links[].path  → remapped to .to  by applyFooter()
--   • socialLinks[].path      → remapped to .to  by applyFooter()
--   • legalLinks[].path       → remapped to .to  by applyFooter()
--   • calloutHeading/calloutBody removed (2026-08-02) — footer contact block takes that position
--
-- Semantics: ON CONFLICT DO UPDATE — seed-owned key (see R__100 header).
-- =============================================================================

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
    'storefront.footer',
    '{
        "description": "Wholesale and retail supplier for PPE, medical, cleaning, safety, hospitality and household products.",
        "columns": [
            {
                "heading": "Products",
                "links": [
                    { "id": "fc-ppe",         "label": "PPE",                "path": "/products?category=ppe",         "external": false },
                    { "id": "fc-medical",     "label": "Medical",            "path": "/products?category=medical",     "external": false },
                    { "id": "fc-cleaning",    "label": "Cleaning & Hygiene", "path": "/products?category=cleaning",    "external": false },
                    { "id": "fc-safety",      "label": "Safety",             "path": "/products?category=safety",      "external": false },
                    { "id": "fc-hospitality", "label": "Hospitality",        "path": "/products?category=hospitality", "external": false },
                    { "id": "fc-household",   "label": "Household",          "path": "/products?category=household",   "external": false }
                ]
            },
            {
                "heading": "Company",
                "links": [
                    { "id": "fc-about",     "label": "About Us",          "path": "/about-us",              "external": false },
                    { "id": "fc-contact",   "label": "Contact Us",        "path": "/contact-us",            "external": false },
                    { "id": "fc-quote",     "label": "Request a Quote",   "path": "/quote-request",         "external": false },
                    { "id": "fc-wholesale", "label": "Wholesale Applications", "path": "/wholesale-application", "external": false }
                ]
            },
            {
                "heading": "Legal",
                "links": [
                    { "id": "fc-privacy",  "label": "Privacy Policy",       "path": "/privacy-policy",       "external": false },
                    { "id": "fc-terms",    "label": "Terms & Conditions",   "path": "/terms-and-conditions", "external": false },
                    { "id": "fc-delivery", "label": "Delivery & Returns",   "path": "/delivery-and-returns", "external": false }
                ]
            }
        ],
        "socialLinks": [
            { "id": "sl-facebook",  "label": "Facebook",  "icon": "facebook",  "path": "https://www.facebook.com/uvhholdings",          "external": true },
            { "id": "sl-instagram", "label": "Instagram", "icon": "instagram", "path": "https://www.instagram.com/uvhholdings",         "external": true },
            { "id": "sl-linkedin",  "label": "LinkedIn",  "icon": "linkedin",  "path": "https://www.linkedin.com/company/uvh-holdings", "external": true }
        ],
        "legalLinks": [
            { "id": "ll-privacy",  "label": "Privacy Policy",     "path": "/privacy-policy",       "external": false },
            { "id": "ll-terms",    "label": "Terms & Conditions", "path": "/terms-and-conditions", "external": false },
            { "id": "ll-delivery", "label": "Delivery & Returns", "path": "/delivery-and-returns", "external": false }
        ]
    }',
    'Footer content and navigation for UVH storefront'
)
ON CONFLICT (setting_key) DO UPDATE
    SET setting_value = EXCLUDED.setting_value,
        description   = EXCLUDED.description;
