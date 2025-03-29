DROP DATABASE IF EXISTS a06;
CREATE DATABASE a06;
USE a06;

DROP TABLE IF EXISTS edges;
CREATE TABLE edges (
    end VARCHAR(5),
    start VARCHAR(5)
);

INSERT INTO edges (end, start) VALUES
('a', NULL),
('b', 'a'),
('c', 'a'),
('d', 'b'),
('e', 'd'),
('f', 'd'),
('f', 'c'),
('b', 'f');

WITH RECURSIVE paths (end, path) AS (
    SELECT end, CAST(end AS CHAR(256))
    FROM edges
    WHERE start IS NULL
    UNION ALL
    SELECT e.end, CONCAT(p.path, ',', e.end)
    FROM paths AS p
    JOIN edges AS e ON p.end = e.start
		WHERE FIND_IN_SET(e.end, p.path) = 0
)
SELECT * FROM paths;
