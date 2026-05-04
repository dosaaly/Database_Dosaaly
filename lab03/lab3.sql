DROP TABLE IF EXISTS students; --[cite: 220]

CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INT
); --[cite: 210-213]

INSERT INTO students (name, age) 
VALUES ('Alice', 21), 
('Bob', 23); --[cite: 216]


SELECT * FROM students; --[cite: 218]