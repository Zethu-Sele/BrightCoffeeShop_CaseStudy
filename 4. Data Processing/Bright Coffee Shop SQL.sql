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
