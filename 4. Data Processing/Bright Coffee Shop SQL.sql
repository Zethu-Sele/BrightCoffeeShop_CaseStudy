--------------------------------------------
--- Checking all columns limiting to 10 rows
--------------------------------------------
SELECT *
  FROM workspace.default.case_study
  LIMIT 10;

-----------------------------------------
---1. Checking date range 
-----------------------------------------
--- Data collection started on 2023-01-01 and ended on 2023-06-30 indicating a 6 month collection period
SELECT MIN(transaction_date) AS min_date
FROM case_study;

SELECT MAX(transaction_date) AS max_date
FROM case_study;

-----------------------------------------
---2. Checking Products
-----------------------------------------

SELECT DISTINCT(product_category)
FROM case_study;

SELECT DISTINCT(product_type)
FROM case_study;

SELECT DISTINCT(product_detail)
FROM case_study;

SELECT DISTINCT(product_category),product_type,product_detail
FROM case_study
SORT BY product_category;

-----------------------------------------
---3. Checking Stores
-----------------------------------------
------ We have 3 stores -----
SELECT DISTINCT(store_location)
FROM case_study;

SELECT COUNT(DISTINCT store_id) AS number_of_stores
FROM case_study;

-----------------------------------------
---3. Checking pricing
-----------------------------------------
----Cheapest is 0.8 and most expensive is 45
SELECT MIN(unit_price) As cheapest_price
FROM case_study;


SELECT MAX(unit_price) As expensive_price
FROM case_study;

----- Converting time
SELECT date_format(transaction_time, 'HH:mm:ss') AS time,
  *
  FROM case_study

---- Revenue by product type
SELECT product_type,
    ROUND(sum(unit_price * transaction_qty), 2) AS revenue
    FROM case_study
    GROUP BY product_type
    ORDER BY revenue DESC

-----Highest Revenue by date
SELECT transaction_date,
      dayname (transaction_date),
    SUM(unit_price * transaction_qty) AS revenue
    FROM case_study
    GROUP BY transaction_date
    ORDER BY revenue DESC;

---- Highest Revenue by date and time
SELECT transaction_date,
date_format(transaction_time, 'HH:mm:ss') AS time, 
    SUM(unit_price * transaction_qty) AS revenue
    FROM case_study
    GROUP BY transaction_date, time
    ORDER BY revenue DESC

------Revenue by store---------
SELECT store_location,
     ROUND(SUM(unit_price * transaction_qty), 2) AS REVENUE
      FROM case_study
      GROUP BY store_location
      ORDER BY REVENUE DESC

------Sales qty by store------
SELECT store_location,
     SUM(transaction_qty) AS Sales
      FROM case_study
      GROUP BY store_location
      ORDER BY Sales DESC

-----Highest revenue by product tyep by store-----
SELECT product_type,
      store_location,
      ROUND(SUM(unit_price * transaction_qty), 0) AS revenue
      FROM case_study
      GROUP BY product_type, store_location
      ORDER BY revenue DESC

----Highest transaction per store by product type by weekday
SELECT store_location,
      product_type,
      dayname(transaction_date) AS week_day,
      ROUND(SUM(unit_price * transaction_qty), 2) AS revenue
      FROM case_study
      GROUP BY store_location, product_type,week_day
      ORDER BY revenue DESC



SELECT *
FROM case_study
LIMIT 10;

---------------------------------------
--- AGGREGATIONS---------
---------------------------------------

-----Daily sales qty and revenue by day and month and time buckets
SELECT 
-- Dates
      transaction_date,
      dayname(transaction_date) AS day_name,
      monthname(transaction_date) AS month_name,
      date_format(transaction_time,'HH:mm:ss') AS purchase_time,

      CASE 
            WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '00:00:00' AND '11:59:59' THEN '01. Morning Rush'
            WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN '02. Afternoon Rush'
            WHEN date_format(transaction_time,'HH:mm:ss') >= '17:00:00' THEN '03. Evening Rush'
      END AS time_buckets,
      
