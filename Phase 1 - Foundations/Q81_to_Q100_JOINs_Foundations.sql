-- ================================================
-- FILE    : Q81_to_Q100_JOINs_Foundations.sql
-- PHASE   : Phase 1 - Foundations
-- TOPICS  : INNER JOIN, LEFT JOIN, SELF JOIN,
--           Multi-table JOIN, JOIN + GROUP BY,
--           JOIN + HAVING, NULL checks on JOINs
-- DATASET : Employee, Department, Customer, Orders,
--           OrderDetails, Product, Rides
-- TOOL    : SQL Server (SSMS)
-- AUTHOR  : Mounika Yarramdasu
-- GITHUB  : github.com/Mounika-Yarramdasu/Data-Analyst-SQL-Portfolio
-- ================================================

Use Analysis;

-- ─────────────────────────────────────────────────
-- Q81  Display employee name along with their department name.
-- Concept: INNER JOIN Employee + Department
-- Note: INNER JOIN returns only matching rows —
--       employees WITH a department. Pooja (NULL dept) excluded.
-- ─────────────────────────────────────────────────
Select e.name, d.dept_name
from Employee e
Inner Join Department d ON e.dept_id = d.dept_id;

-- ─────────────────────────────────────────────────
-- Q82  Show all employees including those without a department.
-- Concept: LEFT JOIN — keeps ALL rows from left table (Employee)
-- Note: Pooja has NULL dept_id so dept_name shows as NULL.
-- ─────────────────────────────────────────────────
Select e.name, d.dept_name
from Employee e
Left Join Department d ON e.dept_id = d.dept_id;

-- ─────────────────────────────────────────────────
-- Q83  Find departments that have no employees.
-- Concept: LEFT JOIN + WHERE IS NULL
-- Fix: Department must be the LEFT table to include
--      departments with no matching employees.
--      Then filter where Employee side is NULL.
-- ─────────────────────────────────────────────────
Select d.dept_name
from Department d
Left Join Employee e ON d.dept_id = e.dept_id
where e.emp_id is null;

-- ─────────────────────────────────────────────────
-- Q84  Show all departments and their employee count (include empty depts).
-- Concept: LEFT JOIN + COUNT
-- Fix: Department on LEFT so empty departments appear.
--      COUNT(e.emp_id) counts only non-NULL emp_ids
--      so empty departments show 0, not 1.
-- ─────────────────────────────────────────────────
Select d.dept_name, COUNT(e.emp_id) as 'Employee Count'
from Department d
Left Join Employee e ON d.dept_id = e.dept_id
Group by d.dept_name;

-- ─────────────────────────────────────────────────
-- Q85  Display each order with the customer name.
-- Concept: INNER JOIN Orders + Customer
-- ─────────────────────────────────────────────────
Select o.order_id, c.name
from Orders o
Inner Join Customer c ON o.customer_id = c.customer_id;

-- ─────────────────────────────────────────────────
-- Q86  Show order details with product names.
-- Concept: INNER JOIN OrderDetails + Product
-- ─────────────────────────────────────────────────
Select od.order_id, p.name
from OrderDetails od
Inner Join Product p ON od.product_id = p.product_id;

-- ─────────────────────────────────────────────────
-- Q87  List customers who have NEVER placed an order.
-- Concept: LEFT JOIN Customer + Orders + WHERE NULL check
-- Note: Check NULL on Orders side (o.order_id),
--       not on Customer side.
-- ─────────────────────────────────────────────────
Select c.name, c.customer_id
from Customer c
Left Join Orders o ON c.customer_id = o.customer_id
where o.order_id is null;

-- ─────────────────────────────────────────────────
-- Q88  Find products that have NEVER been ordered.
-- Concept: LEFT JOIN Product + OrderDetails + WHERE NULL
-- Fix: Check NULL on the JOIN side (o.product_id),
--      NOT on p.product_id which is a PRIMARY KEY
--      and can never be NULL.
-- ─────────────────────────────────────────────────
Select p.name
from Product p
Left Join OrderDetails o ON p.product_id = o.product_id
where o.product_id is null;

-- ─────────────────────────────────────────────────
-- Q89  Show employee names and their manager names.
-- Concept: SELF JOIN on Employee table
-- Fix: e = employee record, m = manager record
--      Join on e.manager_id = m.emp_id
--      e.name = Employee, m.name = Manager
-- ─────────────────────────────────────────────────
Select e.name as Employee, m.name as Manager
from Employee e
Join Employee m ON e.manager_id = m.emp_id;

-- ─────────────────────────────────────────────────
-- Q90  Find employees who earn more than their manager.
-- Concept: SELF JOIN + WHERE salary comparison
-- Fix: Show the EMPLOYEE who earns more, not the manager.
--      e = employee, m = manager
--      Condition: e.salary > m.salary
-- ─────────────────────────────────────────────────
Select e.name as Employee,
       e.salary as Employee_Salary,
       m.name as Manager,
       m.salary as Manager_Salary
from Employee e
Join Employee m ON e.manager_id = m.emp_id
where e.salary > m.salary;

