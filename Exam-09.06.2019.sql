CREATE TABLE branches(
	id INT(11) AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY `branches_unique` (`name`)
);

CREATE TABLE employees(
	id INT(11) AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    started_on DATE NOT NULL,
    branch_id INT(11) NOT NULL,
    PRIMARY KEY (id),
	KEY `fk_employees_branches_idx` (`branch_id`),
    CONSTRAINT fk_employees_branches
    FOREIGN KEY (branch_id)REFERENCES branches(id)
);

CREATE TABLE clients(
	id INT(11) AUTO_INCREMENT,
    full_name VARCHAR(50) NOT NULL,
    age INT(11) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE employees_clientS(
	employee_id INT(11),
    client_id INT(11),
	KEY `fk_ec_employees_idx` (`employee_id`),
    KEY `fk_ec_clients_idx` (`client_id`),
    CONSTRAINT fk_employees
    FOREIGN KEY (employee_id)REFERENCES employees(id),
    CONSTRAINT fk_clients
    FOREIGN KEY (client_id)REFERENCES clients(id)
);

CREATE TABLE bank_accounts(
	id INT(11) AUTO_INCREMENT,
    account_number VARCHAR(10) NOT NULL,
    balance DECIMAL(10,2) NOT NULL,
    client_id INT(11) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY `bank_account_unique` (client_id),
    CONSTRAINT fk_bank_accounts_clients
    FOREIGN KEY (client_id) REFERENCES clients(id)
);

CREATE TABLE cards(
	id INT(11) AUTO_INCREMENT,
    card_number VARCHAR(19) NOT NULL,
    card_status VARCHAR(7) NOT NULL,
    bank_account_id INT(11) NOT NULL,
    PRIMARY KEY (id),
    KEY `fk_cards_ba_idx` (`bank_account_id`),
    CONSTRAINT fk_cards_bank_accounts
    FOREIGN KEY (bank_account_id) REFERENCES bank_accounts(id)
);

-- EX 2 -----------------------------------------------------------------------------
INSERT INTO cards(card_number, card_status, bank_account_id)
SELECT reverse(full_name), 'Active', id
FROM clients
WHERE id BETWEEN 191 AND 200;

-- EX 3 ------------------------------------------------------------------------------
UPDATE employees_clients
SET employee_id = (SELECT employee_id FROM (SELECT * FROM  employees_clients) AS ec
GROUP BY ec.employee_id
ORDER BY count(ec.client_id), ec.employee_id
LIMIT 1)
WHERE employee_id = client_id;

-- EX 4 -------------------------------------------------------------------------------
DELETE FROM employees
WHERE id NOT IN (SELECT employee_id FROM employees_clients);

-- EX 5 -------------------------------------------------------------------------------
SELECT id, full_name
FROM clients
ORDER BY id;

-- EX 6 --------------------------------------------------------------------------------
SELECT 
	id,
    concat(first_name, " ", last_name) AS `full_name`,
    concat('$', salary) AS `salary`,
    started_on
FROM employees
WHERE salary >= 100000 AND started_on >= '2018-01-01'
ORDER BY salary DESC, id;

-- EX 7 -------------------------------------------------------------------------------
SELECT 
	c.id,
    concat_ws(' : ', c.card_number, cl.full_name) AS `card_token`
FROM cards AS c
LEFT JOIN bank_accounts AS ba ON c.bank_account_id = ba.id
LEFT JOIN clients AS cl ON cl.id = ba.client_id
ORDER BY c.id DESC;

-- EX 8 -------------------------------------------------------------------------------
SELECT 
	concat(e.first_name, ' ', e.last_name) AS `name`,
    e.started_on,
    count(ec.client_id) AS `count_of_clients`
FROM employees AS e
JOIN employees_clients AS ec ON e.id = ec.employee_id
GROUP BY e.id
ORDER BY count_of_clients DESC, e.id
LIMIT 5;

-- EX 9 --------------------------------------------------------------------------------
SELECT 
	b.name,
    count(ca.id) AS `count_of_cards`
FROM branches AS b 
left JOIN employees AS e ON e.branch_id = b.id
left JOIN employees_clients AS ec ON e.id = ec.employee_id
left JOIN clients AS cl ON cl.id = ec.client_id
left JOIN bank_accounts AS ba ON ba.client_id = cl.id
left JOIN cards AS ca ON ba.id = ca.bank_account_id
GROUP BY b.id
ORDER BY count_of_cards DESC, b.name;

-- EX 10 --------------------------------------------------------------------------------
DELIMITER $$
CREATE FUNCTION `udf_client_cards_counT` (name VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN
RETURN (
	SELECT count(c.id)
	FROM clients AS cl
	JOIN bank_accounts AS ba ON cl.id = ba.client_id
	JOIN cards AS c ON c.bank_account_id = ba.id
	WHERE cl.full_name = name
	GROUP BY cl.id
);
END;
$$
DELIMITER ;

-- EX 11 -------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `udp_clientinfo` (full_name VARCHAR(50))
BEGIN
	SELECT 
		c.full_name,
		c.age,
		ba.account_number,
		concat('$', ba.balance) AS `balance`
	FROM clients AS c
	JOIN bank_accounts AS ba ON ba.client_id = c.id
	WHERE c.full_name = full_name;
END;
$$
DELIMITER ;
