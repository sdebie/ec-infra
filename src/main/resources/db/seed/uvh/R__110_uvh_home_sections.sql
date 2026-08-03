-- =============================================================================
-- R__110_uvh_home_sections — UVH home page section layout
-- =============================================================================
-- Final merged state of legacy V1.0.9 → V2.5.1 (full layout) → V2.8.1
-- (wholesale CTA fix) → V2.9.1 (sale-products section) → testimonials-1
-- (testimonials-management spec) → storefront-commercial-sections spec
-- (recomposition: industry tiles, trust-strip icons, dark testimonials,
-- accreditors eyebrow, hero CTA re-seed) → storefront-conversion-polish
-- (section reorder per Req 6.1, carousel unification Req 12, benefits rewrite
-- Req 1, hero footnote Req 2, CTA band copy Req 1.5, brands minItems Req 6.3,
-- showcase retarget Req 6.2).
--
-- Order (owner-directed 2026-08-03 — Best Sellers and the quote/wholesale band
-- both moved ABOVE Shop by Industry; this NO LONGER matches Req 6.1's stated
-- order, which is superseded):
--   hero → featured-products (Best Sellers) → cta (quote/wholesale band) →
--   promo-grid (Shop by Industry) → benefits (Trust & Reassurance) →
--   sale-products (Specials) → category-showcase ×4 → brands →
--   testimonials → accreditors
-- (Testimonials moved below brands 2026-08-03 so it sits directly above
-- Accreditors — owner directive.)
-- Surfaces alternate down the page: featured light → cta dark → industry light
-- → benefits dark → specials light.
--
-- Benefits (owner-directed 2026-08-02): reverted to the pre-spec four tiles
-- (Delivery / Returns / Secure Payments / Support). This REVERSES the Req 1
-- rewrite. Switched BACK to the dark surface 2026-08-03 (owner directive) —
-- the Req 1 light-surface revert is itself now reverted. ⚠️ The Returns tile
-- promises handling "quickly and fairly" with no published returns policy
-- behind it — see BACKLOG `delivery-and-returns`.
-- Layout (owner directive 2026-08-03): "headingPlacement": "side" puts the
-- heading in a left column at lg+ so the four cards fill the right as a 2×2
-- ("columns": 2) with no dead zone beside a short heading, and "iconTone":
-- "solid" renders the icons in accent-text on a muted accent tile. Both are
-- generic display hints derived from --sf-accent/--sf-accent-text, so any
-- client gets its own brand colour with no client-specific code.
--
-- Carousel unification (Req 12.1a) RELAXED FOR SHOWCASES 2026-08-03 (owner
-- directive): testimonials keeps carouselControls: 'header', but the four
-- category-showcase bands move to 'overlay'. Rationale: a showcase renders its
-- OWN heading above the deck, so its header row could only ever hold two arrow
-- buttons — 68px of chrome per band, ×4 bands. On 'overlay' the arrows ride the
-- deck edges and that row disappears. The bands sit on a client colour gradient
-- rather than the page surface, so a different control treatment reads as part
-- of the band rather than as inconsistency. Mobile is UNCHANGED — the dots +
-- "Swipe to browse" treatment is now requested explicitly by the section
-- (Carousel `mobileControls`) instead of riding on having a header row.
--
-- Showcase deck width (owner directive 2026-08-03): the band now uses the
-- shared Section container (max-w-5xl) so its heading lines up with every other
-- home section instead of starting 112px further left. That leaves 736px beside
-- the 256px image rail, so "columns" drops 4 → 3 and the cards land at ~229px —
-- within 10px of the Best Sellers deck, so the two read as the same card.
--
-- Showcase retarget (Req 6.2) REVERTED 2026-08-02 (owner directive): the fourth
-- showcase is Safety again. Req 6.2's distinct-product-set requirement is
-- therefore NOT met by this seed — PPE and Safety overlap. Retarget to a
-- distinct category (Hospitality artwork was never uploaded) if that matters
-- more than keeping Safety on the homepage.
--
-- Hero (owner directive 2026-08-02): "height": "full" fills the viewport minus
-- the measured announcement bar + header (--sf-chrome-h, StorefrontLayout).
--
-- Hero panel (owner directive 2026-08-03): "contentPanel": true moves the
-- kicker/title/subtitle/CTAs/footnote off the bare photo and into a bounded
-- translucent dark box (55% black + a slight backdrop blur), so text contrast
-- is constant instead of depending on what sits behind any given line.
-- "overlayOpacity" drops 0.55 → 0.25 AT THE SAME TIME and the two must be
-- tuned together: the panel now carries the contrast, so the full-bleed scrim
-- only needs to calm the photo. Left at 0.55 the panel area would compound to
-- ~80% black and the warehouse photo would stop reading through it.
--
-- Industry tiles carry registry icons and "columns": 3 with "rowAlign":
-- "center" (owner directive 2026-08-03), so the five tiles read as 3 + 2 with
-- the short final row centred under the row above. The 'cards' layout wraps
-- with flex, so that centring is the flex line's own behaviour — no per-item
-- grid-column span offset is needed. Below lg the tiles step to 2-up then
-- stack, and the same centring applies to whatever remainder falls out.
--
-- Brands and Accreditors are both light (variant omitted) — owner directive
-- 2026-08-03. The page's last dark band is now the testimonials carousel.
--
-- Benefits rewrite (Req 1): concrete, verifiable commitments — no free-delivery
-- threshold (none exists in the platform), no vague copy.
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
                    "overlayOpacity": 0.25,
                    "contentPanel": true,
                    "contentAlignment": "left",
                    "darkStyle": true,
                    "footnote": [{"text": "Competitive bulk & tender pricing — quotes within 1 business day, held for 7 days."}]
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
                    "columns": 4,
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
                    "columns": 2,
                    "iconPlacement": "inline",
                    "iconTone": "solid",
                    "headingPlacement": "side",
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
                    "columns": 3,
                    "themeColor": "#0EA5E9",
                    "gradient": "linear-gradient(90deg, rgba(14, 165, 233, 1) 0%, rgba(29, 78, 216, 1) 50%, rgba(2, 6, 23, 1) 100%)",
                    "imageUrl": "storefront/medical.png",
                    "carouselControls": "overlay"
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
                    "columns": 3,
                    "themeColor": "#DC2626",
                    "gradient": "linear-gradient(90deg, rgba(220, 38, 38, 1) 0%, rgba(185, 28, 28, 1) 50%, rgba(12, 10, 9, 1) 100%)",
                    "imageUrl": "storefront/ppe.png",
                    "carouselControls": "overlay"
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
                    "columns": 3,
                    "themeColor": "#16A34A",
                    "gradient": "linear-gradient(90deg, rgba(22, 163, 74, 1) 0%, rgba(5, 150, 105, 1) 50%, rgba(2, 6, 23, 1) 100%)",
                    "imageUrl": "storefront/cleaning-equipment.png",
                    "carouselControls": "overlay"
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
                    "columns": 3,
                    "themeColor": "#FACC15",
                    "gradient": "linear-gradient(90deg, rgba(250, 204, 21, 1) 0%, rgba(202, 138, 4, 1) 50%, rgba(12, 10, 9, 1) 100%)",
                    "imageUrl": "storefront/safety-wear-equipment.png",
                    "carouselControls": "overlay"
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
                        { "id": "acc-sabs", "name": "SABS", "logoUrl": "storefront/sabs-logo.png", "url": "https://www.sabs.co.za" },
                        { "id": "acc-sahpra", "name": "SAHPRA", "logoUrl": "storefront/sahpra-logo.png", "url": "https://www.sahpra.org.za" },
                        { "id": "acc-safripol", "name": "Safripol", "logoUrl": "storefront/safripol-logo.png", "url": "https://www.safripol.com" }
                    ]
                }
            }
        ]',
        'Home page section layout and content for UVH storefront')
ON CONFLICT (setting_key) DO UPDATE
    SET setting_value = EXCLUDED.setting_value,
        description   = EXCLUDED.description;
