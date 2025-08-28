CREATE OR REPLACE FUNCTION search_products(
    p_search_term TEXT,
    p_page INTEGER DEFAULT 1,
    p_size INTEGER DEFAULT 24,
    p_language_iso CHAR(2) DEFAULT 'en',
    p_category_filter INTEGER DEFAULT NULL,
    p_tag_filter INTEGER [] DEFAULT NULL,
    p_attribute_filter JSONB DEFAULT NULL
) RETURNS TABLE (
    -- Core product data
    product_id INTEGER,
    product_name TEXT,
    product_description TEXT,
    product_type PRODUCT_TYPE,
    price NUMERIC(10, 2),
    base_price NUMERIC(10, 2),
    image_url TEXT,
    preparation_time_hours INTEGER,
    min_order_hours INTEGER,
    serving_info TEXT,
    is_customizable BOOLEAN,
    created_at TIMESTAMPTZ,

    -- Category data
    category_id INTEGER,
    category_name TEXT,
    category_color TEXT,

    -- Search relevance
    search_rank REAL,

    -- Related data counts
    attribute_count INTEGER,
    tag_count INTEGER,

    -- Pagination info
    pagination PAGINATION_INFO
) AS $$
DECLARE
    v_total_count BIGINT;
    v_offset INTEGER := (p_page - 1) * p_size;
    v_query tsquery;
BEGIN
    -- Prepare search query
    v_query := websearch_to_tsquery('english', p_search_term);

    -- Get total count for pagination
    WITH search_results AS (
        SELECT DISTINCT p.product_id
        FROM products p
        LEFT JOIN product_translations pt ON p.product_id = pt.product_id
            AND pt.language_id = (SELECT language_id FROM languages WHERE iso_code = p_language_iso)
        WHERE p.is_enabled = TRUE
        AND (
            to_tsvector('english', p.product_name || ' ' || COALESCE(p.product_description, '')) @@ v_query
            OR to_tsvector('english', COALESCE(pt.product_name, '') || ' ' || COALESCE(pt.product_description, '')) @@ v_query
        )
        AND (p_category_filter IS NULL OR p.category_id = p_category_filter)
        AND (p_tag_filter IS NULL OR EXISTS (
            SELECT 1 FROM product_tag_assignments pta
            WHERE pta.product_id = p.product_id
            AND pta.product_tag_id = ANY(p_tag_filter)
        ))
    )
    SELECT COUNT(*) INTO v_total_count FROM search_results;

    RETURN QUERY
    WITH search_results AS (
        SELECT
            p.product_id,
            ts_rank_cd(
                to_tsvector('english', p.product_name || ' ' || COALESCE(p.product_description, '')),
                v_query
            ) as rank
        FROM products p
        LEFT JOIN product_translations pt ON p.product_id = pt.product_id
            AND pt.language_id = (SELECT language_id FROM languages WHERE iso_code = p_language_iso)
        WHERE p.is_enabled = TRUE
        AND (
            to_tsvector('english', p.product_name || ' ' || COALESCE(p.product_description, '')) @@ v_query
            OR to_tsvector('english', COALESCE(pt.product_name, '') || ' ' || COALESCE(pt.product_description, '')) @@ v_query
        )
        AND (p_category_filter IS NULL OR p.category_id = p_category_filter)
        AND (p_tag_filter IS NULL OR EXISTS (
            SELECT 1 FROM product_tag_assignments pta
            WHERE pta.product_id = p.product_id
            AND pta.product_tag_id = ANY(p_tag_filter)
        ))
    )
    SELECT
        p.product_id,
        COALESCE(tr.product_name, p.product_name) as product_name,
        COALESCE(tr.product_description, p.product_description) as product_description,
        p.product_type,
        p.price,
        p.base_price,
        p.image_url,
        p.preparation_time_hours,
        p.min_order_hours,
        p.serving_info,
        p.is_customizable,
        p.created_at,

        -- Category data
        pc.category_id,
        COALESCE(ct.category_name, pc.category_name) as category_name,
        pc.category_color::TEXT,

        -- Search relevance
        sr.rank as search_rank,

        -- Related data counts
        (SELECT COUNT(*)::INTEGER FROM product_attributes pa WHERE pa.product_id = p.product_id) as attribute_count,
        (SELECT COUNT(*)::INTEGER FROM product_tag_assignments pta
         JOIN product_tags pt ON pta.product_tag_id = pt.product_tag_id
         WHERE pta.product_id = p.product_id AND pt.is_enabled = TRUE) as tag_count,

        -- Pagination info
        get_pagination_info(p_page, p_size, v_total_count) as pagination

    FROM search_results sr
    JOIN products p ON sr.product_id = p.product_id
    LEFT JOIN product_categories pc ON p.category_id = pc.category_id
    LEFT JOIN category_translations ct ON pc.category_id = ct.category_id
        AND ct.language_id = (SELECT language_id FROM languages WHERE iso_code = p_language_iso)
    LEFT JOIN LATERAL get_product_translation(p.product_id, p_language_iso) tr ON true
    ORDER BY sr.rank DESC, p.created_at DESC
    LIMIT p_size OFFSET v_offset;
END;
$$ LANGUAGE plpgsql;
