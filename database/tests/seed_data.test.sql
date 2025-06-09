CREATE EXTENSION IF NOT EXISTS pgtap;

BEGIN;

SELECT plan(3);

SELECT is(
    (
        SELECT count(*)::INT FROM languages
        WHERE iso_code = 'fr'
            AND english_name = 'French'
            AND native_name = 'Français'
    ),
    1, 'Language with ISO code "fr" exists'
);

SELECT is(
    (
        SELECT count(*)::INT FROM languages
        WHERE iso_code = 'en'
            AND english_name = 'English'
            AND native_name = 'English'
    ),
    1, 'Language with ISO code "en" exists'
);

SELECT is(
    (
        SELECT count(*)::INT FROM languages
        WHERE iso_code = 'es'
            AND english_name = 'Spanish'
            AND native_name = 'Español'
    ),
    1, 'Language with ISO code "es" exists'
);

SELECT finish(TRUE);

ROLLBACK;
