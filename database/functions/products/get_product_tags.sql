CREATE OR REPLACE FUNCTION get_product_tags(
    p_language_iso CHAR(2) DEFAULT 'en'
) RETURNS TABLE (
    tag_id INTEGER,
    tag_name TEXT,
    tag_color TEXT,
    tag_description TEXT,
    product_count BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        pt.product_tag_id,
        COALESCE(ptt.tag_name, pt.tag_name) as tag_name,
        pt.tag_color::TEXT,
        COALESCE(ptt.tag_description, pt.tag_description) as tag_description,
        COUNT(pta.product_id) as product_count
    FROM product_tags pt
    LEFT JOIN product_tag_translations ptt ON pt.product_tag_id = ptt.product_tag_id
        AND ptt.language_id = (SELECT language_id FROM languages WHERE iso_code = p_language_iso)
    LEFT JOIN product_tag_assignments pta ON pt.product_tag_id = pta.product_tag_id
    LEFT JOIN products p ON pta.product_id = p.product_id AND p.is_enabled = TRUE
    WHERE pt.is_enabled = TRUE
    GROUP BY pt.product_tag_id, pt.tag_name, pt.tag_color, pt.tag_description,
             ptt.tag_name, ptt.tag_description, pt.display_order
    ORDER BY pt.display_order, COALESCE(ptt.tag_name, pt.tag_name);
END;
$$ LANGUAGE plpgsql;
