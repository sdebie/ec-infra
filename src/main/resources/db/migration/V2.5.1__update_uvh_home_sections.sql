-- =============================================================================
-- V2.5.1 — Update UVH home sections layout
-- =============================================================================
-- Replaces the placeholder home sections (V1.0.9) with the full UVH layout.
-- Drops the old `category-preview` section and adds:
--   - 4 × `category-showcase` (Medical, PPE, Cleaning, Safety)
--   - `accreditors` (SABS, SAHPRA, Safripol)
--   - `brands` (fetches live from brands table)
-- Idempotent: uses ON CONFLICT DO UPDATE.
-- =============================================================================

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
                "primaryCta": { "label": "Shop Now", "to": "/products" },
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
                "limit": 8
            }
        },
        {
            "id": "brands-1",
            "type": "brands",
            "enabled": true,
            "props": {
                "heading": "Our Brands"
            }
        },
        {
            "id": "benefits-1",
            "type": "benefits",
            "enabled": true,
            "props": {
                "title": "Why Choose UVH Holdings",
                "items": [
                    { "title": "Nationwide Delivery", "description": "Fast, reliable delivery to all major centres across South Africa." },
                    { "title": "Wholesale & Retail", "description": "Competitive pricing for bulk orders — no minimum order quantity required." },
                    { "title": "Dedicated Account Manager", "description": "Registered wholesale customers receive a dedicated account manager." },
                    { "title": "Quality Assured Products", "description": "All products meet South African quality and safety standards." }
                ]
            }
        },
        {
            "id": "category-showcase-medical",
            "type": "category-showcase",
            "enabled": true,
            "props": {
                "title": "Medical Supplies",
                "categorySlug": "medical",
                "themeColor": "#0EA5E9",
                "gradient": "linear-gradient(90deg, rgba(14, 165, 233, 1) 0%, rgba(29, 78, 216, 1) 50%, rgba(2, 6, 23, 1) 100%)"
            }
        },
        {
            "id": "category-showcase-ppe",
            "type": "category-showcase",
            "enabled": true,
            "props": {
                "title": "PPE & Protective Equipment",
                "categorySlug": "ppe",
                "themeColor": "#DC2626",
                "gradient": "linear-gradient(90deg, rgba(220, 38, 38, 1) 0%, rgba(185, 28, 28, 1) 50%, rgba(12, 10, 9, 1) 100%)"
            }
        },
        {
            "id": "category-showcase-cleaning",
            "type": "category-showcase",
            "enabled": true,
            "props": {
                "title": "Cleaning & Equipment",
                "categorySlug": "cleaning-equipment",
                "themeColor": "#16A34A",
                "gradient": "linear-gradient(90deg, rgba(22, 163, 74, 1) 0%, rgba(5, 150, 105, 1) 50%, rgba(2, 6, 23, 1) 100%)"
            }
        },
        {
            "id": "category-showcase-safety",
            "type": "category-showcase",
            "enabled": true,
            "props": {
                "title": "Safety Wear & Equipment",
                "categorySlug": "safety-wear-equipment",
                "themeColor": "#FACC15",
                "gradient": "linear-gradient(90deg, rgba(250, 204, 21, 1) 0%, rgba(202, 138, 4, 1) 50%, rgba(12, 10, 9, 1) 100%)"
            }
        },
        {
            "id": "accreditors-1",
            "type": "accreditors",
            "enabled": true,
            "props": {
                "items": [
                    { "id": "acc-sabs", "name": "SABS", "logoUrl": "accreditors/sabs-logo.png", "url": "https://www.sabs.co.za" },
                    { "id": "acc-sahpra", "name": "SAHPRA", "logoUrl": "accreditors/sahpra-logo.png", "url": "https://www.sahpra.org.za" },
                    { "id": "acc-safripol", "name": "Safripol", "logoUrl": "accreditors/safripol-logo.png", "url": "https://www.safripol.com" }
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
