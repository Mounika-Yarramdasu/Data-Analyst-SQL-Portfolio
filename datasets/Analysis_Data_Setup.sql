-- ================================================
-- FILE    : Analysis_Data_Setup.sql
-- PURPOSE : Master Dataset Setup — All 6 Datasets
-- TOOL    : SQL Server (SSMS)
-- AUTHOR  : Mounika Yarramdasu
-- DATE    : March 27, 2026
-- GITHUB  : github.com/Mounika-Yarramdasu/Data-Analyst-SQL-Portfolio
-- ------------------------------------------------
-- INSTRUCTIONS:
--   Run this file FIRST before executing any
--   query files. This creates all tables and
--   inserts all sample data used across 1000 questions.
-- ================================================

Create Database Analysis;
Use Analysis;

-- ════════════════════════════════════════════════
-- DATASET 1: Employee & Department (HR Domain)
-- Tables : Department, Employee
-- Used in: Phase 1, Phase 2, Phase 3 questions
-- ════════════════════════════════════════════════

CREATE TABLE Department (
  dept_id   INT PRIMARY KEY,
  dept_name VARCHAR(50),
  location  VARCHAR(50)
);

INSERT INTO Department VALUES
(1, 'Engineering', 'Hyderabad'),
(2, 'HR',          'Mumbai'),
(3, 'Sales',       'Bangalore'),
(4, 'Finance',     'Delhi'),
(5, 'Marketing',   'Hyderabad');

CREATE TABLE Employee (
  emp_id     INT PRIMARY KEY,
  name       VARCHAR(50),
  dept_id    INT,
  manager_id INT,
  salary     DECIMAL(10,2),
  hire_date  DATE,
  email      VARCHAR(100),
  phone      VARCHAR(15),
  city       VARCHAR(50)
);

INSERT INTO Employee VALUES
(1,  'Arjun', 1, NULL, 95000, '2020-01-15', 'arjun@company.com', '9876543210', 'Hyderabad'),
(2,  'Priya', 1, 1,    82000, '2020-06-01', 'priya@company.com', '9876543211', 'Hyderabad'),
(3,  'Ravi',  1, 1,    78000, '2021-03-10', 'ravi@company.com',  '9876543212', 'Hyderabad'),
(4,  'Sneha', 2, NULL, 70000, '2019-08-20', 'sneha@company.com', '9876543213', 'Mumbai'),
(5,  'Kiran', 2, 4,    55000, '2022-01-05', 'kiran@company.com', '9876543214', 'Mumbai'),
(6,  'Meera', 3, NULL, 90000, '2018-11-11', 'meera@company.com', '9876543215', 'Bangalore'),
(7,  'Suresh',3, 6,    65000, '2021-07-22', 'suresh@company.com','9876543216', 'Bangalore'),
(8,  'Divya', 4, NULL, 88000, '2020-02-14', 'divya@company.com', '9876543217', 'Delhi'),
(9,  'Rahul', 4, 8,    72000, '2022-09-30', 'rahul@company.com', '9876543218', 'Delhi'),
(10, 'Anita', 5, NULL, 60000, '2023-01-01', 'anita@company.com', '9876543219', 'Hyderabad'),
(11, 'Vijay', 1, 1,    78000, '2021-03-10', 'vijay@company.com', '987abc3220', 'Hyderabad'),
(12, 'Pooja', NULL, 1, 50000, '2023-06-15', 'pooja@company.com', '9876543221', 'Chennai');

-- ════════════════════════════════════════════════
-- DATASET 2: Customer, Orders, Products (E-Commerce)
-- Tables : Customer, Product, Orders, OrderDetails
-- Used in: Phase 1 JOINs, Phase 2, Phase 3
-- ════════════════════════════════════════════════

CREATE TABLE Customer (
  customer_id INT PRIMARY KEY,
  name        VARCHAR(50),
  email       VARCHAR(100),
  city        VARCHAR(50),
  signup_date DATE
);

INSERT INTO Customer VALUES
(1, 'Aarav Shah',  'aarav@gmail.com',  'Hyderabad', '2022-01-10'),
(2, 'Diya Patel',  'diya@gmail.com',   'Mumbai',    '2022-03-15'),
(3, 'Ishaan Roy',  'ishaan@gmail.com', 'Bangalore', '2022-06-01'),
(4, 'Kavya Nair',  'kavya@gmail.com',  'Delhi',     '2023-01-20'),
(5, 'Rohan Mehta', 'rohan@gmail.com',  'Hyderabad', '2023-04-05'),
(6, 'Tara Singh',  'tara@gmail.com',   'Chennai',   '2023-07-11'),
(7, 'Aryan Das',   'aryan@gmail.com',  'Kolkata',   '2023-09-01'),
(8, 'Neha Joshi',  'neha@gmail.com',   'Pune',      '2024-01-01');

