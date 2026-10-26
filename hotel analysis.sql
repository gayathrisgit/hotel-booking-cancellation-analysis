
CREATE DATABASE IF NOT EXISTS hotel_booking_analysis;

USE hotel_booking_analysis;

DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    country VARCHAR(50)
);
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_type VARCHAR(50),
    price_per_night DECIMAL(10,2)
);

CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    room_id INT,
    booking_date DATE,
    check_in DATE,
    check_out DATE,
    booking_status VARCHAR(30),
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),
    FOREIGN KEY (room_id)
        REFERENCES rooms(room_id)
);

INSERT INTO customers
(customer_name, city, country)
VALUES
('Arun', 'Erode', 'India'),
('Priya', 'Chennai', 'India'),
('Divya', 'Coimbatore', 'India'),
('Rahul', 'Bangalore', 'India'),
('Meena', 'Salem', 'India');

INSERT INTO rooms (room_type, price_per_night)
VALUES
('Standard', 2000),
('Deluxe', 3500),
('Suite', 6000),
('Single', 1500),
('Family', 4500);

INSERT INTO bookings
(customer_id, room_id, booking_date,
 check_in, check_out, booking_status)
VALUES
(1, 1, '2026-10-01', '2026-10-10',
 '2026-10-12', 'Confirmed'),
(2, 2, '2026-10-02', '2026-10-15',
 '2026-10-18', 'Cancelled'),
(3, 3, '2026-10-03', '2026-10-20',
 '2026-10-23', 'Confirmed'),
(4, 4, '2026-10-04', '2026-10-12',
 '2026-10-14', 'Completed'),
(5, 5, '2026-10-05', '2026-10-25',
 '2026-10-28', 'Confirmed'),
(1, 2, '2026-10-06', '2026-10-16',
 '2026-10-19', 'Completed'),
(2, 3, '2026-10-07', '2026-10-22',
 '2026-10-24', 'Cancelled'),
(3, 1, '2026-10-08', '2026-10-26',
 '2026-10-29', 'Confirmed');
SELECT * FROM customers;
SELECT * FROM rooms;
SELECT * FROM bookings;
SELECT COUNT(*) AS total_bookings
FROM bookings;
SELECT booking_status,
       COUNT(*) AS total_bookings
FROM bookings
GROUP BY booking_status;
SELECT r.room_type,
       COUNT(b.booking_id) AS total_bookings
FROM rooms r
JOIN bookings b
    ON r.room_id = b.room_id
GROUP BY r.room_type
ORDER BY total_bookings DESC;
SELECT r.room_type,
       SUM(
           r.price_per_night *
           DATEDIFF(b.check_out, b.check_in)
       ) AS booking_value
FROM rooms r
JOIN bookings b
    ON r.room_id = b.room_id
WHERE b.booking_status IN ('Confirmed', 'Completed')
GROUP BY r.room_type
ORDER BY booking_value DESC;
SELECT r.room_type,
       COUNT(b.booking_id) AS cancelled_bookings
FROM rooms r
JOIN bookings b
    ON r.room_id = b.room_id
WHERE b.booking_status = 'Cancelled'
GROUP BY r.room_type
ORDER BY cancelled_bookings DESC;

SELECT c.customer_name,
       r.room_type,
       b.check_in,
       b.check_out,
       b.booking_status
FROM customers c
JOIN bookings b
    ON c.customer_id = b.customer_id
JOIN rooms r
    ON b.room_id = r.room_id
ORDER BY b.booking_date;
SELECT
    COUNT(*) AS total_bookings,
    SUM(
        CASE
            WHEN booking_status = 'Cancelled' THEN 1
            ELSE 0
        END
    ) AS cancelled_bookings,
    ROUND(
        SUM(
            CASE
                WHEN booking_status = 'Cancelled' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS cancellation_percentage
FROM bookings;
SELECT
    ROUND(
        AVG(DATEDIFF(check_out, check_in)),
        2
    ) AS average_stay_nights
FROM bookings
WHERE booking_status IN ('Confirmed', 'Completed');
SELECT
    DATE_FORMAT(booking_date, '%Y-%m') AS booking_month,
    COUNT(*) AS total_bookings
FROM bookings
GROUP BY DATE_FORMAT(booking_date, '%Y-%m')
ORDER BY booking_month;
