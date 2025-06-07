-- Check if the user has 2FA enabled
CREATE OR REPLACE FUNCTION is_2fa_enabled(p_user_id INTEGER) RETURNS BOOLEAN AS $$
DECLARE
    v_enabled BOOLEAN;
BEGIN
    SELECT is_enabled INTO v_enabled
    FROM user_authentication_methods
    WHERE user_id = p_user_id;

    RETURN COALESCE(v_enabled, FALSE);
END;
$$ LANGUAGE plpgsql;
