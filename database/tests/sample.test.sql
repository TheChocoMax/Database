CREATE EXTENSION IF NOT EXISTS pgtap;

SELECT plan(2);

BEGIN;
-- Basic tests to ensure pgtap is working
SELECT ok(TRUE, 'True is ok');
SELECT is(1 + 1, 2, '1 + 1 equals 2');


-- Finish the tests and clean up.
SELECT * FROM finish(true);
ROLLBACK;
