CREATE OR REPLACE FUNCTION is_email_available(
    p_verification_token TEXT
)
RETURNS BOOLEAN AS $$
DECLARE
    v_email_hash TEXT;
BEGIN
    -- Retrieve the email_hash from pending_users using the verification_token
    SELECT email_hash INTO v_email_hash
    FROM pending_users
    WHERE verification_token = p_verification_token;

    -- If not found, return false
    IF v_email_hash IS NULL THEN
        RETURN FALSE;
    END IF;

    -- Check if email_hash exists in users
    RETURN NOT EXISTS (
        SELECT 1 FROM users WHERE email_hash = v_email_hash
    );
END;
$$ LANGUAGE plpgsql;
