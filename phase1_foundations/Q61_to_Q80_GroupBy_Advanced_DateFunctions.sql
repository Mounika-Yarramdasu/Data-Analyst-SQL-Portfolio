-- ================================================
-- FILE    : Q61_to_Q80_GroupBy_Advanced_DateFunctions.sql
-- PHASE   : Phase 1 - Foundations
-- TOPICS  : GROUP BY advanced, HAVING, DATEDIFF,
--           DATEPART, DATENAME, Quarter filtering,
--           multi-table GROUP BY, ORDER BY with AGG
-- DATASET : Employee, Orders, Product, Transactions,
--           Rides, UserLogin, Department
-- TOOL    : SQL Server (SSMS)
-- AUTHOR  : Mounika Yarramdasu
-- GITHUB  : github.com/Mounika-Yarramdasu/Data-Analyst-SQL-Portfolio
-- ================================================

Use Analysis;

-- ─────────────────────────────────────────────────
-- Q61  Find total distance covered per driver.
-- Concept: GROUP BY + SUM on numeric column
-- ─────────────────────────────────────────────────
Select Driver_Id, SUM(Distance) as 'Total Distance'
from Rides
Group by Driver_Id;

-- ─────────────────────────────────────────────────
-- Q62  Which drivers had more than 3 rides?
-- Concept: GROUP BY + HAVING COUNT > 3
-- ─────────────────────────────────────────────────
Select Driver_Id, COUNT(*) as 'No Of Rides'
from Rides
Group by Driver_Id
Having COUNT(*) > 3;

-- ─────────────────────────────────────────────────
-- Q63  Count orders per status.
-- Concept: GROUP BY on text/category column
-- ─────────────────────────────────────────────────
Select Status, COUNT(*) as 'No Of Orders'
from Orders
Group by Status;

-- ─────────────────────────────────────────────────
-- Q64  Find total revenue per order (quantity * price).
-- Concept: GROUP BY + SUM with calculated expression
-- ─────────────────────────────────────────────────
Select Order_Id, SUM(Quantity * Price) as 'Total Revenue'
from OrderDetails
Group by Order_Id;

-- ─────────────────────────────────────────────────
-- Q65  Find the month with the most orders.
-- Concept: GROUP BY MONTH + ORDER BY COUNT DESC + TOP 1
-- Fix: Must ORDER BY COUNT(*) DESC to get highest month.
-- ─────────────────────────────────────────────────
Select TOP 1 MONTH(order_date) as Month,
       COUNT(*) as 'No Of Orders'
from Orders
Group by MONTH(order_date)
Order by COUNT(*) DESC;

-- ─────────────────────────────────────────────────
-- Q66  Find max transaction amount per city.
-- Concept: GROUP BY city + MAX aggregate
-- ─────────────────────────────────────────────────
Select City, MAX(Amount) as 'Highest Amount'
from Transactions
Group by City;

-- ─────────────────────────────────────────────────
-- Q67  Count how many products are in each category.
-- Concept: GROUP BY on Product table
-- ─────────────────────────────────────────────────
Select Category, COUNT(*) as 'No Of Products'
from Product
Group by Category;

-- ─────────────────────────────────────────────────
-- Q68  Find categories with average price above 10000.
-- Concept: GROUP BY + HAVING AVG
-- ─────────────────────────────────────────────────
Select Category, AVG(Price) as 'Average Price'
from Product
Group by Category
Having AVG(Price) > 10000;

-- ─────────────────────────────────────────────────
-- Q69  List departments with minimum salary less than 60000.
-- Concept: GROUP BY + HAVING MIN + LEFT JOIN
-- Note: Joined with Department to show dept_name.
-- ─────────────────────────────────────────────────
Select d.dept_name, MIN(e.salary) as 'Minimum Salary'
from Employee e
Left Join Department d ON e.dept_id = d.dept_id
Group by d.dept_name
Having MIN(e.salary) < 60000;

-- ─────────────────────────────────────────────────
-- Q70  Count employees per hire year.
-- Concept: GROUP BY YEAR(hire_date)
-- ─────────────────────────────────────────────────
Select YEAR(hire_date) as 'Hire Year',
       COUNT(*) as 'No Of Employees'
from Employee
Group by YEAR(hire_date)
Order by YEAR(hire_date);

