	USE `minions`;
    
    CREATE TABLE `towns`(
    `town_id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45)
    );
    
ALTER TABLE `towns` 
CHANGE COLUMN `town_id` `id` INT NOT NULL AUTO_INCREMENT ;

ALTER TABLE `minions`
ADD COLUMN town_id INT NOT NULL;

ALTER TABLE `minions`
ADD CONSTRAINT fk_minions_towns FOREIGN KEY (`town_id`)
REFERENCES towns(`id`);

INSERT INTO towns(`id`, `name`)
VALUES
 ('1', 'Sofia'),
 ('2', 'Plovdiv'),
 ('3', 'Varna');
 
INSERT INTO minions(`id`, `name`, `age`, `town_id`)
VALUES
 ('1', 'Kevin', '22', '1'),
 ('2', 'Bob', '15', '3'),
 ('3', 'Steward', NULL, '2');


TRUNCATE TABLE minions;

DROP TABLE minions;
DROP TABLE towns;

CREATE TABLE `people`(
 `id` INT PRIMARY KEY AUTO_INCREMENT,
 `name` VARCHAR(200) NOT NULL,
 `picture` BLOB,
 `height` DOUBLE(10,2),
 `weight` DOUBLE(10,2),
 `gender` CHAR(1) NOT NULL,
 `birthdate` DATE NOT NULL,
 `biography` TEXT
);

INSERT INTO people(`name`, `gender`, `birthdate`)
VALUES
 ('Test', 'M', DATE(NOW())),
 ('Test', 'M', DATE(NOW())),
 ('Test', 'M', DATE(NOW())),
 ('Test', 'M', DATE(NOW())),
 ('Test', 'M', DATE(NOW()));
 
 CREATE TABLE `users`(
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `username` VARCHAR(30) NOT NULL,
  `password` VARCHAR(26) NOT NULL,
  `profile_picture` BLOB,
  `last_login_time` TIME,
  `is_deleted` BOOLEAN
 );
 
 INSERT INTO users(`username`, `password`)
 VALUES 
('Test1', 'Pass'),
('Test2', 'Pass'),
('Test3', 'Pass'),
('Test4', 'Pass'),
('Test5', 'Pass');

ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT `pk_users2`
PRIMARY KEY users(`id`, `username`);

ALTER TABLE users
CHANGE COLUMN `last_login_time` `last_login_time` DATETIME DEFAULT NOW();

ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT `pk_users`
PRIMARY KEY users(`id`),
CHANGE COLUMN `username` `username` VARCHAR(50) UNIQUE;

/* Ex 11 */
CREATE DATABASE `movies`;
USE movies;

CREATE TABLE `directors`(
 `id` INT PRIMARY KEY AUTO_INCREMENT,
 `director_name` VARCHAR(50) NOT NULL,
 `notes` TEXT
);

INSERT INTO directors(`director_name`, `notes`)
VALUES
 ('TestName1', 'TestNotes'),
 ('TestName1', 'TestNotes'),
 ('TestName1', 'TestNotes'),
 ('TestName1', 'TestNotes'),
 ('TestName1', 'TestNotes');

CREATE TABLE `genres`(
 `id` INT PRIMARY KEY AUTO_INCREMENT,
 `genre_name` VARCHAR(45) NOT NULL,
 `notes` TEXT
);

INSERT INTO genres(`genre_name`, `notes`)
VALUES
 ('TestName1', 'TestNotes'),
 ('TestName1', 'TestNotes'),
 ('TestName1', 'TestNotes'),
 ('TestName1', 'TestNotes'),
 ('TestName1', 'TestNotes');
 
CREATE TABLE `categories`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`category_name` VARCHAR(39) NOT NULL,
 `notes` TEXT
);

INSERT INTO categories(`category_name`, `notes`)
VALUES
 ('TestName1', 'TestNotes'),
 ('TestName1', 'TestNotes'),
 ('TestName1', 'TestNotes'),
 ('TestName1', 'TestNotes'),
 ('TestName1', 'TestNotes');

CREATE TABLE `movies`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`title` VARCHAR(39) NOT NULL,
`director_id` INT,
`copyright_year` INT,
`length` INT,
`genre_id` INT,
`category_id` INT,
`rating` DOUBLE,
 `notes` TEXT
);

INSERT INTO movies(`title`)
VALUES
 ('TestMovie'),
 ('TestMovie'),
 ('TestMovie'),
 ('TestMovie'),
 ('TestMovie');
 
 /* Ex 12*/
 CREATE DATABASE car_rental;
 USE car_rental;
 
 
 CREATE TABLE categories(
  `id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `category` VARCHAR(30),
  `daily_rate` DOUBLE,
  `weekly_rate` DOUBLE,
  `monthly_rate` DOUBLE,
  `weekend_rate` DOUBLE
 );
 
 INSERT INTO categories(`category`)
 VALUES
 ('Test'),
 ('Test'),
 ('Test');
 
 CREATE TABLE `cars`(
 `id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
 `plate_number` VARCHAR(20),
 `make` VARCHAR(20),
 `model` VARCHAR(20),
 `car_year` INT,
 `category_id` INT,
 `doors` INT,
 `picture` BLOB,
 `car_condition` VARCHAR(50),
 `available` BOOLEAN
 );
 
 INSERT INTO cars(`plate_number`)
 VALUES
 ('Test'),
 ('Test'),
 ('Test');
 
 CREATE TABLE `employees`(
 `id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
 `first_name` VARCHAR(30),
 `last_name` VARCHAR(30),
 `title` VARCHAR(30),
 `notes` TEXT
 );
 
 INSERT INTO employees(`first_name`, `last_name`)
 VALUES
 ('Test', 'Test'),
 ('Test', 'Test'),
 ('Test', 'Test');
 
 CREATE TABLE customers(
 `id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
 `driver_licence_number` INT,
 `full_name` VARCHAR(40),
 `address` VARCHAR(50),
 `city` VARCHAR(40),
 `zip_code` VARCHAR(15),
 `notes` TEXT
 );
 
 INSERT INTO customers(`driver_licence_number`, `full_name`)
 VALUES
 (1, 'Test'),
 (2, 'Test'),
 (3, 'Test');
 
 CREATE TABLE `rental_orders`(
 `id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
 `employee_id` INT,
 `customer_id` INT,
 `car_id` INT,
 `car_condition` VARCHAR(50),
 `tank_level` VARCHAR(20),
 `kilometrage_start` INT,
 `kilometrage_end` INT,
 `total_kilometrage` INT,
 `start_date` DATE,
 `end_date` DATE,
 `total_days` INT,
 `rate_applied` DOUBLE,
 `tax_rate` DOUBLE,
 `order_status` VARCHAR(30),
 `notes` TEXT
 );
 
 INSERT INTO rental_orders(`employee_id`, `customer_id`)
 VALUES
 (1, 1),
 (2, 2),
 (3, 3);
 
 /* EX 13*/
 CREATE DATABASE `soft_uni`;
 USE `soft_uni`;
 
 CREATE TABLE `towns`(
 `id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
 `name` VARCHAR(30) NOT NULL
 );
 
 CREATE TABLE `addresses`(
 `id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
 `address_text` VARCHAR(40) not null,
 `town_id` INT
 );
 
 CREATE TABLE `departments`(
 `id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
 `name` VARCHAR(30) NOT NULL
 );
 
 CREATE TABLE `employees`(
 `id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
 `first_name` VARCHAR(30) NOT NULL,
 `middle_name` VARCHAR(30),
 `last_name` VARCHAR(30) NOT NULL,
 `job_title` VARCHAR(25),
 `department_id` INT NOT NULL,
 `hire_date` DATE,
 `salary` DECIMAL(15,2),
 `address_id` INT,
 CONSTRAINT `fk_employees_departments`
 FOREIGN KEY employees(`department_id`)
 REFERENCES departments(`id`),
 CONSTRAINT `fk_employees_adress`
 FOREIGN KEY employees(`address_id`)
 REFERENCES addresses(`id`)
 );

INSERT INTO towns(`name`)
VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

INSERT INTO departments(`name`)
VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');

INSERT INTO employees(`first_name`, `middle_name`, `last_name`, `job_title`, `department_id`, `hire_date`, `salary`)
VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', '3500.00'),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', '4000.00'),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', '525.25'),
('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', '3000.00'),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', '599.88');

/* EX 14*/
USE soft_uni;

SELECT * FROM towns;
SELECT * FROM departments;
SELECT * FROM employees;

/* EX 15*/
SELECT * FROM towns ORDER BY `name` ASC;
SELECT * FROM  departments ORDER BY `name` ASC;
SELECT * FROM employees ORDER BY `salary` DESC;

/* EX 16 */
SELECT `name` FROM towns ORDER BY `name` ASC;
SELECT `name` FROM  departments ORDER BY `name` ASC;
SELECT `first_name`, `last_name`, `job_title`, `salary` FROM employees ORDER BY `salary` DESC;

/* EX 17 */
UPDATE  employees
SET `salary` = `salary` + (`salary` * 0.1);
SELECT `salary` FROM employees;

