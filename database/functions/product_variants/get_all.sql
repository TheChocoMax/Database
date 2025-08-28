CREATE OR REPLACE FUNCTION get_product_variants(
    p_product_id INTEGER
) RETURNS TABLE (
    variant_id INTEGER,
    product_id INTEGER,
    variant_name TEXT,
    size TEXT,
    quantity INTEGER,
    serving_size TEXT,
    price_override NUMERIC(10, 2),
    final_price NUMERIC(10, 2),
    is_default BOOLEAN,
    display_order INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        pv.product_variant_id as variant_id,
        pv.product_id,
        pv.variant_name,
        pv.size,
        pv.quantity,
        pv.serving_size,
        pv.price_override,
        COALESCE(pv.price_override, p.price) as final_price,
        pv.is_default,
        pv.display_order
    FROM product_variants pv
    JOIN products p ON pv.product_id = p.product_id
    WHERE pv.product_id = p_product_id
    AND pv.is_test = FALSE
    AND p.is_enabled = TRUE
    ORDER BY pv.display_order, pv.product_variant_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
