WITH rfm AS (
    SELECT
        c.customer_unique_id,
        DATEDIFF((SELECT MAX(order_purchase_timestamp) FROM olist.orders), MAX(o.order_purchase_timestamp)) AS recency_days,
        COUNT(DISTINCT o.order_id) AS frequency,
        ROUND(SUM(oi.price), 2) AS monetary
    FROM olist.orders o
    JOIN olist.customers c ON o.customer_id = c.customer_id
    JOIN olist.order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
rfm_scored AS (
    SELECT
        customer_unique_id,
        recency_days,
        frequency,
        monetary,
        NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,
        CASE
            WHEN frequency = 1 THEN 1
            WHEN frequency = 2 THEN 3
            WHEN frequency >= 3 THEN 4
        END AS f_score,
        NTILE(4) OVER (ORDER BY monetary ASC) AS m_score
    FROM rfm
)
SELECT
    customer_unique_id,
    recency_days,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    CASE
        WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Champions'
        WHEN r_score >= 3 AND f_score = 1 THEN 'New/Promising'
        WHEN r_score <= 2 AND f_score >= 3 AND m_score >= 3 THEN 'At Risk'
        WHEN r_score <= 2 AND f_score = 1 AND m_score <= 2 THEN 'Lost'
        ELSE 'Needs Attention'
    END AS segment
FROM rfm_scored
ORDER BY monetary DESC