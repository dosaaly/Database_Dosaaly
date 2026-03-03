-- UNIQUE:
CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name VARCHAR(100)
);

INSERT INTO departments VALUES (1, 'Computer Science');
INSERT INTO departments VALUES (1, 'Mathematics'); -- This will fail due to duplicate primary key

-- NOT NULL:
-- This will fail because primary key cannot be NULL
INSERT INTO departments VALUES (NULL, 'Physics');