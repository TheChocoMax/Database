CREATE OR REPLACE FUNCTION get_product_attributes_for_filter(
    p_category_id INTEGER DEFAULT NULL
) RETURNS TABLE (
    attribute_name TEXT,
    attribute_values JSONB
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        pa.attribute_name,
        jsonb_agg(
            DISTINCT jsonb_build_object(
                'value', pa.attribute_value,
                'color', pa.attribute_color::TEXT,
                'count', (
                    SELECT COUNT(DISTINCT p2.product_id)
                    FROM product_attributes pa2
                    JOIN products p2 ON pa2.product_id = p2.product_id
                    WHERE pa2.attribute_name = pa.attribute_name
                    AND pa2.attribute_value = pa.attribute_value
                    AND p2.is_enabled = TRUE
                    AND (p_category_id IS NULL OR p2.category_id = p_category_id)
                )
            )
        ) as attribute_values
    FROM product_attributes pa
    JOIN products p ON pa.product_id = p.product_id
    WHERE p.is_enabled = TRUE
    AND (p_category_id IS NULL OR p.category_id = p_category_id)
    GROUP BY pa.attribute_name
    ORDER BY pa.attribute_name;
END;
$$ LANGUAGE plpgsql;
