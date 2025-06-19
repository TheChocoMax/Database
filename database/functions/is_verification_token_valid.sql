CREATE OR REPLACE FUNCTION is_verification_token_valid(p_verification_token TEXT)
RETURNS BOOLEAN AS $$
DECLARE
    v_email_hash TEXT;
BEGIN
    -- Get email_hash of the token
    SELECT email_hash INTO v_email_hash
    FROM pending_users
    WHERE verification_token = p_verification_token;

    IF v_email_hash IS NULL THEN
        RETURN FALSE;
    END IF;

    -- Check that this token is the most recent and not expired
    RETURN EXISTS (
        SELECT 1
        FROM pending_users
        WHERE email_hash = v_email_hash
          AND verification_token = p_verification_token
          AND created_at = (
              SELECT MAX(created_at)
              FROM pending_users
              WHERE email_hash = v_email_hash
          )
          AND created_at >= NOW() - INTERVAL '24 hours'
    );
END;
$$ LANGUAGE plpgsql STABLE;
