DROP TABLE IF EXISTS students;

CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    faculty VARCHAR(50),
    email VARCHAR(100)
);

INSERT INTO students (name, age, faculty, email) VALUES 
('Alymbek', 21, 'COM-25', 'alymbek@example.com'),
('Timur', 23, 'MED', 'timur@example.com'),
('Beka', 22, 'MAT', 'beka@example.com'),
('Alice', 21, 'Engineering', 'alice@example.com');

SELECT * FROM students;

SELECT name, email FROM students;

SELECT name, email FROM students WHERE name = 'Timur';

SELECT name, email FROM students ORDER BY name;

SELECT name, email FROM students LIMIT 2;