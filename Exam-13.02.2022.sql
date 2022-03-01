-- EX 1 ----------------------------------------------------------------------
CREATE TABLE brands(
	id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE categories(
	id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE reviews(
	id INT PRIMARY KEY AUTO_INCREMENT,
    content TEXT,
    rating DECIMAL(10,2) NOT NULL,
    picture_url VARCHAR(80) NOT NULL,
    published_at DATETIME NOT NULL
);

CREATE TABLE products(
	id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL,
    price DECIMAL(19,2) NOT NULL,
    quantity_in_stock INT,
    `description` TEXT,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    review_id INT,
    CONSTRAINT fk_products_brands
    FOREIGN KEY (brand_id) 
    REFERENCES brands(id),
    CONSTRAINT fk_products_categories
    FOREIGN KEY (category_id) REFERENCES categories(id),
    CONSTRAINT fk_products_reviews
    FOREIGN KEY (review_id) REFERENCES reviews(id)
);

CREATE TABLE customers(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    phone VARCHAR(30) NOT NULL UNIQUE,
    address VARCHAR(60) NOT NULL,
    discount_card BIT(1) NOT NULL DEFAULT 0
);

CREATE TABLE orders(
	id INT PRIMARY KEY AUTO_INCREMENT,
    order_datetime DATETIME NOT NULL,
    customer_id INT NOT NULL,
    CONSTRAINT fk_orders_customers
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE orders_products(
	order_id INT,
    product_id INT,
    CONSTRAINT fk_orders_products
    FOREIGN KEY (order_id) REFERENCES orders(id),
    CONSTRAINT fk_products_orders
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- EX 2 --------------------------------------------------------------------------------
INSERT INTO reviews(content, picture_url, published_at, rating)
SELECT substring(`description`, 1, 15), reverse(`name`), '2010-10-10', price / 8
	FROM products
    WHERE id >= 5;
    
-- EX 3 --------------------------------------------------------------------------------
UPDATE products
SET quantity_in_stock = quantity_in_stock - 5
WHERE quantity_in_stock BETWEEN 60 AND 70;

-- EX 4 --------------------------------------------------------------------------------
DELETE FROM customers
WHERE id NOT IN (SELECT customer_id FROM orders);

-- EX 5 --------------------------------------------------------------------------------
SELECT *
FROM categories
ORDER BY `name` DESC;

-- EX 6 ---------------------------------------------------------------------------------
SELECT 
	id,
    brand_id,
    `name`,
    quantity_in_stock
FROM products
WHERE price > 1000 AND quantity_in_stock < 30
ORDER BY quantity_in_stock, id;

-- EX 7 --------------------------------------------------------------------------------
SELECT *
FROM reviews
WHERE content LIKE 'My%' AND char_length(content) > 61
ORDER BY rating DESC;

-- EX 8 -------------------------------------------------------------------------------
SELECT 
	concat(c.first_name, " ", c.last_name) AS `full_name`,
    c.address,
    o.order_datetime
FROM customers AS c
JOIN orders AS o ON o.customer_id = c.id
WHERE year(o.order_datetime) <= 2018
ORDER BY full_name DESC;

-- EX 9 ---------------------------------------------------------------------------------
SELECT 
	count(p.id) AS `items_count`,
    c.name,
    sum(p.quantity_in_stock) AS `total_quantity`
FROM categories AS c 
JOIN products AS p ON c.id = p.category_id
GROUP BY c.id
ORDER BY items_count DESC, total_quantity
LIMIT 5;

-- EX 10 -------------------------------------------------------------------------------
DELIMITER $$
CREATE FUNCTION `udf_customer_products_count` (name VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN
RETURN 
(
	SELECT count(p.id)
	FROM customers AS c
	JOIN orders AS o ON c.id = o.customer_id
	JOIN orders_products AS op ON o.id = op.order_id
	JOIN products AS p ON op.product_id = p.id
	WHERE c.first_name = name
	GROUP BY c.id
);
END;
$$
DELIMITER ;

-- EX 11 --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `udp_reduce_price` (category_name VARCHAR(50))
BEGIN
	UPDATE categories AS c
	JOIN products AS p ON c.id = p.category_id
    JOIN reviews AS r ON p.review_id = r.id
    SET p.price = 0.7 * p.price
	WHERE c.name = category_name AND r.rating < 4;
END;
$$
DELIMITER ;