CREATE TABLE Product (
  product_id     INT PRIMARY KEY,
  name           VARCHAR(50),
  category       VARCHAR(50),
  price          DECIMAL(10,2),
  stock_quantity INT,
  region         VARCHAR(30)
);

INSERT INTO Product VALUES
(1,  'Laptop',     'Electronics', 55000, 10,   'South'),
(2,  'Phone',      'Electronics', 25000, 25,   'West'),
(3,  'Shirt',      'Clothing',    999,   100,  'North'),
(4,  'Jeans',      'Clothing',    1499,  80,   'South'),
(5,  'Book',       'Education',   299,   200,  'East'),
(6,  'Headphones', 'Electronics', 3999,  0,    'West'),
(7,  'Tablet',     'Electronics', 18000, 15,   'South'),
(8,  'Pen',        'Stationery',  29,    500,  'All'),
(9,  'Bag',        'Accessories', 2500,  40,   'North'),
(10, 'Watch',      'Accessories', 8000,  NULL, 'West');

CREATE TABLE Orders (
  order_id     INT PRIMARY KEY,
  customer_id  INT,
  order_date   DATE,
  order_amount DECIMAL(10,2),
  status       VARCHAR(20)
);

INSERT INTO Orders VALUES
(1,  1, '2024-01-05', 55000, 'Delivered'),
(2,  1, '2024-02-10', 999,   'Delivered'),
(3,  2, '2024-01-15', 25000, 'Shipped'),
(4,  2, '2024-02-20', 1499,  'Delivered'),
(5,  3, '2024-03-01', 3999,  'Delivered'),
(6,  3, '2024-03-15', 299,   'Cancelled'),
(7,  4, '2024-04-10', 18000, 'Delivered'),
(8,  5, '2024-04-20', 55000, 'Shipped'),
(9,  1, '2024-05-01', 8000,  'Delivered'),
(10, 2, '2024-05-10', 2500,  'Delivered'),
(11, 6, '2024-06-01', 999,   'Delivered'),
(12, 3, '2024-06-15', 25000, 'Delivered'),
(13, 1, '2024-07-04', 1499,  'Delivered'),
(14, 7, '2024-07-20', 29,    'Delivered');

CREATE TABLE OrderDetails (
  detail_id  INT PRIMARY KEY,
  order_id   INT,
  product_id INT,
  quantity   INT,
  price      DECIMAL(10,2)
);

INSERT INTO OrderDetails VALUES
(1,  1,  1, 1, 55000), (2,  2,  3, 1, 999),
(3,  3,  2, 1, 25000), (4,  4,  4, 1, 1499),
(5,  5,  6, 1, 3999),  (6,  6,  5, 1, 299),
(7,  7,  7, 1, 18000), (8,  8,  1, 1, 55000),
(9,  9,  10,1, 8000),  (10, 10, 9, 1, 2500),
(11, 11, 3, 1, 999),   (12, 12, 2, 1, 25000),
(13, 13, 4, 1, 1499),  (14, 14, 8, 1, 29),
(15, 1,  2, 1, 25000), (16, 3,  3, 2, 1998);

-- ════════════════════════════════════════════════
-- DATASET 3: Rides (Interview Dataset — Extended)
-- Tables : Rides
-- Used in: Interview Q1, Phase 1, Phase 2
-- ════════════════════════════════════════════════

CREATE TABLE Rides (
  ride_id      INT,
  driver_id    INT,
  passenger_id INT,
  start_time   DATETIME,
  end_time     DATETIME,
  distance     DECIMAL(5,1),
  fare         DECIMAL(8,2)
);

