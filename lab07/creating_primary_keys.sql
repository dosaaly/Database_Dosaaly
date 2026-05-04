-- Creating primary keys
-- 1: Column-level Constraint
CREATE TABLE students (
    student_id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(150)
);

-- 2: Table-level Constraint
CREATE TABLE students (
    student_id INTEGER,
    name VARCHAR(100),
    email VARCHAR(150),
    PRIMARY KEY (student_id)
);

-- 3: Named Constraint
CREATE TABLE students (
    student_id INTEGER,
    name VARCHAR(100),
    email VARCHAR(150),
    CONSTRAINT pk_students PRIMARY KEY (student_id)
);

-- Adding Primary Key to Existing Table
ALTER TABLE students ADD CONSTRAINT pk_students PRIMARY KEY (student_id);
