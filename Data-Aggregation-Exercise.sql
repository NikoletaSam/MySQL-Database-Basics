-- EX 1
SELECT count(*) AS `count` FROM wizzard_deposits;

-- EX 2
SELECT max(magic_wand_size) AS `longest_magic_wand` FROM wizzard_deposits;

-- EX 3
SELECT deposit_group, max(magic_wand_size) AS `longest_magic_wand`
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY `longest_magic_wand`, deposit_group;

-- EX 4
SELECT deposit_group
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY min(magic_wand_size)
LIMIT 1;

-- EX 5
SELECT deposit_group, SUM(deposit_amount) AS `total_sum`
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY `total_sum`;

-- EX 6
SELECT deposit_group, SUM(deposit_amount) AS `total_sum`
FROM wizzard_deposits
WHERE `magic_wand_creator` = 'Ollivander family'
GROUP BY deposit_group
ORDER BY deposit_group;

-- EX 7
SELECT deposit_group, SUM(deposit_amount) AS `total_sum`
FROM wizzard_deposits
WHERE `magic_wand_creator` = 'Ollivander family'
GROUP BY deposit_group
HAVING `total_sum` < 150000
ORDER BY total_sum DESC;

-- EX 8
SELECT deposit_group, magic_wand_creator, min(deposit_charge) AS `min_deposit_charge`
FROM wizzard_deposits
GROUP BY deposit_group, magic_wand_creator
ORDER BY magic_wand_creator, deposit_group;

-- EX 9
SELECT
 CASE
 WHEN age <= 10 THEN '[0-10]'
 WHEN age BETWEEN 11 AND 20 THEN '[11-20]'
 WHEN age BETWEEN 21 AND 30 THEN '[21-30]'
 WHEN age BETWEEN 31 AND 40 THEN '[31-40]'
 WHEN age BETWEEN 41 AND 50 THEN '[41-50]'
 WHEN age BETWEEN 51 AND 60 THEN '[51-60]'
 ELSE '[61+]'
 END AS `age_group`, COUNT(*) AS `wizard_count`
 FROM wizzard_deposits
 GROUP BY `age_group`
 ORDER BY wizard_count;
 
 -- EX 10
 SELECT left(first_name, 1) AS `first_letter`
 FROM wizzard_deposits
 WHERE `deposit_group` = 'Troll Chest'
 GROUP BY first_letter
 ORDER BY first_letter;
 
 -- EX 11
 SELECT deposit_group, is_deposit_expired, AVG(deposit_interest) AS `average_interest`
 FROM wizzard_deposits
 WHERE `deposit_start_date` > '1985-01-01'
 GROUP BY deposit_group, is_deposit_expired
 ORDER BY deposit_group DESC, is_deposit_expired ASC;
 
 -- EX 12
 SELECT department_id, min(salary) AS `minimum_salary`
 FROM employees
WHERE date(`hire_date`) > '2000-01-01'
GROUP BY department_id 
HAVING department_id IN (2, 5, 7)
ORDER BY department_id ASC;

-- EX 13
CREATE TABLE `v_employees` AS 
SELECT department_id, salary
FROM employees
WHERE salary > 30000 AND manager_id != 42;
UPDATE `v_employees`
set salary = salary + 5000 
where department_id = 1;
SELECT department_id, AVG(salary) AS `avg_salary`
FROM v_employees
GROUP BY department_id
ORDER BY department_id;

-- EX 14
SELECT department_id, max(salary) AS `max_salary`
FROM employees
GROUP BY department_id
HAVING `max_salary` NOT BETWEEN 30000 AND 70000
ORDER BY department_id;

-- EX 15
SELECT count(*) FROM employees
WHERE manager_id IS NULL;

-- EX 18
SELECT department_id, sum(salary) AS `total_salary`
FROM employees
GROUP BY department_id
ORDER BY department_id;
