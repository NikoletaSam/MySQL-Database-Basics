CREATE TABLE users(
	id INT PRIMARY KEY,
    username VARCHAR(30) NOT NULL UNIQUE,
    `password` VARCHAR(30) NOT NULL,
    email VARCHAR(50) NOT NULL,
    gender CHAR(1) NOT NULL,
    age INT NOT NULL,
    job_title VARCHAR(40) NOT NULL,
    ip VARCHAR(30) NOT NULL
);

CREATE TABLE addresses(
	id INT PRIMARY KEY AUTO_INCREMENT,
    address VARCHAR(30) NOT NULL,
    town VARCHAR(30) NOT NULL,
    country VARCHAR(30) NOT NULL,
    user_id INT NOT NULL,
    CONSTRAINT fk_addresses_users
    FOREIGN KEY (user_id)
    REFERENCES users(id)
);

CREATE TABLE photos(
	id INT PRIMARY KEY AUTO_INCREMENT,
    `description` TEXT NOT NULL,
    `date` DATETIME NOT NULL,
    views INT NOT NULL DEFAULT 0
);

CREATE TABLE comments(
	id INT PRIMARY KEY AUTO_INCREMENT,
    `comment` VARCHAR(255) NOT NULL,
	`date` DATETIME NOT NULL,
    photo_id INT NOT NULL,
    CONSTRAINT fk_comments_photos
    FOREIGN KEY (photo_id)
    REFERENCES photos(id)
);

CREATE TABLE users_photos(
	user_id INT NOT NULL,
    photo_id INT NOT NULL,
    CONSTRAINT fk_users_photos
    FOREIGN KEY (user_id)
    REFERENCES users(id),
    CONSTRAINT fk_photos_photos
    FOREIGN KEY (photo_id)REFERENCES photos(id)
);

CREATE TABLE likes(
	id INT PRIMARY KEY AUTO_INCREMENT,
    photo_id INT,
    user_id INT,
    CONSTRAINT fk_likes_photos
    FOREIGN KEY (photo_id) REFERENCES photos(id),
    CONSTRAINT fk_likes_users
    FOREIGN KEY (user_id)REFERENCES users(id)
);

-- EX 2 ---------------------------------------------------------------------------------------
INSERT INTO addresses(address, town, country, user_id)
SELECT username, `password`, ip, age
FROM users
WHERE gender = 'M';
 
 -- EX 3 --------------------------------------------------------------------------------------
 UPDATE addresses
 SET country = CASE
 WHEN country LIKE 'B%' THEN 'Blocked'
 WHEN country LIKE 'T%' THEN 'Test'
 WHEN country LIKE 'P%' THEN 'In Progress'
 ELSE country
 END;
 
 -- EX 4 ----------------------------------------------------------------------------------------
 DELETE
 FROM addresses
 WHERE (id % 3) = 0;
 
 -- EX 5 ----------------------------------------------------------------------------------------
 SELECT username,  gender, age
 FROM users
 ORDER BY age DESC, username ASC;
 
 -- EX 6 -----------------------------------------------------------------------------------------
 SELECT p.id,
	p.date AS `date_and_time`,
    p.description,
    count(c.id) AS `commentsCount`
 FROM photos AS p
 JOIN comments AS c ON c.photo_id = p.id
 GROUP BY p.id
 ORDER BY commentsCount DESC, p.id
 LIMIT 5;
 
 -- EX 7 ------------------------------------------------------------------------------------------
 SELECT 
	concat(u.id, ' ', u.username) AS `id_username`,
    u.email
 FROM users AS u
 JOIN users_photos AS up ON u.id = up.user_id
 WHERE up.user_id = up.photo_id
 ORDER BY u.id;
 
 -- EX 8 ------------------------------------------------------------------------------------------
SELECT 
	p.id AS `photo_id`,
	count(DISTINCT l.id) AS `likes_count`,
    count(DISTINCT c.id) AS `comments_count`
FROM photos AS p
LEFT JOIN likes AS l ON p.id = l.photo_id
LEFT JOIN comments AS c ON p.id = c.photo_id
GROUP BY p.id
ORDER BY likes_count desc, comments_count desc, p.id;

-- EX 9 ---------------------------------------------------------------------------------------------
SELECT 
	concat(substring(`description`, 1, 30), '...') AS `summary`,
    `date`
FROM photos
WHERE day(`date`) = 10
ORDER BY `date` DESC;

-- EX 10 --------------------------------------------------------------------------------------------
DELIMITER $$
CREATE FUNCTION `udf_users_photos_count`(username VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN
RETURN 
(
	SELECT count(p.id)
	FROM users AS u
	JOIN users_photos AS up ON u.id = up.user_id
	JOIN photos AS p ON up.photo_id = p.id
	WHERE u.username = username
);
END;
$$
DELIMITER ;

-- EX 11 --------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `udp_modify_user`(address VARCHAR(30), town VARCHAR(30))
BEGIN
	UPDATE users AS u
	JOIN addresses AS a ON u.id = a.user_id
	SET u.age = u.age + 10
	WHERE a.address = address AND a.town = town;
END;
$$
DELIMITER ;