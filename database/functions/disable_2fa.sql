-- Disable 2FA for a user
CREATE OR REPLACE FUNCTION disable_2fa(p_user_id UUID) RETURNS VOID AS $$
BEGIN
    UPDATE user_authentication_methods
    SET is_enabled = FALSE, updated_at = NOW()
    WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;
