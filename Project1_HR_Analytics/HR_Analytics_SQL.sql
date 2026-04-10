-- ============================================================
-- PROJECT 1: HR ANALYTICS
-- Day 1: SQL Queries (10 Questions)
-- Database: HRAnalytics
-- Author: Mounika Yarramdasu
-- ============================================================

CREATE DATABASE HRAnalytics;
USE HRAnalytics;

-- Department table
CREATE TABLE Department (
    DeptID   VARCHAR(10) PRIMARY KEY,
    DeptName VARCHAR(50),
    Manager  VARCHAR(50),
    Budget   DECIMAL(10,2)
);

INSERT INTO Department VALUES
('D01','Engineering','Arjun',500000),
('D02','HR','Sneha',300000),
('D03','Sales','Meera',400000),
('D04','Finance','Divya',350000);

-- Employee table
CREATE TABLE Employee (
    EmpID    VARCHAR(10) PRIMARY KEY,
    Name     VARCHAR(50),
    DeptID   VARCHAR(10),
    City     VARCHAR(30),
    Salary   DECIMAL(10,2),
    JoinYear INT,
    Sales    DECIMAL(10,2)
);

INSERT INTO Employee VALUES
('E001','Arjun','D01','Hyderabad',95000,2020,450000),
('E002','Priya','D01','Hyderabad',82000,2020,380000),
('E003','Ravi','D02','Mumbai',78000,2021,290000),
('E004','Sneha','D02','Mumbai',70000,2019,310000),
('E005','Kiran','D03','Bangalore',55000,2022,180000),
('E006','Meera','D03','Bangalore',90000,2018,520000),
('E007','Suresh','D04','Delhi',65000,2021,240000),
('E008','Divya','D04','Delhi',88000,2020,410000),
('E009','Rahul','D01','Hyderabad',72000,2022,330000),
('E010','Anita','D03','Bangalore',60000,2023,150000);

-- Monthly Sales table
CREATE TABLE MonthlySales (
    EmpID  VARCHAR(10),
    Month  VARCHAR(10),
    Region VARCHAR(20),
    Amount DECIMAL(10,2),
    Target DECIMAL(10,2)
);

INSERT INTO MonthlySales VALUES
('E001','Jan','South',120000,100000),
('E001','Feb','South',95000,100000),
('E002','Jan','South',85000,80000),
('E003','Jan','West',70000,90000),
('E004','Feb','West',80000,75000),
('E005','Jan','North',45000,50000),
('E006','Feb','North',130000,120000),
('E007','Jan','East',60000,65000),
('E008','Feb','East',110000,100000),
('E009','Jan','South',90000,85000);


-- ============================================================
-- QUERIES: Q1 TO Q10
-- ============================================================

-- Q1 - Department wise employee count
SELECT d.DeptName,
       COUNT(e.EmpID) AS EmployeeCount
FROM Department d
LEFT JOIN Employee e ON d.DeptID = e.DeptID
GROUP BY d.DeptName
ORDER BY EmployeeCount DESC;

-- Q2 - Average salary per department
SELECT d.DeptName,
       ROUND(AVG(e.Salary),0) AS AvgSalary
FROM Employee e
JOIN Department d ON e.DeptID = d.DeptID
GROUP BY d.DeptName
ORDER BY AvgSalary DESC;

-- Q3 - City wise employee count
SELECT City,
       COUNT(*) AS EmpCount,
       AVG(Salary) AS AvgSalary
FROM Employee
GROUP BY City
ORDER BY EmpCount DESC;

-- Q4 - Employees earning above company average
SELECT Name, Salary, DeptID
FROM Employee
WHERE Salary > (SELECT AVG(Salary) FROM Employee)
ORDER BY Salary DESC;

-- Q5 - Department budget vs actual salary spend
SELECT d.DeptName,
       d.Budget,
       SUM(e.Salary) AS ActualSalary,
       d.Budget - SUM(e.Salary) AS Remaining,
       CASE
           WHEN SUM(e.Salary) > d.Budget THEN 'Over Budget'
           ELSE 'Within Budget'
       END AS Status
FROM Department d
JOIN Employee e ON d.DeptID = e.DeptID
GROUP BY d.DeptName, d.Budget;

-- Q6 - Top earner per department
WITH RankedEmp AS (
    SELECT e.Name, e.Salary, d.DeptName,
           RANK() OVER(PARTITION BY e.DeptID
                       ORDER BY e.Salary DESC) AS rnk
    FROM Employee e
    JOIN Department d ON e.DeptID = d.DeptID
)
SELECT DeptName, Name, Salary
FROM RankedEmp
WHERE rnk = 1;

-- Q7 - Year wise hiring trend
SELECT JoinYear,
       COUNT(*) AS NewHires,
       SUM(COUNT(*)) OVER(ORDER BY JoinYear) AS CumulativeHires
FROM Employee
GROUP BY JoinYear
ORDER BY JoinYear;

-- Q8 - Region wise sales performance
SELECT Region,
       SUM(Amount)    AS TotalSales,
       SUM(Target)    AS TotalTarget,
       ROUND(SUM(Amount)*100.0/SUM(Target),1) AS AchievementPct
FROM MonthlySales
GROUP BY Region
ORDER BY TotalSales DESC;

-- Q9 - Employees who exceeded their sales target
SELECT e.Name,
       SUM(m.Amount) AS TotalSales,
       SUM(m.Target) AS TotalTarget,
       CASE
           WHEN SUM(m.Amount) > SUM(m.Target) THEN 'Exceeded'
           ELSE 'Below Target'
       END AS Performance
FROM Employee e
JOIN MonthlySales m ON e.EmpID = m.EmpID
GROUP BY e.Name
ORDER BY TotalSales DESC;

-- Q10 - Full employee summary
SELECT e.Name,
       d.DeptName,
       e.City,
       e.Salary,
       e.JoinYear,
       CASE
           WHEN e.Salary > 85000 THEN 'Senior'
           WHEN e.Salary > 70000 THEN 'Mid'
           ELSE 'Junior'
       END AS SalaryBand,
       RANK() OVER(PARTITION BY e.DeptID
                   ORDER BY e.Salary DESC) AS DeptRank
FROM Employee e
JOIN Department d ON e.DeptID = d.DeptID
ORDER BY d.DeptName, DeptRank;

-- ============================================================
-- END OF FILE
-- ============================================================
