CREATE OR REPLACE FUNCTION add_product_customization_option(
    p_product_id INTEGER,
    p_customization_option_id INTEGER,
    p_is_required BOOLEAN DEFAULT FALSE,
    p_display_order INTEGER DEFAULT 0
) RETURNS BOOLEAN AS $$
DECLARE
    v_product_type PRODUCT_TYPE;
    v_option_exists BOOLEAN;
BEGIN
    -- Validate product exists and is configurable
    SELECT product_type INTO v_product_type
    FROM products
    WHERE product_id = p_product_id
    AND is_enabled = TRUE;

    IF v_product_type IS NULL THEN
        RAISE EXCEPTION 'Product ID % not found or is disabled', p_product_id
            USING ERRCODE = 'C0001';
    END IF;

    IF v_product_type != 'configurable' THEN
        RAISE EXCEPTION 'Can only add customization options to configurable products'
            USING ERRCODE = 'C0002',
                  HINT = 'Product type is: ' || v_product_type;
    END IF;

    -- Validate customization option exists
    SELECT EXISTS (
        SELECT 1 FROM customization_options
        WHERE customization_option_id = p_customization_option_id
        AND is_enabled = TRUE
    ) INTO v_option_exists;

    IF NOT v_option_exists THEN
        RAISE EXCEPTION 'Customization option ID % not found or is disabled', p_customization_option_id
            USING ERRCODE = 'C0003';
    END IF;

    -- Insert the association
    INSERT INTO product_customization_options (
        product_id,
        customization_option_id,
        is_required,
        display_order
    ) VALUES (
        p_product_id,
        p_customization_option_id,
        p_is_required,
        p_display_order
    ) ON CONFLICT (product_id, customization_option_id) DO UPDATE SET
        is_required = EXCLUDED.is_required,
        display_order = EXCLUDED.display_order;

    RAISE NOTICE 'Added customization option % to product %', p_customization_option_id, p_product_id;

    RETURN TRUE;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error adding customization option: % - %', SQLSTATE, SQLERRM;
        RAISE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
