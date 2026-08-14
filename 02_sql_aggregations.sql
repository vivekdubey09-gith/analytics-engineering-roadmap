USE DATABASE URBANRIDE_DB;
USE SCHEMA RAW_STAGE;

-- 1. Create the Trips table to track ride transactions
CREATE OR REPLACE TABLE RAW_TRIPS (
    trip_id INT,
    user_id INT,
    city VARCHAR(50),
    fare_amount DECIMAL(10, 2),
    trip_distance_km DECIMAL(10, 2),
    payment_status VARCHAR(20)
);

-- 2. Insert mock trip records
INSERT INTO RAW_TRIPS (trip_id, user_id, city, fare_amount, trip_distance_km, payment_status) VALUES
(1001, 101, 'Bengaluru', 250.00, 12.5, 'COMPLETED'),
(1002, 102, 'Mumbai', 450.50, 22.0, 'COMPLETED'),
(1003, 101, 'Bengaluru', 180.00, 8.2, 'COMPLETED'),
(1004, 104, 'Bengaluru', 320.00, 15.0, 'CANCELLED'),
(1005, 105, 'Bengaluru', 500.00, 25.4, 'COMPLETED'),
(1006, 106, 'Hyderabad', 210.00, 9.1, 'COMPLETED'),
(1007, 109, 'Mumbai', 600.00, 30.0, 'COMPLETED'),
(1008, 103, 'Delhi', 150.00, 5.5, 'CANCELLED');

-- 3. Business Query 1: Total user registrations per city
SELECT 
    city, 
    COUNT(user_id) AS total_users
FROM RAW_USERS
GROUP BY city;

-- 4. Business Query 2: Revenue and average ride distance for completed trips
SELECT 
    city, 
    SUM(fare_amount) AS total_revenue, 
    AVG(trip_distance_km) AS avg_distance
FROM RAW_TRIPS
WHERE payment_status = 'COMPLETED'
GROUP BY city;

-- 5. Business Query 3: High revenue cities where completed earnings exceed 400
SELECT 
    city, 
    SUM(fare_amount) AS total_revenue
FROM RAW_TRIPS
WHERE payment_status = 'COMPLETED'
GROUP BY city
HAVING SUM(fare_amount) > 400;

-- 6. Business Query 4: Trip volume categorized by city and completion status
SELECT 
    city, 
    payment_status, 
    COUNT(trip_id) AS total_trips
FROM RAW_TRIPS
GROUP BY city, payment_status;