CREATE OR REPLACE PROCEDURE expire_user_session_token(
    p_token TEXT
)
AS $$
BEGIN
    UPDATE user_sessions
    SET expires_at = NOW()
    WHERE token = p_token
      AND token_type = 'session';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE expire_user_refresh_token(
    p_token TEXT
)
AS $$
BEGIN
    UPDATE user_sessions
    SET expires_at = NOW()
    WHERE token = p_token
      AND token_type = 'refresh';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE expire_all_user_sessions(
    p_token TEXT
)
AS $$
DECLARE
    user_id UUID;
BEGIN
    SELECT us.user_id INTO user_id
    FROM user_sessions us
    WHERE us.token = p_token
      AND us.expires_at > NOW();

    IF user_id IS NOT NULL THEN
        UPDATE user_sessions
        SET expires_at = NOW()
        WHERE user_id = user_id;
    END IF;
END;
$$ LANGUAGE plpgsql;
