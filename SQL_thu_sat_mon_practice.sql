-- 1ST DAY PROBLEM

-- The Schema:
-- employees (emp_id, first_name, last_name, dept_id, salary, hire_date)
-- departments (dept_id, dept_name, location)
-- salaries (emp_id, salary_amount, change_date)

-- [Easy] Write a query to find all unique dept_id values from the employees table, sorted in ascending order.
-- [Easy] Write a query to retrieve the first_name and last_name of all employees who were hired after January 1st, 2023, and earn more than $60,000.
-- [Medium] Write a query to find the total number of employees and the average salary in each dept_id. Rename the columns to total_employees and avg_salary.
-- [Medium] Write a query to find the names of employees (first_name, last_name) along with their dept_name. Use a join.

SELECT DISTINCT dept_id FROM employees
ORDER BY dept_id ASC;

SELECT first_name, last_name FROM employees
WHERE hire_date>'2023-01-01' AND salary>60000;

SELECT dept_id, COUNT(*) AS total_employees, AVG(salary) AS avg_salary FROM employees
GROUP BY dept_id;

SELECT 
    e.first_name,
    e.last_name,
    d.dept_name
FROM employees e
INNER JOIN departments d ON d.dept_id = e.dept_id;
-- HERE WE CANNOT USE LEFT JOIN FROM BOTH END BEACUSE IT GIVE NULL VALUE EITHER IN EMPLOYEE TABLE OR IN DEPARTMENT TABLE. SO TO NOT GET NULL VALUE WE USE INNER JOIN


-- 2ND DAY PROBLEM 

-- Updated Schema:
-- employees (emp_id, first_name, last_name, dept_id, manager_id, salary, hire_date)
-- departments (dept_id, dept_name, location)
-- projects (project_id, project_name, budget)

-- [NULL Handling] Write a query to find all employees who do not have a manager (where manager_id is null).
-- [Pattern Matching] Find all employees whose first_name starts with 'A' and has at least 5 characters in the name.
-- [Top N Records] Write a query to find the top 3 highest-paid employees. Display their first_name and salary.

SELECT * FROM employees
WHERE manager_id IS NULL;

SELECT * FROM employess
Where first_name LIKE 'A_____%';

SELECT first_name, salary from employees
ORDER BY salary DESC
LIMIT 3;

-- [HAVING Clause] Write a query to find all dept_ids where the total salary spent on employees is greater than $200,000.
SELECT dept_id , SUM(salary) from employees
GROUP BY dept_id
HAVING SUM(salary) > 200000;

-- [Subquery] Write a query to find all employees who earn more than the average salary of the entire company.
SELECT * 
FROM employees
WHERE salary > (SELECT AVG(salary)
from employees);


-- [Joins & Counts] Write a query to list all dept_names and the count of employees in each department. Include departments that have zero employees. (Hint: Use a LEFT JOIN).
-- -- 
SELECT d.dept_name , 
Count(e.emp_id) AS total_employees
FROM department d
LEFT JOIN employees e ON e.dept_id = d.dept_id;
GROUP BY d.dept_name;


-- 3RD DAY PROBLEM
-- The Schema
-- employees (emp_id, emp_name, manager_id, salary, dept_id)
-- orders (order_id, customer_id, order_date, amount, status)
-- customers (customer_id, customer_name, city)

-- [Conditional Logic] Write a query to list all employees and a new column called salary_category.
-- If salary > 90,000, label it 'High'.
-- If salary between 50,000 and 90,000, label it 'Medium'.
-- Otherwise, label it 'Low'.

SELECT
    emp_name,
    salary,
    CASE 
        WHEN salary > 90000 THEN 'High' --- this is used like if or else in SQL(CASE -> WHEN -> THEN -> ELSE -> END);
        WHEN salary BETWEEN 50000 AND 90000 THEN 'Medium' 
        ELSE 'Low' 
    END --- this is used like if or else in SQL(CASE -> WHEN -> THEN -> ELSE -> END);
    AS salary_category
    FROM employees;

-- [Date Formatting] Find all orders placed in February 2024. (Hint: Use LIKE or BETWEEN or DATE functions).

