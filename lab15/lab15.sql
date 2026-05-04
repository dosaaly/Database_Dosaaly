CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name  VARCHAR(100),
    last_name   VARCHAR(100),
    department  VARCHAR(100),
    salary      DECIMAL(10,2),
    tenure      INTEGER,
    manager_id  INTEGER REFERENCES employees(employee_id)
);

CREATE TABLE orders (
    order_id   SERIAL PRIMARY KEY,
    region_id  INTEGER,
    amount     DECIMAL(10,2),
    status     VARCHAR(50)
);

CREATE TABLE warehouse_1 (
    product_id   INTEGER PRIMARY KEY,
    product_name VARCHAR(100),
    quantity     INTEGER
);

CREATE TABLE warehouse_2 (
    product_id   INTEGER PRIMARY KEY,
    product_name VARCHAR(100),
    quantity     INTEGER
);

CREATE TABLE sales (
    sale_id      SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    year         INTEGER,
    sales_amount DECIMAL(10,2)
);

CREATE TABLE pivoted_sales (
    product_name VARCHAR(100),
    year_2022    DECIMAL(10,2),
    year_2023    DECIMAL(10,2),
    year_2024    DECIMAL(10,2)
);


SELECT first_name, last_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);


WITH regional_sales AS (
    SELECT region_id, SUM(amount) AS total_sales
    FROM orders
    GROUP BY region_id
)
SELECT region_id, total_sales
FROM regional_sales
WHERE total_sales > 1000000;


WITH RECURSIVE org_chart AS (
    SELECT employee_id, first_name, last_name, manager_id
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.employee_id, e.first_name, e.last_name, e.manager_id
    FROM employees e
    INNER JOIN org_chart oc ON e.manager_id = oc.employee_id
)
SELECT * FROM org_chart;


SELECT product_name FROM warehouse_1
UNION
SELECT product_name FROM warehouse_2;


SELECT product_name FROM warehouse_1
UNION ALL
SELECT product_name FROM warehouse_2;


SELECT product_id FROM warehouse_1 WHERE quantity = 0
INTERSECT
SELECT product_id FROM warehouse_2 WHERE quantity = 0;


SELECT product_id FROM warehouse_1
EXCEPT
SELECT product_id FROM warehouse_2;


SELECT
    first_name,
    last_name,
    department,
    salary,
    RANK()         OVER (PARTITION BY department ORDER BY salary DESC) AS dept_salary_rank,
    ROW_NUMBER()   OVER (PARTITION BY department ORDER BY salary DESC) AS row_num,
    DENSE_RANK()   OVER (PARTITION BY department ORDER BY salary DESC) AS dense_rank,
    SUM(salary)    OVER (PARTITION BY department)                      AS total_dept_salary,
    AVG(salary)    OVER (PARTITION BY department)                      AS avg_dept_salary,
    LAG(salary)    OVER (PARTITION BY department ORDER BY salary DESC) AS prev_salary,
    LEAD(salary)   OVER (PARTITION BY department ORDER BY salary DESC) AS next_salary
FROM employees;


SELECT
    product_name,
    SUM(CASE WHEN year = 2022 THEN sales_amount ELSE 0 END) AS year_2022,
    SUM(CASE WHEN year = 2023 THEN sales_amount ELSE 0 END) AS year_2023,
    SUM(CASE WHEN year = 2024 THEN sales_amount ELSE 0 END) AS year_2024
FROM sales
GROUP BY product_name;


SELECT product_name, '2022' AS year, year_2022 AS sales_amount FROM pivoted_sales
UNION ALL
SELECT product_name, '2023' AS year, year_2023 AS sales_amount FROM pivoted_sales
UNION ALL
SELECT product_name, '2024' AS year, year_2024 AS sales_amount FROM pivoted_sales
ORDER BY product_name, year;


SELECT
    employee_id,
    SUM(salary)    OVER (PARTITION BY department)                        AS total_dept_salary,
    AVG(salary)    FILTER (WHERE tenure > 5) OVER ()                    AS avg_salary_senior
FROM employees;


SELECT product_name, status
FROM orders
ORDER BY
    CASE status
        WHEN 'High Priority'   THEN 1
        WHEN 'Medium Priority' THEN 2
        WHEN 'Low Priority'    THEN 3
        ELSE 4
    END;


EXPLAIN
SELECT first_name, last_name, salary
FROM employees
WHERE salary > 50000;


EXPLAIN ANALYZE
SELECT first_name, last_name, salary
FROM employees
WHERE salary > 50000;


CREATE INDEX idx_employees_salary     ON employees(salary);
CREATE INDEX idx_employees_department ON employees(department);
CREATE INDEX idx_orders_region_id     ON orders(region_id);


SELECT first_name, last_name, department, salary
FROM employees
LIMIT 10;