DROP DATABASE IF EXISTS a06;
CREATE DATABASE a06;
USE a06;

WITH RECURSIVE
nodes (val) AS (
    SELECT 'a' UNION ALL
    SELECT 'b' UNION ALL
    SELECT 'c' UNION ALL
    SELECT 'd' UNION ALL
    SELECT 'e' UNION ALL
    SELECT 'f'
),
edges (end, start) AS (
    SELECT 'b', 'a' UNION ALL
    SELECT 'c', 'a' UNION ALL
    SELECT 'd', 'b' UNION ALL
    SELECT 'e', 'd' UNION ALL
    SELECT 'f', 'd' UNION ALL
    SELECT 'f', 'c'
),
paths (end, path) AS (
		SELECT val, CAST(val AS CHAR(256))
    FROM nodes
    UNION ALL
    SELECT e.end, CONCAT(p.path, ',', e.end)
    FROM paths AS p
    JOIN edges AS e ON p.end = e.start
    WHERE FIND_IN_SET(e.end, p.path) = 0
)
SELECT * FROM paths;
