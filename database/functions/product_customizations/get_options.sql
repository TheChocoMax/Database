CREATE OR REPLACE FUNCTION get_product_customization_options(
    p_product_id INTEGER,
    p_language_iso CHAR(2) DEFAULT 'en'
) RETURNS TABLE (
    option_id INTEGER,
    product_id INTEGER,
    option_name TEXT,
    option_type TEXT,
    is_required BOOLEAN,
    display_order INTEGER,
    created_at TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        co.customization_option_id as option_id,
        pco.product_id,
        COALESCE(cot.option_name, co.option_name) as option_name,
        co.option_type,
        COALESCE(pco.is_required, co.is_required) as is_required,
        COALESCE(pco.display_order, co.display_order) as display_order,
        pco.created_at
    FROM product_customization_options pco
    JOIN customization_options co ON pco.customization_option_id = co.customization_option_id
    LEFT JOIN customization_option_translations cot
        ON co.customization_option_id = cot.customization_option_id
        AND cot.language_id = (SELECT language_id FROM languages WHERE iso_code = p_language_iso)
    JOIN products p ON pco.product_id = p.product_id
    WHERE pco.product_id = p_product_id
    AND co.is_enabled = TRUE
    AND p.is_enabled = TRUE
    ORDER BY COALESCE(pco.display_order, co.display_order), co.option_name;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
