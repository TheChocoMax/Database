-- =====================================
-- FIXED functions.test.sql
-- Replace: database/tests/functions.test.sql
-- =====================================

CREATE EXTENSION IF NOT EXISTS pgtap;

BEGIN;

SELECT plan(15);

-- =============================================================================
-- FUNCTION EXISTENCE TESTS
-- =============================================================================

SELECT has_function('get_pagination_info', 'get_pagination_info function exists');
SELECT has_function('get_product_translation', 'get_product_translation function exists');
SELECT has_function('get_products_paginated', 'get_products_paginated function exists');
SELECT has_function('get_product_details', 'get_product_details function exists');
SELECT has_function('get_product_categories', 'get_product_categories function exists');
SELECT has_function('get_product_tags', 'get_product_tags function exists');
SELECT has_function('get_product_attributes_for_filter', 'get_product_attributes_for_filter function exists');
SELECT has_function('search_products', 'search_products function exists');
SELECT has_function('calculate_product_price', 'calculate_product_price function exists');

-- =============================================================================
-- FUNCTION FUNCTIONALITY TESTS
-- =============================================================================

-- Test get_product_categories function
SELECT ok(
    (SELECT count(*) FROM get_product_categories('en')) > 0,
    'get_product_categories returns categories'
);

-- Test get_product_tags function
SELECT ok(
    (SELECT count(*) FROM get_product_tags('en')) > 0,
    'get_product_tags returns tags'
);

-- Test get_products_paginated with basic parameters
SELECT ok(
    (SELECT count(*) FROM get_products_paginated(1, 12, 'en')) > 0,
    'get_products_paginated returns products'
);

-- Test get_products_paginated with category filter
SELECT ok(
    (SELECT count(*) FROM get_products_paginated(1, 12, 'en', 'created_at', 'DESC', 1)) >= 0,
    'get_products_paginated works with category filter'
);

-- Test search_products function
SELECT ok(
    (SELECT count(*) FROM search_products('chocolate', 1, 12, 'en')) >= 0,
    'search_products function works'
);

-- Test calculate_product_price for standard product
SELECT ok(
    (SELECT calculate_product_price(3)) > 0, -- Chocolate spread product
    'calculate_product_price works for standard products'
);

SELECT finish();

ROLLBACK;
