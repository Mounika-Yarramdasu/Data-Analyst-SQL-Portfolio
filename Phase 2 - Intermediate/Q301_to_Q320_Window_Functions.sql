-- ================================================
-- FILE    : Q301_to_Q320_Window_Functions.sql
-- PHASE   : Phase 2 - Intermediate
-- TOPICS  : ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD,
--           SUM OVER, COUNT OVER, FIRST_VALUE, LAST_VALUE,
--           NTILE, PERCENT_RANK, Moving Average
-- DATASET : Employee, Orders, Transactions, Rides
-- TOOL    : SQL Server (SSMS)
-- AUTHOR  : Mounika Yarramdasu
-- GITHUB  : github.com/Mounika-Yarramdasu/Data-Analyst-SQL-Portfolio
-- ================================================
 
Use Analysis;
 
-- ─────────────────────────────────────────────────
-- Q301  Assign row numbers to employees ordered by salary descending.
-- Concept: ROW_NUMBER() OVER (ORDER BY)
-- Note: ROW_NUMBER gives unique sequential numbers 1,2,3...
--       even when salaries are equal (no ties).
-- ─────────────────────────────────────────────────
Select name, salary,
       ROW_NUMBER() OVER (ORDER BY salary DESC) as Row_Num
from Employee;
 
-- ─────────────────────────────────────────────────
-- Q302  Rank employees by salary within each department.
-- Concept: RANK() OVER (PARTITION BY dept_id ORDER BY salary)
-- Note: PARTITION BY resets the rank for each department.
--       Tied salaries get the same rank, next rank skips.
-- ─────────────────────────────────────────────────
Select name, dept_id,
       RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) as Rk
from Employee;
 
-- ─────────────────────────────────────────────────
-- Q303  Find employees ranked 1st in salary in each department.
-- Concept: RANK() in CTE, then filter WHERE Rk = 1
-- ─────────────────────────────────────────────────
With Dept_Rank as (
    Select name, dept_id, salary,
           RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) as Rk
    from Employee
)
Select * from Dept_Rank
where Rk = 1;
 
-- ─────────────────────────────────────────────────
-- Q304  Show DENSE_RANK vs RANK — what is the difference?
-- Concept: RANK skips numbers after ties.
--          DENSE_RANK never skips — always consecutive.
-- Example: Salaries 90k, 82k, 78k, 78k, 70k
--   RANK:       1,   2,   3,   3,   5   (skips 4)
--   DENSE_RANK: 1,   2,   3,   3,   4   (no skip)
-- ─────────────────────────────────────────────────
Select name, salary,
       RANK()       OVER (ORDER BY salary DESC) as Rk,
       DENSE_RANK() OVER (ORDER BY salary DESC) as Dense_Rk
from Employee;
 
-- ─────────────────────────────────────────────────
-- Q305  Find the 2nd highest salary in each department.
-- Concept: DENSE_RANK with PARTITION BY dept_id
-- Fix: Must use PARTITION BY dept_id to rank WITHIN
--      each department. Without it, ranks the whole company.
-- ─────────────────────────────────────────────────
With Dept_Salary_Rank as (
    Select name, dept_id, salary,
           DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) as Rnk
    from Employee
)
Select * from Dept_Salary_Rank
where Rnk = 2;
 
-- ─────────────────────────────────────────────────
-- Q306  Display each order and the previous order amount for the same customer.
-- Concept: LAG(order_amount) OVER PARTITION BY customer
-- Fix: ORDER BY order_date (time order) not order_amount.
--      LAG should find the PREVIOUS order in time,
--      not the previous by amount.
-- ─────────────────────────────────────────────────
Select customer_id, order_id, order_date, order_amount,
       LAG(order_amount) OVER (PARTITION BY customer_id
                               ORDER BY order_date) as Previous_Amount
from Orders;
 
-- ─────────────────────────────────────────────────
-- Q307  Show each order and the change from previous order (difference).
-- Concept: LAG + subtraction in CTE
-- Fix: ORDER BY order_date for correct time-based previous order.
-- ─────────────────────────────────────────────────
With Previous_Order as (
    Select customer_id, order_id, order_date, order_amount,
           LAG(order_amount) OVER (PARTITION BY customer_id
                                   ORDER BY order_date) as Previous_Amount
    from Orders
)
Select *,
       order_amount - Previous_Amount as Difference
