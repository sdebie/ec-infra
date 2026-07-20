-- =============================================================================
-- R__140_uvh_contact — UVH contact details (OPERATOR-OWNED)
-- =============================================================================
-- Merged from legacy V2.9.5 (contact row) + V2.9.6 (enquiryEmail backfill).
--
-- Semantics: unlike the other UVH seeds, this key is operator-owned — admins
-- edit contact details in the admin UI. Both statements below only fill gaps:
--   • INSERT ... DO NOTHING: never overwrites an existing row.
--   • UPDATE: only adds enquiryEmail when the key is absent from the JSON.
-- =============================================================================

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
    'storefront.contact',
    '{"emails":["info@uvhholdings.co.za","sales@uvhholdings.co.za","accounts@uvhholdings.co.za"],"phones":["+27 76 819 5245","+27 71 461 4419"],"landline":"012 944 9184","physicalAddress":"207 Edison Crescent, Centurion, Gauteng, 0157, South Africa","enquiryEmail":"info@uvhholdings.co.za"}',
    'Contact details shown on the public /contact-us page'
)
ON CONFLICT (setting_key) DO NOTHING;

-- Backfill for rows created before enquiryEmail existed: only applies when the
-- key is absent — an operator-set value is never overwritten.
UPDATE store_settings
SET setting_value = (setting_value::jsonb || '{"enquiryEmail":"info@uvhholdings.co.za"}')::text
WHERE setting_key = 'storefront.contact'
  AND NOT (setting_value::jsonb ? 'enquiryEmail');
