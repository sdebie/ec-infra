ALTER TABLE customers
    ADD COLUMN IF NOT EXISTS status VARCHAR(20);

UPDATE customers
SET status = CASE
    WHEN password_hash IS NOT NULL AND btrim(password_hash) <> '' THEN 'ACTIVE'
    ELSE 'REGISTERING'
END
WHERE status IS NULL;

ALTER TABLE customers
    ALTER COLUMN status SET DEFAULT 'REGISTERING';

ALTER TABLE customers
    ALTER COLUMN status SET NOT NULL;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'ck_customers_status'
    ) THEN
        ALTER TABLE customers
            ADD CONSTRAINT ck_customers_status
            CHECK (status IN ('ACTIVE', 'DISABLED', 'REGISTERING'));
    END IF;
END $$;

