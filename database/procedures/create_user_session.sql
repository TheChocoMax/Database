CREATE OR REPLACE PROCEDURE create_user_session_token(
    p_user_id UUID,
    p_session_token TEXT,
    p_device_info JSONB,
    p_ip_address INET,
    p_user_agent TEXT
)
AS $$
BEGIN
    INSERT INTO user_sessions (
        user_id,
        token,
        token_type,
        device_info,
        ip_address,
        expires_at,
        user_agent
    )
    VALUES (
        p_user_id,
        p_session_token,
        'access',
        p_device_info,
        p_ip_address,
        NOW() + INTERVAL '1 hour',
        p_user_agent
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE create_user_refresh_token(
    p_user_id UUID,
    p_refresh_token TEXT,
    p_device_info JSONB,
    p_ip_address INET,
    p_user_agent TEXT
)
AS $$
BEGIN
    INSERT INTO user_sessions (
        user_id,
        token,
        token_type,
        device_info,
        ip_address,
        expires_at,
        user_agent
    )
    VALUES (
        p_user_id,
        p_refresh_token,
        'refresh',
        p_device_info,
        p_ip_address,
        NOW() + INTERVAL '7 days',
        p_user_agent
    );
END;
$$ LANGUAGE plpgsql;
