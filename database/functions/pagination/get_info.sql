CREATE OR REPLACE FUNCTION get_pagination_info(
    p_page INTEGER,
    p_size INTEGER,
    p_total_count BIGINT
) RETURNS PAGINATION_INFO AS $$
DECLARE
    v_total_pages INTEGER;
BEGIN
    v_total_pages := CEIL(p_total_count::NUMERIC / p_size);

    RETURN ROW(
        p_page,
        p_size,
        p_total_count,
        v_total_pages,
        p_page < v_total_pages,  -- has_next
        p_page > 1             -- has_previous
    )::pagination_info;
END;
$$ LANGUAGE plpgsql;
