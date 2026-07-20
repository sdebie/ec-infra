-- =============================================================================
-- V2.8.1 — Fix wholesale CTA label and link
-- =============================================================================
-- The CTA seeded in V1.0.9 / superseded by V2.5.1 points to /account/register
-- with label "Register as Wholesale". This migration corrects the live row to
-- label "Apply for a wholesaler account" targeting /wholesale-application.
--
-- setting_value is a top-level JSON array of section objects; we rebuild it with
-- jsonb_array_elements + jsonb_agg, rewriting only the cta-1 element.
-- =============================================================================

UPDATE store_settings
SET setting_value = (
    SELECT jsonb_agg(
        CASE
            WHEN elem->>'id' = 'cta-1' THEN jsonb_set(
                jsonb_set(elem, '{props,cta,label}', '"Apply for a wholesaler account"'),
                '{props,cta,to}', '"/wholesale-application"'
            )
            ELSE elem
        END
    )::text
    FROM jsonb_array_elements(setting_value::jsonb) AS elem
)
WHERE setting_key = 'storefront.home_sections';
