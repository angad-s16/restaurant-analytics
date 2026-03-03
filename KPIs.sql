-- Total Revenue

select sum(m.price) totalrevenue
from order_details o
inner join menu_items m
on m.menu_item_id = o.item_id;


-- Total Number of Orders

select count(distinct order_id) totalorders
from order_details;


-- Average Order Value (AOV)

SELECT
  ROUND(SUM(m.price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM order_details o
JOIN menu_items m ON o.item_id = m.menu_item_id;


-- Average Items Per Order

SELECT
  ROUND(COUNT(*) / COUNT(DISTINCT order_id), 0) AS avg_items_per_order
FROM order_details;



-- Best-Selling Item by Volume

SELECT
  m.item_name,
  m.category,
  COUNT(*) AS times_ordered
FROM order_details o
JOIN menu_items m ON o.item_id = m.menu_item_id
GROUP BY m.item_name, m.category
ORDER BY times_ordered DESC
LIMIT 10;

-- Top Item Per Category by Volume

SELECT 
	item,
    category,
    times_ordered
FROM 
(
  SELECT
    m.item_name item,
    m.category category,
    COUNT(*) AS times_ordered,
    RANK() OVER (PARTITION BY m.category ORDER BY COUNT(*) DESC) AS category_rank
  FROM order_details o
  JOIN menu_items m ON o.item_id = m.menu_item_id
  GROUP BY m.item_name, m.category
) t
WHERE category_rank = 1
ORDER BY times_ordered DESC;

-- Highest Revenue-Generating Item

SELECT
  m.item_name,
  m.category,
  COUNT(*) AS times_ordered,
  m.price,
  ROUND(SUM(m.price), 2) AS total_revenue
FROM order_details o
JOIN menu_items m ON o.item_id = m.menu_item_id
GROUP BY m.item_name, m.category, m.price
ORDER BY total_revenue DESC
LIMIT 10;

-- Revenue by Category

SELECT
  m.category,
  COUNT(*) AS items_sold,
  ROUND(SUM(m.price), 2) AS total_revenue,
  ROUND(AVG(m.price), 2) AS avg_item_price,
  ROUND(SUM(m.price) / COUNT(DISTINCT o.order_id), 2) AS revenue_per_order
FROM order_details o
JOIN menu_items m ON o.item_id = m.menu_item_id
GROUP BY m.category
ORDER BY total_revenue DESC;


-- Peak Order Hour

SELECT
  HOUR(order_time) AS hour_of_day,
  COUNT(DISTINCT order_id) AS total_orders,
  CASE
    WHEN COUNT(DISTINCT order_id) >= 550 THEN 'Peak'
    WHEN COUNT(DISTINCT order_id) BETWEEN 400 AND 549 THEN 'Busy'
    WHEN COUNT(DISTINCT order_id) BETWEEN 200 AND 399 THEN 'Moderate'
    WHEN COUNT(DISTINCT order_id) BETWEEN 50 AND 199 THEN 'Quiet'
    ELSE 'Closed'
  END AS traffic_level
FROM order_details
GROUP BY HOUR(order_time)
ORDER BY hour_of_day;


-- Daily Revenue Trend 

WITH monthly_data AS (
    SELECT
        MONTH(o.order_date) AS month_num,
        MONTHNAME(o.order_date) AS month,
        ROUND(SUM(m.price), 2) AS monthly_revenue,
		ROUND(SUM(m.price) / COUNT(DISTINCT o.order_date), 2) AS daily_avg
    FROM order_details o
    JOIN menu_items m 
        ON o.item_id = m.menu_item_id
    GROUP BY MONTH(o.order_date), MONTHNAME(o.order_date)
)

SELECT
    month,
    monthly_revenue,
    daily_avg,
    ROUND(
        (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY month_num))
        / LAG(monthly_revenue) OVER (ORDER BY month_num) * 100,
    1) AS pct_vs_prev
FROM monthly_data
ORDER BY month_num;





/* 
-- Total Revenue for Q1 2023: $159,217.90
-- Total Orders: 5,370
-- Average Order Value: $29.65
-- Average Items Per Order: 2.28
-- Best-Selling Item: Hamburger (622 orders), closely followed by Edamame (620)
-- Top Revenue Item: Korean Beef Bowl at $10,554.60, driven by high price ($17.95) and high volume (588 orders)
-- Italian leads in revenue ($49,463) despite being 2nd in volume. Asian leads in items sold (3,470) but sits 2nd in revenue. American is the most affordable category.
-- Peak Hours: 12:00, 13:00, 17:00, 18:00 — all classified as "Peak" (550+ orders). 19:00, 16:00, and 14:00 fall into "Busy" (400–549 orders). 
	Two clear rushes confirmed: Lunch (12–13) and Dinner (17–19), with Dinner actually spanning 3 consecutive high-traffic hours making it the longer and heavier rush overall.
-- Monthly revenue ranges from $50,790 (Feb) to $54,611 (Mar). February dips despite fewer days, then March recovers to the highest month overall.
*/







































