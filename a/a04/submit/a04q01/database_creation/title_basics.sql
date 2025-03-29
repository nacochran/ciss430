-- title_basics.sql
-- Nathan Cochran
-- a/a04/a04q01

-- Notes:

-- relevant tables for title.basics.tsv
-- title: first field from data output is tconst, second field is title_type, third field is primary_title, fourth field is original_title, fifth field is isAdult, sixth field is startYear, seventh field is endYear, eight field is runtime_minutes
-- genre : the ninth field is a list of genres associated with the title; for every genre that does not already exist in the genre table, add it
-- title_basics_genre : for every genre in the ninth field, a row should be added to those title_basics_genre that connects a row in the genre table with a row in the title table


USE movie_db;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS title;
DROP TABLE IF EXISTS genre;
DROP TABLE IF EXISTS titles_basic_genre;
SET FOREIGN_KEY_CHECKS = 1;


CREATE TABLE title (
			 tconst VARCHAR(50) PRIMARY KEY,
			 title_type VARCHAR(100),
			 primary_title VARCHAR(600),
			 original_title VARCHAR(600),
			 is_adult BIT,
			 start_year INT,
			 end_year INT,
			 runtime_minutes INT
);

CREATE TABLE genre (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 name VARCHAR(50)
);

CREATE TABLE titles_basic_genre (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 tconst VARCHAR(50),
			 genre_id INT,
			 FOREIGN KEY (tconst) REFERENCES title(tconst),
			 FOREIGN KEY (genre_id) REFERENCES genre(id)
);
