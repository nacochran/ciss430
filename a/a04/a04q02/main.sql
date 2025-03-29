USE movie_db;

SELECT 
    tb.start_year, 
    tb.primary_title, 
    tb.original_title, 
    tp.character_name
FROM title tb
JOIN principal tp ON tb.tconst = tp.tconst
JOIN name nb ON tp.nconst = nb.nconst
WHERE nb.first_name = 'Kevin' 
AND nb.last_name = 'Bacon'
AND tp.category = 'actor'
ORDER BY tb.start_year DESC, tb.primary_title ASC;
