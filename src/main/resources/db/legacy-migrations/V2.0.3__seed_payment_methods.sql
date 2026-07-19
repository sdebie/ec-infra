-- =============================================================================
-- Seed allowed payment methods for the storefront checkout.
-- Read by StorefrontPaymentResource → GET /api/storefront/payment-methods.
-- Value must be a JSON array of payment method keys.
-- Supported keys: PAYFAST, IN_STORE
-- Safe to re-run: ON CONFLICT DO UPDATE.
-- =============================================================================

INSERT INTO store_settings (setting_key, setting_value, description)
VALUES (
    'payment_methods_allowed',
    '["PAYFAST", "IN_STORE"]',
    'Payment methods available at checkout. PAYFAST redirects to the PayFast hosted payment page. IN_STORE is pay at collection.'
)
ON CONFLICT (setting_key) DO UPDATE
    SET setting_value = EXCLUDED.setting_value,
        description   = EXCLUDED.description;
