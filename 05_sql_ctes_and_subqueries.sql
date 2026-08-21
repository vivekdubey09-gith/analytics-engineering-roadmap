USE DATABASE URBANRIDE_DB;
USE SCHEMA RAW_STAGE;

WITH user_trip_stats AS (
    SELECT 
        user_id,
        COUNT(trip_id) AS total_trips,
        SUM(fare_amount) AS total_spend,
        AVG(fare_amount) AS avg_spend_per_trip
    FROM RAW_TRIPS
    WHERE payment_status = 'COMPLETED'
    GROUP BY user_id
)
SELECT 
    u.user_id,
    u.user_name,
    u.city,
    COALESCE(s.total_trips, 0) AS total_completed_trips,
    COALESCE(s.total_spend, 0) AS total_lifetime_spend,
    COALESCE(s.avg_spend_per_trip, 0) AS avg_spend_per_trip
FROM RAW_USERS u
LEFT JOIN user_trip_stats s 
    ON u.user_id = s.user_id
ORDER BY total_lifetime_spend DESC;

WITH ranked_city_trips AS (
    SELECT 
        trip_id,
        user_id,
        city,
        fare_amount,
        ROW_NUMBER() OVER (PARTITION BY city ORDER BY fare_amount DESC) AS rank_in_city
    FROM RAW_TRIPS
    WHERE payment_status = 'COMPLETED'
)
SELECT 
    trip_id,
    user_id,
    city,
    fare_amount
FROM ranked_city_trips
WHERE rank_in_city = 1;