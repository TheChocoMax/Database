CREATE EXTENSION IF NOT EXISTS pgtap;

BEGIN;

SELECT plan(167);

-- =============================================================================
-- TABLE EXISTENCE TESTS
-- =============================================================================

SELECT has_table('languages', 'Languages table exists');
SELECT has_table('product_categories', 'Product categories table exists');
SELECT has_table('products', 'Products table exists');
SELECT has_table('product_variants', 'Product variants table exists');
SELECT has_table('product_images', 'Product images table exists');
SELECT has_table('product_attributes', 'Product attributes table exists');
SELECT has_table('product_tags', 'Product tags table exists');
SELECT has_table('product_tag_assignments', 'Product tag assignments table exists');
SELECT has_table('customization_options', 'Customization options table exists');
SELECT has_table('customization_option_values', 'Customization option values table exists');
SELECT has_table('product_customization_options', 'Product customization options table exists');
SELECT has_table('translations', 'Translations table exists');
SELECT has_table('product_translations', 'Product translations table exists');
SELECT has_table('category_translations', 'Category translations table exists');
SELECT has_table('product_tag_translations', 'Product tag translations table exists');
SELECT has_table('customization_option_translations', 'Customization option translations table exists');
SELECT has_table('customization_option_value_translations', 'Customization option value translations table exists');
SELECT has_table('contact_messages', 'Contact messages table exists');

-- =============================================================================
-- ENUM AND TYPE TESTS
-- =============================================================================

SELECT has_type('delivery_type', 'delivery_type enum exists');
SELECT has_type('product_type', 'product_type enum exists');
SELECT has_type('pagination_info', 'pagination_info type exists');
SELECT has_domain('hex_color', 'hex_color domain exists');

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

-- Product categories table columns
SELECT has_column('product_categories', 'category_id', 'product_categories.category_id exists');
SELECT has_column('product_categories', 'category_name', 'product_categories.category_name exists');
SELECT has_column('product_categories', 'category_color', 'product_categories.category_color exists');
SELECT has_column('product_categories', 'category_description', 'product_categories.category_description exists');
SELECT has_column('product_categories', 'display_order', 'product_categories.display_order exists');
SELECT has_column('product_categories', 'is_enabled', 'product_categories.is_enabled exists');

SELECT col_type_is('product_categories', 'category_color', 'hex_color', 'product_categories.category_color is hex_color');

-- Products table columns
SELECT has_column('products', 'product_id', 'products.product_id exists');
SELECT has_column('products', 'category_id', 'products.category_id exists');
SELECT has_column('products', 'product_name', 'products.product_name exists');
SELECT has_column('products', 'product_description', 'products.product_description exists');
SELECT has_column('products', 'product_type', 'products.product_type exists');
SELECT has_column('products', 'price', 'products.price exists');
SELECT has_column('products', 'base_price', 'products.base_price exists');
SELECT has_column('products', 'image_url', 'products.image_url exists');
SELECT has_column('products', 'preparation_time_hours', 'products.preparation_time_hours exists');
SELECT has_column('products', 'min_order_hours', 'products.min_order_hours exists');
SELECT has_column('products', 'serving_info', 'products.serving_info exists');
SELECT has_column('products', 'is_customizable', 'products.is_customizable exists');
SELECT has_column('products', 'is_enabled', 'products.is_enabled exists');
SELECT has_column('products', 'created_at', 'products.created_at exists');
SELECT has_column('products', 'updated_at', 'products.updated_at exists');

SELECT col_type_is('products', 'product_id', 'integer', 'products.product_id is integer');
SELECT col_type_is('products', 'product_type', 'product_type', 'products.product_type is product_type enum');
SELECT col_type_is('products', 'price', 'numeric(10,2)', 'products.price is numeric(10,2)');
SELECT col_type_is('products', 'base_price', 'numeric(10,2)', 'products.base_price is numeric(10,2)');

-- Product variants table columns
SELECT has_column('product_variants', 'product_variant_id', 'product_variants.product_variant_id exists');
SELECT has_column('product_variants', 'product_id', 'product_variants.product_id exists');
SELECT has_column('product_variants', 'variant_name', 'product_variants.variant_name exists');
SELECT has_column('product_variants', 'size', 'product_variants.size exists');
SELECT has_column('product_variants', 'quantity', 'product_variants.quantity exists');
SELECT has_column('product_variants', 'serving_size', 'product_variants.serving_size exists');
SELECT has_column('product_variants', 'is_test', 'product_variants.is_test exists');
SELECT has_column('product_variants', 'price_override', 'product_variants.price_override exists');
SELECT has_column('product_variants', 'is_default', 'product_variants.is_default exists');
SELECT has_column('product_variants', 'display_order', 'product_variants.display_order exists');

-- Product attributes table columns
SELECT has_column('product_attributes', 'product_attribute_id', 'product_attributes.product_attribute_id exists');
SELECT has_column('product_attributes', 'product_id', 'product_attributes.product_id exists');
SELECT has_column('product_attributes', 'attribute_name', 'product_attributes.attribute_name exists');
SELECT has_column('product_attributes', 'attribute_value', 'product_attributes.attribute_value exists');
SELECT has_column('product_attributes', 'attribute_color', 'product_attributes.attribute_color exists');

