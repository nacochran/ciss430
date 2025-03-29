
USE movie_db;

WITH KevinBaconMovieCount AS (
    SELECT COUNT(DISTINCT tconst) AS movie_count
    FROM principal tp
    JOIN name nb ON tp.nconst = nb.nconst
    WHERE nb.first_name = 'Kevin' AND nb.last_name = 'Bacon'
    AND tp.category IN ('actor', 'actress')
),
ActorMovieCounts AS (
    SELECT tp.nconst, COUNT(DISTINCT tp.tconst) AS movie_count
    FROM principal tp
    WHERE tp.category IN ('actor', 'actress')
    GROUP BY tp.nconst
)
SELECT COUNT(*)
FROM ActorMovieCounts
WHERE movie_count > (SELECT movie_count FROM KevinBaconMovieCount);
