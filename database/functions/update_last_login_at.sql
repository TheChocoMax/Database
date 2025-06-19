CREATE OR REPLACE FUNCTION update_last_login_at()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.token_type = 'access' THEN
        UPDATE users
        SET last_login_at = current_timestamp
        WHERE user_id = NEW.user_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
