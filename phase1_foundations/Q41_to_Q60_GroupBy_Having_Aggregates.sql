-- ================================================
-- FILE    : Q41_to_Q60_GroupBy_Having_Aggregates.sql
-- PHASE   : Phase 1 - Foundations
-- TOPICS  : GROUP BY, HAVING, COUNT, SUM, AVG, MAX,
--           COUNT DISTINCT, multi-table grouping
-- DATASET : Employee, Orders, Product, Transactions, Rides
-- TOOL    : SQL Server (SSMS)
-- AUTHOR  : Mounika Yarramdasu
-- GITHUB  : github.com/Mounika-Yarramdasu/Data-Analyst-SQL-Portfolio
-- ================================================

Use Analysis;

-- ─────────────────────────────────────────────────
-- Q41  Count the number of employees in each department.
-- Concept: GROUP BY + COUNT
-- Note: Shows dept_id only. JOIN with Department table
--       to show dept_name — covered in Phase 1 JOINs.
-- ─────────────────────────────────────────────────
Select Dept_Id, COUNT(*) as 'No Of Employees'
from Employee
Group by Dept_Id;

-- ─────────────────────────────────────────────────
-- Q42  Find the average salary per department.
-- Concept: GROUP BY + AVG
-- ─────────────────────────────────────────────────
Select Dept_Id, AVG(Salary) as 'Average Salary'
from Employee
Group by Dept_Id;

-- ─────────────────────────────────────────────────
-- Q43  Show departments where the average salary is above 75000.
-- Concept: GROUP BY + HAVING
-- Rule: Use WHERE to filter rows BEFORE grouping.
--       Use HAVING to filter groups AFTER aggregation.
-- ─────────────────────────────────────────────────
Select Dept_Id, AVG(Salary) as 'Average Salary'
from Employee
Group by Dept_Id
Having AVG(Salary) > 75000;

-- ─────────────────────────────────────────────────
-- Q44  Find total salary paid per department.
-- Concept: GROUP BY + SUM
-- ─────────────────────────────────────────────────
Select Dept_Id, SUM(Salary) as 'Total Salary'
from Employee
Group by Dept_Id;

-- ─────────────────────────────────────────────────
-- Q45  Which departments have more than 2 employees?
-- Concept: GROUP BY + HAVING COUNT
-- Note: COUNT(*) counts all rows including NULLs.
--       COUNT(emp_id) skips NULL values in that column.
--       Both give same result here since emp_id has no NULLs.
-- ─────────────────────────────────────────────────

-- Approach 1: COUNT(*) — counts all rows
Select Dept_Id, COUNT(*) as 'No Of Employees'
from Employee
Group by Dept_Id
Having COUNT(*) > 2;

-- Approach 2: COUNT(emp_id) — counts non-NULL emp_id values
Select Dept_Id, COUNT(Emp_Id) as 'No Of Employees'
from Employee
Group by Dept_Id
Having COUNT(Emp_Id) > 2;

-- ─────────────────────────────────────────────────
-- Q46  Find the highest salary in each department.
-- Concept: GROUP BY + MAX
-- ─────────────────────────────────────────────────
Select Dept_Id, MAX(Salary) as 'Highest Salary'
from Employee
Group by Dept_Id;

-- ─────────────────────────────────────────────────
-- Q47  Count employees per city.
-- Concept: GROUP BY on non-numeric column
-- ─────────────────────────────────────────────────
Select City, COUNT(*) as 'No Of Employees'
from Employee
Group by City;

-- ─────────────────────────────────────────────────
-- Q48  Show cities that have more than 1 employee.
-- Concept: GROUP BY + HAVING > 1
-- ─────────────────────────────────────────────────
Select City, COUNT(*) as 'No Of Employees'
from Employee
Group by City
Having COUNT(*) > 1;

