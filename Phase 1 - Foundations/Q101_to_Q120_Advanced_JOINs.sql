-- ================================================
-- FILE    : Q101_to_Q120_Advanced_JOINs.sql
-- PHASE   : Phase 1 - Foundations
-- TOPICS  : LEFT JOIN + COUNT, SELF JOIN pairs,
--           CTE + RANK + JOIN, INTERSECT,
--           Multi-table JOIN, NULL handling in JOIN,
--           Subquery inside WHERE with JOIN
-- DATASET : Employee, Department, Customer, Orders,
--           OrderDetails, Product
-- TOOL    : SQL Server (SSMS)
-- AUTHOR  : Mounika Yarramdasu
-- GITHUB  : github.com/Mounika-Yarramdasu/Data-Analyst-SQL-Portfolio
-- ================================================

Use Analysis;

-- ─────────────────────────────────────────────────
-- Q101  List all products and how many times ordered (include unordered).
-- Concept: LEFT JOIN Product + OrderDetails + COUNT
-- Note: LEFT JOIN keeps products with 0 orders.
--       COUNT(o.product_id) returns 0 for unordered products.
-- ─────────────────────────────────────────────────
Select p.name, COUNT(o.product_id) as No_Of_Times_Ordered
from Product p
Left Join OrderDetails o ON p.product_id = o.product_id
Group by p.name
Order by No_Of_Times_Ordered DESC;

-- ─────────────────────────────────────────────────
-- Q102  Find employees reporting to managers in different departments.
-- Concept: SELF JOIN + WHERE dept comparison
-- ─────────────────────────────────────────────────
Select e.name as Employee,
       e.dept_id as Emp_Dept,
       m.name as Manager,
       m.dept_id as Mgr_Dept
from Employee e
Join Employee m ON e.manager_id = m.emp_id
where e.dept_id <> m.dept_id;

-- ─────────────────────────────────────────────────
-- Q103  Display customers sorted by their total spend (highest first).
-- Concept: JOIN + GROUP BY + ORDER BY aggregate
-- ─────────────────────────────────────────────────
Select c.name, SUM(o.order_amount) as Total_Spend
from Customer c
Join Orders o ON c.customer_id = o.customer_id
Group by c.name
Order by Total_Spend DESC;

-- ─────────────────────────────────────────────────
-- Q104  Find the top spending customer in each city.
-- Concept: CTE + RANK() OVER PARTITION BY city + JOIN
-- ─────────────────────────────────────────────────
With Customer_Total_Spend as (
    Select c.name, c.city,
           SUM(o.order_amount) as Total_Spend,
           RANK() OVER (PARTITION BY c.city
                        ORDER BY SUM(o.order_amount) DESC) as Rk
    from Customer c
    Join Orders o ON c.customer_id = o.customer_id
    Group by c.city, c.name
)
Select * from Customer_Total_Spend
where Rk = 1;

-- ─────────────────────────────────────────────────
-- Q105  Show products with their category and order count.
-- Concept: JOIN Product + OrderDetails + GROUP BY
-- Fix: Added p.name to SELECT and GROUP BY.
--      Question asks for product name + category + order count.
-- ─────────────────────────────────────────────────
Select p.name, p.category,
       COUNT(o.order_id) as No_Of_Orders
from Product p
Join OrderDetails o ON p.product_id = o.product_id
Group by p.name, p.category;

-- ─────────────────────────────────────────────────
-- Q106  Find orders placed by Hyderabad customers only.
-- Concept: JOIN Customer + Orders + WHERE city filter
-- ─────────────────────────────────────────────────
Select Distinct c.name, c.city, o.order_id
from Customer c
Join Orders o ON c.customer_id = o.customer_id
where c.city = 'Hyderabad';

