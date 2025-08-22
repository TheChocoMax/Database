CREATE EXTENSION IF NOT EXISTS pgtap;

BEGIN;

SELECT plan(9);

-- Verify that the schema has the expected tables

SELECT has_table('languages', 'Table exists');
SELECT has_table('products', 'Table exists');
SELECT has_table('product_categories', 'Table exists');
SELECT has_table('product_variants', 'Table exists');
SELECT has_table('product_images', 'Table exists');
SELECT has_table('translations', 'Table exists');
SELECT has_table('product_translations', 'Table exists');
SELECT has_table('category_translations', 'Table exists');
SELECT has_table('contact_messages', 'Table exists');

SELECT finish(TRUE);

ROLLBACK;
