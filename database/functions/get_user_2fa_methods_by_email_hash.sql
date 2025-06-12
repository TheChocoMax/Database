-- Returns the 2FA secret and authentication method for a given email hash and authentication method (e.g., TOTP)
CREATE OR REPLACE FUNCTION get_user_2fa_methods_by_email_hash(
    p_email_hash TEXT
)
RETURNS TABLE (
    authentication_method authentication_method,
    is_preferred BOOLEAN
) AS $$
    SELECT authentication_method, is_preferred
    FROM user_authentication_methods
    WHERE user_id = (SELECT user_id FROM users WHERE email_hash = p_email_hash)
        AND is_enabled = TRUE;
$$ LANGUAGE sql STABLE;