-- ─────────────────────────────────────────────────
-- Q107  List employees alongside total orders in their city.
-- Concept: JOIN Employee + Customer + Orders by city match
-- ─────────────────────────────────────────────────
Select e.name as Employee,
       e.city,
       COUNT(o.order_id) as City_Total_Orders
from Employee e
Left Join Customer c ON e.city = c.city
Left Join Orders o ON c.customer_id = o.customer_id
Group by e.name, e.city;

-- ─────────────────────────────────────────────────
-- Q108  Show driver and their total distance.
-- Concept: GROUP BY on Rides (no separate driver table in dataset)
-- Note: Rides table has driver_id. Using that directly.
-- ─────────────────────────────────────────────────
Select Driver_id,
       SUM(distance) as Total_Distance,
       COUNT(*) as Total_Rides
from Rides
Group by Driver_id;

-- ─────────────────────────────────────────────────
-- Q109  Find all pairs of employees in the same department.
-- Concept: SELF JOIN on dept_id
-- Note: e1.emp_id < e2.emp_id avoids duplicate pairs
--       like (Arjun, Priya) AND (Priya, Arjun).
-- ─────────────────────────────────────────────────
Select e1.name as Employee_1,
       e2.name as Employee_2,
       e1.dept_id
from Employee e1
Join Employee e2 ON e1.dept_id = e2.dept_id
where e1.emp_id < e2.emp_id;

-- ─────────────────────────────────────────────────
-- Q110  Show each product category and the customer who spent most on it.
-- Concept: CTE + RANK() OVER PARTITION BY category + 4-table JOIN
-- ─────────────────────────────────────────────────
With Customer_Spend_Most as (
    Select c.name, p.category,
           SUM(od.quantity * od.price) as Total_Spent,
           RANK() OVER (PARTITION BY p.category
                        ORDER BY SUM(od.quantity * od.price) DESC) as Rk
    from Product p
    Join OrderDetails od ON p.product_id = od.product_id
    Join Orders o ON od.order_id = o.order_id
    Join Customer c ON o.customer_id = c.customer_id
    Group by c.name, p.category
)
Select * from Customer_Spend_Most
where Rk = 1;

-- ─────────────────────────────────────────────────
-- Q111  Find employees whose salary equals another employee in same dept.
-- Concept: SELF JOIN on dept_id + salary equality
-- Fix: Original used < (less than) instead of = (equal).
--      e1.emp_id < e2.emp_id avoids showing duplicate pairs.
-- ─────────────────────────────────────────────────
Select e1.name as Employee_1,
       e2.name as Employee_2,
       e1.salary,
       e1.dept_id
from Employee e1
Join Employee e2 ON e1.dept_id = e2.dept_id
where e1.salary = e2.salary
  AND e1.emp_id < e2.emp_id;

-- ─────────────────────────────────────────────────
-- Q112  Show orders with their product details for orders > 10000.
-- Concept: JOIN Orders + OrderDetails + Product + WHERE calculation
-- ─────────────────────────────────────────────────
Select o.order_id,
       p.name as Product,
       od.quantity,
       od.price,
       od.quantity * od.price as Total_Order_Amount
from Product p
Join OrderDetails od ON p.product_id = od.product_id
Join Orders o ON od.order_id = o.order_id
where od.quantity * od.price > 10000
Order by Total_Order_Amount DESC;

-- ─────────────────────────────────────────────────
-- Q113  Find customers who placed orders in both January AND February 2024.
-- Concept: INTERSECT — finds common rows between two result sets
-- Note: INTERSECT is an advanced set operator.
--       Returns customers appearing in BOTH queries.
-- ─────────────────────────────────────────────────
Select c.name
from Customer c
Join Orders o ON c.customer_id = o.customer_id
where o.order_date >= '2024-01-01' AND o.order_date <= '2024-01-31'

INTERSECT

Select c.name
from Customer c
Join Orders o ON c.customer_id = o.customer_id
where o.order_date >= '2024-02-01' AND o.order_date <= '2024-02-29';

