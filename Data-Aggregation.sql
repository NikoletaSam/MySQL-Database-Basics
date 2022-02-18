-- EX 1
SELECT department_id, count(id) AS `Number of employees`
FROM employees
GROUP BY department_id
ORDER BY department_id, `Number of employees`;

-- EX 2
SELECT department_id, round(avg(salary), 2) AS `Average Salary`
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- EX 3
SELECT department_id, round(MIN(salary), 2) AS `Min Salary`
FROM employees
GROUP BY department_id
HAVING `Min Salary` > 800;

-- EX 4
SELECT count(*) FROM products
WHERE category_id = 2 AND price > 8;

-- EX 5
SELECT category_id, round(avg(price), 2) AS `Average Price`,
 round(MIN(price), 2) AS `Cheapest Product`,
 round(MAX(price), 2) AS `Most Expensive Product`
FROM products
GROUP BY category_id;