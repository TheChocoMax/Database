-- Register a new user using a verified pending_user's token
CREATE OR REPLACE PROCEDURE register_user(
    p_verification_token TEXT,
    p_username TEXT,
    p_discriminator SMALLINT,
    p_password_hash TEXT,
    p_language_id INTEGER,
    p_otp_secret TEXT
)
AS $$
DECLARE
    v_email_encrypted TEXT;
    v_email_hash TEXT;
    v_user_id UUID;
BEGIN
    -- Retrieve email_encrypted and email_hash from pending_users
    SELECT email_encrypted, email_hash
        INTO v_email_encrypted, v_email_hash
        FROM pending_users
        WHERE verification_token = p_verification_token;

    -- Insert new user and get user_id
    INSERT INTO users (
        username,
        discriminator,
        email_encrypted,
        email_hash,
        password_hash,
        language_id
    )
    VALUES (
        p_username,
        p_discriminator,
        v_email_encrypted,
        v_email_hash,
        p_password_hash,
        p_language_id
    )
    RETURNING user_id INTO v_user_id;

    -- Insert authentication secret for the user
    INSERT INTO user_authentication_methods (
        user_id,
        user_authentication_method_secret
    ) VALUES (
        v_user_id,
        p_otp_secret
    );

    -- Delete the pending_user entry
    DELETE FROM pending_users WHERE verification_token = p_verification_token;
END;
$$ LANGUAGE plpgsql;
