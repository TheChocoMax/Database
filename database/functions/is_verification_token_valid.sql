CREATE OR REPLACE FUNCTION is_verification_token_valid(p_verification_token TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM pending_users
        WHERE verification_token = p_verification_token
          AND created_at >= NOW() - INTERVAL '24 hour'
    );
END;
$$ LANGUAGE plpgsql STABLE;
