-- Register a new user
CREATE OR REPLACE PROCEDURE register_user(
    p_email_encrypted TEXT,
    p_email_hash TEXT,
    p_username VARCHAR,
    p_password_hash VARCHAR,
    p_phone_encrypted TEXT,
    p_phone_hash TEXT,
    p_preferred_language VARCHAR
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO users (
        email_encrypted,
        email_hash,
        username,
        password_hash,
        phone_encrypted,
        phone_hash,
        preferred_language
    )
    VALUES (
        p_email_encrypted,
        p_email_hash,
        p_username,
        p_password_hash,
        p_phone_encrypted,
        p_phone_hash,
        p_preferred_language
    )
    ON CONFLICT (username) DO NOTHING;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Username % already exists', p_username;
    END IF;
END;
$$;
