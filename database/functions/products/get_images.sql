CREATE OR REPLACE FUNCTION get_product_images(
    p_product_id INTEGER,
    p_variant_id INTEGER DEFAULT NULL
) RETURNS TABLE (
    image_id INTEGER,
    product_id INTEGER,
    variant_id INTEGER,
    image_url TEXT,
    is_primary BOOLEAN,
    created_at TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        pi.product_image_id as image_id,
        pi.product_id,
        pi.variant_id,
        pi.image_url,
        pi.is_primary,
        pi.created_at
    FROM product_images pi
    JOIN products p ON pi.product_id = p.product_id
    WHERE pi.product_id = p_product_id
    AND (p_variant_id IS NULL OR pi.variant_id = p_variant_id OR pi.variant_id IS NULL)
    AND p.is_enabled = TRUE
    ORDER BY pi.is_primary DESC, pi.created_at;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
