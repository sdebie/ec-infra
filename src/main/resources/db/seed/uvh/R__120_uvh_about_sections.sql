-- =============================================================================
-- R__120_uvh_about_sections — UVH About page section layout
-- =============================================================================
-- Final merged state of legacy V2.9.7 → V2.9.8 (hero background-image +
-- contentSurface fix) → about-page-presentation spec (alternating rhythm) →
-- owner polish round 2026-07-24 (categories dark w/ images + 4-up, story
-- full-width, products-services icons, why-uvh split into Competitive
-- Advantage + What Makes Us Different, testimonials entry REMOVED — the
-- carousel lives on the home page only).
--
-- Rhythm (owner decision 2026-07-24 final, round 3): alternating end-to-end —
-- dark bands = about-stats, about-core-categories, about-competitive-advantage,
-- about-cta (dark CTA = shared Section frame, compact split row — the accent
-- band read as mismatched); light = story, products-services, why-uvh.
--
-- Imagery: about-story ships text-first — when the operator uploads
-- storefront/uvh-about-story.jpg, re-add "imageUrl" (+ "imagePosition") to
-- about-story props. Core-category tiles reuse the four home-showcase images
-- (verified present in storage).
--
-- Semantics: ON CONFLICT DO UPDATE — seed-owned key (see R__100 header).
-- =============================================================================

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
    'storefront.about_sections',
    '[
        {
            "id": "about-hero",
            "type": "hero",
            "enabled": true,
            "props": {
                "title": "Quality supply. Competitive pricing. Fast fulfilment.",
                "kicker": "ABOUT UVH HOLDINGS",
                "subtitle": "UVH Holdings is a South African supplier focused on importing, procuring, and manufacturing essential business consumables—Personal Protective Equipment (PPE), hygiene and cleaning chemicals, medical disposable products, and sanitizer wipes.",
                "primaryCta": { "label": "Request a quote", "to": "/quote-request" },
                "secondaryCta": { "label": "Browse products", "to": "/products" },
                "backgroundImageUrl": "storefront/uvh-about-us.png",
                "overlayOpacity": 0.55,
                "contentAlignment": "center",
                "contentSurface": "dark"
            }
        },
        {
            "id": "about-stats",
            "type": "stats",
            "enabled": true,
            "props": {
                "variant": "dark",
                "items": [
                    { "value": "48h", "label": "Target fulfilment window (where practical)" },
                    { "value": "SA + Africa", "label": "Nationwide delivery and export support" },
                    { "value": "One supplier", "label": "PPE, cleaning, hygiene, medical consumables" }
                ]
            }
        },
        {
            "id": "about-story",
            "type": "content-split",
            "enabled": true,
            "props": {
                "title": "About UVH Holdings",
                "paragraphs": [
                    "From local businesses to wholesale buyers across Africa, we simplify procurement through a modern e-commerce platform and a hands-on service team—so you can source what you need, place orders quickly, and keep operations running without delays.",
                    "To supply what customers need—when they need it—at the best possible price. Where demand is strong, we manufacture and source at scale to keep stock consistent. Our goal is to fulfil and deliver within 48 hours where practical (subject to stock availability and delivery destination).",
                    "To become the most trusted supplier and manufacturer of PPE, medical disposables, and hygiene products in South Africa—and a preferred partner to wholesalers across Africa.",
                    "We work with trusted suppliers, premium materials, and reliable manufacturing processes to deliver products that meet relevant quality and regulatory expectations.",
                    "We''re a hands-on team focused on quality supply, fast fulfilment, and a smooth buying experience."
                ]
            }
        },
        {
            "id": "about-core-categories",
            "type": "category-preview",
            "enabled": true,
            "props": {
                "title": "Our Core Product Categories",
                "variant": "dark",
                "imagePosition": "left",
                "columns": 2,
                "items": [
                    { "id": "cat-medical", "label": "Medical", "to": "/products?category=medical", "imageSrc": "storefront/medical.png", "description": "Medical disposables and clinic essentials for practices, facilities, and healthcare operations." },
                    { "id": "cat-ppe", "label": "PPE", "to": "/products?category=ppe", "imageSrc": "storefront/ppe.png", "description": "Protection you can rely on—from gloves and masks to workplace PPE for multiple industries." },
                    { "id": "cat-cleaning", "label": "Cleaning & Equipment", "to": "/products?category=cleaning-equipment", "imageSrc": "storefront/cleaning-equipment.png", "description": "Cleaning chemicals, hygiene supplies, and equipment to keep facilities safe and compliant." },
                    { "id": "cat-safety", "label": "Safety Wear & Equipment", "to": "/products?category=safety-wear-equipment", "imageSrc": "storefront/safety-wear-equipment.png", "description": "Workwear and safety equipment designed for tough environments and daily use." }
                ]
            }
        },
        {
            "id": "about-products-services",
            "type": "benefits",
            "enabled": true,
            "props": {
                "title": "Products and Services",
                "iconPlacement": "inline",
                "columns": 2,
                "items": [
                    { "title": "PPE", "icon": "hard-hat", "description": "From masks and gloves to gowns and face shields, our PPE range supports a wide variety of industries and applications—helping teams stay protected and compliant." },
                    { "title": "Hygiene and Cleaning Chemicals", "icon": "spray-can", "description": "We supply effective cleaning chemicals and hygiene products suitable for commercial and industrial environments—designed to help maintain clean, safe, and professional facilities." },
                    { "title": "Medical Disposable Products", "icon": "stethoscope", "description": "We stock medical-grade disposable essentials such as gauze, syringes, gloves, and more—supporting clinics, practices, and healthcare operations." },
                    { "title": "Sanitizer Wipes Manufacturing", "icon": "factory", "description": "UVH Holdings manufactures high-quality sanitizer wipes for convenient on-the-go sanitisation—efficient, practical, and suitable for everyday use." }
                ]
            }
        },
        {
            "id": "about-competitive-advantage",
            "type": "benefits",
            "enabled": true,
            "props": {
                "title": "Competitive Advantage",
                "variant": "dark",
                "items": [
                    { "title": "Quality assurance", "description": "Products go through checks aligned to supplier and industry expectations." },
                    { "title": "Affordability", "description": "Efficient procurement and streamlined operations help keep pricing competitive." },
                    { "title": "One-stop range", "description": "PPE, hygiene, and medical disposables in one place—simplifying buying and reordering." },
                    { "title": "E-commerce platform", "description": "Browse, order, and track efficiently with a user-friendly online store." },
                    { "title": "Nationwide delivery + export", "description": "We deliver across South Africa and support export to selected African countries." }
                ],
                "footnote": [
                    { "text": "If you want to understand delivery timelines and return handling, view our " },
                    { "text": "Delivery and Returns Policy", "to": "/delivery-and-returns" },
                    { "text": "." }
                ]
            }
        },
        {
            "id": "about-why-uvh",
            "type": "benefits",
            "enabled": true,
            "props": {
                "title": "What Makes Us Different",
                "items": [
                    { "title": "Sourcing excellence", "description": "Strong supplier relationships help maintain consistent quality and availability." },
                    { "title": "Manufacturing innovation", "description": "Ongoing investment in processes and capability to meet demand." },
                    { "title": "Wholesale-first service", "description": "Built to support repeat buyers and wholesalers with dependable fulfilment." },
                    { "title": "Customer satisfaction", "description": "Responsive support, practical guidance, and reliable delivery." }
                ],
                "footnote": [
                    { "text": "For wholesale buying and account enquiries, visit our " },
                    { "text": "Wholesale", "to": "/wholesale-application" },
                    { "text": " page or " },
                    { "text": "contact us", "to": "/contact-us" },
                    { "text": "." }
                ]
            }
        },
        {
            "id": "about-cta",
            "type": "cta",
            "enabled": true,
            "props": {
                "title": "Ready to Get Started?",
                "description": "Whether you''re looking for a wholesale partner, need a competitive quote, or want to learn about our delivery and returns policy—we''re here to help.",
                "variant": "dark",
                "cta": { "label": "Request a Quote", "to": "/quote-request" },
                "secondaryLinks": [
                    { "label": "Wholesale enquiries", "to": "/wholesale-application" },
                    { "label": "Delivery & Returns", "to": "/delivery-and-returns" }
                ]
            }
        }
    ]',
    'About page section layout and content for UVH storefront'
)
ON CONFLICT (setting_key) DO UPDATE
    SET setting_value = EXCLUDED.setting_value,
        description   = EXCLUDED.description;
