-- Custom exception types for better error handling
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'raise_product_exception') THEN
        NULL;
    END IF;
END $$;

CREATE OR REPLACE FUNCTION add_new_product(
    -- Required product information
    p_product_name TEXT,
    p_product_description TEXT,
    p_product_type PRODUCT_TYPE,
    p_category_id INTEGER,

    -- Pricing (one must be provided based on product type)
    p_price NUMERIC(10, 2) DEFAULT NULL,
    p_base_price NUMERIC(10, 2) DEFAULT NULL,

    -- Optional product details
    p_image_url TEXT DEFAULT NULL,
    p_preparation_time_hours INTEGER DEFAULT 48,
    p_min_order_hours INTEGER DEFAULT 48,
    p_serving_info TEXT DEFAULT NULL,
    p_is_customizable BOOLEAN DEFAULT FALSE,

    -- Optional arrays for related data
    p_tag_ids INTEGER [] DEFAULT NULL,
    p_attributes JSONB DEFAULT NULL, -- Format: [{"name": "allergen", "value": "gluten", "color": "#FF6B6B"}]
    p_translations JSONB DEFAULT NULL, -- Format: [{"language_iso": "en", "name": "...", "description": "..."}]

    -- Audit information
    p_created_by TEXT DEFAULT 'system'
) RETURNS INTEGER AS $$
DECLARE
    v_product_id INTEGER;
    v_category_exists BOOLEAN;
    v_tag_record RECORD;
    v_attr_record RECORD;
    v_trans_record RECORD;
    v_language_id INTEGER;
