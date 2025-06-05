-- Connect to the database
-- \c chocomax;

CREATE OR REPLACE FUNCTION authenticate_user(
    p_username VARCHAR,
    p_password_hash VARCHAR
) RETURNS BOOLEAN AS $$
DECLARE
    v_user_id INTEGER;
BEGIN
    -- Check if the user exists with the provided username and password
    SELECT id INTO v_user_id
    FROM users
    WHERE username = p_username AND password_hash = p_password_hash
    LIMIT 1;

    -- TODO: Log the authentication attempt

    -- If user was found, authentication is successful
    IF v_user_id IS NOT NULL THEN
        -- Update the last login timestamp
        UPDATE users
        SET last_login_at = NOW()
        WHERE id = v_user_id;

        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;
