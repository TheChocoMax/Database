CREATE OR REPLACE FUNCTION get_product_details(
    p_product_id INTEGER,
    p_language_iso CHAR(2) DEFAULT 'en'
) RETURNS TABLE (
    -- Product data
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
    -- Related data
    category JSONB,
    variants JSONB,
    customization_options JSONB,
    attributes JSONB,
    tags JSONB,
    images JSONB
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
        CASE
            WHEN p.product_type = 'variant_based' THEN
                (SELECT jsonb_agg(
                    jsonb_build_object(
                        'variant_id', pv.product_variant_id,
                        'name', pv.variant_name,
                        'quantity', pv.quantity,
                        'price', COALESCE(pv.price_override, p.price),
                        'serving_size', pv.serving_size,
                        'is_default', pv.is_default,
                        'size', pv.size
                    ) ORDER BY pv.display_order
                ) FROM product_variants pv
                WHERE pv.product_id = p.product_id AND pv.is_test = FALSE)
            ELSE NULL
        END as variants,
        -- Customization options for configurable products
        CASE
            WHEN p.product_type = 'configurable' THEN
                (SELECT jsonb_agg(
                    jsonb_build_object(
                        'option_id', co.customization_option_id,
                        'name', COALESCE(cot.option_name, co.option_name),
                        'type', co.option_type,
                        'is_required', COALESCE(pco.is_required, co.is_required),
                        'values', CASE
                            WHEN co.option_type IN ('single_select', 'multi_select') THEN
                                (SELECT jsonb_agg(
                                    jsonb_build_object(
                                        'value_id', cov.option_value_id,
                                        'name', COALESCE(covt.value_name, cov.value_name),
                                        'price_modifier', cov.price_modifier,
                                        'is_default', cov.is_default
                                    ) ORDER BY cov.display_order
                                ) FROM customization_option_values cov
                                LEFT JOIN customization_option_value_translations covt
                                    ON cov.option_value_id = covt.option_value_id
                                    AND covt.language_id = (SELECT language_id FROM languages WHERE iso_code = p_language_iso)
                                WHERE cov.customization_option_id = co.customization_option_id
                                AND cov.is_enabled = TRUE)
                            ELSE NULL
                        END
                    ) ORDER BY COALESCE(pco.display_order, co.display_order)
                ) FROM product_customization_options pco
                JOIN customization_options co ON pco.customization_option_id = co.customization_option_id
                LEFT JOIN customization_option_translations cot
                    ON co.customization_option_id = cot.customization_option_id
                    AND cot.language_id = (SELECT language_id FROM languages WHERE iso_code = p_language_iso)
                WHERE pco.product_id = p.product_id AND co.is_enabled = TRUE)
            ELSE NULL
        END as customization_options,
        -- Product attributes (fixed - no nested aggregates)
        (SELECT
            CASE
                WHEN COUNT(*) > 0 THEN
                    jsonb_object_agg(
                        attr_grouped.attribute_name,
                        attr_grouped.values
                    )
                ELSE NULL
            END
         FROM (
            SELECT
                pa.attribute_name,
                jsonb_agg(
                    jsonb_build_object(
                        'value', pa.attribute_value,
                        'color', pa.attribute_color::TEXT
                    )
                ) as values
            FROM product_attributes pa
            WHERE pa.product_id = p.product_id
            GROUP BY pa.attribute_name
         ) attr_grouped
        ) as attributes,
        -- Product tags
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
        -- Product images
        (SELECT jsonb_agg(
            jsonb_build_object(
                'image_id', pi.product_image_id,
                'url', pi.image_url,
                'is_primary', pi.is_primary,
                'variant_id', pi.variant_id
            ) ORDER BY pi.is_primary DESC, pi.created_at
        ) FROM product_images pi
        WHERE pi.product_id = p.product_id
        ) as images
    FROM products p
    LEFT JOIN product_categories pc ON p.category_id = pc.category_id
    LEFT JOIN category_translations ct ON pc.category_id = ct.category_id
        AND ct.language_id = (SELECT language_id FROM languages WHERE iso_code = p_language_iso)
    LEFT JOIN LATERAL get_product_translation(p.product_id, p_language_iso) tr ON true
    WHERE p.product_id = p_product_id AND p.is_enabled = TRUE;
END;
$$ LANGUAGE plpgsql;