SELECT *
FROM orders
WHERE order_date >='2024-02-01' and order_date <'2024-03-01';

-- [Data Cleaning] Write a query to return customer_name and city. If the city is NULL, display it as 'Unknown Location'.

SELECT
    customer_name,
    COALESCE(city, 'Unknown Location') AS city  -- this is used to return deault nullvalue with new name in SQL(COALESCE)
FROM customers;


-- [Self-Join] (Very Common) Write a query to find the names of employees and the names of their managers. (The manager_id refers to an emp_id in the same table).
-- employees (emp_id, emp_name, manager_id, salary, dept_id)
SELECT
    e.emp_name AS employee_name,
    m.emp_name AS manager_name
    FROM employees AS e
    JOIN employees AS m ON e.manager_id = m.emp_id; 

-- [CTEs / Subqueries] Find the customer_id and the total amount spent by customers who have spent more than the average order amount of all orders.
SELECT
    customer_id,
    SUM(amount) AS total_spent
    FROM orders
    GROUP BY customer_id
    HAVING SUM(amount) > (select avg(amount) from orders);

-- [Ranking / Offset] Write a query to find the second-highest salary from the employees table. (Note: Do not use TOP or LIMIT alone; 
-- think about how to handle duplicates if two people have the same highest salary).

--1
SELECT MAX(salary) AS second_max_salary
FROM employees
WHERE salary < (
    SELECT MAX(salary)
    FROM employees
);

--2

SELECT DISTINCT SALARY
FROM employees
ORDER BY SALARY DESC
OFFSET 1 ROWS
FETCH NEXT 1 ROWS ONLY;

--3

SELECT DISTINCT salary
from employees
WHERE salary < (SELECT MAX(salary) FROM employees)
ORDER BY salary DESC
LIMIT 1;



-- Day 4: Window Functions & Data Analysis

-- The Schema
-- employees (emp_id, emp_name, dept_id, salary)
-- departments (dept_id, dept_name)
-- sales (sale_id, emp_id, sale_date, amount)


-- 3 Easy Questions

-- [String Manipulation] Write a query to find all employees whose emp_name ends with the letter 'n'.

SELECT *
FROM employees
WHERE emp_name LIKE '%n';

-- [Basic Math] List all employees in dept_id = 101 and show their emp_name, salary, and a new column bonus which is 10% of their salary.

SELECT
    emp_name,
    salary,
    salary * 0.10 AS bonus
    FROM employees
    WHERE dept_id = 101;


-- [Existence] Write a query to find all dept_names from the departments table that currently have no employees assigned to them. (Hint: Use NOT IN or NOT EXISTS or a LEFT JOIN).
    SELECT
    dept_name
    FROM departments
    WHERE dept_id NOT IN (SELECT DISTINCT dept_id FROM employees);

