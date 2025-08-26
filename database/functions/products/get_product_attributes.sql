CREATE OR REPLACE FUNCTION get_product_attributes(
    p_product_id INTEGER
) RETURNS TABLE (
    attribute_id INTEGER,
    product_id INTEGER,
    attribute_name TEXT,
    attribute_value TEXT,
    attribute_color TEXT,
    created_at TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        pa.product_attribute_id as attribute_id,
        pa.product_id,
        pa.attribute_name,
        pa.attribute_value,
        pa.attribute_color::TEXT,
        pa.created_at
    FROM product_attributes pa
    JOIN products p ON pa.product_id = p.product_id
    WHERE pa.product_id = p_product_id
    AND p.is_enabled = TRUE
    ORDER BY pa.attribute_name, pa.attribute_value;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
