CREATE OR REPLACE FUNCTION add_product_variant(
    p_product_id INTEGER,
    p_variant_name TEXT,
    p_size TEXT DEFAULT NULL,
    p_quantity INTEGER DEFAULT NULL,
    p_serving_size TEXT DEFAULT NULL,
    p_price_override NUMERIC(10, 2) DEFAULT NULL,
    p_is_default BOOLEAN DEFAULT FALSE,
    p_display_order INTEGER DEFAULT 0
) RETURNS INTEGER AS $$
DECLARE
    v_variant_id INTEGER;
    v_product_type PRODUCT_TYPE;
    v_product_exists BOOLEAN;
BEGIN
    -- Validate product exists and is variant-based
    SELECT product_type INTO v_product_type
    FROM products
    WHERE product_id = p_product_id
    AND is_enabled = TRUE;

    IF v_product_type IS NULL THEN
        RAISE EXCEPTION 'Product ID % not found or is disabled', p_product_id
            USING ERRCODE = 'V0001';
    END IF;

    IF v_product_type != 'variant_based' THEN
        RAISE EXCEPTION 'Can only add variants to variant_based products'
            USING ERRCODE = 'V0002',
                  HINT = 'Product type is: ' || v_product_type;
    END IF;

    -- Validate required fields
    IF p_variant_name IS NULL OR TRIM(p_variant_name) = '' THEN
        RAISE EXCEPTION 'Variant name cannot be empty'
            USING ERRCODE = 'V0003';
    END IF;

    -- Validate quantity if provided
    IF p_quantity IS NOT NULL AND p_quantity <= 0 THEN
        RAISE EXCEPTION 'Quantity must be positive'
            USING ERRCODE = 'V0004';
    END IF;

    -- Validate price override if provided
    IF p_price_override IS NOT NULL AND p_price_override < 0 THEN
        RAISE EXCEPTION 'Price override cannot be negative'
            USING ERRCODE = 'V0005';
    END IF;

    -- Check for duplicate variant name within product
    IF EXISTS (
        SELECT 1 FROM product_variants
        WHERE product_id = p_product_id
        AND LOWER(variant_name) = LOWER(TRIM(p_variant_name))
    ) THEN
        RAISE EXCEPTION 'A variant with this name already exists for this product'
            USING ERRCODE = 'V0006';
    END IF;

    -- If setting as default, unset other defaults
    IF p_is_default THEN
        UPDATE product_variants
        SET is_default = FALSE, updated_at = CURRENT_TIMESTAMP
        WHERE product_id = p_product_id AND is_default = TRUE;
    END IF;

    -- Insert variant
    INSERT INTO product_variants (
        product_id,
        variant_name,
        size,
        quantity,
        serving_size,
        price_override,
        is_default,
        display_order,
        is_test
    ) VALUES (
        p_product_id,
        TRIM(p_variant_name),
        p_size,
        p_quantity,
        p_serving_size,
        p_price_override,
        p_is_default,
        p_display_order,
        FALSE  -- Not a test variant
    ) RETURNING product_variant_id INTO v_variant_id;

    RAISE NOTICE 'Added variant ID % to product ID %', v_variant_id, p_product_id;

    RETURN v_variant_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error adding variant to product %: % - %', p_product_id, SQLSTATE, SQLERRM;
        RAISE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
