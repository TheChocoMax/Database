CREATE EXTENSION IF NOT EXISTS pgtap;

BEGIN;

SELECT plan(3);

SELECT is(
    (
        SELECT count(*)::INT FROM languages
        WHERE iso_code = 'fr'
    ),
    1, 'Language with ISO code "fr" exists'
);

SELECT is(
    (
        SELECT count(*)::INT FROM languages
        WHERE iso_code = 'en'
    ),
    1, 'Language with ISO code "en" exists'
);

SELECT is(
    (
        SELECT count(*)::INT FROM languages
        WHERE iso_code = 'es'
    ),
    1, 'Language with ISO code "es" exists'
);

SELECT finish(TRUE);

ROLLBACK;
