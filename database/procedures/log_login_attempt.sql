-- Log a login attempt (used in both success and failure cases)
CREATE OR REPLACE PROCEDURE log_login_attempt(
    p_user_id UUID,
    p_ip_address INET,
    p_user_agent TEXT,
    p_success BOOLEAN
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO login_attempts (user_id, ip_address, user_agent, success)
    VALUES (p_user_id, p_ip_address, p_user_agent, p_success);
END;
$$;
