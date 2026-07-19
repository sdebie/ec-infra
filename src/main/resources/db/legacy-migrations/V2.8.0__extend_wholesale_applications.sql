-- V2.8.0__extend_wholesale_applications.sql

-- 1. Add new columns
ALTER TABLE wholesale_applications
    ADD COLUMN IF NOT EXISTS applicant_email VARCHAR(255),
    ADD COLUMN IF NOT EXISTS trading_name VARCHAR(255),
    ADD COLUMN IF NOT EXISTS company_phone VARCHAR(50),
    ADD COLUMN IF NOT EXISTS company_email VARCHAR(255),
    ADD COLUMN IF NOT EXISTS finance_contact_name VARCHAR(255),
    ADD COLUMN IF NOT EXISTS finance_contact_email VARCHAR(255),
    ADD COLUMN IF NOT EXISTS finance_contact_phone VARCHAR(50),
    ADD COLUMN IF NOT EXISTS purchase_order_required BOOLEAN DEFAULT false;

-- 2. Backfill applicant_email from account_email for existing rows
UPDATE wholesale_applications
SET applicant_email = account_email
WHERE applicant_email IS NULL;

-- 3. Make applicant_email NOT NULL
ALTER TABLE wholesale_applications
    ALTER COLUMN applicant_email SET NOT NULL;

-- 4. Make account_email nullable
ALTER TABLE wholesale_applications
    ALTER COLUMN account_email DROP NOT NULL;

-- 5. Drop the existing unique constraint and replace with partial unique
ALTER TABLE wholesale_applications
    DROP CONSTRAINT IF EXISTS ux_wholesale_applications_account_email;

CREATE UNIQUE INDEX IF NOT EXISTS ux_wholesale_applications_account_email_partial
    ON wholesale_applications (lower(account_email))
    WHERE account_email IS NOT NULL;