from Previous_Order;
 
-- ─────────────────────────────────────────────────
-- Q308  Display each transaction and the NEXT transaction amount for same account.
-- Concept: LEAD() OVER PARTITION BY account ORDER BY date
-- Fix: ORDER BY txn_date (time order) to get next in time.
-- ─────────────────────────────────────────────────
Select account_id, txn_date, amount,
       LEAD(amount) OVER (PARTITION BY account_id
                          ORDER BY txn_date) as Next_Transaction
from Transactions;
 
-- ─────────────────────────────────────────────────
-- Q309  Find customers whose order amount increased from previous order.
-- Concept: LAG + CTE + WHERE current > previous
-- Fix: ORDER BY order_date so LAG gives previous in time.
--      Filter: order_amount > Previous_Amount (increased).
--      Include IS NULL to keep first orders (no previous).
-- ─────────────────────────────────────────────────
With Previous_Order as (
    Select customer_id, order_id, order_date, order_amount,
           LAG(order_amount) OVER (PARTITION BY customer_id
                                   ORDER BY order_date) as Previous_Amount
    from Orders
)
Select * from Previous_Order
where order_amount > Previous_Amount
   OR Previous_Amount is null;
 
-- ─────────────────────────────────────────────────
-- Q310  Calculate running total of order amounts by order date.
-- Concept: SUM() OVER ORDER BY date (no PARTITION = global running total)
-- Fix: Removed PARTITION BY order_date which was resetting
--      the total each day. True running total needs no partition.
-- ─────────────────────────────────────────────────
Select order_id, order_date, order_amount,
       SUM(order_amount) OVER (ORDER BY order_date
                               ROWS BETWEEN UNBOUNDED PRECEDING
                               AND CURRENT ROW) as Running_Total
from Orders;
 
-- ─────────────────────────────────────────────────
-- Q311  Show running total of sales per customer (ordered by order date).
-- Concept: SUM() OVER PARTITION BY customer ORDER BY date
-- Note: PARTITION BY customer_id resets running total
--       for each customer separately.
-- ─────────────────────────────────────────────────
Select customer_id, order_id, order_date, order_amount,
       SUM(order_amount) OVER (PARTITION BY customer_id
                               ORDER BY order_date) as Running_Total
from Orders;
 
-- ─────────────────────────────────────────────────
-- Q312  Calculate running count of rides per driver.
-- Concept: COUNT() OVER PARTITION BY driver ORDER BY ride_id
-- Fix: Removed DISTINCT — window functions need all rows.
--      Running count shows how many rides completed so far.
-- ─────────────────────────────────────────────────
Select ride_id, driver_id, fare,
       COUNT(*) OVER (PARTITION BY driver_id
                      ORDER BY ride_id
                      ROWS BETWEEN UNBOUNDED PRECEDING
                      AND CURRENT ROW) as Running_Ride_Count
from Rides;
 
-- ─────────────────────────────────────────────────
-- Q313  Display each transaction with the cumulative sum per account.
-- Concept: SUM OVER PARTITION BY account ORDER BY date
-- Fix: ORDER BY txn_date for correct time-based cumulative.
-- ─────────────────────────────────────────────────
Select account_id, txn_date, amount,
       SUM(amount) OVER (PARTITION BY account_id
                         ORDER BY txn_date) as Cumulative_Total
from Transactions;
 
-- ─────────────────────────────────────────────────
-- Q314  Show each product's running revenue contribution sorted by revenue.
-- Concept: SUM OVER ORDER BY — running total of revenue
-- ─────────────────────────────────────────────────
Select p.name, od.quantity * od.price as Revenue,
       SUM(od.quantity * od.price) OVER (ORDER BY od.quantity * od.price DESC
                                         ROWS BETWEEN UNBOUNDED PRECEDING
                                         AND CURRENT ROW) as Running_Revenue