-- 3 Medium Questions
-- [Running Total] (Very Common) Write a query to list all sale_date and amount from the sales table, and add a third column called running_total that shows the cumulative sum of sales 
-- ordered by date.
SELECT
sale_date,
amount,
SUM(amount) OVER (ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM sales
ORDER BY sale_date;

-- [Joins & Aggregation] Find the dept_name and the total sales amount generated by all employees belonging to that department.
SELECT
    d.dept_name,
    SUM(s.amount) AS total_sales
    FROM departments d
    JOIN employees e ON d.dept_id = e.dept_id
    JOIN sales s ON e.emp_id = s.emp_id
    GROUP BY d.dept_name;

-- [Finding Duplicates] Write a query to find any emp_name that appears more than once in the employees table. Show the name and the number of times it appears.
SELECT
emp_name, 
COUNT(*) AS occur_count
FROM employees
GROUP BY emp_name
HAVING COUNT(*) > 1;



-- For Day 5, we are going to focus on Window Functions (Ranking), Advanced Joins, and Logic-based Filtering. These are the questions that separate the beginners from the pros in interviews.


-- The Schema
-- employees (emp_id, emp_name, dept_id, salary)
-- departments (dept_id, dept_name)
-- sales (sale_id, emp_id, sale_date, amount)
-- salaries_history (emp_id, salary_amount, change_date)


-- 3 Easy Questions

-- [In-List Filtering] Write a query to find all employees who work in either the 'HR', 'IT', or 'Finance' departments. (Use the dept_name from the departments table).
SELECT
e.emp_name,
d.dept_name
FROM employees e 
JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_name IN ('HR', 'IT', 'Finance');


-- [Salary Growth] Write a query to find all employees whose salary is between $50,000 and $100,000, but exclude those who are in dept_id 101.


SELECT *
FROM employees
Where dept_id <> 101 AND salary Between 50000 and 100000;

-- [Aggregation with Filter] Count how many sales were made that were greater than $500 in the year 2023.


SELECT COUNT(*) AS high_count
FROM sales
WHERE sales_date BETWEEN '2023-01-01' and '2023-12-31' AND amount > 500;




-- 3 Medium / Advanced Questions (Interview Favorites)

-- [Ranking - DENSE_RANK] Write a query to rank employees by their salary within each department. Use DENSE_RANK(). 
-- The output should show dept_name, emp_name, salary, and the rank.
SELECT
    d.dept_name,
    e.emp_name,
    e.salary,
    DENSE_RANK() OVER (PARTITION BY d.dept_id ORDER BY e.salary DESC) AS salary_rank
    from employees e
    JOIN departments d ON e.dept_id = d.dept_id;


-- [Self-Comparison] Write a query to find all employees whose current salary is higher than the average salary of their own department.
SELECT
    e.emp_name,
    e.salary,
    d.dept_name
    FROM employees e 
    JOIN departments d ON e.dept_id = d.dept_id
    WHERE e.salary > (SELECT AVG(e2.salary) FROM employees e2 WHERE e2.dept_id = e.dept_id);

-- [Trend Analysis] Find the Month-over-Month total sales. Your output should show the Year, the Month, and the Total Sales Amount for that month, 
-- ordered chronologically. (Hint: Use EXTRACT or MONTH() functions and GROUP BY).

SELECT
    EXTRACT(YEAR FROM sale_date) AS sale_year,
    EXTRACT(MONTH FROM sale_date) AS sale_month,
    SUM(amount) AS total_sales
    FROM sales
    GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
    ORDER BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date);

-- Bonus Challenge (Hard)

-- [Department Headcount] List all departments (even those with no employees) and the name of the highest-paid employee in that department. 
-- If a department has no employees, show NULL.
SELECT
    d.dept_name,
    e.emp_name AS highest_paid_employee
    FROM departments d
    LEFT JOIN employees e ON d.dept_id = e.dept_id
    AND e.salary = (SELECT MAX(e2.salary) FROM employees e2 WHERE e2.dept_id = d.dept_id);




-- Day 6: Advanced Filtering & Analytical Queries
-- Let's step up the difficulty slightly. Today we focus on CTEs (Common Table Expressions), Set Operators, and Percentage Calculations.


-- The Schema
-- employees (emp_id, emp_name, dept_id, salary)
-- sales (sale_id, emp_id, sale_date, amount)
-- web_traffic (visit_id, emp_id, login_time, logout_time)

-- 3 Easy Questions

-- [Set Operators] Write a query to find all emp_ids who are present in both the employees table and the sales table (use INTERSECT or an IN clause).
SELECT emp_id
FROM employees
WHERE emp_id IN (SELECT DISTINCT emp_id FROM sales);

-- [Date Difference] Write a query to find the duration of each session in the web_traffic table (i.e., logout_time minus login_time). 
-- Display emp_id and duration_minutes. ----start karo yaha se--

SELECT
emp_id,
EXTRACT(EPOCH FROM (logout_time - login_time)) / 60 AS duration_minutes
FROM web_traffic;


-- [Filtering] Find all employees whose emp_name starts with 'S' and ends with 'n' (e.g., "Steven").
SELECT
emp_name
FROM employees
WHERE emp_name LIKE 'S%n';

-- 3 Medium Questions

