-- ============================================================
-- Shopping Product List Query
-- Mirrors: ProductRepository.findShoppingProductList()
-- Returns: product info + variant count + lowest active price
--          per type (retail, wholesale, retail sale, wholesale sale)
--          with oldest start date, ordered by price ASC
-- ============================================================
WITH active_prices AS (
    -- All variant prices currently within their active date window
    SELECT
        v.product_id,
        vp.id           AS price_id,
        vp.price_type,
        vp.price,
        vp.price_start_date,
        vp.price_end_date,
        ROW_NUMBER() OVER (
            PARTITION BY v.product_id, vp.price_type
            -- Lowest price first; tie-break: oldest start date (NULL = oldest), then created_at
            ORDER BY
                vp.price ASC,
                COALESCE(vp.price_start_date, '1970-01-01'::timestamp) ASC,
                vp.created_at ASC
            ) AS rn
    FROM variant_prices vp
             JOIN product_variants v ON v.id = vp.variant_id
    WHERE (vp.price_start_date IS NULL OR vp.price_start_date <= NOW())
      AND (vp.price_end_date   IS NULL OR vp.price_end_date   >= NOW())
),
     lowest_prices AS (
         -- One row per (product, price_type) — the cheapest active price
         SELECT * FROM active_prices WHERE rn = 1
     ),
     variant_counts AS (
         SELECT product_id, COUNT(*) AS variant_count
         FROM product_variants
         GROUP BY product_id
     )
SELECT
    p.id,
    p.name,
    p.short_description,
    COALESCE(vc.variant_count, 0)   AS variant_count,

    -- Retail Price
    rp.price_id                     AS retail_price_id,
    rp.price                        AS retail_price,
    rp.price_start_date             AS retail_price_start_date,
    rp.price_end_date               AS retail_price_end_date,

    -- Wholesale Price
    wp.price_id                     AS wholesale_price_id,
    wp.price                        AS wholesale_price,
    wp.price_start_date             AS wholesale_price_start_date,
    wp.price_end_date               AS wholesale_price_end_date,

    -- Retail Sale Price
    rsp.price_id                    AS retail_sale_price_id,
    rsp.price                       AS retail_sale_price,
    rsp.price_start_date            AS retail_sale_price_start_date,
    rsp.price_end_date              AS retail_sale_price_end_date,

    -- Wholesale Sale Price
    wsp.price_id                    AS wholesale_sale_price_id,
    wsp.price                       AS wholesale_sale_price,
    wsp.price_start_date            AS wholesale_sale_price_start_date,
    wsp.price_end_date              AS wholesale_sale_price_end_date

FROM products p
         LEFT JOIN categories   c   ON c.id  = p.category_id
         LEFT JOIN brands       b   ON b.id  = p.brand_id
         LEFT JOIN variant_counts  vc  ON vc.product_id  = p.id
         LEFT JOIN lowest_prices   rp  ON rp.product_id  = p.id AND rp.price_type = 'RETAIL_PRICE'
         LEFT JOIN lowest_prices   wp  ON wp.product_id  = p.id AND wp.price_type = 'WHOLESALE_PRICE'
         LEFT JOIN lowest_prices   rsp ON rsp.product_id = p.id AND rsp.price_type = 'RETAIL_SALE_PRICE'
         LEFT JOIN lowest_prices   wsp ON wsp.product_id = p.id AND wsp.price_type = 'WHOLESALE_SALE_PRICE'
WHERE EXISTS (
    SELECT 1
    FROM product_variants v
             JOIN variant_prices vp ON vp.variant_id = v.id
    WHERE v.product_id = p.id
      AND vp.price_type IN (
                            'RETAIL_PRICE',
                            'WHOLESALE_PRICE',
                            'RETAIL_SALE_PRICE',
                            'WHOLESALE_SALE_PRICE'
        )
      AND (vp.price_start_date IS NULL OR vp.price_start_date <= NOW())
      AND (vp.price_end_date   IS NULL OR vp.price_end_date   >= NOW())
)
ORDER BY p.name ASC;
