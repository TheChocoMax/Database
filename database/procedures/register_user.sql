-- Register a new user
CREATE OR REPLACE PROCEDURE register_user(
    p_username TEXT,
    p_email_encrypted TEXT,
    p_email_hash TEXT,
    p_password_hash TEXT,
    p_phone_encrypted TEXT,
    p_phone_hash TEXT,
    p_preferred_language_iso_code CHAR(2)
)
LANGUAGE plpgsql AS $$
BEGIN
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
            p_email_encrypted,
            p_email_hash,
            p_username,
            p_password_hash,
            p_phone_encrypted,
            p_phone_hash,
            (SELECT language_id FROM languages WHERE iso_code = p_preferred_language_iso_code)
        );
    EXCEPTION
        WHEN unique_violation THEN
            -- Identify the constraint that caused the error
            IF SQLERRM LIKE '%username%' THEN
                RAISE EXCEPTION 'Username % already exists', p_username;
            ELSIF SQLERRM LIKE '%email_hash%' THEN
                RAISE EXCEPTION 'Email address already exists';
            ELSIF SQLERRM LIKE '%phone_hash%' THEN
                RAISE EXCEPTION 'Phone number already exists';
            ELSE
                RAISE;
            END IF;
    END;
END;
$$;
