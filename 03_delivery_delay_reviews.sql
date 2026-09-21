SELECT
    CASE
        WHEN DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) <= 0 THEN 'On Time or Early'
        WHEN DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) BETWEEN 1 AND 3 THEN '1-3 Days Late'
        WHEN DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) BETWEEN 4 AND 7 THEN '4-7 Days Late'
        WHEN DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) BETWEEN 8 AND 14 THEN '8-14 Days Late'
        ELSE '15+ Days Late'
    END AS delay_bucket,
    COUNT(*) AS num_orders,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM olist.orders o
JOIN olist.reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY delay_bucket
ORDER BY
    CASE delay_bucket
        WHEN 'On Time or Early' THEN 1
        WHEN '1-3 Days Late' THEN 2
        WHEN '4-7 Days Late' THEN 3
        WHEN '8-14 Days Late' THEN 4
        WHEN '15+ Days Late' THEN 5
    END;