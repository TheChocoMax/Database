CREATE OR REPLACE FUNCTION update_product_status(
    p_product_id INTEGER,
    p_is_enabled BOOLEAN,
    p_updated_by TEXT DEFAULT 'system'
) RETURNS BOOLEAN AS $$
DECLARE
    v_current_status BOOLEAN;
    v_product_name TEXT;
BEGIN
    -- Check if product exists and get current status
    SELECT is_enabled, product_name
    INTO v_current_status, v_product_name
    FROM products
    WHERE product_id = p_product_id;

    IF v_current_status IS NULL THEN
        RAISE EXCEPTION 'Product with ID % not found', p_product_id
            USING ERRCODE = 'P0021';
    END IF;

    -- Check if status change is needed
    IF v_current_status = p_is_enabled THEN
        RAISE NOTICE 'Product "%" already has status: %', v_product_name,
            CASE WHEN p_is_enabled THEN 'enabled' ELSE 'disabled' END;
        RETURN TRUE;
    END IF;

    -- Update product status
    UPDATE products
    SET is_enabled = p_is_enabled,
        updated_at = CURRENT_TIMESTAMP
    WHERE product_id = p_product_id;

    RAISE NOTICE 'Product "%" status changed to: %', v_product_name,
        CASE WHEN p_is_enabled THEN 'enabled' ELSE 'disabled' END;

    RETURN TRUE;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error updating product status: % - %', SQLSTATE, SQLERRM;
        RAISE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
