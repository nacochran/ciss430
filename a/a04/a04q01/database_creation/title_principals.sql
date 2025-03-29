
USE movie_db;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS principal;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE principal (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 tconst VARCHAR(50),
			 ordering INT,
			 nconst VARCHAR(50),
			 category VARCHAR(400),
			 job VARCHAR(400),
			 character_name VARCHAR(600)
);



