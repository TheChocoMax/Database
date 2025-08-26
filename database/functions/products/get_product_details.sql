CREATE OR REPLACE FUNCTION get_product_details(
    p_product_id INTEGER,
    p_language_iso CHAR(2) DEFAULT 'en'
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

    -- Variant data
    has_variants BOOLEAN,
    default_variant_id INTEGER,

    -- Customization data
    has_customization_options BOOLEAN,

    -- Counts for related data
    attribute_count INTEGER,
    tag_count INTEGER,
    image_count INTEGER
) AS $$
BEGIN
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
        (SELECT product_variant_id FROM product_variants
         WHERE product_id = p.product_id AND is_default = TRUE AND is_test = FALSE
         LIMIT 1) as default_variant_id,

        -- Customization indicator
        (p.product_type = 'configurable') as has_customization_options,

        -- Related data counts
        (SELECT COUNT(*)::INTEGER FROM product_attributes pa WHERE pa.product_id = p.product_id) as attribute_count,
        (SELECT COUNT(*)::INTEGER FROM product_tag_assignments pta
         JOIN product_tags pt ON pta.product_tag_id = pt.product_tag_id
         WHERE pta.product_id = p.product_id AND pt.is_enabled = TRUE) as tag_count,
        (SELECT COUNT(*)::INTEGER FROM product_images pi WHERE pi.product_id = p.product_id) as image_count

    FROM products p
    LEFT JOIN product_categories pc ON p.category_id = pc.category_id
    LEFT JOIN category_translations ct ON pc.category_id = ct.category_id
        AND ct.language_id = (SELECT language_id FROM languages WHERE iso_code = p_language_iso)
    LEFT JOIN LATERAL get_product_translation(p.product_id, p_language_iso) tr ON true
    WHERE p.product_id = p_product_id AND p.is_enabled = TRUE;
END;
$$ LANGUAGE plpgsql;
