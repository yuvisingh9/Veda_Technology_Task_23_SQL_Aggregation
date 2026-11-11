-- Veda Technology | Task 23: SQL Aggregation Basics
-- Portable SQL for MySQL 8+ and PostgreSQL 13+
-- Run this file from top to bottom in a fresh database/schema.
-- Demo dataset is included so all 10 queries return reproducible results.

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name VARCHAR(80) NOT NULL,
    region VARCHAR(30),
    email VARCHAR(100)
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(80) NOT NULL,
    category VARCHAR(40),
    unit_price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers VALUES
(1, 'Aarav Sharma', 'North', 'aarav@example.com'),
(2, 'Diya Verma', 'South', 'diya@example.com'),
(3, 'Kabir Singh', 'East', NULL),
(4, 'Meera Das', 'West', 'meera@example.com'),
(5, 'Ishaan Roy', 'North', 'ishaan@example.com'),
(6, 'Anaya Kumar', NULL, 'anaya@example.com');

INSERT INTO products VALUES
(101, 'Laptop Stand', 'Accessories', 1200.00),
(102, 'Wireless Mouse', 'Accessories', 650.00),
(103, 'Keyboard', 'Electronics', 1500.00),
(104, 'USB Hub', 'Electronics', 900.00),
(105, 'Notebook', 'Stationery', 80.00),
(106, 'Pen Set', 'Stationery', 120.00);

INSERT INTO orders VALUES
(1001, 1, '2026-10-01', 'Completed'),
(1002, 2, '2026-10-03', 'Completed'),
(1003, 3, '2026-10-05', 'Pending'),
(1004, 1, '2026-10-08', 'Completed'),
(1005, 4, '2026-10-12', 'Cancelled'),
(1006, 5, '2026-11-01', 'Completed'),
(1007, 6, '2026-11-04', 'Pending'),
(1008, 2, '2026-11-07', 'Completed');

INSERT INTO order_items VALUES
(1,1001,101,1,1200.00),
(2,1001,102,2,650.00),
(3,1002,103,1,1500.00),
(4,1002,105,5,80.00),
(5,1003,104,1,900.00),
(6,1004,102,1,650.00),
(7,1004,106,2,120.00),
(8,1005,101,1,1200.00),
(9,1006,103,2,1500.00),
(10,1006,104,1,900.00),
(11,1007,105,10,80.00),
(12,1008,102,3,650.00),
(13,1008,106,1,120.00),
(14,1008,104,1,NULL);

-- QUERY 1: Count all orders.
SELECT COUNT(*) AS total_orders FROM orders;

-- QUERY 2: Total sales value across all order items (NULL line prices are ignored).
SELECT SUM(quantity * unit_price) AS total_sales FROM order_items;

-- QUERY 3: Average order value, calculated from each order's item totals.
SELECT AVG(order_total) AS average_order_value
FROM (
    SELECT order_id, SUM(quantity * unit_price) AS order_total
    FROM order_items
    GROUP BY order_id
) AS order_totals;

-- QUERY 4: Lowest and highest order totals.
SELECT MIN(order_total) AS minimum_order_value,
       MAX(order_total) AS maximum_order_value
FROM (
    SELECT order_id, SUM(quantity * unit_price) AS order_total
    FROM order_items
    GROUP BY order_id
) AS order_totals;

-- QUERY 5: Number of orders and sales by customer region (NULL region is retained).
SELECT c.region,
       COUNT(DISTINCT o.order_id) AS order_count,
       SUM(oi.quantity * oi.unit_price) AS total_sales
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.region
ORDER BY c.region;

-- QUERY 6: Count orders by status.
SELECT status, COUNT(*) AS order_count
FROM orders
GROUP BY status
ORDER BY status;

-- QUERY 7: Average listed product price by category.
SELECT category, AVG(unit_price) AS average_product_price,
       MIN(unit_price) AS minimum_price, MAX(unit_price) AS maximum_price
FROM products
GROUP BY category
ORDER BY category;

-- QUERY 8: Total units sold and sales value per product.
SELECT p.product_name,
       SUM(oi.quantity) AS units_sold,
       SUM(oi.quantity * oi.unit_price) AS sales_value
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY sales_value DESC;

-- QUERY 9: Monthly sales totals.
SELECT EXTRACT(YEAR FROM o.order_date) AS sales_year,
       EXTRACT(MONTH FROM o.order_date) AS sales_month,
       SUM(oi.quantity * oi.unit_price) AS monthly_sales
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY EXTRACT(YEAR FROM o.order_date), EXTRACT(MONTH FROM o.order_date)
ORDER BY sales_year, sales_month;

-- QUERY 10: Check NULL behaviour in customer emails and item prices.
SELECT
    (SELECT COUNT(*) FROM customers WHERE email IS NULL) AS customers_with_missing_email,
    (SELECT COUNT(*) FROM order_items WHERE unit_price IS NULL) AS items_with_missing_price,
    (SELECT COUNT(unit_price) FROM order_items) AS non_null_item_prices,
    (SELECT COUNT(*) FROM order_items) AS total_item_rows;
