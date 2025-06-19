CREATE TRIGGER tr_update_last_login_at
AFTER INSERT ON user_sessions
FOR EACH ROW
EXECUTE FUNCTION update_last_login_at();
