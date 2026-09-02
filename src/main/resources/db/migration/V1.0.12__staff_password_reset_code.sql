-- Staff users have no self-service password-reset flow: the only existing reset
-- endpoint requires an already-valid staff JWT, so a staff member who has genuinely
-- forgotten their password and cannot log in has no way back in without a
-- SUPER_ADMIN. These four columns mirror users.password_reset_code_* exactly,
-- giving staff_users the same OTP mechanics the customer flow already has.
ALTER TABLE staff_users ADD COLUMN IF NOT EXISTS password_reset_code_hash TEXT;
ALTER TABLE staff_users ADD COLUMN IF NOT EXISTS password_reset_code_expiry TIMESTAMPTZ;
ALTER TABLE staff_users ADD COLUMN IF NOT EXISTS password_reset_code_attempts INTEGER NOT NULL DEFAULT 0;
ALTER TABLE staff_users ADD COLUMN IF NOT EXISTS password_reset_code_locked_until TIMESTAMPTZ;
