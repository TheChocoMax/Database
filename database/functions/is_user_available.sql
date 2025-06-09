CREATE OR REPLACE FUNCTION is_user_available(
    p_username TEXT,
    p_email_hash TEXT,
    p_phone_hash TEXT
)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN NOT EXISTS (
        SELECT 1 FROM users
        WHERE username = p_username
           OR email_hash = p_email_hash
           OR phone_hash = p_phone_hash
    );
END;
$$ LANGUAGE plpgsql;
