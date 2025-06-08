-- Authenticate a user and log the result
CREATE OR REPLACE FUNCTION authenticate_user(
    p_username VARCHAR,
    p_password_hash VARCHAR,
    p_ip_address INET,
    p_user_agent TEXT
) RETURNS BOOLEAN AS $$
DECLARE
    v_user_id UUID;
BEGIN
    -- Attempt to find the user by username and hashed password
    SELECT user_id INTO v_user_id
    FROM users
    WHERE username = p_username AND password_hash = p_password_hash
    LIMIT 1;

    IF v_user_id IS NOT NULL THEN
        -- Successful login: handle and log
        CALL handle_successful_login(v_user_id, p_ip_address, p_user_agent);
        RETURN TRUE;
    ELSE
        -- Failed login: log with NULL user_id
        CALL log_login_attempt(NULL, p_ip_address, p_user_agent, FALSE);
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;
