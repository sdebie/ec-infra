ALTER TABLE wholesale_applications
    ADD COLUMN IF NOT EXISTS account_email VARCHAR(255),
    ADD COLUMN IF NOT EXISTS first_name VARCHAR(100),
    ADD COLUMN IF NOT EXISTS last_name VARCHAR(100),
    ADD COLUMN IF NOT EXISTS phone VARCHAR(20),
    ADD COLUMN IF NOT EXISTS reg_number VARCHAR(100),
    ADD COLUMN IF NOT EXISTS processed_at TIMESTAMP WITH TIME ZONE,
    ADD COLUMN IF NOT EXISTS customer_id UUID REFERENCES customers(id) ON DELETE SET NULL;

-- Remove legacy application contact columns now that account/customer aligned fields exist.
ALTER TABLE wholesale_applications
    DROP COLUMN IF EXISTS contact_email,
    DROP COLUMN IF EXISTS contact_phone;

ALTER TABLE wholesale_applications
    ALTER COLUMN account_email SET NOT NULL,
    ALTER COLUMN first_name SET NOT NULL,
    ALTER COLUMN status SET DEFAULT 'PENDING',
    ALTER COLUMN status SET NOT NULL;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'ux_wholesale_applications_account_email'
    ) THEN
        ALTER TABLE wholesale_applications
            ADD CONSTRAINT ux_wholesale_applications_account_email UNIQUE (account_email);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'ck_wholesale_applications_status'
    ) THEN
        ALTER TABLE wholesale_applications
            ADD CONSTRAINT ck_wholesale_applications_status
            CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED', 'CONVERTED'));
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_wholesale_applications_customer_id
    ON wholesale_applications(customer_id);

CREATE INDEX IF NOT EXISTS idx_wholesale_applications_account_email
    ON wholesale_applications(lower(account_email));

