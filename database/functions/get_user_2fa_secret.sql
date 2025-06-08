-- Get the user's authentication methods secret
CREATE OR REPLACE FUNCTION get_user_authentication_method_secret(p_user_id UUID) RETURNS TABLE (method TEXT, secret TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT authentication_method, user_authentication_method_secret
    FROM user_authentication_methods
    WHERE user_id = p_user_id AND is_enabled = TRUE;
END;
$$ LANGUAGE plpgsql;
