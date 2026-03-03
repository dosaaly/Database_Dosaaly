DROP TABLE IF EXISTS students;

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    faculty VARCHAR(100),
    admission_date DATE DEFAULT CURRENT_DATE
);

INSERT INTO students (first_name, last_name, email, faculty) 
VALUES ('Sanzhar', 'Dosaaly', 'sanzhar@example.com', 'COM-25');

-- Altering table structure
ALTER TABLE students ADD COLUMN phone_number VARCHAR(15);

ALTER TABLE students ALTER COLUMN faculty SET NOT NULL;

ALTER TABLE students RENAME COLUMN email TO email_address;

-- Final check
SELECT * FROM students;