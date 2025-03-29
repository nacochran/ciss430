DROP DATABASE IF EXISTS a06;
CREATE DATABASE a06;
USE a06;

CREATE TABLE edges (
    end VARCHAR(5),
    start VARCHAR(5)
);

CREATE TABLE nodes (
		val VARCHAR(5)
);

INSERT INTO nodes (val) VALUES
('a'),
('b'),
('c'),
('d'),
('e'),
('f');

INSERT INTO edges (end, start) VALUES
('a', NULL),
('b', 'a'),
('c', 'a'),
('d', 'b'),
('e', 'd'),
('f', 'd'),
('f', 'c');

WITH RECURSIVE paths (end, path) AS (
		SELECT val, CAST(val AS CHAR(256))
		FROM nodes
    UNION ALL
    SELECT e.end, CONCAT(p.path, ',', e.end)
    FROM paths AS p
    JOIN edges AS e ON p.end = e.start
		WHERE FIND_IN_SET(e.end, p.path) = 0
)
SELECT * FROM paths;
