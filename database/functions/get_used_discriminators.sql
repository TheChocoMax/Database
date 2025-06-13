CREATE OR REPLACE FUNCTION get_used_discriminators(
    p_username TEXT
)
RETURNS SETOF SMALLINT AS $$
BEGIN
    RETURN QUERY
    SELECT discriminator
    FROM users
    WHERE username = p_username;
END;
$$ LANGUAGE plpgsql;
