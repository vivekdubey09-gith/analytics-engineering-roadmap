USE DATABASE URBANRIDE_DB;
USE SCHEMA RAW_STAGE;

CREATE OR REPLACE VIEW VW_USER_LIFETIME_METRICS AS
WITH trip_aggregates AS (
    SELECT 
        user_id,
        COUNT(trip_id) AS total_trips_attempted,
        COUNT(CASE WHEN payment_status = 'COMPLETED' THEN trip_id END) AS completed_trips_count,
        COUNT(CASE WHEN payment_status = 'CANCELLED' THEN trip_id END) AS cancelled_trips_count,
        COALESCE(SUM(CASE WHEN payment_status = 'COMPLETED' THEN fare_amount ELSE 0 END), 0) AS total_lifetime_spend,
        COALESCE(AVG(CASE WHEN payment_status = 'COMPLETED' THEN fare_amount END), 0) AS avg_completed_fare
    FROM RAW_TRIPS
    GROUP BY user_id
)
SELECT 
    u.user_id,
    u.user_name,
    u.city,
    u.signup_date,
    COALESCE(t.total_trips_attempted, 0) AS total_trips_attempted,
    COALESCE(t.completed_trips_count, 0) AS completed_trips_count,
    COALESCE(t.cancelled_trips_count, 0) AS cancelled_trips_count,
    COALESCE(t.total_lifetime_spend, 0) AS total_lifetime_spend,
    ROUND(COALESCE(t.avg_completed_fare, 0), 2) AS avg_completed_fare,
    CASE 
        WHEN COALESCE(t.total_lifetime_spend, 0) >= 500 THEN 'VIP Tier'
        WHEN COALESCE(t.total_lifetime_spend, 0) > 0 THEN 'Regular Tier'
        ELSE 'Dormant User'
    END AS user_segment
FROM RAW_USERS u
LEFT JOIN trip_aggregates t 
    ON u.user_id = t.user_id;

CREATE OR REPLACE VIEW VW_CITY_PERFORMANCE_ANALYTICS AS
WITH city_trip_metrics AS (
    SELECT 
        city,
        COUNT(trip_id) AS total_trips,
        COUNT(CASE WHEN payment_status = 'COMPLETED' THEN trip_id END) AS completed_trips,
        COUNT(CASE WHEN payment_status = 'CANCELLED' THEN trip_id END) AS cancelled_trips,
        SUM(CASE WHEN payment_status = 'COMPLETED' THEN fare_amount ELSE 0 END) AS total_revenue
    FROM RAW_TRIPS
    GROUP BY city
)
SELECT 
    city,
    total_trips,
    completed_trips,
    cancelled_trips,
    total_revenue,
    ROUND((cancelled_trips * 100.0) / NULLIF(total_trips, 0), 2) AS cancellation_rate_percentage,
    DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS city_revenue_rank
FROM city_trip_metrics;

SELECT * FROM VW_USER_LIFETIME_METRICS ORDER BY total_lifetime_spend DESC;

SELECT * FROM VW_CITY_PERFORMANCE_ANALYTICS ORDER BY city_revenue_rank;