INSERT INTO Rides VALUES
(1,  101, 201, '2023-09-01 08:00', '2023-09-01 08:30', 10.5, 10),
(2,  101, 202, '2023-09-01 09:00', '2023-09-01 09:45', 15,   10),
(3,  102, 203, '2023-09-01 10:00', '2023-09-01 10:20', 5,    18),
(4,  103, 204, '2023-09-01 11:00', '2023-09-01 11:50', 12,   20),
(5,  101, 205, '2023-09-01 12:00', '2023-09-01 12:25', 8,    25),
(6,  102, 206, '2023-09-01 13:00', '2023-09-01 13:30', 7.5,  25),
(7,  103, 207, '2023-09-01 14:00', '2023-09-01 14:15', 3,    30),
(8,  101, 208, '2023-09-01 15:00', '2023-09-01 15:40', 20,   35),
(9,  102, 209, '2023-09-01 16:00', '2023-09-01 16:25', 9,    45),
(10, 103, 210, '2023-09-01 17:00', '2023-09-01 17:35', 18,   50);

-- ════════════════════════════════════════════════
-- DATASET 4: Transactions (Analytics Domain)
-- Tables : Transactions
-- Used in: Phase 2, Phase 3, Phase 4
-- ════════════════════════════════════════════════

CREATE TABLE Transactions (
  txn_id     INT,
  account_id INT,
  txn_date   DATE,
  amount     DECIMAL(10,2),
  category   VARCHAR(30),
  city       VARCHAR(30)
);

INSERT INTO Transactions VALUES
(1,  1001, '2024-01-10', 5000,  'Food',        'Hyderabad'),
(2,  1001, '2024-01-11', 12000, 'Electronics', 'Hyderabad'),
(3,  1002, '2024-01-12', 800,   'Food',        'Mumbai'),
(4,  1003, '2024-01-13', 25000, 'Electronics', 'Bangalore'),
(5,  1001, '2024-02-01', 3000,  'Clothing',    'Hyderabad'),
(6,  1002, '2024-02-14', 15000, 'Electronics', 'Mumbai'),
(7,  1004, '2024-02-20', 500,   'Food',        'Delhi'),
(8,  1003, '2024-03-05', 7000,  'Clothing',    'Bangalore'),
(9,  1001, '2024-03-15', 9999,  'Electronics', 'Hyderabad'),
(10, 1005, '2024-03-20', 200,   'Food',        'Chennai'),
(11, 1001, '2024-04-01', 4500,  'Food',        'Hyderabad'),
(12, 1002, '2024-04-10', 11000, 'Electronics', 'Mumbai');

-- ════════════════════════════════════════════════
-- DATASET 5: Stocks (Interview Dataset — Extended)
-- Tables : Stocks
-- Used in: Interview Round 2 Q2, Phase 3, Phase 4
-- ════════════════════════════════════════════════

CREATE TABLE Stocks (
  stock_name    VARCHAR(50),
  operation     VARCHAR(10),
  operation_day INT,
  price         DECIMAL(10,2)
);

INSERT INTO Stocks VALUES
('Red Bull',      'Buy',  1,  1000),
('Corona Masks',  'Buy',  2,  10),
('Corona Masks',  'Sell', 3,  1010),
('Corona Masks',  'Buy',  4,  1000),
('Red Bull',      'Sell', 5,  9000),
('Corona Masks',  'Sell', 5,  500),
('Corona Masks',  'Buy',  6,  1000),
('Corona Masks',  'Sell', 10, 10000),
('Handbags',      'Buy',  17, 30000),
('Handbags',      'Sell', 29, 7000);

-- ════════════════════════════════════════════════
-- DATASET 6: UserLogin / Activity (Product Analytics)
-- Tables : UserLogin
-- Used in: Phase 3, Phase 4 product analytics
-- ════════════════════════════════════════════════

CREATE TABLE UserLogin (
  user_id         INT,
  login_date      DATE,
  session_minutes INT,
  source          VARCHAR(20)
);

INSERT INTO UserLogin VALUES
(1, '2024-01-01', 30, 'organic'),
(1, '2024-01-02', 45, 'organic'),
(1, '2024-01-03', 20, 'paid'),
(2, '2024-01-01', 60, 'paid'),
(2, '2024-01-03', 25, 'organic'),
(3, '2024-01-02', 15, 'social'),
(3, '2024-01-04', 50, 'organic'),
(4, '2024-01-01', 90, 'paid'),
(4, '2024-01-02', 80, 'paid'),
(4, '2024-01-03', 70, 'paid'),
(5, '2024-02-10', 40, 'social'),
(5, '2024-02-12', 35, 'organic');

-- ================================================
-- END OF SETUP
-- All 6 datasets loaded successfully.
-- Total tables created: 10
-- ================================================
