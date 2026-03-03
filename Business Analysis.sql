-- -- -- About the Menu

-- Q1	Which items sell the most?

select
	*,
	rank() over(order by times_ordered desc) item_rank
from
(
SELECT
  m.item_name,
  m.category,
  COUNT(*) AS times_ordered
FROM order_details o
JOIN menu_items m ON o.item_id = m.menu_item_id
GROUP BY m.item_name, m.category
)t
ORDER BY times_ordered DESC
LIMIT 10;



-- Best-selling item: Hamburger (622 orders). Top 3 are all from American and Asian categories. Italian's best entry (Spaghetti & Meatballs) comes in at #8.


-- Q2	Which items make the most money?

SELECT
  m.item_name,
  m.category,
  m.price,
  COUNT(*) AS times_ordered,
  ROUND(SUM(m.price), 2) AS total_revenue
FROM order_details o
INNER JOIN menu_items m ON o.item_id = m.menu_item_id
GROUP BY m.item_name, m.category, m.price
ORDER BY total_revenue DESC
LIMIT 10;

-- Top revenue item: Korean Beef Bowl at $10,554.60, it combines high volume (588 orders) with a premium price ($17.95). It earns $2,118 more than the #2 item.


-- Q3	Which category is most popular?

SELECT
  m.category,
  COUNT(*) AS items_sold,
  ROUND(COUNT(*) / SUM(COUNT(*)) OVER() * 100, 1) AS pct_of_total
FROM order_details o
JOIN menu_items m ON o.item_id = m.menu_item_id
GROUP BY m.category
ORDER BY items_sold DESC;

-- Most popular category: Asian (3,470 items sold, 28.7% of all orders). Italian and Mexican are almost tied for 2nd at 24.4% each.



-- Q4	Which category makes the most money?

SELECT
  m.category,
  COUNT(*) AS items_sold,
  ROUND(SUM(m.price), 2) AS total_revenue,
  ROUND(AVG(m.price), 2) AS avg_item_price
FROM order_details o
JOIN menu_items m ON o.item_id = m.menu_item_id
GROUP BY m.category
ORDER BY total_revenue DESC;

/*
Top revenue category: Italian ($49,463), despite selling fewer items than Asian. 
	Italian earns more because its average item price ($16.78) is $3.32 higher than Asian's.*/
    


-- -- -- About Time


-- Q5	What time of day are we busiest?

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

/*
4 hours classified as Peak (12, 13, 17, 18), all above 550 orders. 
Two clear rushes: Lunch (12–13) and Dinner (17–19). Dinner spans 3 consecutive high-traffic hours making it the longer and heavier rush overall.
*/


-- Q6	Which day of the week makes the most money?

SELECT
  DAYNAME(o.order_date) AS day_of_week,
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(SUM(m.price), 2) AS total_revenue,
  ROUND(SUM(m.price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM order_details o
JOIN menu_items m ON o.item_id = m.menu_item_id
GROUP BY DAYNAME(o.order_date), DAYOFWEEK(o.order_date)
ORDER BY DAYOFWEEK(o.order_date);

/*
Monday is the highest revenue day ($26,007) and has the most orders (885). 
Wednesday is the weakest at $19,902, a $6,105 gap vs Monday. 

Weekdays outperform weekends in this dataset.
*/


-- Q7	Is revenue growing month over month?


WITH monthly_data AS (
  SELECT
    MONTH(o.order_date) AS month_num,
    MONTHNAME(o.order_date) AS month,
    ROUND(SUM(m.price), 2) AS monthly_revenue,
    ROUND(SUM(m.price) / COUNT(DISTINCT o.order_date), 2) AS daily_avg
  FROM order_details o
  JOIN menu_items m ON o.item_id = m.menu_item_id
  GROUP BY MONTH(o.order_date), MONTHNAME(o.order_date)
)
SELECT
  month,
  monthly_revenue,
  daily_avg,
  ROUND(
    (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY month_num))
    / LAG(monthly_revenue) OVER (ORDER BY month_num) * 100,
  1) AS pct_vs_prev_month
FROM monthly_data
ORDER BY month_num;


/*
February drops 5.6% vs January in total revenue but has the highest daily average ($1,814), it simply has fewer days.
March recovers strongly at +7.5% to become the highest revenue month.
*/



-- -- -- About Orders


-- Q8	Which items are barely ordered, should we remove them?


SELECT
  m.item_name,
  m.category,
  m.price,
  COUNT(*) AS times_ordered,
  ROUND(SUM(m.price), 2) AS total_revenue
FROM order_details o
JOIN menu_items m ON o.item_id = m.menu_item_id
GROUP BY m.item_name, m.category, m.price
ORDER BY times_ordered ASC
LIMIT 10;

/*
Shrimp Scampi has only 239 orders but earns $4,768 because it is priced at $19.95, it is a high-margin item worth keeping. 
Chicken Tacos and Potstickers are the real candidates for removal or replacement because they have both low volume AND low revenue. 
Replacing them with a new item in their category could recover or improve their contribution.
*/


-- Q9	How many items do people usually order at once?


SELECT
  items_in_order,
  COUNT(*) AS number_of_orders,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS pct_of_orders
FROM (
  SELECT
    order_id,
    CASE
      WHEN COUNT(*) >= 5 THEN '5+'
      ELSE CAST(COUNT(*) AS CHAR)
    END AS items_in_order
  FROM order_details
  GROUP BY order_id
) order_sizes
GROUP BY items_in_order
ORDER BY items_in_order;


-- 67.2% of all orders contain just 1 or 2 items. 38.2% are single-item orders. Only 3.5% of orders have 5 or more items.



