-- Connect to the chocomax database before running
-- \c chocomax;

-- Log a login attempt (used in both success and failure cases)
CREATE OR REPLACE PROCEDURE log_login_attempt(
    p_user_id INTEGER,
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

-- Update last_login and log successful attempt
CREATE OR REPLACE PROCEDURE handle_successful_login(
    p_user_id INTEGER,
    p_ip_address INET,
    p_user_agent TEXT
)
AS $$
BEGIN
    -- Update login timestamp
    UPDATE users SET last_login_at = NOW(), updated_at = NOW()
    WHERE id = p_user_id;

    -- Log success
    CALL log_login_attempt(p_user_id, p_ip_address, p_user_agent, TRUE);
END;
$$ LANGUAGE plpgsql;

-- Check if the user has 2FA enabled
CREATE OR REPLACE FUNCTION is_2fa_enabled(p_user_id INTEGER) RETURNS BOOLEAN AS $$
DECLARE
    v_enabled BOOLEAN;
BEGIN
    SELECT is_enabled INTO v_enabled
    FROM user_2fa
    WHERE user_id = p_user_id;

    RETURN COALESCE(v_enabled, FALSE);
END;
$$ LANGUAGE plpgsql;

-- Get the user's 2FA secret and method
CREATE OR REPLACE FUNCTION get_user_2fa_secret(p_user_id INTEGER) RETURNS TABLE(method TEXT, secret TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT method, secret
    FROM user_2fa
    WHERE user_id = p_user_id AND is_enabled = TRUE;
END;
$$ LANGUAGE plpgsql;

-- Disable 2FA for a user
CREATE OR REPLACE FUNCTION disable_2fa(p_user_id INTEGER) RETURNS VOID AS $$
BEGIN
    UPDATE user_2fa
    SET is_enabled = FALSE, updated_at = NOW()
    WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;

-- Authenticate a user and log the result
CREATE OR REPLACE FUNCTION authenticate_user(
    p_username VARCHAR,
    p_password_hash VARCHAR,
    p_ip_address INET,
    p_user_agent TEXT
) RETURNS BOOLEAN AS $$
DECLARE
    v_user_id INTEGER;
BEGIN
    -- Attempt to find the user by username and hashed password
    SELECT id INTO v_user_id
    FROM users
    WHERE username = p_username AND password_hash = p_password_hash
    LIMIT 1;

    IF v_user_id IS NOT NULL THEN
        -- Successful login: handle and log
        CALL handle_successful_login(v_user_id, p_ip_address, p_user_agent);
        RETURN TRUE;
    ELSE
        -- Failed login: log with NULL user_id (or you can try to resolve user ID by username alone)
        CALL log_login_attempt(NULL, p_ip_address, p_user_agent, FALSE);
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;