BEGIN
    -- =============================================================================
    -- INPUT VALIDATION AND SECURITY CHECKS
    -- =============================================================================

    -- Validate required fields
    IF p_product_name IS NULL OR TRIM(p_product_name) = '' THEN
        RAISE EXCEPTION 'Product name cannot be empty'
            USING ERRCODE = 'P0001',
                  HINT = 'Please provide a valid product name';
    END IF;

    IF p_product_description IS NULL OR TRIM(p_product_description) = '' THEN
        RAISE EXCEPTION 'Product description cannot be empty'
            USING ERRCODE = 'P0002',
                  HINT = 'Please provide a product description';
    END IF;

    -- Validate product name length and format
    IF LENGTH(TRIM(p_product_name)) < 3 THEN
        RAISE EXCEPTION 'Product name must be at least 3 characters long'
            USING ERRCODE = 'P0003';
    END IF;

    IF LENGTH(TRIM(p_product_name)) > 200 THEN
        RAISE EXCEPTION 'Product name cannot exceed 200 characters'
            USING ERRCODE = 'P0004';
    END IF;

    -- Sanitize and validate product name (prevent XSS)
    IF p_product_name ~ '[<>''"]' THEN
        RAISE EXCEPTION 'Product name contains invalid characters'
            USING ERRCODE = 'P0005',
                  HINT = 'Product name cannot contain <, >, quotes, or other special characters';
    END IF;

    -- Validate description length
    IF LENGTH(p_product_description) > 2000 THEN
        RAISE EXCEPTION 'Product description cannot exceed 2000 characters'
            USING ERRCODE = 'P0006';
    END IF;

    -- Validate pricing based on product type
    IF p_product_type = 'configurable' THEN
        IF p_base_price IS NULL OR p_base_price < 0 THEN
            RAISE EXCEPTION 'Configurable products require a valid base_price >= 0'
                USING ERRCODE = 'P0007',
                      HINT = 'Set base_price for configurable products';
        END IF;
        IF p_price IS NOT NULL THEN
            RAISE WARNING 'Price field ignored for configurable products, using base_price';
        END IF;
    ELSE
        IF p_price IS NULL OR p_price < 0 THEN
            RAISE EXCEPTION 'Standard and variant-based products require a valid price >= 0'
                USING ERRCODE = 'P0008',
                      HINT = 'Set price for non-configurable products';
        END IF;
        IF p_base_price IS NOT NULL THEN
            RAISE WARNING 'Base price field ignored for non-configurable products';
        END IF;
    END IF;

    -- Validate time constraints
    IF p_preparation_time_hours < 0 OR p_preparation_time_hours > 8760 THEN -- Max 1 year
        RAISE EXCEPTION 'Preparation time must be between 0 and 8760 hours'
            USING ERRCODE = 'P0009';
    END IF;

    IF p_min_order_hours < 0 OR p_min_order_hours > 8760 THEN
        RAISE EXCEPTION 'Minimum order time must be between 0 and 8760 hours'
            USING ERRCODE = 'P0010';
    END IF;

    -- Validate category exists and is enabled
    SELECT EXISTS (
        SELECT 1 FROM product_categories
        WHERE category_id = p_category_id
        AND is_enabled = TRUE
    ) INTO v_category_exists;

    IF NOT v_category_exists THEN
        RAISE EXCEPTION 'Invalid or disabled category ID: %', p_category_id
            USING ERRCODE = 'P0011',
                  HINT = 'Please select a valid, enabled category';
    END IF;

    -- Validate image URL format if provided
    IF p_image_url IS NOT NULL AND p_image_url !~ '^https?://[^\s]+\.(jpg|jpeg|png|webp)(\?[^\s]*)?$' THEN
        RAISE EXCEPTION 'Invalid image URL format'
            USING ERRCODE = 'P0012',
                  HINT = 'Image URL must be a valid HTTP/HTTPS URL pointing to jpg, jpeg, png, or webp file';
    END IF;

    -- Check for duplicate product names (case-insensitive)
    IF EXISTS (
        SELECT 1 FROM products
        WHERE LOWER(product_name) = LOWER(TRIM(p_product_name))
        AND is_enabled = TRUE
    ) THEN
        RAISE EXCEPTION 'A product with this name already exists'
            USING ERRCODE = 'P0013',
                  HINT = 'Please choose a different product name';
    END IF;

    -- Validate tag IDs if provided
    IF p_tag_ids IS NOT NULL THEN
        FOR i IN 1..array_length(p_tag_ids, 1) LOOP
            IF NOT EXISTS (
                SELECT 1 FROM product_tags
                WHERE product_tag_id = p_tag_ids[i]
                AND is_enabled = TRUE
            ) THEN
                RAISE EXCEPTION 'Invalid or disabled tag ID: %', p_tag_ids[i]
                    USING ERRCODE = 'P0014',
                          HINT = 'All tag IDs must reference existing, enabled tags';
            END IF;
        END LOOP;
    END IF;

    -- =============================================================================
    -- INSERT MAIN PRODUCT RECORD
    -- =============================================================================

    INSERT INTO products (
        category_id,
        product_name,
        product_description,
        product_type,
        price,
        base_price,
        image_url,
        preparation_time_hours,
        min_order_hours,
        serving_info,
        is_customizable
    ) VALUES (
        p_category_id,
        TRIM(p_product_name),
        TRIM(p_product_description),
        p_product_type,
        CASE WHEN p_product_type != 'configurable' THEN p_price ELSE NULL END,
        CASE WHEN p_product_type = 'configurable' THEN p_base_price ELSE NULL END,
        p_image_url,
        p_preparation_time_hours,
        p_min_order_hours,
        p_serving_info,
        p_is_customizable
    ) RETURNING product_id INTO v_product_id;

    -- =============================================================================
    -- ADD RELATED DATA
    -- =============================================================================

    -- Add tag associations
    IF p_tag_ids IS NOT NULL AND array_length(p_tag_ids, 1) > 0 THEN
        FOR i IN 1..array_length(p_tag_ids, 1) LOOP
            INSERT INTO product_tag_assignments (product_id, product_tag_id)
            VALUES (v_product_id, p_tag_ids[i])
            ON CONFLICT (product_id, product_tag_id) DO NOTHING;
        END LOOP;

        RAISE NOTICE 'Added % tag associations', array_length(p_tag_ids, 1);
    END IF;

    -- Add product attributes
    IF p_attributes IS NOT NULL THEN
        FOR v_attr_record IN SELECT * FROM jsonb_array_elements(p_attributes) LOOP
            -- Validate attribute structure
            IF NOT (v_attr_record.value ? 'name' AND v_attr_record.value ? 'value') THEN
                RAISE EXCEPTION 'Each attribute must have "name" and "value" fields'
                    USING ERRCODE = 'P0015';
            END IF;

            -- Validate attribute name and value
            IF TRIM(v_attr_record.value->>'name') = '' OR TRIM(v_attr_record.value->>'value') = '' THEN
                RAISE EXCEPTION 'Attribute name and value cannot be empty'
                    USING ERRCODE = 'P0016';
            END IF;

            -- Validate hex color if provided
            IF v_attr_record.value ? 'color' THEN
                IF NOT (v_attr_record.value->>'color' ~ '^#[0-9A-Fa-f]{6}$') THEN
                    RAISE EXCEPTION 'Invalid hex color format: %', v_attr_record.value->>'color'
                        USING ERRCODE = 'P0017',
                              HINT = 'Color must be in format #RRGGBB';
                END IF;
            END IF;

            INSERT INTO product_attributes (
                product_id,
                attribute_name,
                attribute_value,
                attribute_color
            ) VALUES (
                v_product_id,
                TRIM(v_attr_record.value->>'name'),
                TRIM(v_attr_record.value->>'value'),
                COALESCE((v_attr_record.value->>'color')::HEX_COLOR, '#32cd32')
            ) ON CONFLICT (product_id, attribute_name, attribute_value) DO NOTHING;
        END LOOP;

        RAISE NOTICE 'Added product attributes';
    END IF;

    -- Add translations
    IF p_translations IS NOT NULL THEN
        FOR v_trans_record IN SELECT * FROM jsonb_array_elements(p_translations) LOOP
            -- Validate translation structure
            IF NOT (v_trans_record.value ? 'language_iso' AND v_trans_record.value ? 'name') THEN
                RAISE EXCEPTION 'Each translation must have "language_iso" and "name" fields'
                    USING ERRCODE = 'P0018';
            END IF;

            -- Get language ID
            SELECT language_id INTO v_language_id
            FROM languages
            WHERE iso_code = v_trans_record.value->>'language_iso';

            IF v_language_id IS NULL THEN
                RAISE EXCEPTION 'Invalid language ISO code: %', v_trans_record.value->>'language_iso'
                    USING ERRCODE = 'P0019',
                          HINT = 'Language must exist in languages table';
            END IF;

            -- Validate translation data
            IF TRIM(v_trans_record.value->>'name') = '' THEN
                RAISE EXCEPTION 'Translation name cannot be empty'
                    USING ERRCODE = 'P0020';
            END IF;

            INSERT INTO product_translations (
                product_id,
                language_id,
                product_name,
                product_description
            ) VALUES (
                v_product_id,
                v_language_id,
                TRIM(v_trans_record.value->>'name'),
                TRIM(COALESCE(v_trans_record.value->>'description', ''))
            ) ON CONFLICT (product_id, language_id) DO UPDATE SET
                product_name = EXCLUDED.product_name,
                product_description = EXCLUDED.product_description;
        END LOOP;

        RAISE NOTICE 'Added product translations';
    END IF;

    -- Log successful creation
    RAISE NOTICE 'Successfully created product ID % with name "%"', v_product_id, p_product_name;

    RETURN v_product_id;

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error for debugging
        RAISE NOTICE 'Error creating product "%": % - %', p_product_name, SQLSTATE, SQLERRM;
        RAISE; -- Re-raise the exception
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
