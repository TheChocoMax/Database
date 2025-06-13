-- Returns the 2FA secret and authentication method for a given email hash and authentication method (e.g., TOTP)
CREATE OR REPLACE FUNCTION get_user_2fa_secret_by_email_hash(
    p_email_hash TEXT,
    p_authentication_method AUTHENTICATION_METHOD
)
RETURNS TABLE (
    authentication_secret TEXT,
    authentication_method AUTHENTICATION_METHOD
) AS $$
    SELECT user_authentication_method_secret AS authentication_secret, authentication_method
    FROM user_authentication_methods
    WHERE user_id = (SELECT user_id FROM users WHERE email_hash = p_email_hash)
        AND authentication_method = p_authentication_method
        AND is_enabled = TRUE
    LIMIT 1;
$$ LANGUAGE sql STABLE;
