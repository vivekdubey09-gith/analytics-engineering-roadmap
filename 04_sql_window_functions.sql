USE DATABASE URBANRIDE_DB;
USE SCHEMA RAW_STAGE;

SELECT 
    trip_id,
    user_id,
    city,
    fare_amount,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY fare_amount DESC) AS user_fare_rank
FROM RAW_TRIPS;

SELECT 
    trip_id,
    city,
    fare_amount,
    RANK() OVER (PARTITION BY city ORDER BY fare_amount DESC) AS city_fare_rank,
    DENSE_RANK() OVER (PARTITION BY city ORDER BY fare_amount DESC) AS city_dense_rank
FROM RAW_TRIPS;

SELECT 
    trip_id,
    user_id,
    fare_amount,
    LAG(fare_amount, 1) OVER (PARTITION BY user_id ORDER BY trip_id) AS previous_trip_fare,
    fare_amount - LAG(fare_amount, 1) OVER (PARTITION BY user_id ORDER BY trip_id) AS fare_difference_from_previous
FROM RAW_TRIPS;