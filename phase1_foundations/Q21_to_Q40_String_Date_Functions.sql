-- ================================================
-- FILE    : Q21_to_Q40_String_Date_Functions.sql
-- PHASE   : Phase 1 - Foundations
-- TOPICS  : YEAR(), UPPER(), LEN(), LIKE, CONCAT,
--           LEFT(), REPLACE(), LOWER(), DATE filtering,
--           ORDER BY, DISTINCT, COUNT, MAX
-- DATASET : Employee, Customer, Product, Orders
-- TOOL    : SQL Server (SSMS)
-- AUTHOR  : Mounika Yarramdasu
-- GITHUB  : github.com/Mounika-Yarramdasu/Data-Analyst-SQL-Portfolio
-- ================================================

Use Analysis;

-- ─────────────────────────────────────────────────
-- Q21 ★ Find employees hired in the year 2022.
-- Concept: YEAR() date function
-- ─────────────────────────────────────────────────
Select * from Employee
where YEAR(hire_date) = 2022;

-- ─────────────────────────────────────────────────
-- Q22  Display employee names in UPPERCASE.
-- Concept: UPPER() string function
-- ─────────────────────────────────────────────────
Select UPPER(name) as Name from Employee;

-- ─────────────────────────────────────────────────
-- Q23  Show the length of each employee's name.
-- Concept: LEN() in SQL Server | LENGTH() in MySQL
-- ─────────────────────────────────────────────────
Select Name, LEN(name) as Length_Name from Employee;

-- ─────────────────────────────────────────────────
-- Q24  Display employees whose name ends with 'a'.
-- Concept: LIKE with % prefix wildcard
-- ─────────────────────────────────────────────────
Select Name from Employee
where Name like '%a';

-- ─────────────────────────────────────────────────
-- Q25 ★ Show employees with salary exactly 78000.
-- Concept: WHERE = exact match
-- Note: salary = 78000 (without quotes) is best practice
--       for numeric columns. SQL Server auto-converts
--       '78000' but avoid quotes on numbers.
-- ─────────────────────────────────────────────────
Select Name, Salary from Employee
where Salary = 78000;

-- ─────────────────────────────────────────────────
-- Q26  List employees with salary NOT equal to 55000.
-- Concept: WHERE <>
-- ─────────────────────────────────────────────────
Select Name, Salary from Employee
where Salary <> 55000;

-- ─────────────────────────────────────────────────
-- Q27  Find employees hired on '2021-03-10'.
-- Concept: WHERE + exact date match
-- ─────────────────────────────────────────────────
Select Name, Hire_Date from Employee
where Hire_Date = '2021-03-10';

-- ─────────────────────────────────────────────────
-- Q28  Retrieve employee names concatenated with their city.
-- Concept: CONCAT() | In SQL Server: Name + ' ' + City also works
-- Note: + operator is SQL Server specific.
--       CONCAT() works in both SQL Server and MySQL.
-- ─────────────────────────────────────────────────
Select Name + ' ' + City as 'Name & City' from Employee;
-- MySQL alternative:
-- Select CONCAT(Name, ' ', City) as 'Name & City' from Employee;

-- ─────────────────────────────────────────────────
-- Q29 ★ Show the first 3 characters of each employee's name.
-- Concept: LEFT() string function
-- ─────────────────────────────────────────────────
Select LEFT(Name, 3) as 'First 3 Letters' from Employee;

-- ─────────────────────────────────────────────────
-- Q30  Replace 'gmail' with 'yahoo' in customer emails.
-- Concept: REPLACE(column, old_text, new_text)
-- ─────────────────────────────────────────────────
Select *, REPLACE(email, 'gmail', 'yahoo') as 'New Email'
from Customer;

-- ─────────────────────────────────────────────────
-- Q31  Show all orders from January 2024.
-- Concept: MONTH() + YEAR() date functions
-- Note: Using MONTH() + YEAR() is cleaner and more precise
--       than a date range for filtering a single month.
-- ─────────────────────────────────────────────────
Select * from Orders
where MONTH(order_date) = 1 AND YEAR(order_date) = 2024;
-- Alternative using date range:
-- where order_date >= '2024-01-01' AND order_date < '2024-02-01'

-- ─────────────────────────────────────────────────
-- Q32 ★ List products with price less than 1000.
-- Concept: WHERE on Product table with < operator
-- ─────────────────────────────────────────────────
Select * from Product
where Price < 1000;

-- ─────────────────────────────────────────────────
-- Q33  Find all delivered orders.
-- Concept: WHERE status = exact string match
-- ─────────────────────────────────────────────────
Select * from Orders
where Status = 'Delivered';

-- ─────────────────────────────────────────────────
-- Q34  Show customer names in lowercase.
-- Concept: LOWER() string function
-- ─────────────────────────────────────────────────
Select LOWER(Name) as Name from Customer;

-- ─────────────────────────────────────────────────
-- Q35 ★ List all products sorted by price ascending.
-- Concept: ORDER BY ASC (ASC is default, can be omitted)
-- ─────────────────────────────────────────────────
Select Name, Category, Price from Product
Order By Price ASC;

-- ─────────────────────────────────────────────────
-- Q36  Find products with stock_quantity greater than 50.
-- Concept: WHERE on numeric column
-- ─────────────────────────────────────────────────
Select * from Product
where Stock_Quantity > 50;

-- ─────────────────────────────────────────────────
-- Q37  Show orders placed in April 2024.
-- Concept: DATE filtering using MONTH() + YEAR()
-- ─────────────────────────────────────────────────
Select * from Orders
where MONTH(order_date) = 4 AND YEAR(order_date) = 2024;
-- Alternative using date range:
-- where order_date >= '2024-04-01' AND order_date <= '2024-04-30'

-- ─────────────────────────────────────────────────
-- Q38  List all distinct order statuses.
-- Concept: DISTINCT on a single column
-- ─────────────────────────────────────────────────
Select Distinct Status from Orders;

-- ─────────────────────────────────────────────────
-- Q39 ★ Count total number of products.
-- Concept: COUNT(*) on Product table
-- ─────────────────────────────────────────────────
Select Count(*) as 'Total No Of Products' from Product;

-- ─────────────────────────────────────────────────
-- Q40  Find the most expensive product.
-- Concept: MAX() OR TOP 1 + ORDER BY DESC
-- Note: Two approaches shown below —
--       Approach 1 returns the full row details.
--       Approach 2 returns only the price value.
-- ─────────────────────────────────────────────────

-- Approach 1: Full row — use when you need all product details
Select Top 1 Product_id, Name, Category, Price as 'Expensive Product'
from Product
Order By Price Desc;

-- Approach 2: Price only — use when you just need the value
Select MAX(Price) as 'Most Expensive Price' from Product;
