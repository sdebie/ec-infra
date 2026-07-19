-- =============================================================================
-- Seed enquiryEmail into the existing storefront.contact row
-- =============================================================================
-- Adds enquiryEmail to the storefront.contact JSON so the contact enquiry form
-- has a server-resolved recipient on first deploy.
--
-- Guard: only applies when the key is absent — an operator who has already set
-- enquiryEmail via the admin editor will not have their value overwritten.
--
-- Column type is TEXT holding JSON; cast to jsonb for manipulation, back to text.
--
-- Depends on: V2.9.5__seed_storefront_contact.sql (creates the row)
-- Reserved:   V2.9.2 / V2.9.3 — already applied to the target database; never reuse.
-- =============================================================================

UPDATE store_settings
SET setting_value = (setting_value::jsonb || '{"enquiryEmail":"info@uvhholdings.co.za"}')::text
WHERE setting_key = 'storefront.contact'
  AND NOT (setting_value::jsonb ? 'enquiryEmail');
