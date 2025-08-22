CREATE EXTENSION IF NOT EXISTS pgtap;

BEGIN;

SELECT plan(86);

-- =============================================================================
-- TABLE EXISTENCE TESTS
-- =============================================================================

SELECT has_table('languages', 'Languages table exists');
SELECT has_table('products', 'Products table exists');
SELECT has_table('product_categories', 'Product categories table exists');
SELECT has_table('product_variants', 'Product variants table exists');
SELECT has_table('product_images', 'Product images table exists');
SELECT has_table('translations', 'Translations table exists');
SELECT has_table('product_translations', 'Product translations table exists');
SELECT has_table('category_translations', 'Category translations table exists');
SELECT has_table('contact_messages', 'Contact messages table exists');

-- =============================================================================
-- ENUM AND TYPE TESTS
-- =============================================================================

SELECT has_type('delivery_type', 'delivery_type enum exists');

-- =============================================================================
-- COLUMN EXISTENCE AND TYPE TESTS
-- =============================================================================

-- Languages table columns
SELECT has_column('languages', 'language_id', 'languages.language_id exists');
SELECT has_column('languages', 'iso_code', 'languages.iso_code exists');
SELECT has_column('languages', 'english_name', 'languages.english_name exists');
SELECT has_column('languages', 'native_name', 'languages.native_name exists');

SELECT col_type_is('languages', 'language_id', 'integer', 'languages.language_id is integer');
SELECT col_type_is('languages', 'iso_code', 'character(2)', 'languages.iso_code is char(2)');
SELECT col_type_is('languages', 'english_name', 'text', 'languages.english_name is text');
SELECT col_type_is('languages', 'native_name', 'text', 'languages.native_name is text');

-- Products table columns
SELECT has_column('products', 'product_id', 'products.product_id exists');
SELECT has_column('products', 'product_name', 'products.product_name exists');
SELECT has_column('products', 'product_description', 'products.product_description exists');
SELECT has_column('products', 'price', 'products.price exists');
SELECT has_column('products', 'image_url', 'products.image_url exists');
SELECT has_column('products', 'is_enabled', 'products.is_enabled exists');
SELECT has_column('products', 'created_at', 'products.created_at exists');
SELECT has_column('products', 'updated_at', 'products.updated_at exists');

SELECT col_type_is('products', 'product_id', 'integer', 'products.product_id is integer');
SELECT col_type_is('products', 'product_name', 'text', 'products.product_name is text');
SELECT col_type_is('products', 'price', 'numeric(10,2)', 'products.price is numeric(10,2)');
SELECT col_type_is('products', 'is_enabled', 'boolean', 'products.is_enabled is boolean');
SELECT col_type_is('products', 'created_at', 'timestamp with time zone', 'products.created_at is timestamptz');

-- Product categories table columns
SELECT has_column('product_categories', 'product_category_id', 'product_categories.product_category_id exists');
SELECT has_column('product_categories', 'product_category_name', 'product_categories.product_category_name exists');
SELECT has_column('product_categories', 'product_category_description', 'product_categories.product_category_description exists');
SELECT has_column('product_categories', 'created_at', 'product_categories.created_at exists');
SELECT has_column('product_categories', 'updated_at', 'product_categories.updated_at exists');

-- Product variants table columns
SELECT has_column('product_variants', 'product_variant_id', 'product_variants.product_variant_id exists');
SELECT has_column('product_variants', 'product_id', 'product_variants.product_id exists');
SELECT has_column('product_variants', 'size', 'product_variants.size exists');
SELECT has_column('product_variants', 'is_test', 'product_variants.is_test exists');
SELECT has_column('product_variants', 'price_override', 'product_variants.price_override exists');

SELECT col_type_is('product_variants', 'is_test', 'boolean', 'product_variants.is_test is boolean');
SELECT col_type_is('product_variants', 'price_override', 'numeric(10,2)', 'product_variants.price_override is numeric(10,2)');

-- =============================================================================
-- PRIMARY KEY TESTS
-- =============================================================================

