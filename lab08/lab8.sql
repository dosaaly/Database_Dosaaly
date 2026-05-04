DROP TABLE IF EXISTS student_enrollments;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS courses;

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INTEGER
);

CREATE TABLE student_enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(student_id),
    course_id INTEGER REFERENCES courses(course_id),
    grade VARCHAR(2),
    enrollment_date DATE DEFAULT CURRENT_DATE
);

INSERT INTO students (first_name, last_name, email) VALUES
('Alice', 'Johnson', 'alice@university.edu'),
('Bob', 'Smith', 'bob@university.edu');

INSERT INTO courses (course_code, course_name, credits) VALUES
('CS101', 'Intro to Programming', 3),
('CS201', 'Data Structures', 4);

INSERT INTO student_enrollments (student_id, course_id, grade) VALUES
(1, 1, 'A'),
(1, 2, 'B+'),
(2, 1, 'A-');

SELECT 
    s.first_name || ' ' || s.last_name AS student_name,
    c.course_code,
    c.course_name,
    se.grade
FROM students s
JOIN student_enrollments se ON s.student_id = se.student_id
JOIN courses c ON se.course_id = c.course_id
ORDER BY s.last_name, c.course_code;