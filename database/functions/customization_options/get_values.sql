CREATE OR REPLACE FUNCTION get_customization_option_values(
    p_customization_option_id INTEGER,
    p_language_iso CHAR(2) DEFAULT 'en'
) RETURNS TABLE (
    value_id INTEGER,
    customization_option_id INTEGER,
    value_name TEXT,
    price_modifier NUMERIC(10, 2),
    is_default BOOLEAN,
    display_order INTEGER,
    is_enabled BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        cov.option_value_id as value_id,
        cov.customization_option_id,
        COALESCE(covt.value_name, cov.value_name) as value_name,
        cov.price_modifier,
        cov.is_default,
        cov.display_order,
        cov.is_enabled
    FROM customization_option_values cov
    LEFT JOIN customization_option_value_translations covt
        ON cov.option_value_id = covt.option_value_id
        AND covt.language_id = (SELECT language_id FROM languages WHERE iso_code = p_language_iso)
    WHERE cov.customization_option_id = p_customization_option_id
    AND cov.is_enabled = TRUE
    ORDER BY cov.display_order, cov.value_name;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
