CREATE OR REPLACE FUNCTION calculate_product_price(
    p_product_id INTEGER,
    p_variant_id INTEGER DEFAULT NULL,
    p_customization_values INTEGER [] DEFAULT NULL
) RETURNS NUMERIC(10, 2) AS $$
DECLARE
    base_price NUMERIC(10, 2);
    final_price NUMERIC(10, 2);
    customization_total NUMERIC(10, 2) := 0;
    product_type_val product_type;
BEGIN
    -- Get product type and base pricing
    SELECT p.product_type,
           CASE
               WHEN p.product_type = 'variant_based' AND p_variant_id IS NOT NULL THEN
                   COALESCE(pv.price_override, p.price)
               WHEN p.product_type = 'configurable' THEN p.base_price
               ELSE p.price
           END
    INTO product_type_val, base_price
    FROM products p
    LEFT JOIN product_variants pv ON p.product_id = pv.product_id
        AND pv.product_variant_id = p_variant_id
    WHERE p.product_id = p_product_id;

    IF base_price IS NULL THEN
        RAISE EXCEPTION 'Product not found or invalid configuration';
    END IF;

    final_price := base_price;

    -- Add customization costs for configurable products
    IF product_type_val = 'configurable' AND p_customization_values IS NOT NULL THEN
        SELECT COALESCE(SUM(price_modifier), 0) INTO customization_total
        FROM customization_option_values
        WHERE option_value_id = ANY(p_customization_values);

        final_price := final_price + customization_total;
    END IF;

    RETURN GREATEST(final_price, 0); -- Ensure price is never negative
END;
$$ LANGUAGE plpgsql;
