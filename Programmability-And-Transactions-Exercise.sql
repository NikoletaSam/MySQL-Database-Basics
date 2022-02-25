-- EX 1 ----------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `usp_get_employees_salary_above_35000` ()
BEGIN
	SELECT first_name, last_name FROM employees
	WHERE salary > 35000
	ORDER BY first_name, last_name, employee_id;
END;
$$
DELIMITER ;

-- EX 2 ----------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `usp_get_employees_salary_above` (salary_to_check DECIMAL(15, 4))
BEGIN
	SELECT first_name, last_name FROM employees
	WHERE salary >= salary_to_check
	ORDER BY first_name, last_name, employee_id;
END;
$$
DELIMITER ;

-- EX 3 -------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `usp_get_towns_starting_with` (name_to_check VARCHAR(15))
BEGIN
	SELECT `name` 
	FROM towns
	WHERE `name` LIKE concat(name_to_check, '%')
	ORDER BY `name`;
END;
$$
DELIMITER ;

-- EX 4 --------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `usp_get_employees_from_town` (town_name VARCHAR(15))
BEGIN
	SELECT e.first_name, e.last_name
	FROM employees AS e
	JOIN addresses AS a ON e.address_id = a.address_id
	JOIN towns AS t ON t.town_id = a.town_id
	WHERE t.name = town_name
	ORDER BY e.first_name, e.last_name, e.employee_id;
END;
$$
DELIMITER ;

-- EX 5 ----------------------------------------------------------------------
DELIMITER $$
CREATE FUNCTION `ufn_get_salary_level` (salary_to_check DECIMAL)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
	DECLARE salary_type VARCHAR(10);
    SET salary_type := (
		CASE
        WHEN salary_to_check < 30000 THEN 'Low'
        WHEN salary_to_check <= 50000 THEN 'Average'
        ELSE 'High'
        END
    );
RETURN salary_type;
END;
$$
DELIMITER ;

-- EX 6 -------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `usp_get_employees_by_salary_level` (salary_to_check VARCHAR(15))
BEGIN
	SELECT first_name, last_name
	FROM employees AS e
	WHERE ufn_get_salary_level(e.salary) = salary_to_check
    ORDER BY first_name DESC, last_name DESC;
END;
$$
DELIMITER ;

-- EX 7 --------------------------------------------------------------------
DELIMITER $$
CREATE FUNCTION `ufn_is_word_comprised` (set_of_letters varchar(50), word varchar(50))
RETURNS BIT
DETERMINISTIC
RETURN word REGEXP(CONCAT('^[', set_of_letters, ']+$'));
$$
DELIMITER ;

-- EX 8 ---------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `usp_get_holders_full_name` ()
BEGIN
	SELECT concat_ws(' ', first_name, last_name) AS `full_name`
	FROM account_holders
	ORDER BY `full_name`, id;
END;
$$
DELIMITER ;

-- EX 9 -------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `usp_get_holders_with_balance_higher_than` (minial_salary DECIMAL)
BEGIN
	SELECT ah.first_name, ah.last_name
	FROM account_holders AS ah
	JOIN accounts AS a ON ah.id = a.account_holder_id
	GROUP BY ah.id
	HAVING SUM(a.balance) > minial_salary
	ORDER BY ah.id;
END;
$$
DELIMITER ;

-- EX 10 --------------------------------------------------------------------
DELIMITER $$
CREATE FUNCTION `ufn_calculate_future_value` (initial_sum DECIMAL(20, 4), interest_rate DECIMAL(20, 4), num_years INT)
RETURNS DECIMAL(20, 4)
DETERMINISTIC
BEGIN
	DECLARE future_value DECIMAL(20, 4);
    SET future_value := (
		initial_sum * (pow((1 + interest_rate), num_years))
    );
RETURN future_value;
END;
$$
DELIMITER ;

-- EX 11 ---------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `usp_calculate_future_value_for_account` (current_account_id INT, current_interest_rate DECIMAL(20, 4))
BEGIN
	SELECT a.id AS `account_id`,
		ah.first_name,
		ah.last_name,
		a.balance AS `current_balance`, 
		ufn_calculate_future_value(a.balance, current_interest_rate, 5) AS `balance_in_5_years`
	FROM accounts AS a
	JOIN account_holders AS ah ON a.account_holder_id = ah.id
	WHERE a.id = current_account_id;
END;
$$
DELIMITER ;

-- EX 12 ----------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `usp_deposit_money` (current_account_id INT, money_amount DECIMAL(20, 4))
BEGIN
	UPDATE accounts AS a
    SET a.balance = 
		if(money_amount > 0, a.balance + money_amount, a.balance)
	WHERE a.id = current_account_id;
END;
$$
DELIMITER ;

-- EX 13 ------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `usp_withdraw_money` (current_account_id INT, money_amount DECIMAL(20, 4))
BEGIN
	START TRANSACTION;
	IF(((SELECT balance FROM accounts WHERE id = current_account_id) > money_amount) AND (money_amount > 0))
    THEN 
		UPDATE accounts
        SET balance = balance - money_amount
        WHERE id = current_account_id;
	ELSE 
    ROLLBACK;
    END IF;
END;
$$
DELIMITER ;

-- EX 14 --------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `usp_transfer_money`(from_account_id INT, to_account_id INT, amount DECIMAL(20, 4))
BEGIN
	START TRANSACTION;
    IF ((from_account_id NOT IN (SELECT id FROM accounts)) OR (to_account_id NOT IN (SELECT id FROM accounts)) 
        OR (amount <= 0) OR ((SELECT balance FROM accounts WHERE id = from_account_id) < amount) OR (from_account_id = to_account_id))
	THEN
		ROLLBACK;
	ELSE 
		UPDATE accounts
        SET balance = balance - amount
        WHERE id = from_account_id;
        UPDATE accounts
        SET balance = balance + amount
        WHERE id = to_account_id;
	END IF;
END;
$$

DELIMITER ;
call usp_transfer_money(1, 2, 10);
SELECT * FROM accounts WHERE ID = 1 or id = 2;