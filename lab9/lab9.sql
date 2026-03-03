DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS book_authors;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS authors;
DROP TABLE IF EXISTS members;

CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    nationality VARCHAR(50)
);

CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    isbn VARCHAR(13) UNIQUE,
    available_copies INTEGER DEFAULT 1
);

CREATE TABLE book_authors (
    book_id INTEGER REFERENCES books(book_id),
    author_id INTEGER REFERENCES authors(author_id),
    PRIMARY KEY (book_id, author_id)
);

-- Inserting updated authors
INSERT INTO authors (first_name, last_name, nationality) VALUES 
('Chinghiz', 'Aitmatov', 'Kyrgyz'),
('Mukhtar', 'Auezov', 'Kazakh');

-- Inserting iconic books
INSERT INTO books (title, isbn) VALUES 
('The Day Lasts More Than a Hundred Years', '9780253204820'),
('Abai Zholy', '9786017321000');

-- Linking books to authors
INSERT INTO book_authors (book_id, author_id) VALUES 
(1, 1), 
(2, 2);

-- Verification
SELECT b.title, a.first_name, a.last_name 
FROM books b
JOIN book_authors ba ON b.book_id = ba.book_id
JOIN authors a ON ba.author_id = a.author_id;