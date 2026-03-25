Use Analyst;
--41.Find the total payroll (sum of all salaries).
Select sum(Salary) as payroll from  employees;
--42.Count employees where email is not null.
Select Count(email) from Employees;
--43.Find the number of distinct job titles.
Select count(distinct job_title) from Employees;
--44.What is the total revenue from orders?
Select * from OrderItems
Select sum(Quantity* unit_price*(1-discount_pct/100.0)) as 'Total Revenue' from OrderItems;
--45.How many orders were placed in 2023?
Select Count(order_date) from Orders
where year(order_date)='2023';
--46.Show total salary by department.
Select d.dept_name, sum(e.salary) as 'Total salary' 
from employees e join departments d
on e.dept_id=d.dept_id
group by d.dept_name;
--47.Show average salary per job title.
Select job_title, avg(salary) as 'Avg salary' from employees
group by job_title;
--48.Show number of employees per city.
Select City,count(*) 'No of Employees' from employees
Group by City;
--49.Show max salary in each department.
Select d.dept_name, max(e.salary) as 'Max salary' 
from employees e join departments d
on e.dept_id=d.dept_id
group by d.dept_name;
--50.Show total revenue per product category.
Select pc.category_name, sum(o.quantity*o.unit_price*(1-o.discount_pct/100.0)) as 'Total revenue'from OrderItems o
join Products p on o.product_id=p.product_id
join ProductCategories pc on p.category_id=pc.category_id
Group by pc.category_name
Order by 'Total revenue' desc;

--51.Show how many orders each customer placed.
Select C.first_name, count(*) as 'No of orders'from customers c
join orders o on c.customer_id=o.customer_id
Group by c.first_name
--52.Show the earliest hire date per department.
Select d.Dept_name, Min(e.hire_date) as 'Earliest hired dept' from employees e
join departments d on e.dept_id=d.dept_id
Group by d.dept_name
--53.Show count of products per brand.
Select Brand, count(*) as 'Count Of Products' from Products
group by brand
--54.Show average order value per month
Select month(o.order_date) as month, AVG(oi.unit_price*oi.quantity) as 'Avg order value'
from orders o join OrderItems oi 
on o.order_id=oi.order_id
group by month(o.order_date) ;
--55.Show total sales per salesperson.

--56.Find departments with more than 5 employees.

--57.Find departments with average salary above 60000.

--58.Find products with total sales greater than 10000.

--59.Find customers who placed more than 3 orders.

--60.Find cities where average house price exceeds 500000.