-- ─────────────────────────────────────────────────
-- Q91  Display employee name, department name, and city.
-- Concept: INNER JOIN Employee + Department
-- ─────────────────────────────────────────────────
Select e.name, d.dept_name, e.city
from Employee e
Join Department d ON e.dept_id = d.dept_id;

-- ─────────────────────────────────────────────────
-- Q92  Show all orders with customer name and order amount.
-- Concept: 3-table JOIN — Customer + Orders + OrderDetails
-- Note: order_amount already in Orders table.
--       Showing both approaches below.
-- ─────────────────────────────────────────────────

-- Approach 1: Direct from Orders table (simpler)
Select o.order_id, c.name, o.order_amount
from Customer c
Join Orders o ON c.customer_id = o.customer_id;

-- Approach 2: Calculated from OrderDetails (when you need line-item detail)
Select o.order_id, c.name,
       SUM(od.quantity * od.price) as 'Calculated Amount'
from Customer c
Join Orders o ON c.customer_id = o.customer_id
Join OrderDetails od ON o.order_id = od.order_id
Group by o.order_id, c.name;

-- ─────────────────────────────────────────────────
-- Q93  Find products ordered by customer 'Aarav Shah'.
-- Concept: 4-table JOIN — Customer + Orders + OrderDetails + Product
-- ─────────────────────────────────────────────────
Select c.name as Customer, p.name as Product
from Customer c
Join Orders o ON c.customer_id = o.customer_id
Join OrderDetails od ON o.order_id = od.order_id
Join Product p ON od.product_id = p.product_id
where c.name = 'Aarav Shah';

-- ─────────────────────────────────────────────────
-- Q94  List employees in the same department as 'Arjun'.
-- Concept: Subquery in WHERE (alternative to SELF JOIN)
-- Note: Subquery first finds Arjun's dept_id,
--       outer query then finds all employees in that dept.
-- ─────────────────────────────────────────────────
Select name, dept_id
from Employee
where dept_id = (Select dept_id from Employee where name = 'Arjun');

-- ─────────────────────────────────────────────────
-- Q95  Show customers from Hyderabad and their total orders.
-- Concept: JOIN + WHERE + GROUP BY
-- ─────────────────────────────────────────────────
Select c.name, SUM(o.order_amount) as 'Total Amount'
from Customer c
Join Orders o ON c.customer_id = o.customer_id
where c.city = 'Hyderabad'
Group by c.name;

-- ─────────────────────────────────────────────────
-- Q96  Find employees hired after their manager.
-- Concept: SELF JOIN + date comparison
-- Fix: e = employee, m = manager
--      Show employees where e.hire_date > m.hire_date
--      (employee joined AFTER their manager)
-- ─────────────────────────────────────────────────
Select e.name as Employee,
       e.hire_date as Employee_HireDate,
       m.name as Manager,
       m.hire_date as Manager_HireDate
from Employee e
Join Employee m ON e.manager_id = m.emp_id
where e.hire_date > m.hire_date;

-- ─────────────────────────────────────────────────
-- Q97  Display order details: customer, product, quantity, price.
-- Concept: 4-table JOIN
-- ─────────────────────────────────────────────────
Select o.order_id, c.name as Customer,
       p.name as Product,
       od.quantity, od.price
from Customer c
Join Orders o ON c.customer_id = o.customer_id
Join OrderDetails od ON o.order_id = od.order_id
Join Product p ON od.product_id = p.product_id;

-- ─────────────────────────────────────────────────
-- Q98  Find departments whose employees ALL earn above 60000.
-- Concept: JOIN + GROUP BY + HAVING MIN
-- Fix: WHERE salary > 60000 filters rows BEFORE grouping
--      so it doesn't check ALL employees in a dept.
--      HAVING MIN(salary) > 60000 checks that even the
--      LOWEST paid employee earns above 60000.
-- ─────────────────────────────────────────────────
Select d.dept_name, MIN(e.salary) as 'Min Salary'
from Employee e
Join Department d ON e.dept_id = d.dept_id
Group by d.dept_name
Having MIN(e.salary) > 60000;

-- ─────────────────────────────────────────────────
-- Q99  Show each driver's ride count and total earnings.
-- Concept: GROUP BY on Rides table
-- ─────────────────────────────────────────────────
Select Driver_Id,
       COUNT(*) as 'Total Rides',
       SUM(fare) as 'Total Earnings'
from Rides
Group by Driver_Id;

-- ─────────────────────────────────────────────────
-- Q100  Find customers who ordered the same product more than once.
-- Concept: JOIN + GROUP BY + HAVING COUNT > 1
-- Note: Must check at product level using OrderDetails.
--       Grouping by customer + product, then HAVING COUNT > 1
--       means same customer ordered same product 2+ times.
-- ─────────────────────────────────────────────────
Select c.name as Customer,
       p.name as Product,
       COUNT(*) as 'Times Ordered'
from Customer c
Join Orders o ON c.customer_id = o.customer_id
Join OrderDetails od ON o.order_id = od.order_id
Join Product p ON od.product_id = p.product_id
Group by c.name, p.name
Having COUNT(*) > 1;
