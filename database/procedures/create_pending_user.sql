CREATE OR REPLACE PROCEDURE create_pending_user(
    p_email_encrypted TEXT,
    p_email_hash TEXT,
    p_verification_token TEXT
)
AS $$
BEGIN
    INSERT INTO pending_users (
        email_encrypted,
        email_hash,
        verification_token
    ) VALUES (
        p_email_encrypted,
        p_email_hash,
        p_verification_token
    );
END;
$$ LANGUAGE plpgsql;
