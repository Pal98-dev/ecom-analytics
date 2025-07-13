CREATE OR REPLACE TABLE `profound-outlet-465808-b3.ecommerce_analytics.daily_sessions_jan2017` AS
SELECT
  PARSE_DATE('%Y%m%d', date) AS session_date,
  COUNT(*) AS total_sessions
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170131'
GROUP BY session_date
ORDER BY session_date;

CREATE OR REPLACE TABLE `profound-outlet-465808-b3.ecommerce_analytics.revenue_by_device_jan2017` AS
SELECT
  device.deviceCategory AS device_type,
  SUM(totals.totalTransactionRevenue)/1000000 AS revenue_usd
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170131'
  AND totals.totalTransactionRevenue IS NOT NULL
GROUP BY device_type
ORDER BY revenue_usd DESC;

CREATE OR REPLACE TABLE `profound-outlet-465808-b3.ecommerce_analytics.traffic_sources_jan2017` AS
SELECT
  trafficSource.source AS source,
  COUNT(*) AS total_sessions
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170131'
GROUP BY source
ORDER BY total_sessions DESC
LIMIT 10;


CREATE OR REPLACE TABLE `profound-outlet-465808-b3.ecommerce_analytics.product_revenue_jan2017` AS
SELECT
  product.v2ProductName AS product_name,
  SUM(product.productRevenue)/1000000 AS revenue_usd
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
UNNEST(hits) AS hit,
UNNEST(hit.product) AS product
WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170131'
  AND product.productRevenue IS NOT NULL
GROUP BY product_name
ORDER BY revenue_usd DESC
LIMIT 10;


CREATE OR REPLACE TABLE `profound-outlet-465808-b3.ecommerce_analytics.user_funnel_events_q1_2017` AS
SELECT
  LOWER(hit.eventInfo.eventAction) AS event_action,
  COUNT(*) AS event_count
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
UNNEST(hits) AS hit
WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
  AND hit.type = 'EVENT'
  AND LOWER(hit.eventInfo.eventAction) IN (
    'product click',
    'quickview click',
    'add to cart',
    'remove from cart'
  )
GROUP BY event_action
ORDER BY event_count DESC;

CREATE OR REPLACE TABLE `profound-outlet-465808-b3.ecommerce_analytics.refresh_tracker` AS
SELECT
  CURRENT_TIMESTAMP() AS last_updated,
  'daily_sessions' AS table_name;




CREATE OR REPLACE TABLE `profound-outlet-465808-b3.ecommerce_analytics.daily_sessions_by_device_jan2017` AS
SELECT
  PARSE_DATE('%Y%m%d', date) AS session_date,
  device.deviceCategory AS device_type,
  COUNT(*) AS total_sessions
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170131'
GROUP BY session_date, device_type
ORDER BY session_date;