SELECT has_pk('languages', 'languages has primary key');
SELECT has_pk('products', 'products has primary key');
SELECT has_pk('product_categories', 'product_categories has primary key');
SELECT has_pk('product_variants', 'product_variants has primary key');
SELECT has_pk('product_images', 'product_images has primary key');
SELECT has_pk('translations', 'translations has primary key');
SELECT has_pk('product_translations', 'product_translations has primary key');
SELECT has_pk('category_translations', 'category_translations has primary key');
SELECT has_pk('contact_messages', 'contact_messages has primary key');

SELECT col_is_pk('languages', 'language_id', 'languages.language_id is primary key');
SELECT col_is_pk('products', 'product_id', 'products.product_id is primary key');
SELECT col_is_pk('product_categories', 'product_category_id', 'product_categories.product_category_id is primary key');

-- =============================================================================
-- FOREIGN KEY TESTS
-- =============================================================================

SELECT has_fk('product_variants', 'product_variants has foreign key');
SELECT has_fk('product_images', 'product_images has foreign key');
SELECT has_fk('translations', 'translations has foreign key');
SELECT has_fk('product_translations', 'product_translations has foreign key');
SELECT has_fk('category_translations', 'category_translations has foreign key');

-- Specific foreign key relationships
SELECT col_is_fk('product_variants', 'product_id', 'product_variants.product_id is foreign key');
SELECT col_is_fk('product_images', 'product_id', 'product_images.product_id is foreign key');
SELECT col_is_fk('translations', 'language_id', 'translations.language_id is foreign key');
SELECT col_is_fk('product_translations', 'product_id', 'product_translations.product_id is foreign key');
SELECT col_is_fk('product_translations', 'language_id', 'product_translations.language_id is foreign key');

-- =============================================================================
-- UNIQUE CONSTRAINT TESTS
-- =============================================================================

SELECT col_is_unique('languages', ARRAY['iso_code'], 'languages.iso_code is unique');
SELECT col_is_unique('languages', ARRAY['english_name'], 'languages.english_name is unique');
SELECT col_is_unique('languages', ARRAY['native_name'], 'languages.native_name is unique');
SELECT col_is_unique('product_categories', ARRAY['product_category_name'], 'product_categories.product_category_name is unique');
SELECT col_is_unique('translations', ARRAY['translation_key'], 'translations.translation_key is unique');
SELECT col_is_unique('translations', ARRAY['translation_key', 'language_id'], 'translations (translation_key, language_id) is unique');
SELECT col_is_unique('product_translations', ARRAY['product_id', 'language_id'], 'product_translations (product_id, language_id) is unique');
SELECT col_is_unique('category_translations', ARRAY['category_id', 'language_id'], 'category_translations (category_id, language_id) is unique');

-- =============================================================================
-- NOT NULL CONSTRAINT TESTS
-- =============================================================================

SELECT col_not_null('products', 'product_name', 'products.product_name is not null');
SELECT col_not_null('products', 'price', 'products.price is not null');
SELECT col_not_null('product_categories', 'product_category_name', 'product_categories.product_category_name is not null');
SELECT col_not_null('product_variants', 'product_id', 'product_variants.product_id is not null');
SELECT col_not_null('product_images', 'product_id', 'product_images.product_id is not null');
SELECT col_not_null('product_images', 'image_url', 'product_images.image_url is not null');
SELECT col_not_null('translations', 'translation_key', 'translations.translation_key is not null');
SELECT col_not_null('translations', 'language_id', 'translations.language_id is not null');
SELECT col_not_null('translations', 'translation_value', 'translations.translation_value is not null');

-- =============================================================================
-- DEFAULT VALUE TESTS
-- =============================================================================

SELECT col_has_default('products', 'is_enabled', 'products.is_enabled has default');
SELECT col_has_default('products', 'created_at', 'products.created_at has default');
SELECT col_has_default('product_variants', 'is_test', 'product_variants.is_test has default');
SELECT col_has_default('product_images', 'is_primary', 'product_images.is_primary has default');

-- =============================================================================
-- TODO: INDEX TESTS
-- =============================================================================

SELECT finish();

ROLLBACK;
