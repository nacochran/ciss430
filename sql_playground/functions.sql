-- This file documents the usage of
-- both procedures and functions,
-- which are very similar in nature
-- with one slight difference

USE test;

DROP TABLE IF EXISTS Person;

CREATE TABLE Person (
			 fname VARCHAR(100),
			 lname VARCHAR(200),
			 fingers INT
);

INSERT Person (fname, lname, fingers)
VALUES ('John', 'Doe', 10),
('Tom', 'Smith', 9),
('Sue', 'Somebody', 7);

-- Ensure database 'test' is selected to store the machine code for our function
USE test;

-- drop procedures & functions before using it
DROP PROCEDURE IF EXISTS p1;
DROP PROCEDURE IF EXISTS p2;
DROP FUNCTION IF EXISTS p3;
DROP PROCEDURE IF EXISTS p4;

-- temporarily set the "delimiter" or "end of statement"
-- to // so that our SQL queries don't terminate the creation
-- of our procedure(s)
DELIMITER //

-- @procedure p1
CREATE PROCEDURE p1(in f int)
BEGIN
SELECT * FROM Person where fingers = f;
END //

-- @procedure p2
CREATE PROCEDURE p2(out f int)
BEGIN
SELECT fingers FROM Person LIMIT 1 INTO f;
END //

-- reset delimiter to semicolon
DELIMITER ;


-- invoke function
CALL p1(10);

CALL p2(@f);

SELECT @f;

-- If desired, you can print the procedure as stored in the DB
-- SHOW CREATE PROCEDURE p;



-- Example of Functions
-- uses return keyword instead of in/out parameters
USE test;
DELIMITER //
CREATE FUNCTION p3(f int)
RETURNS int DETERMINISTIC
BEGIN
DECLARE g INT;
SELECT fingers FROM Person where fingers >= f LIMIT 1 INTO g;
RETURN g;
END //
DELIMITER ;

-- call functions like you would other MySQL functions
-- e.g.: COUNT function
SELECT p3(5);


-- Exercise: while loops in a procedure
-- Why can't we create tables inside of a PROCEDURE?
DROP TABLE IF EXISTS Z;
CREATE TABLE Z (
			 x INT
);

DELIMITER //
CREATE PROCEDURE p4(in a int, in b int)
BEGIN
DECLARE i INT DEFAULT a;
WHILE i < b DO
			INSERT INTO Z VALUES (i);
			SET i = i + 1;
END WHILE;
SELECT * FROM Z;
END //
DELIMITER ;

CALL p4(10, 14);
