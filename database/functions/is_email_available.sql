CREATE OR REPLACE FUNCTION is_email_available(
    p_email_hash TEXT
)
RETURNS BOOLEAN AS $$
    SELECT NOT EXISTS (
        SELECT 1 FROM users WHERE email_hash = p_email_hash
    );
$$ LANGUAGE sql;
