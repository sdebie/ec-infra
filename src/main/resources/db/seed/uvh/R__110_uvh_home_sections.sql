-- =============================================================================
-- R__110_uvh_home_sections — UVH home page section layout
-- =============================================================================
-- Seeds: storefront.home_sections
--
-- Technical notes (non-obvious constraints — do not "simplify" without
-- re-checking these):
--   • Hero "overlayStyle": "gradient-left" + "overlayOpacity" must be changed
--     together. The opacity is the leading-edge value of the gradient ramp,
--     not a flat wash — changing one without the other under- or
--     over-darkens the copy area.
--   • Benefits "iconTone": "muted" is required on this dark band. "soft"
--     measures under WCAG AA contrast here (an accent icon on an accent wash
--     over near-black background) — "muted" is the tone that stays legible.
--   • Industry tiles use "columns": 3 with "rowAlign": "center" — the 'cards'
--     layout wraps via flex, so this centres a short final row with no
--     per-item grid-column offset needed.
--   • Section colors are theme-derived (--sf-accent / --sf-accent-text), not
--     hardcoded — this section layout itself carries no client-specific
--     styling, only the JSON content below is client-specific.
--
-- Semantics: ON CONFLICT DO UPDATE — seed-owned key (see R__100 header).
-- =============================================================================

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES ('storefront.home_sections',
        '[
            {
                "id": "hero-1",
                "type": "hero",
                "enabled": true,
                "props": {
                    "kicker": "WHOLESALE & RETAIL SUPPLIER",
                    "title": "UVH Holdings",
                    "height": "full",
                    "subtitle": "Medical, PPE, Cleaning & Equipment, Safety Wear & Equipment, Hospitality, Household, Bulk Paper Products and Automotives — all in one place",
                    "primaryCta": { "label": "Shop Now", "to": "/products" },
                    "secondaryCta": { "label": "Request a Quote", "to": "/quote-request" },
                    "backgroundImageUrl": "storefront/uvh-hero-categories-v3.png",
                    "overlayOpacity": 0.85,
                    "overlayStyle": "gradient-left",
                    "contentAlignment": "left",
                    "darkStyle": true,
                    "footnote": [{"text": "We will beat any price and quote. We will also assist you in all your tender needs! Please note that prices may not be accurate and are subject to change after order completion due to supply chain disruptions in the Middle East driving up supplier prices."}]
                }
            },
            {
                "id": "featured-1",
                "type": "featured-products",
                "enabled": true,
                "props": {
                    "title": "Best Sellers",
                    "eyebrow": "Trending Products",
                    "layout": "carousel",
                    "columns": 5,
                    "badgeLabel": "Best Seller",
                    "limit": 8
                }
            },
            {
                "id": "cta-1",
                "type": "cta",
                "enabled": true,
                "props": {
                    "eyebrow": "Business & Wholesale",
                    "title": "Need a Quote or Buying in Bulk?",
                    "description": "Send us your list and we''ll return tender-ready pricing within 1 business day. We quote at live supplier rates and hold every quote for 7 days — and if you have a better written offer, give us the chance to beat it.",
                    "cta": { "label": "Get a Quote", "to": "/quote-request" },
                    "secondaryCta": { "label": "Apply for a Wholesale Account", "to": "/wholesale-application" },
                    "variant": "dark"
                }
            },
            {
                "id": "industry-1",
                "type": "promo-grid",
                "enabled": true,
                "props": {
                    "eyebrow": "What We Supply",
                    "title": "Shop by Industry",
                    "compact": true,
                    "columns": 3,
                    "rowAlign": "center",
                    "items": [
                        { "id": "industry-ppe", "title": "PPE & Protective Equipment", "description": "Gloves, masks, workwear and protective gear for every industry.", "icon": "hard-hat", "cta": { "label": "Shop PPE", "to": "/products?category=ppe" } },
                        { "id": "industry-medical", "title": "Medical Supplies", "description": "Consumables and equipment for clinics, care and medical practice.", "icon": "stethoscope", "cta": { "label": "Shop Medical", "to": "/products?category=medical" } },
                        { "id": "industry-cleaning", "title": "Cleaning & Equipment", "description": "Chemicals, consumables and equipment for commercial cleaning.", "icon": "spray-can", "cta": { "label": "Shop Cleaning", "to": "/products?category=cleaning-equipment" } },
                        { "id": "industry-safety", "title": "Safety Wear & Equipment", "description": "Compliant safety wear and equipment for site and industry.", "icon": "shield-check", "cta": { "label": "Shop Safety", "to": "/products?category=safety-wear-equipment" } },
                        { "id": "industry-hospitality", "title": "Hospitality", "description": "Supplies for kitchens, catering and front-of-house.", "icon": "utensils", "cta": { "label": "Shop Hospitality", "to": "/products?category=hospitality" } }
                    ]
                }
            },
            {
                "id": "benefits-1",
                "type": "benefits",
                "enabled": true,
                "props": {
                    "columns": 4,
                    "iconPlacement": "inline",
                    "iconTone": "solid",
                    "variant": "dark",
                    "eyebrow": "How We Look After You",
                    "title": "Trust & Reassurance",
                    "subtitle": "Clear communication, secure checkout, and support when you need it.",
                    "items": [
                        { "title": "Delivery", "description": "Delivery areas and lead times vary by product and location.", "icon": "truck" },
                        { "title": "Returns", "description": "We help you handle returns quickly and fairly.", "icon": "package" },
                        { "title": "Secure Payments", "description": "Secure checkout and trusted payment methods.", "icon": "shield-check" },
                        { "title": "Support", "description": "Need help choosing products or ordering in bulk? We can assist.", "icon": "headphones" }
                    ]
                }
            },
            {
                "id": "sale-products-1",
                "type": "sale-products",
                "enabled": true,
                "props": {
                    "title": "Specials",
                    "limit": 8
                }
            },
            {
                "id": "category-showcase-medical",
                "type": "category-showcase",
                "enabled": true,
                "props": {
                    "title": "Medical Supplies",
                    "categorySlug": "medical",
                    "layout": "carousel",
                    "columns": 5,
                    "themeColor": "#0EA5E9",
                    "gradient": "linear-gradient(90deg, rgba(14, 165, 233, 1) 0%, rgba(29, 78, 216, 1) 50%, rgba(2, 6, 23, 1) 100%)",
                    "imageUrl": "storefront/medical.png",
                    "carouselControls": "header"
                }
            },
            {
                "id": "category-showcase-ppe",
                "type": "category-showcase",
                "enabled": true,
                "props": {
                    "title": "PPE & Protective Equipment",
                    "categorySlug": "ppe",
                    "layout": "carousel",
                    "columns": 5,
                    "themeColor": "#DC2626",
                    "gradient": "linear-gradient(90deg, rgba(220, 38, 38, 1) 0%, rgba(185, 28, 28, 1) 50%, rgba(12, 10, 9, 1) 100%)",
                    "imageUrl": "storefront/ppe.png",
                    "carouselControls": "header"
                }
            },
            {
                "id": "category-showcase-cleaning",
                "type": "category-showcase",
                "enabled": true,
                "props": {
                    "title": "Cleaning & Equipment",
                    "categorySlug": "cleaning-equipment",
                    "layout": "carousel",
                    "columns": 5,
                    "themeColor": "#16A34A",
                    "gradient": "linear-gradient(90deg, rgba(22, 163, 74, 1) 0%, rgba(5, 150, 105, 1) 50%, rgba(2, 6, 23, 1) 100%)",
                    "imageUrl": "storefront/cleaning-equipment.png",
                    "carouselControls": "header"
                }
            },
            {
                "id": "category-showcase-safety",
                "type": "category-showcase",
                "enabled": true,
                "props": {
                    "title": "Safety Wear & Equipment",
                    "categorySlug": "safety-wear-equipment",
                    "layout": "carousel",
                    "columns": 5,
                    "themeColor": "#FACC15",
                    "gradient": "linear-gradient(90deg, rgba(250, 204, 21, 1) 0%, rgba(202, 138, 4, 1) 50%, rgba(12, 10, 9, 1) 100%)",
                    "imageUrl": "storefront/safety-wear-equipment.png",
                    "carouselControls": "header"
                }
            },
            {
                "id": "brands-1",
                "type": "brands",
                "enabled": true,
                "props": {
                    "eyebrow": "Brands We Stock",
                    "title": "Trusted Brands",
                    "minItems": 4
                }
            },
            {
                "id": "testimonials-1",
                "type": "testimonials",
                "enabled": true,
                "props": {
                    "variant": "dark",
                    "layout": "carousel",
                    "columns": 3,
                    "eyebrow": "What Our Customers Say",
                    "title": "Real Customer Experiences",
                    "carouselControls": "header"
                }
            },
            {
                "id": "accreditors-1",
                "type": "accreditors",
                "enabled": true,
                "props": {
                    "eyebrow": "Certified & Compliant",
                    "title": "Our Accreditations",
                    "items": [
                        { "id": "acc-sabs", "name": "SABS", "logoUrl": "storefront/sabs-logo-1200x400.png", "url": "https://www.sabs.co.za" },
                        { "id": "acc-sahpra", "name": "SAHPRA", "logoUrl": "storefront/SAHPRA-logo-1200x400.png", "url": "https://www.sahpra.org.za" },
                        { "id": "acc-safripol", "name": "Safripol", "logoUrl": "storefront/Safripol-Logo-1200x400.png", "url": "https://www.safripol.com" }
                    ]
                }
            }
        ]',
        'Home page section layout and content for UVH storefront')
ON CONFLICT (setting_key) DO UPDATE
    SET setting_value = EXCLUDED.setting_value,
        description   = EXCLUDED.description;
