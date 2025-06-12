CREATE OR REPLACE FUNCTION get_used_discriminators(
    p_username TEXT
)
RETURNS SETOF SMALLINT AS $$
BEGIN
    RETURN QUERY
    SELECT discriminator
    FROM users
    WHERE users.username = p_username;
END;
$$ LANGUAGE plpgsql;
