CREATE EXTENSION IF NOT EXISTS pgtap;

BEGIN;

SELECT plan(2);

-- Basic tests to ensure pgtap is working
SELECT ok(TRUE, 'True is ok');
SELECT is(1 + 1, 2, '1 + 1 equals 2');

SELECT finish(TRUE);

ROLLBACK;