-- ─────────────────────────────────────────────────
-- Q71  Find quarter-wise order count for 2024.
-- Concept: DATEPART(Quarter) + GROUP BY + WHERE year filter
-- Note: SQL Server = DATEPART | MySQL = QUARTER()
-- ─────────────────────────────────────────────────
Select DATEPART(Quarter, order_date) as 'Quarter',
       COUNT(*) as 'No Of Orders'
from Orders
Where YEAR(order_date) = 2024
Group by DATEPART(Quarter, order_date)
Order by Quarter;

-- ─────────────────────────────────────────────────
-- Q72  Show total order amount per customer sorted highest first.
-- Concept: GROUP BY + ORDER BY aggregate expression
-- Fix: Cannot ORDER BY alias in SQL Server.
--      Use the aggregate expression directly.
-- ─────────────────────────────────────────────────
Select Customer_Id, SUM(order_amount) as 'Total Order Amount'
from Orders
Group by Customer_Id
Order by SUM(order_amount) DESC;

-- ─────────────────────────────────────────────────
-- Q73  Find drivers with average trip duration > 30 minutes.
-- Concept: DATEDIFF(minute) + GROUP BY + HAVING AVG
-- ─────────────────────────────────────────────────
Select Driver_Id,
       AVG(DATEDIFF(minute, Start_Time, End_Time)) as 'Avg Duration (mins)'
from Rides
Group by Driver_Id
Having AVG(DATEDIFF(minute, Start_Time, End_Time)) > 30;

-- ─────────────────────────────────────────────────
-- Q74  Count number of products with 0 stock.
-- Concept: WHERE filter + COUNT + GROUP BY
-- ─────────────────────────────────────────────────
Select Category, COUNT(*) as 'No Of Products With 0 Stock'
from Product
where Stock_Quantity = 0
Group by Category;

-- ─────────────────────────────────────────────────
-- Q75  Find categories where all products cost more than 1000.
-- Concept: HAVING MIN — if MIN > 1000, ALL cost more than 1000
-- ─────────────────────────────────────────────────
Select Category, MIN(Price) as 'Minimum Price'
from Product
Group by Category
Having MIN(Price) > 1000;

-- ─────────────────────────────────────────────────
-- Q76  Find average login session duration per source.
-- Concept: GROUP BY on UserLogin table
-- ─────────────────────────────────────────────────
Select Source, AVG(session_minutes) as 'Average Duration (mins)'
from UserLogin
Group by Source;

-- ─────────────────────────────────────────────────
-- Q77  Which sources bring in users with avg session > 45 minutes?
-- Concept: GROUP BY source + HAVING AVG
-- ─────────────────────────────────────────────────
Select Source, AVG(session_minutes) as 'Average Session (mins)'
from UserLogin
Group by Source
Having AVG(session_minutes) > 45;

-- ─────────────────────────────────────────────────
-- Q78  Count rides per hour of the day.
-- Concept: DATEPART(hour) SQL Server | HOUR() MySQL
-- ─────────────────────────────────────────────────
Select DATEPART(hour, Start_Time) as 'Hour',
       COUNT(*) as 'No Of Rides'
from Rides
Group by DATEPART(hour, Start_Time)
Order by Hour;

-- ─────────────────────────────────────────────────
-- Q79  Find the day of the week with most transactions.
-- Concept: DATENAME(weekday) + TOP 1 + ORDER BY COUNT DESC
-- Note: DATENAME = SQL Server | DAYNAME() = MySQL
-- ─────────────────────────────────────────────────
Select TOP 1
       DATENAME(weekday, txn_date) as 'Day Of The Week',
       COUNT(*) as 'No Of Transactions'
from Transactions
Group by DATENAME(weekday, txn_date)
Order by COUNT(*) DESC;

-- ─────────────────────────────────────────────────
-- Q80  Find total spend per customer in Q1 2024 only.
-- Concept: GROUP BY + WHERE DATEPART Quarter + YEAR filter
-- ─────────────────────────────────────────────────
Select Customer_Id,
       SUM(order_amount) as 'Total Amount'
from Orders
Where DATEPART(Quarter, order_date) = 1
  AND YEAR(order_date) = 2024
Group by Customer_Id;
