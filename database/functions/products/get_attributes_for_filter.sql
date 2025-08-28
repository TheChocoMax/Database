CREATE OR REPLACE FUNCTION get_product_attributes_for_filter(
    p_category_id INTEGER DEFAULT NULL
) RETURNS TABLE (
    attribute_name TEXT,
    attribute_value TEXT,
    attribute_color TEXT,
    product_count INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        pa.attribute_name,
        pa.attribute_value,
        pa.attribute_color::TEXT,
        COUNT(DISTINCT p.product_id)::INTEGER as product_count
    FROM product_attributes pa
    JOIN products p ON pa.product_id = p.product_id
    WHERE p.is_enabled = TRUE
    AND (p_category_id IS NULL OR p.category_id = p_category_id)
    GROUP BY pa.attribute_name, pa.attribute_value, pa.attribute_color
    ORDER BY pa.attribute_name, pa.attribute_value;
END;
$$ LANGUAGE plpgsql;
