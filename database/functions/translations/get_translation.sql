CREATE OR REPLACE FUNCTION get_product_translation(
    p_product_id INTEGER,
    p_language_iso CHAR(2) DEFAULT 'en'
) RETURNS TABLE (
    product_name TEXT,
    product_description TEXT
) AS $$
BEGIN
    -- Try to get translation in requested language
    RETURN QUERY
    SELECT pt.product_name, pt.product_description
    FROM product_translations pt
    JOIN languages l ON pt.language_id = l.language_id
    WHERE pt.product_id = p_product_id
      AND l.iso_code = p_language_iso;

    -- If no translation found, fallback to English
    IF NOT FOUND THEN
        RETURN QUERY
        SELECT pt.product_name, pt.product_description
        FROM product_translations pt
        JOIN languages l ON pt.language_id = l.language_id
        WHERE pt.product_id = p_product_id
          AND l.iso_code = 'en';
    END IF;

    -- If still no translation, use original product data
    IF NOT FOUND THEN
        RETURN QUERY
        SELECT p.product_name, p.product_description
        FROM products p
        WHERE p.product_id = p_product_id;
    END IF;
END;
$$ LANGUAGE plpgsql;