-- ─────────────────────────────────────────────────
-- Q49  Find total order amount per customer.
-- Concept: GROUP BY customer_id + SUM
-- ─────────────────────────────────────────────────
Select Customer_Id, SUM(order_amount) as 'Total Order Amount'
from Orders
Group by Customer_Id;

-- ─────────────────────────────────────────────────
-- Q50  Which customers have placed more than 2 orders?
-- Concept: GROUP BY + HAVING COUNT
-- Note: Alias corrected to 'No Of Orders' — we are
--       counting orders per customer, not customers.
-- ─────────────────────────────────────────────────
Select Customer_Id, COUNT(*) as 'No Of Orders'
from Orders
Group by Customer_Id
Having COUNT(*) > 2;

-- ─────────────────────────────────────────────────
-- Q51  Find average order amount per customer.
-- Concept: GROUP BY + AVG
-- ─────────────────────────────────────────────────
Select Customer_Id, AVG(order_amount) as 'Average Order Amount'
from Orders
Group by Customer_Id;

-- ─────────────────────────────────────────────────
-- Q52  Count number of orders per month in 2024.
-- Concept: GROUP BY + MONTH() + YEAR() filter
-- Note: Added WHERE YEAR = 2024 to restrict to 2024 only.
--       Without it, orders from other years would be mixed in.
-- ─────────────────────────────────────────────────
Select MONTH(order_date) as Month, COUNT(*) as 'No Of Orders'
from Orders
where YEAR(order_date) = 2024
Group by MONTH(order_date)
Order by Month;

-- ─────────────────────────────────────────────────
-- Q53  Find total sales per product category.
-- Concept: GROUP BY category + SUM
-- Note: SUM(Price) here sums the list price per product.
--       In a real sales scenario, use OrderDetails table
--       with SUM(quantity * price) for actual revenue.
-- ─────────────────────────────────────────────────
Select Category, SUM(Price) as 'Total Sales'
from Product
Group by Category;

-- ─────────────────────────────────────────────────
-- Q54  Which product categories have total stock > 100?
-- Concept: GROUP BY + HAVING SUM
-- ─────────────────────────────────────────────────
Select Category, SUM(stock_quantity) as 'Total Stock'
from Product
Group by Category
Having SUM(stock_quantity) > 100;

-- ─────────────────────────────────────────────────
-- Q55  Find average price per category.
-- Concept: GROUP BY + AVG
-- ─────────────────────────────────────────────────
Select Category, AVG(Price) as 'Average Price'
from Product
Group by Category;

-- ─────────────────────────────────────────────────
-- Q56  Count distinct cities employees are from.
-- Concept: COUNT(DISTINCT column)
-- Note: Returns 1 number — total unique cities.
--       Different from GROUP BY city which lists each city.
-- ─────────────────────────────────────────────────
Select COUNT(Distinct City) as 'Distinct Cities'
from Employee;

-- ─────────────────────────────────────────────────
-- Q57  Find total transaction amount per account.
-- Concept: GROUP BY account_id + SUM
-- ─────────────────────────────────────────────────
Select Account_Id, SUM(Amount) as 'Total Amount'
from Transactions
Group by Account_Id;

-- ─────────────────────────────────────────────────
-- Q58  Which accounts have total transactions > 15000?
-- Concept: GROUP BY + HAVING SUM
-- ─────────────────────────────────────────────────
Select Account_Id, SUM(Amount) as 'Total Transactions'
from Transactions
Group by Account_Id
Having SUM(Amount) > 15000;

-- ─────────────────────────────────────────────────
-- Q59  Count rides per driver.
-- Concept: GROUP BY driver_id + COUNT
-- ─────────────────────────────────────────────────
Select Driver_Id, COUNT(*) as 'No Of Rides'
from Rides
Group by Driver_Id;

-- ─────────────────────────────────────────────────
-- Q60  Find average fare per driver.
-- Concept: GROUP BY + AVG on Rides table
-- ─────────────────────────────────────────────────
Select Driver_Id, AVG(fare) as 'Average Fare'
from Rides
Group by Driver_Id;