from OrderDetails od
Join Product p ON od.product_id = p.product_id;
 
-- ─────────────────────────────────────────────────
-- Q315  Find first and last order date for each customer using window functions.
-- Concept: FIRST_VALUE, LAST_VALUE or MIN/MAX OVER PARTITION
-- Note: MIN/MAX approach (Approach 2) is safer and simpler.
--       LAST_VALUE needs UNBOUNDED FOLLOWING frame clause
--       otherwise it only sees rows up to current row.
-- ─────────────────────────────────────────────────
 
-- Approach 1: FIRST_VALUE + LAST_VALUE (needs correct frame)
Select Distinct customer_id,
       FIRST_VALUE(order_date) OVER (PARTITION BY customer_id
                                     ORDER BY order_date
                                     ROWS BETWEEN UNBOUNDED PRECEDING
                                     AND UNBOUNDED FOLLOWING) as First_Order,
       LAST_VALUE(order_date)  OVER (PARTITION BY customer_id
                                     ORDER BY order_date
                                     ROWS BETWEEN UNBOUNDED PRECEDING
                                     AND UNBOUNDED FOLLOWING) as Last_Order
from Orders;
 
-- Approach 2: MIN/MAX OVER PARTITION (simpler and reliable)
Select Distinct customer_id,
       MIN(order_date) OVER (PARTITION BY customer_id) as First_Order,
       MAX(order_date) OVER (PARTITION BY customer_id) as Last_Order
from Orders;
 
-- ─────────────────────────────────────────────────
-- Q316  Show each order alongside the customer's total order count.
-- Concept: COUNT(*) OVER PARTITION BY customer
-- Fix: Use COUNT(*) not SUM(amount) — question asks for order count.
--      No ORDER BY needed in window — want total count, not running.
-- ─────────────────────────────────────────────────
Select order_id, customer_id, order_amount,
       COUNT(*) OVER (PARTITION BY customer_id) as Customer_Total_Orders
from Orders;
 
-- ─────────────────────────────────────────────────
-- Q317  Divide employees into 4 salary quartiles.
-- Concept: NTILE(4) — splits rows into N equal buckets
-- Note: Bucket 1 = top earners, Bucket 4 = lowest earners
--       (because ORDER BY salary DESC)
-- ─────────────────────────────────────────────────
Select name, salary,
       NTILE(4) OVER (ORDER BY salary DESC) as Salary_Quartile
from Employee;
 
-- ─────────────────────────────────────────────────
-- Q318  Assign percentile rank to each employee by salary.
-- Concept: PERCENT_RANK() — returns value between 0 and 1
-- Note: 0 = lowest salary, 1 = highest salary
--       Formula: (rank - 1) / (total rows - 1)
-- ─────────────────────────────────────────────────
Select name, salary,
       ROUND(PERCENT_RANK() OVER (ORDER BY salary) * 100, 2) as Percentile
from Employee;
 
-- ─────────────────────────────────────────────────
-- Q319  Show each ride's duration ranking among all rides.
-- Concept: CTE + DATEDIFF + DENSE_RANK
-- Note: Excellent use of CTE to calculate duration first,
--       then rank. This is exactly the interview pattern.
-- ─────────────────────────────────────────────────
With Duration as (
    Select ride_id, driver_id, fare,
           DATEDIFF(minute, start_time, end_time) as Duration_Mins
    from Rides
)
Select ride_id, Duration_Mins,
       DENSE_RANK() OVER (ORDER BY Duration_Mins DESC) as Duration_Rank
from Duration;
 
-- ─────────────────────────────────────────────────
-- Q320  Calculate 3-ride moving average fare per driver.
-- Concept: AVG() OVER ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
-- Note: ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
--       looks at current row + 2 rows before = 3 rows total.
--       ORDER BY ride_id for correct time-based sequence.
-- ─────────────────────────────────────────────────
Select ride_id, driver_id, fare,
       AVG(fare) OVER (PARTITION BY driver_id
                       ORDER BY ride_id
                       ROWS BETWEEN 2 PRECEDING
                       AND CURRENT ROW) as Moving_Avg_Fare
from Rides;
 










