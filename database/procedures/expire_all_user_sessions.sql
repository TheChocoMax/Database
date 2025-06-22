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