-- [Percentage of Total] (Very Common Interview Question) Write a query to show each employee's emp_name, their salary, and what percentage their salary is 
-- of the total company payroll.
-- Formula: (Salary / Total Salary of all employees) * 100
SELECT
    emp_name,
    salary,
    (salary * 100.0 / SUM(salary) OVER ()) AS salary_percentage
    FROM employees;


-- [CTEs] Use a CTE (Common Table Expression) to first find the average salary of the company. Then, in the main query, 
-- select all employees who earn more than that average.

WITH AvgSalaryCTE AS(
    SELECT AVG(salary) AS salary_avg
    FROM employees
)
SELECT
    e.emp_name,
    e.salary
    FROM employees e, AvgSalaryCTE a 
    WHERE e.salary > a.salary_avg;

-- [Conditional Aggregation] Write a query to find the total sales amount for each employee, but only for sales made in the year 2023. 
-- If an employee had no sales in 2023, show their total as 0 instead of NULL. (Hint: Use SUM with a CASE statement or COALESCE).

SELECT
    e.emp_name,
    COALESCE(
        SUM(
            CASE 
                WHEN EXTRACT(YEAR FROM s.sale_date) = 2023 THEN s.amount
                ELSE 0
            END    
        ), 0
    ) AS total_sales_2023
    FROM employees e
    LEFT JOIN sales s ON e.emp_id = s.emp_id
    GROUP BY e.emp_name;


-- Bonus Challenge

-- [Advanced Window Functions] For each department, find the employee who has the second-highest salary. (Try to use DENSE_RANK()).
WITH RankedSalaries AS (
    SELECT dept_id, emp_name, salary,
    DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) as rnk
    FROM employees
)
SELECT * FROM RankedSalaries WHERE rnk = 2;


-- Day 7: String Mastery, Self-Joins & Lead/Lag

-- Today we focus on high-probability "Lead/Lag" questions (often used for time-series analysis) and string manipulations.

-- The Schema
-- employees (emp_id, emp_name, manager_id, dept_id, salary)
-- sales (sale_id, emp_id, sale_date, amount)
-- products (prod_id, prod_name, category)

-- 3 Easy Questions


-- [String Formatting] Write a query to return the emp_name in all UPPERCASE and a second column showing the length of the name.
SELECT
    emp_name,
    UPPER(emp_name) AS emp_upper,
    LENGTH(emp_name) AS emp_length
FROM employees;

-- [Category Filter] Find all products where the prod_name contains the word 'Smart' (case-insensitive) and the category is either 'Electronics' or 'Gadgets'.

SELECT *
FROM products
WHERE LOWER(prod_name) LIKE '%smart%' AND category IN ('Electronics', 'Gadgets');

-- [Date Extraction] Write a query to find all sales that happened on a Friday. (Hint: Use TO_CHAR, EXTRACT, or WEEKDAY depending on your SQL dialect).
SELECT *
FROM sales
WHERE EXTRACT(DOW from sale_date) = 5; -- Assuming 0=Sunday, 1=Monday, ..., 5=Friday, 6=Saturday. Adjust based on your SQL dialect.


-- 3 Medium Questions


-- [Self-Join Comparison] (Interview Classic) Write a query to find all employees who earn more than their manager. 
-- Show the employee name, their salary, and their manager's salary.

SELECT
    e.emp_name AS employee_name,
    e.salary AS employee_salary,
    m.salary AS manager_salary
FROM employees e
JOIN employees m ON e.manager_id = m.emp_id
WHERE e.salary > m.salary;


-- [LEAD/LAG Functions] For each employee, show their sale_date, amount, and the amount of the previous sale they made. (Hint: Use LAG() partitioned by emp_id).
SELECT
    emp_id,
    sale_date,
    amount,
    LAG(amount) OVER (PARTITION BY emp_id ORDER BY sale_date) AS previous_sale_amount
FROM sales
ORDER BY emp_id, sale_date;

-- [String Manipulation - Substring] Assume prod_id is a string like 'CAT123-PROD99'. Write a query to extract only the part after the hyphen (e.g., 'PROD99').
SELECT
    prod_id,
    SUBSTRING(prod_id FROM POSITION('-' IN prod_id) + 1) AS prod_code
