CREATE OR REPLACE FUNCTION get_products_paginated(
    p_page INTEGER DEFAULT 1,
    p_size INTEGER DEFAULT 12,
    p_language_iso CHAR(2) DEFAULT 'en',
    p_sort_by TEXT DEFAULT 'created_at',
    p_sort_order TEXT DEFAULT 'DESC',
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
    category_description TEXT,

    -- Variant indicators
    has_variants BOOLEAN,
    default_variant_id INTEGER,
    variant_count INTEGER,

    -- Related data counts
    attribute_count INTEGER,
    tag_count INTEGER,
    image_count INTEGER,

    -- Pagination info
    pagination PAGINATION_INFO
) AS $$
DECLARE
    v_total_count BIGINT;
    v_offset INTEGER := (p_page - 1) * p_size;
BEGIN
    -- Get total count for pagination
    SELECT COUNT(*) INTO v_total_count
    FROM products p
    WHERE p.is_enabled = TRUE
    AND (p_category_filter IS NULL OR p.category_id = p_category_filter);

    RETURN QUERY
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
        COALESCE(ct.category_description, pc.category_description) as category_description,

        -- Variant indicators
        (p.product_type = 'variant_based') as has_variants,
        (SELECT product_variant_id FROM product_variants pv
         WHERE pv.product_id = p.product_id AND pv.is_default = TRUE AND pv.is_test = FALSE
         LIMIT 1) as default_variant_id,
        (SELECT COUNT(*)::INTEGER FROM product_variants pv
         WHERE pv.product_id = p.product_id AND pv.is_test = FALSE) as variant_count,

        -- Related data counts
        (SELECT COUNT(*)::INTEGER FROM product_attributes pa WHERE pa.product_id = p.product_id) as attribute_count,
        (SELECT COUNT(*)::INTEGER FROM product_tag_assignments pta
         JOIN product_tags pt ON pta.product_tag_id = pt.product_tag_id
         WHERE pta.product_id = p.product_id AND pt.is_enabled = TRUE) as tag_count,
        (SELECT COUNT(*)::INTEGER FROM product_images pi WHERE pi.product_id = p.product_id) as image_count,

        -- Pagination info
        get_pagination_info(p_page, p_size, v_total_count) as pagination

    FROM products p
    LEFT JOIN product_categories pc ON p.category_id = pc.category_id
    LEFT JOIN category_translations ct ON pc.category_id = ct.category_id
        AND ct.language_id = (SELECT language_id FROM languages WHERE iso_code = p_language_iso)
    LEFT JOIN LATERAL get_product_translation(p.product_id, p_language_iso) tr ON true
    WHERE p.is_enabled = TRUE
    AND (p_category_filter IS NULL OR p.category_id = p_category_filter)
    ORDER BY
        CASE WHEN p_sort_by = 'created_at' AND p_sort_order = 'DESC' THEN p.created_at END DESC,
        CASE WHEN p_sort_by = 'created_at' AND p_sort_order = 'ASC' THEN p.created_at END ASC,
        CASE WHEN p_sort_by = 'price' AND p_sort_order = 'DESC' THEN COALESCE(p.price, p.base_price) END DESC,
        CASE WHEN p_sort_by = 'price' AND p_sort_order = 'ASC' THEN COALESCE(p.price, p.base_price) END ASC,
        CASE WHEN p_sort_by = 'name' AND p_sort_order = 'DESC' THEN COALESCE(tr.product_name, p.product_name) END DESC,
        CASE WHEN p_sort_by = 'name' AND p_sort_order = 'ASC' THEN COALESCE(tr.product_name, p.product_name) END ASC,
        p.product_id
    LIMIT p_size OFFSET v_offset;
END;
$$ LANGUAGE plpgsql;
