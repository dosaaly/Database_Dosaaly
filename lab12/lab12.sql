DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  department VARCHAR(50) NOT NULL,
  salary INT NOT NULL,
  email VARCHAR(150),
  manager_id INT
);

CREATE TABLE sales (
  id SERIAL PRIMARY KEY,
  employee_id INT NOT NULL,
  amount NUMERIC(10,2) NOT NULL,
  sale_date DATE NOT NULL,
  FOREIGN KEY (employee_id) REFERENCES employees(id)
);

INSERT INTO employees (name, department, salary, email, manager_id)
VALUES
('Brad Smith', 'Engineering', 120000, 'brad.smith@gmail.com', NULL),
('Alice Johnson', 'Sales', 75000, 'alice.johnson@yahoo.com', 1),
('Bob Anderson', 'Marketing', 68000, 'bob.anderson@gmail.com', 1),
('Brian Watson', 'Finance', 90000, 'brian.watson@company.com', 1),
('Amanda Lee', 'Engineering', 60000, 'amanda.lee@company.com', 1);

INSERT INTO sales (employee_id, amount, sale_date)
VALUES
(2, 1500, '2025-03-10'),
(2, 2500, '2025-05-20'),
(3, 600, '2025-06-15'),
(4, 3000, '2025-02-01');

SELECT *
FROM employees;

SELECT
  name,
  salary,
  salary * 0.10 AS bonus_estimate,
  salary + (salary * 0.10) AS salary_with_bonus
FROM employees;

SELECT
  name,
  department,
  salary
FROM employees
WHERE salary >= 75000;

SELECT
  name,
  department,
  salary
FROM employees
WHERE salary > 75000
  AND department = 'Engineering';

SELECT
  name,
  department,
  salary
FROM employees
WHERE department = 'Sales'
   OR department = 'Marketing';

SELECT
  name,
  department,
  salary
FROM employees
WHERE NOT department = 'HR';

SELECT
  name,
  salary
FROM employees
WHERE salary BETWEEN 60000 AND 100000;

SELECT
  name,
  manager_id
FROM employees
WHERE manager_id IS NULL;

SELECT
  name,
  manager_id
FROM employees
WHERE manager_id IS NOT NULL;

SELECT
  name
FROM employees
WHERE name LIKE 'Bra%';

SELECT
  name,
  email
FROM employees
WHERE email ILIKE '%@gmail.com';

SELECT
  name
FROM employees
WHERE name LIKE '%son';

SELECT
  name
FROM employees
WHERE name ~ '^[AB]';

SELECT
  name,
  email
FROM employees
WHERE email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$';

SELECT
  name
FROM employees
WHERE name !~ '[0-9]';

SELECT
  name,
  department
FROM employees
WHERE department IN ('Engineering', 'Sales', 'Finance');

SELECT
  name
FROM employees
WHERE id IN (
  SELECT employee_id
  FROM sales
  WHERE amount > 1000
);

SELECT
  e.name,
  e.department
FROM employees e
WHERE EXISTS (
  SELECT 1
  FROM sales s
  WHERE s.employee_id = e.id
    AND s.amount > 2000
);

SELECT
  name,
  salary,
  CASE
    WHEN salary > 100000 THEN 'Senior'
    WHEN salary BETWEEN 60000 AND 100000 THEN 'Mid-Level'
    ELSE 'Junior'
  END AS employee_level
FROM employees;

WITH department_avg AS (
  SELECT
    department,
    AVG(salary) AS avg_salary
  FROM employees
  GROUP BY department
)
SELECT
  e.name,
  e.department,
  e.salary,
  d.avg_salary
FROM employees e
JOIN department_avg d
  ON e.department = d.department
WHERE e.salary > d.avg_salary;

WITH high_sales_employees AS (
  SELECT
    employee_id,
    SUM(amount) AS total_sales
  FROM sales
  WHERE sale_date BETWEEN '2025-01-01' AND '2025-12-31'
  GROUP BY employee_id
),
department_avg_salary AS (
  SELECT
    department,
    AVG(salary) AS avg_salary
  FROM employees
  GROUP BY department
)
SELECT
  e.name,
  e.department,
  e.salary,
  hs.total_sales,
  da.avg_salary,
  CASE
    WHEN hs.total_sales >= 10000 THEN 'Top Seller'
    WHEN hs.total_sales BETWEEN 5000 AND 9999 THEN 'Strong Seller'
    WHEN hs.total_sales IS NULL THEN 'No Sales'
    ELSE 'Low Seller'
  END AS sales_rank,
  CASE
    WHEN e.salary > da.avg_salary THEN 'Above Dept Avg'
    ELSE 'Below Dept Avg'
  END AS salary_status
FROM employees e
LEFT JOIN high_sales_employees hs
  ON e.id = hs.employee_id
JOIN department_avg_salary da
  ON e.department = da.department
WHERE
  (e.salary >= 50000 AND e.salary <= 150000)
  AND NOT e.department = 'HR'
  AND e.name LIKE '%a%'
  AND e.email ILIKE '%@%'
  AND e.email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$'
  AND e.department IN ('Engineering', 'Sales', 'Marketing')
  AND EXISTS (
    SELECT 1
    FROM sales s
    WHERE s.employee_id = e.id
      AND s.amount > 500
  )
ORDER BY e.department, e.salary DESC;