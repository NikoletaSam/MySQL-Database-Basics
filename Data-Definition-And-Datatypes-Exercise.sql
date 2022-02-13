-- EX 1 --------------------------------------------
SELECT * FROM departments ORDER BY department_id;

-- EX 2 --------------------------------------------
SELECT  `name` FROM  departments ORDER BY  department_id;

-- EX 3 ----------------------------------------------
SELECT first_name, last_name, salary FROM employees ORDER BY employee_id;

-- EX 4 -----------------------------------------------
SELECT first_name, middle_name, last_name FROM employees ORDER BY employee_id;

-- EX 5 -----------------------------------------------
SELECT concat(`first_name`, '.', `last_name`, '@softuni.bg') AS `full_email_address` FROM employees;

-- EX 6 -----------------------------------------------
SELECT DISTINCT salary FROM employees;

-- EX 7 -----------------------------------------------
SELECT * FROM employees WHERE job_title = 'Sales Representative' ORDER BY employee_id;

-- EX 8 -----------------------------------------------
SELECT first_name, last_name, job_title FROM employees WHERE salary BETWEEN 20000 AND 30000 ORDER BY employee_id;

-- EX 9 -----------------------------------------------
SELECT concat_ws(' ', first_name, middle_name, last_name) AS `Full Name` FROM employees WHERE salary IN (25000, 14000, 12500, 23600);

-- EX 10 -----------------------------------------------
SELECT first_name, last_name FROM employees WHERE manager_id IS NULL;

-- EX 11 -----------------------------------------------
SELECT first_name, last_name, salary FROM employees WHERE salary > 50000 ORDER BY salary DESC;

-- EX 12 -----------------------------------------------
SELECT first_name, last_name FROM employees ORDER BY salary DESC LIMIT 5;

-- EX 13 -----------------------------------------------
SELECT first_name, last_name FROM employees WHERE department_id != 4;

-- EX 14 -----------------------------------------------
SELECT * FROM employees ORDER BY salary DESC, first_name ASC, last_name DESC, middle_name ASC;

-- EX 15 -----------------------------------------------
CREATE VIEW `v_employees_salaries` AS 
SELECT first_name, last_name, salary FROM employees;

-- EX 16 -----------------------------------------------
CREATE VIEW `v_employees_job_titles` AS
SELECT concat_ws(' ', first_name, middle_name, last_name) AS `full_name`, job_title FROM employees;

-- EX 17 -----------------------------------------------
SELECT DISTINCT job_title FROM employees ORDER BY job_title;

-- EX 18 -----------------------------------------------
SELECT * FROM projects ORDER BY start_date, `name`, project_id LIMIT 10;

-- EX 19 -----------------------------------------------
SELECT first_name, last_name, hire_date FROM employees ORDER BY hire_date DESC LIMIT 7;

-- EX 20 -----------------------------------------------
UPDATE employees
SET salary = salary + salary * 0.12
WHERE department_id IN (1, 2, 4, 11);
SELECT salary FROM employees;

-- EX 21 -----------------------------------------------
SELECT peak_name FROM peaks ORDER BY peak_name;

-- EX 22 -----------------------------------------------
SELECT country_name, population FROM countries WHERE continent_code = 'EU' ORDER BY population DESC, country_name ASC LIMIT 30;

-- EX 23 -----------------------------------------------
SELECT country_name, country_code, IF(currency_code = 'EUR', 'Euro', 'Not Euro') AS `currency` FROM countries ORDER BY country_name;

-- EX 24 -----------------------------------------------
USE diablo;
SELECT `name` FROM characters ORDER BY `name`;