-- Count of IDs
      COUNT(DISTINCT transaction_id) AS number_of_sales,
      COUNT(DISTINCT product_id) AS number_of_products,
      COUNT(DISTINCT store_id) AS number_of_stores,
-- Revenue
      SUM(transaction_qty*unit_price) AS daily_revenue,
-- Categorical columns
      store_location,
      product_category,
      product_detail
FROM case_study
GROUP BY transaction_date,
         day_name,
      store_location,
      product_category,
      product_detail,
      purchase_time,
      time_buckets,
      month_name;

------Revenue by month
SELECT monthname(transaction_date) AS month_name,
      COUNT(DISTINCT transaction_id) AS number_of_sales,
      SUM(Transaction_qty*unit_price) AS monthly_revenue
FROM case_study
GROUP BY month_name
ORDER BY monthly_revenue DESC;

----- Add weekend or weekday
SELECT 
-- Dates
      transaction_date,
      dayname(transaction_date) AS day_name,
      monthname(transaction_date) AS month_name,
      dayofmonth(transaction_date) AS day_of_month,
            CASE 
                  WHEN dayname(transaction_date) IN ('Sun','Sat') THEN 'Weekend'
                  ELSE 'Weekday'
      END AS day_classification,

      date_format(transaction_time,'HH:mm:ss') AS purchase_time,

      CASE 
            WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '00:00:00' AND '11:59:59' THEN '01. Morning Rush'
            WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN '02. Afternoon Rush'
            WHEN date_format(transaction_time,'HH:mm:ss') >= '17:00:00' THEN '03. Evening Rush'
      END AS time_buckets,
      
-- Count of IDs
      COUNT(DISTINCT transaction_id) AS number_of_sales,
      COUNT(DISTINCT product_id) AS number_of_products,
      COUNT(DISTINCT store_id) AS number_of_stores,
-- Revenue
      SUM(transaction_qty*unit_price) AS daily_revenue,
-- Categorical columns
      store_location,
      product_category,
      product_detail
FROM case_study
GROUP BY transaction_date,
         day_name,
      store_location,
      product_category,
      product_detail,
      purchase_time,
      time_buckets,
      day_classification,
      day_of_month,
      month_name;

----- Spend classifications
SELECT 
-- Dates
      transaction_date,
      dayname(transaction_date) AS day_name,
      monthname(transaction_date) AS month_name,
      dayofmonth(transaction_date) AS day_of_month,
            CASE
                  WHEN dayname(transaction_date) IN ('Sun','Sat') THEN 'Weekend'
                  ELSE 'Weekday'
            END AS day_classification,

      date_format(transaction_time,'HH:mm:ss') AS purchase_time,

      CASE 
            WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '00:00:00' AND '11:59:59' THEN '01. Morning Rush'
            WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN '02. Afternoon Rush'
            WHEN date_format(transaction_time,'HH:mm:ss') >= '17:00:00' THEN '03. Evening Rush'
      END AS time_buckets,
      
-- Count of IDs
      COUNT(DISTINCT transaction_id) AS number_of_sales,
      COUNT(DISTINCT product_id) AS number_of_products,
      COUNT(DISTINCT store_id) AS number_of_stores,
-- Revenue
      SUM(transaction_qty*unit_price) AS daily_revenue,

      CASE 
            WHEN daily_revenue <50 THEN '01. Low Spend'
            WHEN daily_revenue BETWEEN 51 AND 100 THEN '02. Mid Spend'
            ELSE '03. High Spend'

      END AS Spend_classification,
-- Categorical columns
      store_location,
      product_category,
      product_detail
FROM case_study
GROUP BY transaction_date,
         day_name,
      store_location,
      product_category,
      product_detail,
      purchase_time,
      time_buckets,
      day_classification,
      day_of_month,
      month_name;
