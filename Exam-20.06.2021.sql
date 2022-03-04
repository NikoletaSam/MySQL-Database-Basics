CREATE SCHEMA stc;

-- EX 1 --------------------------------------------------------
CREATE TABLE addresses(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE categories(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(10) NOT NULL
);

CREATE TABLE clients(
	id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE drivers(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    age INT NOT NULL,
    rating FLOAT DEFAULT 5.5
);

CREATE TABLE cars(
	id INT PRIMARY KEY AUTO_INCREMENT,
    make VARCHAR(20) NOT NULL,
    model VARCHAR(20),
    `year` INT NOT NULL DEFAULT 0,
    mileage INT DEFAULT 0,
    `condition` CHAR(1) NOT NULL,
    category_id INT NOT NULL,
    CONSTRAINT fk_cars_categories
    FOREIGN KEY (category_id)
    REFERENCES categories(id)
);

CREATE TABLE courses(
	id INT PRIMARY KEY AUTO_INCREMENT,
    from_address_id INT NOT NULL,
    `start` DATETIME NOT NULL,
    bill DECIMAL(10,2) DEFAULT 10,
    car_id INT NOT NULL,
    client_id INT NOT NULL,
    CONSTRAINT fk_courses_addresses
    FOREIGN KEY (from_address_id)
    REFERENCES addresses(id),
    CONSTRAINT fk_courses_cars
    FOREIGN KEY (car_id)
    REFERENCES cars(id),
    CONSTRAINT fk_courses_clients
    FOREIGN KEY (client_id)
    REFERENCES clients(id)
);

CREATE TABLE cars_drivers(
	car_id INT NOT NULL,
    driver_id INT NOT NULL,
    CONSTRAINT pk_cars_drivers
    PRIMARY KEY (car_id, driver_id),
    CONSTRAINT fk_cars
    FOREIGN KEY (car_id)
    REFERENCES cars(id),
    CONSTRAINT fk_drivers
    FOREIGN KEY (driver_id)
    REFERENCES drivers(id)
);

-- EX 2 ------------------------------------------------------------------------------
INSERT INTO clients(full_name, phone_number)
SELECT concat_ws(' ', first_name, last_name),
	concat('(088) 9999', id * 2)
FROM drivers
WHERE id BETWEEN 10 AND 20;

-- EX 3 -------------------------------------------------------------------------------
UPDATE cars
SET `condition` = 'C'
WHERE (mileage >= 800000 OR mileage IS NULL) AND `year` <= 2010 AND make != 'Mercedes-Benz';

-- EX 4 --------------------------------------------------------------------------------
DELETE from clients
WHERE (id NOT IN (SELECT client_id FROM courses)) AND char_length(full_name) > 3;

-- EX 5 ---------------------------------------------------------------------------------
SELECT make, model, `condition`
FROM cars
ORDER BY id;

-- EX 6 ---------------------------------------------------------------------------------
SELECT d.first_name, d.last_name, c.make, c.model, c.mileage
FROM cars AS c
JOIN cars_drivers AS cd ON c.id = cd.car_id
JOIN drivers AS d ON cd.driver_id = d.id
WHERE c.mileage IS NOT NULL
ORDER BY c.mileage DESC, d.first_name;

-- EX 7 ----------------------------------------------------------------------------------
SELECT c.id AS `car_id`,
	c.make,
    c.mileage,
    count(co.id) AS `count_of_courses`,
    round(avg(co.bill), 2) AS `avg_bill`
FROM cars AS c
LEFT JOIN courses AS co ON c.id = co.car_id
GROUP BY c.id
HAVING count_of_courses != 2
ORDER BY count_of_courses DESC, c.id;

-- EX 8 -----------------------------------------------------------------------------------
SELECT 
	c.full_name,
    count(co.car_id) AS `count_of_cars`,
    sum(co.bill) AS `total_sum`
FROM clients AS c
JOIN courses AS co ON c.id = co.client_id
GROUP BY c.id
HAVING count_of_cars > 1
AND c.full_name LIKE '_a%'
ORDER BY c.full_name;

-- EX 9 -----------------------------------------------------------------------------------
SELECT 
	a.name,
    if(hour(co.`start`) BETWEEN 6 AND 20, 'Day', 'Night') AS `day_time`,
    co.bill,
    c.full_name,
    ca.make,
    ca.model,
    cat.name AS `category_name`
FROM courses AS co
JOIN addresses AS a ON co.from_address_id = a.id
JOIN clients AS c ON co.client_id = c.id
JOIN cars AS ca ON co.car_id = ca.id
JOIN categories AS cat ON ca.category_id = cat.id
ORDER BY co.id;

-- EX 10 ================================================================================
DELIMITER $$
CREATE FUNCTION `udf_courses_by_client` (phone_num VARCHAR (20))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE num_of_courses INT;
    SET num_of_courses := (
		SELECT count(co.id)
        FROM clients AS c
        JOIN courses AS co ON c.id = co.client_id
        WHERE c.phone_number = phone_num
    );
RETURN num_of_courses;
END;
$$
DELIMITER ;

-- EX 11 -----------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `udp_courses_by_address` (address_name VARCHAR(100))
BEGIN
	SELECT 	
	a.name,
    cl.full_name,
    (case 
    WHEN co.bill <= 20 THEN 'Low'
    WHEN co.bill <= 30 THEN 'Medium'
    ELSE 'High'
    end) AS `level_of_bill`,
    ca.make,
    ca.`condition`,
    cat.name AS `cat_name`
FROM courses AS co
JOIN addresses AS a ON co.from_address_id = a.id
JOIN clients AS cl ON co.client_id = cl.id
JOIN cars AS ca ON co.car_id = ca.id
JOIN categories AS cat ON ca.category_id = cat.id
WHERE a.name = address_name
ORDER BY ca.make, cl.full_name;
END;
$$
DELIMITER ;