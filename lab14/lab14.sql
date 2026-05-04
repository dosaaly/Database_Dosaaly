CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name        VARCHAR(100),
    email       VARCHAR(100)
);

CREATE TABLE orders (
    order_id      SERIAL PRIMARY KEY,
    customer_id   INTEGER REFERENCES customers(customer_id),
    order_date    DATE,
    total_amount  DECIMAL(10,2)
);

CREATE TABLE products (
    product_id   SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price        DECIMAL(10,2)
);

CREATE TABLE order_items (
    item_id    SERIAL PRIMARY KEY,
    order_id   INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity   INTEGER
);

CREATE TABLE users (
    user_id  SERIAL PRIMARY KEY,
    username VARCHAR(100)
);

CREATE TABLE user_profiles (
    profile_id SERIAL PRIMARY KEY,
    user_id    INTEGER REFERENCES users(user_id),
    first_name VARCHAR(100),
    last_name  VARCHAR(100),
    phone      VARCHAR(20)
);

CREATE TABLE authors (
    author_id   SERIAL PRIMARY KEY,
    author_name VARCHAR(100)
);

CREATE TABLE books (
    book_id          SERIAL PRIMARY KEY,
    author_id        INTEGER REFERENCES authors(author_id),
    title            VARCHAR(200),
    publication_year INTEGER
);

CREATE TABLE students (
    student_id   SERIAL PRIMARY KEY,
    student_name VARCHAR(100)
);

CREATE TABLE courses (
    course_id   SERIAL PRIMARY KEY,
    course_name VARCHAR(100)
);

CREATE TABLE enrollments (
    enrollment_id   SERIAL PRIMARY KEY,
    student_id      INTEGER REFERENCES students(student_id),
    course_id       INTEGER REFERENCES courses(course_id),
    enrollment_date DATE,
    grade           VARCHAR(5)
);

CREATE TABLE employees (
    employee_id INTEGER PRIMARY KEY,
    name        VARCHAR(100),
    manager_id  INTEGER REFERENCES employees(employee_id)
);

CREATE INDEX idx_orders_customer_id      ON orders(customer_id);
CREATE INDEX idx_order_items_order_id    ON order_items(order_id);
CREATE INDEX idx_order_items_product_id  ON order_items(product_id);


SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;


SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;


SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;


SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id;


SELECT c.name, p.product_name
FROM customers c
CROSS JOIN products p;


SELECT c.name, o.order_date, oi.quantity, p.product_name, p.price
FROM customers c
INNER JOIN orders o       ON c.customer_id  = o.customer_id
INNER JOIN order_items oi ON o.order_id     = oi.order_id
INNER JOIN products p     ON oi.product_id  = p.product_id;


SELECT e1.name AS employee, e2.name AS manager
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id;


SELECT c.name, o.order_date, o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= '2024-01-01'
AND o.total_amount > 100;


SELECT u.username, up.first_name, up.last_name, up.phone
FROM users u
LEFT JOIN user_profiles up ON u.user_id = up.user_id;


SELECT a.author_name, b.title, b.publication_year
FROM authors a
INNER JOIN books b ON a.author_id = b.author_id
ORDER BY a.author_name, b.publication_year;


SELECT s.student_name, c.course_name, e.enrollment_date, e.grade
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN courses c     ON e.course_id  = c.course_id
WHERE e.grade IS NOT NULL
ORDER BY s.student_name, c.course_name;


SELECT c.name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;


SELECT c.name, o.order_date
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;