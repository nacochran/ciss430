

DROP DATABASE IF EXISTS test_db;
CREATE DATABASE test_db;
USE test_db;

CREATE TABLE Person (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 firstname VARCHAR(50),
			 lastname VARCHAR(50),
			 fingers INT DEFAULT 10
);

INSERT INTO Person (firstname, lastname, fingers)
VALUES
('Nathan', 'Cochran', 10),
('Joe', 'Cochran', 9),
('Bob', 'Cochran', 9);


-- Select people with max fingers
SELECT firstname,lastname from Person WHERE fingers = (SELECT Max(fingers) from Person);


-- Select people with 2nd most fingers
SELECT firstname,lastname from Person WHERE fingers = (SELECT Max(fingers) from Person WHERE fingers < (SELECT Max(fingers) from Person));
