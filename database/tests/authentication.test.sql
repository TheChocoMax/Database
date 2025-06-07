CREATE EXTENSION IF NOT EXISTS pgtap;

SELECT plan(2);

-- Clean environment
DELETE FROM login_attempts;
DELETE FROM user_authentication_methods;
DELETE FROM users;

-- Create temp table to store test user ID
CREATE TEMP TABLE test_user (id INTEGER);

-- Insert test user
INSERT INTO users (username, email_encrypted, email_hash, password_hash)
VALUES ('demo_user', 'encrypted_email', 'email_hash_value', 'demo_pass_hash');

-- Store inserted user ID into temp table
INSERT INTO test_user (id)
SELECT user_id FROM users
WHERE username = 'demo_user';

-- Test 1: authenticate_user returns true on correct credentials
SELECT ok(
    authenticate_user('demo_user', 'demo_pass_hash', '127.0.0.1', 'psql'),
    'authenticate_user returns TRUE with valid credentials'
);

-- Test 2: A successful login attempt is recorded for that user
SELECT is(
    (
        SELECT count(*)::INT FROM login_attempts
        WHERE user_id = (SELECT id FROM test_user) AND success = TRUE
    ),
    1, 'A successful login attempt is logged'
);

-- Finish the tests and clean up.
SELECT * FROM finish(TRUE);
ROLLBACK;
