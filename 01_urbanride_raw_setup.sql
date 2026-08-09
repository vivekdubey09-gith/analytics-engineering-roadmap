CREATE DATABASE IF NOT EXISTS URBANRIDE_DB;
CREATE SCHEMA IF NOT EXISTS URBANRIDE_DB.RAW_STAGE;


CREATE OR REPLACE TABLE URBANRIDE_DB.RAW_STAGE.RAW_USERS (
    user_id INT,
    user_name VARCHAR(50),
    signup_date DATE,
    city VARCHAR(50)
);

INSERT INTO URBANRIDE_DB.RAW_STAGE.RAW_USERS (user_id, user_name, signup_date, city) VALUES
(101, 'Rahul Sharma', '2026-01-15', 'Bengaluru'),
(102, 'Priya Patel', '2026-02-01', 'Mumbai'),
(103, 'Ankit Verma', '2026-02-20', 'Delhi'),
(104, 'Sneha Rao', '2026-03-05', 'Bengaluru'),
(105, 'Rohan Sharma', '2026-03-10', 'Bengaluru'),
(106, 'Ayesha Khan', '2026-03-12', 'Hyderabad'),
(107, 'Vikram Singh', '2026-03-15', 'Delhi'),
(108, 'Ananya Roy', '2026-03-18', 'Kolkata'),
(109, 'Rahul Verma', '2026-03-20', 'Mumbai'),
(110, 'Suresh Kumar', '2026-03-22', 'Bengaluru');


SELECT * FROM URBANRIDE_DB.RAW_STAGE.RAW_USERS;