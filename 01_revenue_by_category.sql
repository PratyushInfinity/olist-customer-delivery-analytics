SELECT
    ct.product_category_name_english,
    COUNT(DISTINCT oi.order_id) AS num_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS avg_item_price
FROM olist.order_items oi
JOIN olist.products p ON oi.product_id = p.product_id
JOIN olist.category_translation ct ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 15;