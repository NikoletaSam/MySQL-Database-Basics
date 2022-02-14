-- EX 1 ----------------------------------
SELECT title FROM books
WHERE title LIKE 'The%' ORDER BY id;

-- EX 2 ----------------------------------
SELECT replace(title, 'The', '***') AS `title` FROM books WHERE title LIKE 'The%' ORDER BY id;

-- EX 3 ----------------------------------
SELECT sum(cost) AS cost FROM books;

-- EX 4 ----------------------------------
SELECT concat_ws(' ', first_name, last_name) AS `Full Name`, datediff(died, born) AS `Days Lived` FROM authors;

-- EX 5 ----------------------------------
SELECT title FROM books WHERE title LIKE 'Harry Potter%' ORDER BY id;