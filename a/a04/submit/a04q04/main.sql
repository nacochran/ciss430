
USE movie_db;

SELECT n.nconst, n.first_name, n.last_name
FROM principal p1
JOIN principal p2 on p1.tconst = p2.tconst
JOIN name n on p2.nconst = n.nconst
WHERE p1.nconst = (SELECT nconst FROM name WHERE first_name = 'Kevin' AND last_name = 'Bacon' AND year_of_birth = '1958')
AND p2.nconst != p1.nconst
AND p2.category IN ('actor', 'actress')
ORDER BY n.last_name, n.first_name;
