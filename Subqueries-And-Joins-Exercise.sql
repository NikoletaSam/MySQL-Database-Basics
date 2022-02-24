-- EX 1 --------------------------------------------------------
SELECT 
	e.employee_id,
    e.job_title,
    e.address_id,
    a.address_text
FROM employees AS e
JOIN addresses AS a ON e.address_id = a.address_id
ORDER BY address_id ASC
LIMIT 5;

-- EX 2 -----------------------------------------------------------
SELECT 
	e.first_name,
    e.last_name,
    t.name,
    a.address_text
FROM employees AS e
JOIN addresses AS a ON e.address_id = a.address_id
JOIN towns AS t ON a.town_id = t.town_id
ORDER BY e.first_name, e.last_name
LIMIT 5;

-- EX 3 -------------------------------------------------------------
SELECT 
	e.employee_id,
    e.first_name,
    e.last_name,
    d.name
FROM employees AS e
JOIN departments AS d ON e.department_id = d.department_id
WHERE d.name = 'Sales'
ORDER BY e.employee_id DESC;

-- EX 4 ----------------------------------------------------------------
SELECT 
	e.employee_id,
    e.first_name,
    e.salary,
    d.name AS `department_name`
FROM employees AS e
JOIN departments AS d ON e.department_id = d.department_id
WHERE e.salary > 15000
ORDER BY d.department_id DESC
LIMIT 5;

-- EX 5 ------------------------------------------------------------------
SELECT 
	e.employee_id,
    e.first_name
FROM employees AS e
WHERE e.employee_id NOT IN (SELECT ep.employee_id FROM employees_projects AS ep)
ORDER BY e.employee_id DESC
LIMIT 3;

-- EX 6 ------------------------------------------------------------------
SELECT 
	e.first_name,
    e.last_name,
    e.hire_date,
    d.name AS `dept_name`
FROM employees AS e
JOIN departments AS d ON e.department_id = d.department_id
WHERE DATE(e.hire_date) > '1999-01-01'
	AND d.name IN ('Sales', 'Finance')
ORDER BY e.hire_date;

-- EX 7 ------------------------------------------------------------------
SELECT 
	e.employee_id,
    e.first_name,
    p.name As `project_name`
FROM employees AS e
JOIN employees_projects AS ep ON e.employee_id = ep.employee_id
JOIN projects AS p ON ep.project_id = p.project_id
WHERE DATE(p.start_date) > '2002-08-13'
	AND p.end_date IS NULL
ORDER BY e.first_name, p.name
LIMIT 5;

-- EX 8 ------------------------------------------------------------------
SELECT 
	e.employee_id,
    e.first_name,
    if(year(p.start_date) >= 2005, NULL, p.name) As `project_name`
FROM employees AS e
JOIN employees_projects AS ep ON e.employee_id = ep.employee_id
JOIN projects AS p ON ep.project_id = p.project_id
WHERE ep.employee_id = 24
ORDER BY p.name;

-- EX 9 -----------------------------------------------------------------
SELECT 
	e.employee_id,
    e.first_name,
    e.manager_id,
    m.first_name
FROM employees AS e
JOIN employees AS m ON e.manager_id = m.employee_id
WHERE e.manager_id IN (3, 7)
ORDER BY e.first_name;

-- EX 10 ---------------------------------------------------------------
SELECT 
	e.employee_id,
    concat_ws(' ', e.first_name, e.last_name) AS `employee_name`,
    concat_ws(' ', m.first_name, m.last_name) AS `manager_name`,
    d.name AS `department_name`
FROM employees AS e
JOIN employees AS m ON e.manager_id = m.employee_id
JOIN departments AS d ON e.department_id = d.department_id
ORDER BY e.employee_id
LIMIT 5;

-- EX 11 --------------------------------------------------------------
SELECT min(`avg`) AS `min_average_salary`
FROM (
	SELECT avg(salary) as `avg`
	FROM employees
	GROUP BY department_id
) AS `average_salary`;

-- EX 12 -------------------------------------------------------------
SELECT 
	mc.country_code,
    m.mountain_range,
    p.peak_name,
    p.elevation
FROM mountains_countries AS mc
JOIN mountains AS m ON mc.mountain_id = m.id
JOIN peaks AS p ON m.id = p.mountain_id
WHERE mc.country_code = 'BG'
	AND p.elevation > 2835
ORDER BY p.elevation DESC;

-- EX 13 -------------------------------------------------------------
SELECT 
	mc.country_code,
    count(m.mountain_range) AS `mountain_range`
FROM mountains_countries AS mc
JOIN mountains AS m ON mc.mountain_id = m.id
GROUP BY mc.country_code
HAVING mc.country_code IN ('BG', 'RU', 'US')
ORDER BY `mountain_range` DESC;

-- EX 14 --------------------------------------------------------------
SELECT 
	c.country_name,
    r.river_name
FROM countries AS c
LEFT JOIN countries_rivers AS cr ON c.country_code = cr.country_code
LEFT JOIN rivers AS r ON cr.river_id = r.id
WHERE c.continent_code = 'AF'
ORDER BY c.country_name
LIMIT 5;

-- EX 15 ---------------------------------------------------------------
SELECT 
	c.continent_code,
    c.currency_code,
    count(*) AS `currency_usage`
FROM countries AS c
GROUP BY c.continent_code, c.currency_code
HAVING `currency_usage` = (
	SELECT count(currency_code) AS `count`
	FROM countries AS c2
	GROUP BY c2.continent_code, c2.currency_code
	HAVING c2.continent_code = c.continent_code
	ORDER BY `count` DESC
	LIMIT 1
)
	AND `currency_usage` > 1
ORDER BY continent_code, currency_code;

-- EX 16 -------------------------------------------------------------
SELECT count(*) AS `country_count`
FROM countries AS c
WHERE c.country_code NOT IN (SELECT mc.country_code FROM mountains_countries AS mc);

-- EX 17 -----------------------------------------------------------------
SELECT 
	c.country_name,
	max(p.elevation) AS `highest_peak_elevation`,
    max(r.length) AS `longest_river_length`
FROM countries AS c
LEFT JOIN mountains_countries AS mc ON c.country_code = mc.country_code
LEFT JOIN mountains AS m ON mc.mountain_id = m.id
LEFT JOIN peaks AS p ON m.id = p.mountain_id
LEFT JOIN countries_rivers AS cr ON c.country_code = cr.country_code
LEFT JOIN rivers AS r ON cr.river_id = r.id
GROUP BY c.country_code
ORDER BY `highest_peak_elevation` DESC, `longest_river_length` DESC, c.country_name
LIMIT 5;