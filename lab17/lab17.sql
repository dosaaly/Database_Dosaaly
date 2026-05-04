CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name  VARCHAR(100),
    last_name   VARCHAR(100),
    email       VARCHAR(100),
    department  VARCHAR(100)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name       VARCHAR(100),
    price      DECIMAL(10,2)
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name        VARCHAR(100),
    email       VARCHAR(100)
);

CREATE TABLE orders (
    order_id   SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date  DATE,
    total       DECIMAL(10,2)
);

CREATE TABLE customer_feedback (
    feedback_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    message     TEXT
);

CREATE TABLE sales_data (
    sale_id    SERIAL PRIMARY KEY,
    product_id INTEGER,
    amount     DECIMAL(10,2)
);

CREATE TABLE staging_customers AS SELECT * FROM customers WHERE 1=0;

CREATE TABLE target_customers (
    customer_id SERIAL PRIMARY KEY,
    name        VARCHAR(100),
    email       VARCHAR(100)
);

CREATE TABLE large_table (
    id         SERIAL,
    created_at DATE,
    data       TEXT
) PARTITION BY RANGE (created_at);

CREATE TABLE large_table_2023 PARTITION OF large_table
FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');


COPY employees TO '/tmp/employees.csv' WITH CSV HEADER;

COPY employees FROM '/tmp/employees.csv' WITH CSV HEADER;

COPY employees TO '/tmp/employees.txt'
WITH DELIMITER '|' NULL 'N/A' CSV HEADER;

COPY employees(first_name, last_name, email)
FROM '/tmp/new_employees.csv' WITH CSV HEADER;

COPY (SELECT * FROM employees WHERE department = 'IT')
TO '/tmp/it_employees.csv' WITH CSV HEADER;


COPY products TO '/tmp/products.csv' WITH CSV HEADER;

COPY customers TO '/tmp/customers.csv'
WITH CSV HEADER DELIMITER ';' QUOTE '"';

COPY orders TO '/tmp/orders.csv'
WITH CSV HEADER FORCE_QUOTE (order_date);

COPY products FROM '/tmp/products.csv' WITH CSV HEADER;

COPY products FROM '/tmp/products_with_errors.csv'
WITH CSV HEADER ON_ERROR IGNORE;

COPY products FROM '/tmp/products_utf8.csv'
WITH CSV HEADER ENCODING 'UTF8';

COPY customer_feedback TO '/tmp/feedback.csv'
WITH CSV HEADER DELIMITER ',' QUOTE '"' ESCAPE '"';

COPY sales_data FROM '/tmp/sales.csv'
WITH CSV HEADER NULL 'NULL';


SELECT pg_create_restore_point('before_data_migration');

SELECT pid, usename, application_name, client_addr, state
FROM pg_stat_activity
WHERE application_name = 'pg_dump';

SELECT COUNT(*) FROM staging_customers;

SELECT COUNT(*) FROM target_customers;


COPY (SELECT * FROM customers LIMIT 10000 OFFSET 0)
TO '/tmp/customers_batch_1.csv' WITH CSV HEADER;

COPY staging_customers FROM '/tmp/customers_batch_1.csv' WITH CSV HEADER;

INSERT INTO target_customers
SELECT * FROM staging_customers
ON CONFLICT (customer_id) DO UPDATE SET
    name  = EXCLUDED.name,
    email = EXCLUDED.email;


CREATE PUBLICATION migration_pub FOR ALL TABLES;

CREATE SUBSCRIPTION migration_sub
CONNECTION 'host=source_host dbname=source_db user=replication_user'
PUBLICATION migration_pub;