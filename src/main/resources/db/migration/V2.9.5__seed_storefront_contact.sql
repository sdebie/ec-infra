-- =============================================================================
-- Seed UVH storefront.contact defaults
-- =============================================================================
-- Temporary UVH deployment defaults. These client-specific values will move to
-- the client seed scripts when the seed refactor is completed.
--
-- ON CONFLICT DO NOTHING: if the client has already configured contact info,
-- this migration is a no-op — it never overwrites user-edited values.
--
-- Depends on: V2.9.4__add_wholesale_rejection_reason.sql (wholesale workflow)
-- Reserved:   V2.9.2 / V2.9.3 — already applied to the target database; never reuse.
-- =============================================================================

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
    'storefront.contact',
    '{"emails":["info@uvhholdings.co.za","sales@uvhholdings.co.za","accounts@uvhholdings.co.za"],"phones":["+27 76 819 5245","+27 71 461 4419"],"landline":"012 944 9184","physicalAddress":"207 Edison Crescent, Centurion, Gauteng, 0157, South Africa"}',
    'Contact details shown on the public /contact-us page'
)
ON CONFLICT (setting_key) DO NOTHING;
