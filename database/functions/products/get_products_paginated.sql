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
    category JSONB,
    variants JSONB,
    attributes JSONB,
    tags JSONB,
    pagination PAGINATION_INFO
) AS $$
BEGIN
    -- No complex filtering for now
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
        -- Category
        CASE WHEN p.category_id IS NOT NULL THEN
            jsonb_build_object(
                'category_id', pc.category_id,
                'name', COALESCE(ct.category_name, pc.category_name),
                'color', pc.category_color::TEXT,
                'description', COALESCE(ct.category_description, pc.category_description)
            )
        ELSE NULL END as category,
        -- Variants
        (SELECT jsonb_agg(
            jsonb_build_object(
                'variant_id', pv.product_variant_id,
                'name', pv.variant_name,
                'quantity', pv.quantity,
                'price', COALESCE(pv.price_override, p.price),
                'serving_size', pv.serving_size,
                'is_default', pv.is_default
            ) ORDER BY pv.display_order
        ) FROM product_variants pv
        WHERE pv.product_id = p.product_id AND pv.is_test = FALSE
        ) as variants,
        -- Attributes (simplified - no nested aggregates)
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
                'tag_id', pt.product_tag_id,
                'name', COALESCE(ptt.tag_name, pt.tag_name),
                'color', pt.tag_color::TEXT,
                'description', COALESCE(ptt.tag_description, pt.tag_description)
            ) ORDER BY pt.display_order
        ) FROM product_tag_assignments pta
        JOIN product_tags pt ON pta.product_tag_id = pt.product_tag_id
        LEFT JOIN product_tag_translations ptt ON pt.product_tag_id = ptt.product_tag_id
            AND ptt.language_id = (SELECT language_id FROM languages WHERE iso_code = p_language_iso)
        WHERE pta.product_id = p.product_id AND pt.is_enabled = TRUE
        ) as tags,
        get_pagination_info(p_page, p_size, (SELECT COUNT(*) FROM products WHERE is_enabled = TRUE)::BIGINT) as pagination
    FROM products p
    LEFT JOIN product_categories pc ON p.category_id = pc.category_id
    LEFT JOIN category_translations ct ON pc.category_id = ct.category_id
        AND ct.language_id = (SELECT language_id FROM languages WHERE iso_code = p_language_iso)
    LEFT JOIN LATERAL get_product_translation(p.product_id, p_language_iso) tr ON true
    WHERE p.is_enabled = TRUE
    ORDER BY p.created_at DESC
    LIMIT p_size OFFSET (p_page - 1) * p_size;
END;
$$ LANGUAGE plpgsql;
