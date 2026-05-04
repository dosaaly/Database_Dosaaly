CREATE TABLE accounts (
    account_id INTEGER PRIMARY KEY,
    balance    DECIMAL(10,2)
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name        VARCHAR(100),
    email       VARCHAR(100)
);

CREATE TABLE orders (
    order_id    SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    total       DECIMAL(10,2)
);

CREATE TABLE order_items (
    item_id    SERIAL PRIMARY KEY,
    order_id   INTEGER REFERENCES orders(order_id),
    product_id INTEGER,
    quantity   INTEGER
);

CREATE TABLE inventory (
    product_id INTEGER PRIMARY KEY,
    stock      INTEGER
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name       VARCHAR(100),
    price      DECIMAL(10,2)
);

CREATE TABLE logs (
    log_id    SERIAL PRIMARY KEY,
    message   VARCHAR(255)
);

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name    VARCHAR(100),
    email   VARCHAR(100)
);

CREATE TABLE user_preferences (
    pref_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    theme   VARCHAR(50)
);

CREATE TABLE audit_log (
    log_id    SERIAL PRIMARY KEY,
    action    VARCHAR(100),
    timestamp TIMESTAMP
);


BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
COMMIT;


BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
ROLLBACK;


BEGIN;
SELECT balance FROM accounts WHERE account_id = 1;
UPDATE accounts SET balance = balance - 500 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 500 WHERE account_id = 2;
COMMIT;


BEGIN;
INSERT INTO orders (customer_id, total) VALUES (1, 250.00);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (1, 101, 2);
UPDATE inventory SET stock = stock - 2 WHERE product_id = 101;
COMMIT;


BEGIN;
INSERT INTO customers (name, email) VALUES ('John Doe', 'john@email.com');
INSERT INTO orders (customer_id, total) VALUES (LASTVAL(), 100.00);
COMMIT;


BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM accounts;
COMMIT;


BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM accounts WHERE balance > 1000;
SELECT * FROM accounts WHERE balance > 1000;
COMMIT;


BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM accounts WHERE balance > 1000;
SELECT * FROM accounts WHERE balance > 1000;
COMMIT;


BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM accounts;
UPDATE accounts SET balance = balance * 1.05;
COMMIT;


SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;


BEGIN;
INSERT INTO customers (name, email) VALUES ('Alice', 'alice@email.com');
SAVEPOINT after_customer_insert;
INSERT INTO orders (customer_id, total) VALUES (1, 500.00);
ROLLBACK TO SAVEPOINT after_customer_insert;
INSERT INTO orders (customer_id, total) VALUES (1, 300.00);
COMMIT;


BEGIN;
INSERT INTO products (name, price) VALUES ('Laptop', 999.99);
SAVEPOINT sp1;
INSERT INTO products (name, price) VALUES ('Mouse', 25.99);
SAVEPOINT sp2;
INSERT INTO products (name, price) VALUES ('Invalid Product', -50.00);
ROLLBACK TO SAVEPOINT sp2;
INSERT INTO products (name, price) VALUES ('Keyboard', 79.99);
COMMIT;


BEGIN;
INSERT INTO logs (message) VALUES ('Starting process');
SAVEPOINT process_start;
INSERT INTO logs (message) VALUES ('Process completed');
RELEASE SAVEPOINT process_start;
COMMIT;


BEGIN;
UPDATE inventory SET stock = stock - 1 WHERE product_id = 101;
INSERT INTO order_items (order_id, product_id, quantity) VALUES (1, 101, 1);
COMMIT;


BEGIN;
DO $$
DECLARE
    insufficient_funds EXCEPTION;
    current_balance    DECIMAL;
BEGIN
    SELECT balance INTO current_balance FROM accounts WHERE account_id = 1;
    IF current_balance < 100 THEN
        RAISE insufficient_funds;
    END IF;
    UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
    UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
EXCEPTION
    WHEN insufficient_funds THEN
        RAISE NOTICE 'Transaction failed: Insufficient funds';
        ROLLBACK;
END $$;


BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
COMMIT;


BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
COMMIT;


BEGIN;
INSERT INTO orders (customer_id, total) VALUES (1, 1000.00);
SAVEPOINT before_items;
INSERT INTO order_items (order_id, product_id, quantity) VALUES (currval('orders_order_id_seq'), 101, 2);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (currval('orders_order_id_seq'), 102, 1);
COMMIT;


SELECT
    blocked_locks.pid         AS blocked_pid,
    blocked_activity.usename  AS blocked_user,
    blocking_locks.pid        AS blocking_pid,
    blocking_activity.usename AS blocking_user,
    blocked_activity.query    AS blocked_statement
FROM pg_catalog.pg_locks blocked_locks
JOIN pg_catalog.pg_stat_activity blocked_activity
    ON blocked_activity.pid = blocked_locks.pid
JOIN pg_catalog.pg_locks blocking_locks
    ON blocking_locks.locktype = blocked_locks.locktype
WHERE NOT blocked_locks.granted;


BEGIN;
INSERT INTO audit_log (action, timestamp) VALUES ('user_creation', NOW());
INSERT INTO users (name, email) VALUES ('John Doe', 'john@example.com');
INSERT INTO user_preferences (user_id, theme) VALUES (currval('users_user_id_seq'), 'dark');
COMMIT;