SELECT col_type_is('product_attributes', 'attribute_color', 'hex_color', 'product_attributes.attribute_color is hex_color');

-- Product tags table columns
SELECT has_column('product_tags', 'product_tag_id', 'product_tags.product_tag_id exists');
SELECT has_column('product_tags', 'tag_name', 'product_tags.tag_name exists');
SELECT has_column('product_tags', 'tag_color', 'product_tags.tag_color exists');
SELECT has_column('product_tags', 'tag_description', 'product_tags.tag_description exists');
SELECT has_column('product_tags', 'display_order', 'product_tags.display_order exists');
SELECT has_column('product_tags', 'is_enabled', 'product_tags.is_enabled exists');

SELECT col_type_is('product_tags', 'tag_color', 'hex_color', 'product_tags.tag_color is hex_color');

-- Customization options table columns
SELECT has_column('customization_options', 'customization_option_id', 'customization_options.customization_option_id exists');
SELECT has_column('customization_options', 'option_name', 'customization_options.option_name exists');
SELECT has_column('customization_options', 'option_type', 'customization_options.option_type exists');
SELECT has_column('customization_options', 'is_required', 'customization_options.is_required exists');

-- =============================================================================
-- PRIMARY KEY TESTS
-- =============================================================================

SELECT has_pk('languages', 'languages has primary key');
SELECT has_pk('product_categories', 'product_categories has primary key');
SELECT has_pk('products', 'products has primary key');
SELECT has_pk('product_variants', 'product_variants has primary key');
SELECT has_pk('product_images', 'product_images has primary key');
SELECT has_pk('product_attributes', 'product_attributes has primary key');
SELECT has_pk('product_tags', 'product_tags has primary key');
SELECT has_pk('customization_options', 'customization_options has primary key');
SELECT has_pk('customization_option_values', 'customization_option_values has primary key');
SELECT has_pk('translations', 'translations has primary key');
SELECT has_pk('product_translations', 'product_translations has primary key');
SELECT has_pk('category_translations', 'category_translations has primary key');
SELECT has_pk('product_tag_translations', 'product_tag_translations has primary key');
SELECT has_pk('contact_messages', 'contact_messages has primary key');

SELECT col_is_pk('languages', 'language_id', 'languages.language_id is primary key');
SELECT col_is_pk('products', 'product_id', 'products.product_id is primary key');
SELECT col_is_pk('product_categories', 'category_id', 'product_categories.category_id is primary key');

-- =============================================================================
-- FOREIGN KEY TESTS
-- =============================================================================

SELECT has_fk('products', 'products has foreign key');
SELECT has_fk('product_variants', 'product_variants has foreign key');
SELECT has_fk('product_images', 'product_images has foreign key');
SELECT has_fk('product_attributes', 'product_attributes has foreign key');
SELECT has_fk('product_tag_assignments', 'product_tag_assignments has foreign key');
SELECT has_fk('customization_option_values', 'customization_option_values has foreign key');
SELECT has_fk('product_customization_options', 'product_customization_options has foreign key');
SELECT has_fk('translations', 'translations has foreign key');
SELECT has_fk('product_translations', 'product_translations has foreign key');
SELECT has_fk('category_translations', 'category_translations has foreign key');

-- Specific foreign key relationships
SELECT col_is_fk('products', 'category_id', 'products.category_id is foreign key');
SELECT col_is_fk('product_variants', 'product_id', 'product_variants.product_id is foreign key');
SELECT col_is_fk('product_images', 'product_id', 'product_images.product_id is foreign key');
SELECT col_is_fk('product_attributes', 'product_id', 'product_attributes.product_id is foreign key');
SELECT col_is_fk('product_tag_assignments', 'product_id', 'product_tag_assignments.product_id is foreign key');
SELECT col_is_fk('product_tag_assignments', 'product_tag_id', 'product_tag_assignments.product_tag_id is foreign key');

-- =============================================================================
-- UNIQUE CONSTRAINT TESTS
-- =============================================================================

SELECT col_is_unique('languages', ARRAY['iso_code'], 'languages.iso_code is unique');
SELECT col_is_unique('languages', ARRAY['english_name'], 'languages.english_name is unique');
SELECT col_is_unique('languages', ARRAY['native_name'], 'languages.native_name is unique');
SELECT col_is_unique('product_categories', ARRAY['category_name'], 'product_categories.category_name is unique');
SELECT col_is_unique('product_tags', ARRAY['tag_name'], 'product_tags.tag_name is unique');
SELECT col_is_unique('translations', ARRAY['translation_key'], 'translations.translation_key is unique');
SELECT col_is_unique('translations', ARRAY['translation_key', 'language_id'], 'translations (translation_key, language_id) is unique');
SELECT col_is_unique('product_translations', ARRAY['product_id', 'language_id'], 'product_translations (product_id, language_id) is unique');
SELECT col_is_unique('category_translations', ARRAY['category_id', 'language_id'], 'category_translations (category_id, language_id) is unique');
SELECT col_is_unique('product_attributes', ARRAY['product_id', 'attribute_name', 'attribute_value'], 'product_attributes (product_id, attribute_name, attribute_value) is unique');

