-- EX 1 ---------------------------------------------------------------
CREATE TABLE pictures(
	id INT PRIMARY KEY AUTO_INCREMENT,
    url VARCHAR(100) NOT NULL,
    added_on DATETIME NOT NULL
);

CREATE TABLE categories(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE products(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    best_before DATE,
    price DECIMAL(10,2) NOT NULL,
    `description` TEXT,
    category_id INT NOT NULL,
    picture_id INT NOT NULL,
    CONSTRAINT fk_products_categories
    FOREIGN KEY (category_id)
    REFERENCES categories(id),
    CONSTRAINT fk_products_pictures
    FOREIGN KEY (picture_id)
    REFERENCES pictures(id)
);

CREATE TABLE towns(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE addresses(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    town_id INT NOT NULL,
    CONSTRAINT fk_addresses_towns
    FOREIGN KEY (town_id)
    REFERENCES towns(id)
);

CREATE TABLE stores(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL UNIQUE,
    rating FLOAT NOT NULL,
    has_parking TINYINT(1) DEFAULT FALSE,
    address_id INT NOT NULL,
    CONSTRAINT fk_stores_addresses
    FOREIGN KEY (address_id)
    REFERENCES addresses(id)
);

CREATE TABLE products_stores(
	product_id INT NOT NULL,
    store_id INT NOT NULL,
    CONSTRAINT fk_products_products
    FOREIGN KEY (product_id)
    REFERENCES products(id),
    CONSTRAINT fk_stores_stores
    FOREIGN KEY (store_id)
    REFERENCES stores(id),
    CONSTRAINT pk_produtcs_stores
    PRIMARY KEY (product_id, store_id)
);

CREATE TABLE employees(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(15) NOT NULL,
    middle_name CHAR(1),
    last_name VARCHAR(20) NOT NULL,
    salary DECIMAL(19,2) NOT NULL DEFAULT 0,
    hire_date DATE NOT NULL,
    manager_id INT,
    store_id INT NOT NULL,
    CONSTRAINT fk_employees_managers
    FOREIGN KEY (manager_id)
    REFERENCES employees(id),
    CONSTRAINT fk_emlpoyees_stores
    FOREIGN KEY (store_id)
    REFERENCES stores(id)
);

-- EX 2 -------------------------------------------------------------------------
INSERT INTO products_stores(product_id, store_id)
SELECT id, 1 FROM products WHERE id NOT IN (SELECT product_id FROM products_stores);

-- EX 3 --------------------------------------------------------------------------
ALTER TABLE employees
DROP CONSTRAINT fk_employees_managers;
UPDATE employees AS e
JOIN stores AS s ON e.store_id = s.id
SET manager_id = 3 AND salary = salary - 500
WHERE year(hire_date) > 2003 AND s.name NOT IN ('Cardguard', 'Veribet');

-- EX 4 -----------------------------------------------------------------------------
DELETE FROM employees
WHERE manager_id IS NOT NULL AND salary >= 6000;

-- EX 5 -----------------------------------------------------------------------------
SELECT first_name, middle_name, last_name, salary, hire_date
FROM employees
ORDER BY hire_date DESC;

-- EX 6 ------------------------------------------------------------------------------
SELECT pr.name,
	pr.price,
    pr.best_before,
    concat(substring(pr.`description`, 1, 10), '...') AS `short_description`,
    pic.url
FROM products AS pr
JOIN pictures AS pic ON pr.picture_id = pic.id
WHERE char_length(pr.`description`) > 100 AND (year(pic.added_on) < 2019) AND pr.price > 20
ORDER BY pr.price DESC;

-- EX 7 --------------------------------------------------------------------------------
SELECT 
	s.name,
    count(ps.product_id) AS `product_count`,
     round(avg(p.price), 2) AS `avg`
FROM stores AS s
LEFT JOIN products_stores AS ps ON s.id = ps.store_id
LEFT JOIN products AS p ON ps.product_id = p.id
GROUP BY s.id
ORDER BY product_count DESC, `avg` DESC, s.id;

-- EX 8 --------------------------------------------------------------------------------
SELECT 
	concat_ws(' ', e.first_name, e.last_name) AS `Full_name`,
    s.name AS `Store_name`,
    a.name AS `address`,
    e.salary
FROM employees AS e
JOIN stores AS s ON e.store_id = s.id
JOIN addresses AS a ON s.address_id = a.id
WHERE e.salary < 4000 AND a.name LIKE '%5%' AND char_length(s.name) > 8 AND e.last_name LIKE '%n';

-- EX 9 ------------------------------------------------------------------------------
SELECT 
	reverse(s.name) AS `reversed_name`,
    concat(upper(t.name),'-', a.name) AS `full_address`,
    count(e.id) AS `employees_count`
FROM stores AS s
JOIN addresses AS a ON s.address_id = a.id
JOIN towns AS t ON a.town_id = t.id
JOIN employees AS e ON e.store_id = s.id
GROUP BY s.id
HAVING employees_count >= 1
ORDER BY full_address;

-- EX 10 ----------------------------------------------------------------------------
DELIMITER $$
CREATE FUNCTION `udf_top_paid_employee_by_store` (store_name VARCHAR(50))
RETURNS VARCHAR(200)
DETERMINISTIC
BEGIN
RETURN 
	(SELECT 
	concat(e.first_name, ' ', e.middle_name, '. ', e.last_name, ' works in store for ', timestampdiff(year, e.hire_date, '2020-10-18'), ' years')
	FROM employees AS e
	JOIN stores AS s ON e.store_id = s.id
	WHERE s.name = store_name
	ORDER BY salary DESC
	LIMIT 1);
END;
$$
DELIMITER ;

-- EX 11 -------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `udp_update_product_price` (address_name VARCHAR (50))
BEGIN
	UPDATE products AS p
	JOIN products_stores AS ps ON p.id = ps.product_id
	JOIN stores AS s ON ps.store_id = s.id
	JOIN addresses AS a ON s.address_id = a.id
	SET p.price = if (substring(a.name, 1, 1) = '0', p.price + 100, p.price + 200)
	WHERE a.name = address_name;
END;
$$
DELIMITER ;