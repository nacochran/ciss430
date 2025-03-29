
USE movie_db;

CREATE TEMPORARY TABLE BaconNumber0 AS
SELECT p.nconst, 0 AS bacon_number
FROM principal p
JOIN name n on p.nconst = n.nconst
WHERE n.first_name = 'Kevin' AND n.last_name = 'Bacon'
AND p.category IN ('actor', 'actress');

CREATE TEMPORARY TABLE BaconNumber1 AS
SELECT DISTINCT p2.nconst, 1 AS bacon_number
FROM BaconNumber0 bn0
JOIN principal p1 ON bn0.nconst = p1.nconst
JOIN principal p2 ON p1.tconst = p2.tconst
WHERE p2.nconst != bn0.nconst
AND p2.category IN ('actor', 'actress');

CREATE TEMPORARY TABLE BaconNumber2 AS
SELECT DISTINCT p2.nconst, 2 AS bacon_number
FROM BaconNumber1 bn1
JOIN principal p1 ON bn1.nconst = p1.nconst
JOIN principal p2 ON p1.tconst = p2.tconst
WHERE p2.nconst != bn1.nconst
AND p2.category IN ('actor', 'actress');

SELECT COUNT(DISTINCT nconst) AS actors_with_bacon_number_0_1_2
FROM (
    SELECT nconst FROM BaconNumber0
    UNION
    SELECT nconst FROM BaconNumber1
    UNION
    SELECT nconst FROM BaconNumber2
) AS BaconUnion;

