CREATE OR REPLACE FUNCTION get_product_assigned_tags(
    p_product_id INTEGER,
    p_language_iso CHAR(2) DEFAULT 'en'
) RETURNS TABLE (
    tag_id INTEGER,
    product_id INTEGER,
    tag_name TEXT,
    tag_color TEXT,
    tag_description TEXT,
    display_order INTEGER,
    assigned_at TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        pt.product_tag_id as tag_id,
        pta.product_id,
        COALESCE(ptt.tag_name, pt.tag_name) as tag_name,
        pt.tag_color::TEXT,
        COALESCE(ptt.tag_description, pt.tag_description) as tag_description,
        pt.display_order,
        pta.created_at as assigned_at
    FROM product_tag_assignments pta
    JOIN product_tags pt ON pta.product_tag_id = pt.product_tag_id
    LEFT JOIN product_tag_translations ptt ON pt.product_tag_id = ptt.product_tag_id
        AND ptt.language_id = (SELECT language_id FROM languages WHERE iso_code = p_language_iso)
    JOIN products p ON pta.product_id = p.product_id
    WHERE pta.product_id = p_product_id
    AND pt.is_enabled = TRUE
    AND p.is_enabled = TRUE
    ORDER BY pt.display_order, pt.tag_name;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
