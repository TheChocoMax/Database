-- Update last_login and log successful attempt
CREATE OR REPLACE PROCEDURE handle_successful_login(
    p_user_id UUID,
    p_ip_address INET,
    p_user_agent TEXT
)
AS $$
BEGIN
    -- Update login timestamp
    UPDATE users SET last_login_at = NOW(), updated_at = NOW()
    WHERE user_id = p_user_id;

    -- Log success
    CALL log_login_attempt(p_user_id, p_ip_address, p_user_agent, TRUE);
END;
$$ LANGUAGE plpgsql;
