CREATE TABLE country_settings (
    country_code CHAR(2) PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL,
    currency_code CHAR(3) NOT NULL,
    locale VARCHAR(20) NOT NULL,
    decimal_places SMALLINT NOT NULL DEFAULT 2,
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Ensure only one active default country can exist.
CREATE UNIQUE INDEX ux_country_settings_default_true
    ON country_settings (is_default)
    WHERE is_default = TRUE;

INSERT INTO country_settings (country_code, country_name, currency_code, locale, decimal_places, is_default, is_active)
VALUES ('ZA', 'South Africa', 'ZAR', 'en-ZA', 2, TRUE, TRUE)
ON CONFLICT (country_code) DO NOTHING;

-- Keep the existing store settings approach working while introducing normalized country settings.
INSERT INTO store_settings (setting_key, setting_value, description)
VALUES ('store_country_code', 'ZA', 'Default storefront country code used for locale/currency formatting')
ON CONFLICT (setting_key) DO NOTHING;

-- If an older store_currency setting exists, apply it to ZA so existing behavior is preserved.
DO $$
DECLARE
    v_store_currency TEXT;
BEGIN
    SELECT setting_value
    INTO v_store_currency
    FROM store_settings
    WHERE setting_key = 'store_currency'
    LIMIT 1;

    IF v_store_currency IS NOT NULL AND LENGTH(TRIM(v_store_currency)) = 3 THEN
        UPDATE country_settings
        SET currency_code = UPPER(TRIM(v_store_currency)),
            updated_at = CURRENT_TIMESTAMP
        WHERE country_code = 'ZA';
    END IF;
END $$;

