-- EX 1 ----------------------------------------------------------------------------
CREATE TABLE planets(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE spaceports(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    planet_id INT,
    CONSTRAINT fk_spaceports_planets
    FOREIGN KEY (planet_id)REFERENCES planets(id)
);

CREATE TABLE spaceships(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    manufacturer VARCHAR(30) NOT NULL,
    light_speed_rate INT DEFAULT 0
);

CREATE TABLE colonists(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    ucn CHAR(10) NOT NULL UNIQUE,
    birth_date DATE NOT NULL
);

CREATE TABLE journeys(
	id INT PRIMARY KEY AUTO_INCREMENT,
    journey_start DATETIME NOT NULL,
    journey_end DATETIME NOT NULL,
    purpose ENUM('Medical', 'Technical', 'Educational', 'Military'),
    destination_spaceport_id INT,
    spaceship_id INT,
    CONSTRAINT fk_journeys_spaceports
    FOREIGN KEY (destination_spaceport_id) REFERENCES spaceports(id),
    CONSTRAINT fk_journeys_spaceships
    FOREIGN KEY (spaceship_id) REFERENCES spaceships(id)
);

CREATE TABLE travel_cards(
	id INT PRIMARY KEY AUTO_INCREMENT,
    card_number CHAR(10) NOT NULL UNIQUE,
    job_during_journey ENUM('Pilot', 'Engineer', 'Trooper', 'Cleaner', 'Cook'),
    colonist_id INT,
    journey_id INT,
    CONSTRAINT fk_travel_cards_colonists
    FOREIGN KEY (colonist_id)REFERENCES colonists(id),
    CONSTRAINT fk_travel_cards_journeys
    FOREIGN KEY (journey_id)REFERENCES journeys(id)
);

-- EX 2 --------------------------------------------------------------------------------------
INSERT INTO travel_cards(card_number, job_during_journey, colonist_id, journey_id)
SELECT 
	if(c.birth_date > '1980-01-01', concat(year(c.birth_date), day(c.birth_date), substring(c.ucn, 1, 4)),
    concat(year(c.birth_date), month(c.birth_date), substring(c.ucn, 7, 10))) AS `card_number`,
    CASE
		WHEN c.id % 2 = 0 THEN 'Pilot'
		WHEN c.id % 3 = 0 THEN 'Cook'
		ELSE 'Engineer'
		END AS `job_during_journey`,
    c.id,
    substring(c.ucn, 1, 1) AS `journey_id`
FROM colonists AS c
WHERE id BETWEEN 96 AND 100;

-- EX 3 ---------------------------------------------------------------------------------------
UPDATE journeys
SET purpose = (
	CASE
		WHEN id % 2 = 0 THEN 'Medical'
		WHEN id % 3 = 0 THEN 'Technical'
		WHEN id % 5 = 0 THEN 'Educational'
		WHEN id % 7 - 0 THEN 'Military'
	ELSE purpose
END
);

-- EX 4 ------------------------------------------------------------------------------------------
DELETE
FROM colonists
WHERE id NOT IN (SELECT colonist_id FROM travel_cards);

-- EX 5 --------------------------------------------------------------------------------------------
SELECT 
	card_number,
    job_during_journey
FROM travel_cards
ORDER BY card_number;

-- EX 6 ---------------------------------------------------------------------------------------------
SELECT 
	id,
    concat(first_name, ' ', last_name) AS `full_name`,
    ucn
FROM colonists
ORDER BY first_name, last_name, id;

-- EX 7 ---------------------------------------------------------------------------------------------
SELECT 
	id,
    journey_start,
    journey_end
FROM journeys
WHERE purpose = 'Military'
ORDER BY journey_start;

-- EX 8 ----------------------------------------------------------------------------------------------
SELECT 
	c.id,
    concat(c.first_name, ' ', c.last_name) AS `full_name`
FROM colonists AS c
JOIN travel_cards AS tc ON c.id = tc.colonist_id
WHERE tc.job_during_journey = 'Pilot'
ORDER BY c.id;

-- EX 9 -----------------------------------------------------------------------------------------------
SELECT count(*) AS `count`
FROM colonists AS c
JOIN travel_cards AS tc ON c.id = tc.colonist_id
JOIN journeys AS j ON j.id = tc.journey_id
WHERE j.purpose = 'Technical';

-- EX 10 -----------------------------------------------------------------------------------------------
SELECT 
	ss.name AS `spaceship_name`,
    sp.name AS `spaceport_name`
FROM spaceships AS ss
JOIN journeys AS j ON ss.id = j.spaceship_id
JOIN spaceports AS sp ON j.destination_spaceport_id = sp.id
ORDER BY ss.light_speed_rate DESC
limit 1;

-- EX 11 ------------------------------------------------------------------------------------------------
SELECT 
	ss.name,
    ss.manufacturer
FROM spaceships AS ss
JOIN journeys AS j ON j.spaceship_id = ss.id
JOIN travel_cards AS tc ON tc.journey_id = j.id
JOIN colonists AS c ON tc.colonist_id = c.id
WHERE timestampdiff(year, c.birth_date, '2019-01-01') < 30 AND tc.job_during_journey = 'Pilot'
ORDER BY ss.name;

-- EX 12 --------------------------------------------------------------------------------------------------
SELECT 
	p.name AS `planet_name`,
    sp.name AS `spaceport_name`
FROM journeys AS j
JOIN spaceports AS sp ON j.destination_spaceport_id = sp.id
JOIN planets AS p ON sp.planet_id = p.id
WHERE j.purpose = 'Educational'
ORDER BY spaceport_name desc;

-- EX 13 --------------------------------------------------------------------------------------------------
SELECT 
	p.name AS `planet_name`,
    count(j.id) AS `journeys_count`
FROM journeys AS j
JOIN spaceports AS sp ON j.destination_spaceport_id = sp.id
JOIN planets AS p ON sp.planet_id = p.id
GROUP BY p.id
ORDER BY journeys_count desc, planet_name;

-- EX 14 -------------------------------------------------------------------------------------------------
SELECT 
	j.id,
    p.name AS `planet_name`,
    sp.name AS `spaceport_name`,
    j.purpose AS `journey_purpose`
FROM journeys AS j
JOIN spaceports AS sp ON j.destination_spaceport_id = sp.id
JOIN planets AS p ON sp.planet_id = p.id
ORDER BY datediff(j.journey_start, j.journey_end) desc
LIMIT 1;

-- EX 15 --------------------------------------------------------------------------------------------------
SELECT 
	tc.job_during_journey AS `job_name`
FROM journeys AS j
JOIN travel_cards AS tc ON tc.journey_id = j.id
JOIN colonists AS c ON tc.colonist_id = c.id
ORDER BY datediff(j.journey_start, j.journey_end)
LIMIT 1;

-- EX 16 -------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE FUNCTION `udf_count_colonists_by_destination_planet` (planet_name VARCHAR (30))
RETURNS INT
DETERMINISTIC
BEGIN
RETURN (
	SELECT count(DISTINCT c.id)
	FROM planets AS p
	JOIN spaceports AS sp ON sp.planet_id = p.id
	JOIN journeys AS j ON j.destination_spaceport_id = sp.id
	JOIN travel_cards AS tc ON tc.journey_id = j.id
	JOIN colonists AS c ON tc.colonist_id = c.id
	WHERE p.name = planet_name
);
END;
$$
DELIMITER ;