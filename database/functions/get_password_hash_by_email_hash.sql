-- Returns the password hash for a given email hash (for API-side verification)
CREATE OR REPLACE FUNCTION get_password_hash_by_email_hash(
    p_email_hash TEXT
)
RETURNS TEXT AS $$
    SELECT password_hash
    FROM users
    WHERE email_hash = p_email_hash
    LIMIT 1;
$$ LANGUAGE sql;