-- =============================================================================
-- NOT NULL CONSTRAINT TESTS
-- =============================================================================

SELECT col_not_null('products', 'product_name', 'products.product_name is not null');
SELECT col_not_null('product_categories', 'category_name', 'product_categories.category_name is not null');
SELECT col_not_null('product_variants', 'product_id', 'product_variants.product_id is not null');
SELECT col_not_null('product_images', 'product_id', 'product_images.product_id is not null');
SELECT col_not_null('product_images', 'image_url', 'product_images.image_url is not null');
SELECT col_not_null('product_attributes', 'product_id', 'product_attributes.product_id is not null');
SELECT col_not_null('product_attributes', 'attribute_name', 'product_attributes.attribute_name is not null');
SELECT col_not_null('product_attributes', 'attribute_value', 'product_attributes.attribute_value is not null');
SELECT col_not_null('product_tags', 'tag_name', 'product_tags.tag_name is not null');

-- =============================================================================
-- DEFAULT VALUE TESTS
-- =============================================================================

SELECT col_has_default('products', 'product_type', 'products.product_type has default');
SELECT col_has_default('products', 'is_customizable', 'products.is_customizable has default');
SELECT col_has_default('products', 'is_enabled', 'products.is_enabled has default');
SELECT col_has_default('products', 'created_at', 'products.created_at has default');
SELECT col_has_default('products', 'preparation_time_hours', 'products.preparation_time_hours has default');
SELECT col_has_default('products', 'min_order_hours', 'products.min_order_hours has default');
SELECT col_has_default('product_categories', 'display_order', 'product_categories.display_order has default');
SELECT col_has_default('product_categories', 'is_enabled', 'product_categories.is_enabled has default');
SELECT col_has_default('product_variants', 'is_test', 'product_variants.is_test has default');
SELECT col_has_default('product_variants', 'is_default', 'product_variants.is_default has default');
SELECT col_has_default('product_variants', 'display_order', 'product_variants.display_order has default');
SELECT col_has_default('product_images', 'is_primary', 'product_images.is_primary has default');
SELECT col_has_default('product_tags', 'display_order', 'product_tags.display_order has default');
SELECT col_has_default('product_tags', 'is_enabled', 'product_tags.is_enabled has default');

-- =============================================================================
-- INDEX TESTS
-- =============================================================================

-- Categories indexes
SELECT has_index('product_categories', 'idx_product_categories_enabled', 'Index idx_product_categories_enabled exists');
SELECT has_index('product_categories', 'idx_product_categories_name', 'Index idx_product_categories_name exists');

-- Products table indexes
SELECT has_index('products', 'idx_products_enabled', 'Index idx_products_enabled exists');
SELECT has_index('products', 'idx_products_category', 'Index idx_products_category exists');
SELECT has_index('products', 'idx_products_type', 'Index idx_products_type exists');
SELECT has_index('products', 'idx_products_price', 'Index idx_products_price exists');
SELECT has_index('products', 'idx_products_created_at', 'Index idx_products_created_at exists');
SELECT has_index('products', 'idx_products_customizable', 'Index idx_products_customizable exists');

-- Product variants indexes
SELECT has_index('product_variants', 'idx_product_variants_product_id', 'Index idx_product_variants_product_id exists');
SELECT has_index('product_variants', 'idx_product_variants_non_test', 'Index idx_product_variants_non_test exists');
SELECT has_index('product_variants', 'idx_product_variants_default', 'Index idx_product_variants_default exists');
SELECT has_index('product_variants', 'idx_product_variants_display_order', 'Index idx_product_variants_display_order exists');

-- Product attributes indexes
SELECT has_index('product_attributes', 'idx_product_attributes_product_id', 'Index idx_product_attributes_product_id exists');
SELECT has_index('product_attributes', 'idx_product_attributes_name', 'Index idx_product_attributes_name exists');
SELECT has_index('product_attributes', 'idx_product_attributes_value', 'Index idx_product_attributes_value exists');
SELECT has_index('product_attributes', 'idx_product_attributes_name_value', 'Index idx_product_attributes_name_value exists');

-- Product tags indexes
SELECT has_index('product_tags', 'idx_product_tags_enabled', 'Index idx_product_tags_enabled exists');
SELECT has_index('product_tag_assignments', 'idx_product_tag_assignments_tag', 'Index idx_product_tag_assignments_tag exists');

-- Full-text search indexes (GIN indexes)
SELECT has_index('products', 'idx_products_search', 'Index idx_products_search exists');
SELECT has_index('product_translations', 'idx_product_translations_search', 'Index idx_product_translations_search exists');

SELECT finish();

ROLLBACK;
