-- EX 1
SELECT first_name, last_name FROM employees
WHERE lower(substring(first_name, 1, 2)) = 'sa';

-- EX 2
SELECT first_name, last_name FROM employees
WHERE last_name
LIKE '%ei%';

-- EX 3
SELECT first_name FROM employees
WHERE (department_id = 3 OR department_id = 10)
AND (YEAR(hire_date) BETWEEN 1995 AND 2005)
ORDER BY employee_id;

-- EX 4
SELECT first_name, last_name FROM employees
WHERE job_title NOT LIKE '%engineer%'
ORDER BY employee_id;

-- EX 5
SELECT `name` FROM towns
WHERE char_length(`name`) = 5 OR char_length(`name`) = 6
ORDER BY `name` ASC;

-- EX 6
SELECT * FROM towns
WHERE `name` REGEXP '^[MKBEmkbe][a-z]*'
ORDER BY `name` ASC;

-- EX 7
SELECT * FROM towns
WHERE `name` REGEXP '^[^RDBrdb][a-z]*'
ORDER BY `name` ASC;

-- EX 8
CREATE VIEW `v_employees_hired_after_2000` AS
SELECT first_name, last_name FROM employees
WHERE year(hire_date) > 2000;
SELECT * FROM v_employees_hired_after_2000;

-- EX 9
SELECT first_name, last_name FROM employees
WHERE char_length(last_name) = 5;

-- EX 10
SELECT country_name, iso_code FROM countries
WHERE lower(country_name) LIKE '%a%a%a%'
ORDER BY iso_code;

-- EX 11
SELECT p.peak_name, r.river_name, lower(concat(p.peak_name, substring(r.river_name, 2))) AS `mix`
FROM peaks AS p, rivers AS r
WHERE lower(right(p.peak_name, 1)) = lower(left(r.river_name, 1))
ORDER BY mix ASC;

-- EX 12
SELECT `name`, date_format(`start`, '%Y-%m-%d') AS `start` FROM games
WHERE year(`start`) = 2011 OR year(`start`) = 2012
ORDER BY `start` LIMIT 50;

-- EX 13
SELECT user_name, substring(email, locate('@', email) + 1) AS `email provider`
FROM users
ORDER BY `email provider`, `user_name`;

-- EX 14
SELECT user_name, ip_address FROM users
WHERE ip_address LIKE '___.1%.%.___'
ORDER BY user_name;

-- EX 15
SELECT `name` AS `game`, 
CASE 
 WHEN HOUR(`start`) BETWEEN 0 AND 11 THEN 'Morning'
 WHEN hour(`start`) BETWEEN 12 AND 17 THEN 'Afternoon'
 ELSE 'Evening'
 END AS `Part of the Day`,
CASE 
 WHEN `duration` BETWEEN 0 and 3 then 'Extra Short'
 WHEN `duration` BETWEEN 4 and 6 then 'Short'
 WHEN `duration` BETWEEN 7 and 10 then 'Long'
 ELSE 'Extra Long'
 END AS `Duration`
FROM games;
 
 -- EX 16
 SELECT product_name, 
 order_date, 
 adddate(order_date, INTERVAL 3 DAY) AS `pay_due`, 
 adddate(order_date, INTERVAL 1 MONTH) AS `deliver_due`
 FROM orders;