FROM products;



-- Bonus Challenge (Hard)

-- [Top N per Group] Find the top 2 highest-selling products (by total amount) in each category.
WITH ProductSales AS (
    SELECT
        p.category,
        p.prod_name,
        SUM(s.amount) AS total_sales
    FROM products p
    JOIN sales s ON p.prod_id = s.prod_id
    GROUP BY p.category, p.prod_name
), RankedProducts AS (
    SELECT
        category,
        prod_name,
        total_sales,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY total_sales DESC) AS sales_rank
    FROM ProductSales
)
SELECT category, prod_name, total_sales
FROM RankedProducts
WHERE sales_rank <= 2
ORDER BY category, total_sales DESC;



-- Day 8: Recursive Logic & Data Pivoting

-- Today we tackle the "Boss Level" questions that appear in Senior Data Engineer or FAANG (Facebook, Amazon, etc.) interviews.

-- The Schema
-- employees (emp_id, emp_name, manager_id) -> For hierarchy
-- sales_data (sale_id, product_category, sale_year, amount)
-- daily_metrics (day_id, active_users)


-- 3 Easy Questions

-- [UNION vs UNION ALL] Write a query to combine emp_name from the employees table and product_category from sales_data into a single list. 
-- Ensure there are no duplicates.

SELECT emp_name AS name
FROM employees
UNION
SELECT product_category AS name
FROM sales_data;

-- [String Replacement] Write a query to return the product_category, but replace any space with an underscore _. (e.g., 'Home Office' -> 'Home_Office').

SELECT
    product_category,
    REPLACE(product_category, ' ', '_') AS category_formatted
FROM sales_data;

-- [Filtering with Subquery] Find all products in sales_data that have an amount greater than the maximum sale amount of the 'Electronics' category.
SELECT *
FROM sales_data
WHERE amount > (SELECT MAX(amount) FROM sales_data WHERE product_category = 'Electronics');


-- 3 Medium/Advanced Questions

-- [Pivoting Data] (High Interview Probability) Write a query to show the total sales amount for each year, but with categories as columns.
-- Desired Output: sale_year, Electronics_Amount, Furniture_Amount.

-- (Hint: Use SUM(CASE WHEN...))
SELECT
    sale_year,
    SUM(CASE WHEN product_category = 'Electronics' THEN amount ELSE 0 END) AS Electronics_Amount,
    SUM(CASE WHEN product_category = 'Furniture' THEN amount ELSE 0 END) AS Furniture_Amount
FROM sales_data
GROUP BY sale_year
ORDER BY sale_year;

-- [Moving Average] (Data Science Favorite) For the daily_metrics table, calculate a 3-day rolling average of active_users (Current day + 2 previous days).

SELECT
    day_id,
    active_users,
    AVG(active_users) OVER (ORDER BY day_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_avg_active_users
FROM daily_metrics
ORDER BY day_id;

-- [Recursive CTE] (The "Expert" Question) Given the employees table, write a query to show the management hierarchy for a specific employee 
-- (e.g., Emp -> Manager -> Director -> CEO). Show the path as a string.
WITH RECURSIVE ManagementHierarchy AS (
    SELECT emp_id, emp_name, manager_id, emp_name AS hierarchy_path
    FROM employees
    WHERE emp_name = 'Specific Employee Name' -- Replace with the actual employee name you want to trace

    UNION ALL

    SELECT e.emp_id, e.emp_name, e.manager_id, CONCAT(e.emp_name, ' -> ', mh.hierarchy_path)
    FROM employees e
    JOIN ManagementHierarchy mh ON e.emp_id = mh.manager_id
)

-- Bonus Challenge

-- [Data Integrity] Write a query to find "Orphan Records" in the employees table—employees whose manager_id does not 
-- exist in the emp_id column (excluding the CEO who has a NULL manager).
SELECT *
FROM employees
WHERE manager_id IS NOT NULL AND manager_id NOT IN (SELECT emp_id FROM employees);