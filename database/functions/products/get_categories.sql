CREATE OR REPLACE FUNCTION get_product_categories(
    p_language_iso CHAR(2) DEFAULT 'en'
) RETURNS TABLE (
    category_id INTEGER,
    category_name TEXT,
    category_color TEXT,
    category_description TEXT,
    product_count BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        pc.category_id,
        COALESCE(ct.category_name, pc.category_name) as category_name,
        pc.category_color::TEXT,
        COALESCE(ct.category_description, pc.category_description) as category_description,
        COUNT(p.product_id) as product_count
    FROM product_categories pc
    LEFT JOIN category_translations ct ON pc.category_id = ct.category_id
        AND ct.language_id = (SELECT language_id FROM languages WHERE iso_code = p_language_iso)
    LEFT JOIN products p ON pc.category_id = p.category_id AND p.is_enabled = TRUE
    WHERE pc.is_enabled = TRUE
    GROUP BY pc.category_id, pc.category_name, pc.category_color, pc.category_description,
             ct.category_name, ct.category_description, pc.display_order
    ORDER BY pc.display_order, COALESCE(ct.category_name, pc.category_name);
END;
$$ LANGUAGE plpgsql;
