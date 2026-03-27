-- ================================================
-- FILE    : Q01_to_Q20_SELECT_WHERE_LIKE_basics.sql
-- PHASE   : Phase 1 - Foundations
-- TOPICS  : SELECT, WHERE, LIKE, NULL, ORDER BY,
--           DISTINCT, Aggregate Functions
-- DATASET : Employee & Department
-- TOOL    : SQL Server (SSMS)
-- AUTHOR  : Mounika Yarramdasu
-- GITHUB  : github.com/Mounika-Yarramdasu/Data-Analyst-SQL-Portfolio
-- ================================================

Use analysis;

-- ─────────────────────────────────────────────────
-- Q1  Retrieve all columns from the Employee table.
-- Concept: SELECT *
-- ─────────────────────────────────────────────────
Select * from Employee;

-- ─────────────────────────────────────────────────
-- Q2  Display only the name and salary of all employees.
-- Concept: SELECT specific columns
-- ─────────────────────────────────────────────────
Select Name, Salary from Employee;

-- ─────────────────────────────────────────────────
-- Q3  Show all employees from the 'Engineering' department (dept_id=1).
-- Concept: WHERE clause
-- ─────────────────────────────────────────────────
Select Name from Employee
where dept_id = 1;

-- ─────────────────────────────────────────────────
-- Q4  Find all employees with salary greater than 70000.
-- Concept: WHERE + comparison operator
-- ─────────────────────────────────────────────────
Select Name, Salary from Employee
where Salary > 70000;

-- ─────────────────────────────────────────────────
-- Q5  List employees whose name starts with 'A'.
-- Concept: WHERE + LIKE with wildcard
-- ─────────────────────────────────────────────────
Select Name from Employee
where Name like 'A%';

-- ─────────────────────────────────────────────────
-- Q6  Find employees hired after January 1, 2022.
-- Concept: WHERE + date comparison
-- ─────────────────────────────────────────────────
Select Name, Hire_Date from Employee
where Hire_Date > '2022-01-01';

-- ─────────────────────────────────────────────────
-- Q7  Show employees whose salary is between 60000 and 90000.
-- Concept: WHERE + BETWEEN (inclusive on both ends)
-- ─────────────────────────────────────────────────
Select Name, Salary from Employee
where Salary Between 60000 and 90000;

-- ─────────────────────────────────────────────────
-- Q8  Display employees from Hyderabad OR Mumbai.
-- Concept: WHERE + IN (cleaner than multiple OR conditions)
-- ─────────────────────────────────────────────────
Select Name, City from Employee
where City in ('Hyderabad', 'Mumbai');

-- ─────────────────────────────────────────────────
-- Q9  Find employees who do NOT belong to dept_id 1 or 2.
-- Concept: WHERE + NOT IN
-- Note: Added OR Dept_Id IS NULL because NULL does not match
--       NOT IN by default — NULLs must be handled separately.
-- ─────────────────────────────────────────────────
Select Name, Dept_Id from Employee
where Dept_Id not in (1, 2) or Dept_Id is null;

-- ─────────────────────────────────────────────────
-- Q10 List all employees sorted by salary descending.
-- Concept: ORDER BY DESC
-- ─────────────────────────────────────────────────
Select Name, Salary from Employee
Order By Salary Desc;

-- ─────────────────────────────────────────────────
-- Q11 Get the top 5 highest-paid employees.
-- Concept: TOP N (SQL Server) | Use LIMIT 5 in MySQL
-- ─────────────────────────────────────────────────
Select Top 5 * from Employee
Order by Salary Desc;

-- ─────────────────────────────────────────────────
-- Q12 Show employees with NULL dept_id.
-- Concept: WHERE IS NULL
-- ─────────────────────────────────────────────────
Select Name, Dept_Id from Employee
where Dept_Id is null;

-- ─────────────────────────────────────────────────
-- Q13 Show employees with a non-null phone number.
-- Concept: WHERE IS NOT NULL
-- ─────────────────────────────────────────────────
Select Name, Phone from Employee
where Phone is not null;

-- ─────────────────────────────────────────────────
-- Q14 Retrieve distinct cities from the Employee table.
-- Concept: DISTINCT — removes duplicate values
-- ─────────────────────────────────────────────────
Select Distinct City as 'List Of Cities' from Employee;

-- ─────────────────────────────────────────────────
-- Q15 Count total number of employees.
-- Concept: COUNT(*) — counts all rows including NULLs
-- ─────────────────────────────────────────────────
Select Count(*) as 'No Of Employees' from Employee;

-- ─────────────────────────────────────────────────
-- Q16 Find the maximum salary in the company.
-- Concept: MAX() aggregate function
-- ─────────────────────────────────────────────────
Select Max(Salary) as 'Maximum Salary' from Employee;

-- ─────────────────────────────────────────────────
-- Q17 Find the minimum salary in the company.
-- Concept: MIN() aggregate function
-- ─────────────────────────────────────────────────
Select Min(Salary) as 'Minimum Salary' from Employee;

-- ─────────────────────────────────────────────────
-- Q18 Calculate average salary of all employees.
-- Concept: AVG() aggregate function
-- ─────────────────────────────────────────────────
Select Avg(Salary) as 'Average Salary' from Employee;

-- ─────────────────────────────────────────────────
-- Q19 Sum of all employee salaries.
-- Concept: SUM() aggregate function
-- ─────────────────────────────────────────────────
Select Sum(Salary) as 'Total Salary' from Employee;

-- ─────────────────────────────────────────────────
-- Q20 List employees whose email contains 'company.com'.
-- Concept: LIKE with % wildcard on both sides
-- ─────────────────────────────────────────────────
Select * from Employee
where Email like '%company.com%';
