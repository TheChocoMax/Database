CREATE OR REPLACE FUNCTION get_products_paginated(
    p_page INTEGER DEFAULT 1,
    p_size INTEGER DEFAULT 12,
    p_language_iso CHAR(2) DEFAULT 'en',
    p_sort_by TEXT DEFAULT 'created_at',
    p_sort_order TEXT DEFAULT 'DESC'
) RETURNS TABLE (
    -- Product data
    product_id INTEGER,
    product_name TEXT,
    product_description TEXT,
    price NUMERIC(10, 2),
    image_url TEXT,
    created_at TIMESTAMPTZ,
    -- Pagination metadata
    pagination PAGINATION_INFO
) AS $$
DECLARE
    offset_val INTEGER;
    total_count BIGINT;
    pagination_data pagination_info;
    sort_clause TEXT;
BEGIN
    -- Validate and set defaults
    p_page := GREATEST(p_page, 1);
    p_size := GREATEST(p_size, 1);
    offset_val := (p_page - 1) * p_size;

    -- Validate sort parameters
    IF p_sort_by NOT IN ('created_at', 'price', 'product_name') THEN
        p_sort_by := 'created_at';
    END IF;

    IF p_sort_order NOT IN ('ASC', 'DESC') THEN
        p_sort_order := 'DESC';
    END IF;

    -- Get total count first
    SELECT COUNT(*) INTO total_count
    FROM products p
    WHERE p.is_enabled = TRUE;

    -- Get pagination info
    pagination_data := get_pagination_info(p_page, p_size, total_count);

    -- Build dynamic sort clause
    sort_clause := format('ORDER BY %I %s', p_sort_by, p_sort_order);

    -- Return paginated results with translations
    RETURN QUERY
    EXECUTE format('
        SELECT
            p.product_id,
            COALESCE(tr.product_name, p.product_name) as product_name,
            COALESCE(tr.product_description, p.product_description) as product_description,
            p.price,
            p.image_url,
            p.created_at,
            $1::pagination_info as pagination
        FROM products p
        LEFT JOIN LATERAL get_product_translation(p.product_id, $2) tr ON true
        WHERE p.is_enabled = TRUE
        %s
        LIMIT $3 OFFSET $4',
        sort_clause
    ) USING pagination_data, p_language_iso, p_size, offset_val;
END;
$$ LANGUAGE plpgsql;
