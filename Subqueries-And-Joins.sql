-- EX 1
SELECT e.employee_id, concat_ws(' ', first_name, last_name) AS `full_name`, d.department_id, d.`name` AS `departmen_name`
FROM employees AS e
JOIN departments AS d ON e.employee_id = d.manager_id
ORDER BY employee_id LIMIT 5;

-- EX 2
SELECT t.town_id, t.`name` AS `town_name`, a.address_text
FROM towns AS t
JOIN addresses AS a ON t.town_id = a.town_id
WHERE t.town_id IN (9, 15, 32)
ORDER BY t.town_id, a.address_id;

-- EX 3
SELECT employee_id, first_name, last_name, department_id, salary
FROM employees
WHERE manager_id IS NULL;

-- EX 4
SELECT count(*) AS `count`
FROM employees
WHERE salary > (SELECT avg(salary) FROM employees);