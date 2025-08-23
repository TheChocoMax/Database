CREATE EXTENSION IF NOT EXISTS pgtap;

BEGIN;

SELECT plan(12);

-- Test languages
SELECT is(
    (
        SELECT count(*)::INT FROM languages
        WHERE iso_code = 'fr'
    ),
    1, 'French language exists'
);

SELECT is(
    (
        SELECT count(*)::INT FROM languages
        WHERE iso_code = 'en'
    ),
    1, 'English language exists'
);

SELECT is(
    (
        SELECT count(*)::INT FROM languages
        WHERE iso_code = 'es'
    ),
    1, 'Spanish language exists'
);

-- Test categories
SELECT isnt(
    (SELECT count(*)::INT FROM product_categories),
    0, 'Product categories exist'
);

-- Test products
SELECT isnt(
    (SELECT count(*)::INT FROM products),
    0, 'Products exist'
);

-- Test product attributes
SELECT isnt(
    (SELECT count(*)::INT FROM product_attributes),
    0, 'Product attributes exist'
);

-- Test product tags
SELECT isnt(
    (SELECT count(*)::INT FROM product_tags),
    0, 'Product tags exist'
);

-- Test product tag assignments
SELECT isnt(
    (SELECT count(*)::INT FROM product_tag_assignments),
    0, 'Product tag assignments exist'
);

-- Test customization options
SELECT isnt(
    (SELECT count(*)::INT FROM customization_options),
    0, 'Customization options exist'
);

-- Test customization option values
SELECT isnt(
    (SELECT count(*)::INT FROM customization_option_values),
    0, 'Customization option values exist'
);

-- Test translations
SELECT isnt(
    (SELECT count(*)::INT FROM category_translations),
    0, 'Category translations exist'
);

-- Test product variants
SELECT isnt(
    (SELECT count(*)::INT FROM product_variants),
    0, 'Product variants exist'
);

SELECT finish();
