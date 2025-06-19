CREATE OR REPLACE PROCEDURE create_user_session_token(
    p_user_id UUID,
    p_session_token TEXT,
    p_device_info JSONB,
    p_ip_address INET,
    p_user_agent TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Expire old access tokens for the user
    UPDATE user_sessions
    SET expires_at = NOW(), updated_at = NOW()
    WHERE user_id = p_user_id
      AND token_type = 'access'
      AND expires_at > NOW();

    -- Insert new session token
    INSERT INTO user_sessions (
        user_id,
        token,
        token_type,
        device_info,
        ip_address,
        user_agent,
        expires_at
    )
    VALUES (
        p_user_id,
        p_session_token,
        'access',
        p_device_info,
        p_ip_address,
        p_user_agent,
        NOW() + INTERVAL '1 hour'
    );
END;
$$;

CREATE OR REPLACE PROCEDURE create_user_refresh_token(
    p_user_id UUID,
    p_refresh_token TEXT,
    p_device_info JSONB,
    p_ip_address INET,
    p_user_agent TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Expire old refresh tokens
    UPDATE user_sessions
    SET expires_at = NOW(), updated_at = NOW()
    WHERE user_id = p_user_id
      AND token_type = 'refresh'
      AND expires_at > NOW();

    -- Insert new refresh token
    INSERT INTO user_sessions (
        user_id,
        token,
        token_type,
        device_info,
        ip_address,
        user_agent,
        expires_at
    )
    VALUES (
        p_user_id,
        p_refresh_token,
        'refresh',
        p_device_info,
        p_ip_address,
        p_user_agent,
        NOW() + INTERVAL '7 days'
    );
END;
$$;
