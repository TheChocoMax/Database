-- Returns all non-sensitive user data for a given email hash

CREATE OR REPLACE FUNCTION get_user_info_by_email_hash(p_email_hash TEXT)
RETURNS TABLE (
    user_id UUID,
    username TEXT,
    discriminator SMALLINT,
    email_encrypted TEXT,
    phone_encrypted TEXT,
    language_id INTEGER,
    display_role TEXT,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    last_login_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ
) AS $$
    SELECT
        user_id,
        username,
        discriminator,
        email_encrypted,
        phone_encrypted,
        language_id,
        display_role,
        created_at,
        updated_at,
        last_login_at,
        deleted_at
    FROM users
    WHERE email_hash = p_email_hash;
$$ LANGUAGE sql STABLE;
