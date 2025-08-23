CREATE OR REPLACE FUNCTION search_products(
    p_search_term TEXT,
    p_page INTEGER DEFAULT 1,
    p_size INTEGER DEFAULT 24,
    p_language_iso CHAR(2) DEFAULT 'en',
    p_category_filter INTEGER DEFAULT NULL,
    p_tag_filter INTEGER [] DEFAULT NULL,
    p_attribute_filter JSONB DEFAULT NULL
) RETURNS TABLE (
    product_id INTEGER,
    product_name TEXT,
    product_description TEXT,
    product_type PRODUCT_TYPE,
    price NUMERIC(10, 2),
    base_price NUMERIC(10, 2),
    image_url TEXT,
    category JSONB,
    attributes JSONB,
    tags JSONB,
    rank REAL,
    pagination PAGINATION_INFO
) AS $$
BEGIN
    RETURN QUERY
    WITH search_query AS (
        SELECT websearch_to_tsquery('english', p_search_term) as query
    ),
    filtered_products AS (
        SELECT DISTINCT p.product_id
        FROM products p
        LEFT JOIN product_translations pt ON p.product_id = pt.product_id
            AND pt.language_id = (SELECT language_id FROM languages WHERE iso_code = p_language_iso)
        CROSS JOIN search_query sq
        WHERE p.is_enabled = TRUE
        AND (
            to_tsvector('english', p.product_name || ' ' || COALESCE(p.product_description, '')) @@ sq.query
            OR to_tsvector('english', COALESCE(pt.product_name, '') || ' ' || COALESCE(pt.product_description, '')) @@ sq.query
        )
        AND (p_category_filter IS NULL OR p.category_id = p_category_filter)
        AND (p_tag_filter IS NULL OR EXISTS (
            SELECT 1 FROM product_tag_assignments pta
            WHERE pta.product_id = p.product_id
            AND pta.product_tag_id = ANY(p_tag_filter)
        ))
    ),
    paginated_results AS (
        SELECT fp.product_id,
               ROW_NUMBER() OVER (ORDER BY p.created_at DESC) as rn
        FROM filtered_products fp
        JOIN products p ON fp.product_id = p.product_id
        LIMIT p_size OFFSET (p_page - 1) * p_size
    )
    SELECT
        p.product_id,
        COALESCE(tr.product_name, p.product_name) as product_name,
        COALESCE(tr.product_description, p.product_description) as product_description,
        p.product_type,
        p.price,
        p.base_price,
        p.image_url,
        -- Category
        CASE WHEN p.category_id IS NOT NULL THEN
            jsonb_build_object(
                'category_id', pc.category_id,
                'name', COALESCE(ct.category_name, pc.category_name),
                'color', pc.category_color::TEXT
            )
        ELSE NULL END as category,
        -- Attributes (simplified approach - no nested aggregates)
        (SELECT jsonb_agg(
            jsonb_build_object(
                'name', pa.attribute_name,
                'value', pa.attribute_value,
                'color', pa.attribute_color::TEXT
            )
        ) FROM product_attributes pa WHERE pa.product_id = p.product_id
        ) as attributes,
        -- Tags
        (SELECT jsonb_agg(
            jsonb_build_object(
                'tag_id', pt2.product_tag_id,
                'name', COALESCE(ptt.tag_name, pt2.tag_name),
                'color', pt2.tag_color::TEXT
            )
        ) FROM product_tag_assignments pta
        JOIN product_tags pt2 ON pta.product_tag_id = pt2.product_tag_id
        LEFT JOIN product_tag_translations ptt ON pt2.product_tag_id = ptt.product_tag_id
            AND ptt.language_id = (SELECT language_id FROM languages WHERE iso_code = p_language_iso)
        WHERE pta.product_id = p.product_id AND pt2.is_enabled = TRUE
        ) as tags,
        -- Search ranking
        0.5::REAL as rank, -- Simplified ranking
        get_pagination_info(p_page, p_size, (SELECT COUNT(*) FROM filtered_products)::BIGINT) as pagination
    FROM paginated_results pr
    JOIN products p ON pr.product_id = p.product_id
    LEFT JOIN product_categories pc ON p.category_id = pc.category_id
    LEFT JOIN category_translations ct ON pc.category_id = ct.category_id
        AND ct.language_id = (SELECT language_id FROM languages WHERE iso_code = p_language_iso)
    LEFT JOIN LATERAL get_product_translation(p.product_id, p_language_iso) tr ON true
    ORDER BY pr.rn;
END;
$$ LANGUAGE plpgsql;
