USE DATABASE URBANRIDE_DB;
USE SCHEMA RAW_STAGE;

SELECT 
    u.user_id,
    u.user_name,
    u.city AS user_home_city,
    t.trip_id,
    t.fare_amount,
    t.payment_status
FROM RAW_USERS u
INNER JOIN RAW_TRIPS t 
    ON u.user_id = t.user_id;

SELECT 
    u.user_id,
    u.user_name,
    u.city,
    u.signup_date
FROM RAW_USERS u
LEFT JOIN RAW_TRIPS t 
    ON u.user_id = t.user_id
WHERE t.trip_id IS NULL;

SELECT 
    u.user_id,
    u.user_name,
    u.city,
    COUNT(CASE WHEN t.payment_status = 'COMPLETED' THEN t.trip_id END) AS completed_trips_count,
    COALESCE(SUM(CASE WHEN t.payment_status = 'COMPLETED' THEN t.fare_amount ELSE 0 END), 0) AS total_lifetime_spend
FROM RAW_USERS u
LEFT JOIN RAW_TRIPS t 
    ON u.user_id = t.user_id
GROUP BY 
    u.user_id, 
    u.user_name, 
    u.city
ORDER BY 
    total_lifetime_spend DESC;