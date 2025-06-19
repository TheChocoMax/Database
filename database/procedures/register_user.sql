-- Register a new user
CREATE OR REPLACE PROCEDURE register_user(
    p_username TEXT,
    p_email_encrypted TEXT,
    p_email_hash TEXT,
    p_password_hash TEXT,
    p_phone_encrypted TEXT,
    p_phone_hash TEXT,
    p_language_id INTEGER
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO users (
        username,
        email_encrypted,
        email_hash,
        password_hash,
        phone_encrypted,
        phone_hash,
        language_id
    )
    VALUES (
        p_username,
        p_email_encrypted,
        p_email_hash,
        p_password_hash,
        p_phone_encrypted,
        p_phone_hash,
        p_language_id
    );
END;
$$;