-- ─────────────────────────────────────────────────
-- Q114  Display every product ordered at least 3 times.
-- Concept: LEFT JOIN + GROUP BY + HAVING COUNT >= 3
-- ─────────────────────────────────────────────────
Select p.name, COUNT(o.order_id) as No_Of_Times_Ordered
from Product p
Left Join OrderDetails o ON p.product_id = o.product_id
Group by p.name
Having COUNT(o.order_id) >= 3;

-- ─────────────────────────────────────────────────
-- Q115  Find employees hired on the same date as someone else.
-- Concept: SELF JOIN on hire_date
-- Note: e1.emp_id <> e2.emp_id avoids matching employee with itself.
-- ─────────────────────────────────────────────────
Select e1.name as Employee_1,
       e2.name as Employee_2,
       e1.hire_date
from Employee e1
Join Employee e2 ON e1.hire_date = e2.hire_date
where e1.emp_id <> e2.emp_id
  AND e1.emp_id < e2.emp_id;

-- ─────────────────────────────────────────────────
-- Q116  Show total amount spent per customer per month.
-- Concept: JOIN + GROUP BY + FORMAT() for month grouping
-- Note: FORMAT(date, 'yyyy-MM') groups by year-month
--       so Jan 2024 and Jan 2025 are separate groups.
-- ─────────────────────────────────────────────────
Select c.name,
       FORMAT(o.order_date, 'yyyy-MM') as Order_Month,
       SUM(od.quantity * od.price) as Total_Spent
from Customer c
Join Orders o ON c.customer_id = o.customer_id
Join OrderDetails od ON o.order_id = od.order_id
Group by c.name, FORMAT(o.order_date, 'yyyy-MM')
Order by c.name, Order_Month;

-- ─────────────────────────────────────────────────
-- Q117  List products and total revenue (quantity * price) from OrderDetails.
-- Concept: JOIN Product + OrderDetails + SUM calculation
-- ─────────────────────────────────────────────────
Select p.name,
       SUM(o.quantity * o.price) as Total_Revenue
from Product p
Join OrderDetails o ON p.product_id = o.product_id
Group by p.name
Order by Total_Revenue DESC;

-- ─────────────────────────────────────────────────
-- Q118  Find customers who have ordered Electronics products ONLY.
-- Concept: JOIN + GROUP BY + HAVING
-- Fix: Original shows all Electronics orders but not
--      "Electronics only" customers.
--      Use HAVING to check: all categories = Electronics
--      and no other category exists for that customer.
-- ─────────────────────────────────────────────────
Select c.name
from Customer c
Join Orders o ON c.customer_id = o.customer_id
Join OrderDetails od ON o.order_id = od.order_id
Join Product p ON od.product_id = p.product_id
Group by c.name
Having COUNT(Distinct p.category) = 1
   AND MAX(p.category) = 'Electronics';

-- ─────────────────────────────────────────────────
-- Q119  Show employee + department for all employees, including no dept.
-- Concept: LEFT JOIN + ISNULL() for NULL handling
-- Fix: Concatenation fails when dept_name is NULL.
--      ISNULL(value, replacement) handles NULL safely.
-- ─────────────────────────────────────────────────
Select e.name + ' - ' + ISNULL(d.dept_name, 'No Department') as Employee_Department
from Employee e
Left Join Department d ON e.dept_id = d.dept_id;

-- ─────────────────────────────────────────────────
-- Q120  Find products ordered more than the average order quantity.
-- Concept: JOIN + WHERE with scalar subquery
-- Note: Subquery (SELECT AVG(quantity) FROM OrderDetails)
--       returns a single number — the overall avg quantity.
--       Outer query compares each row against that number.
-- ─────────────────────────────────────────────────
Select p.name, od.quantity
from Product p
Join OrderDetails od ON p.product_id = od.product_id
where od.quantity > (Select AVG(quantity) from OrderDetails);
