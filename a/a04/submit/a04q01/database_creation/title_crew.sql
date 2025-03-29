
USE movie_db;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS crew;
DROP TABLE IF EXISTS director;
DROP TABLE IF EXISTS writer;
SET FOREIGN_KEY_CHECKS = 1;


-- crew of a given title
CREATE TABLE crew (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 tconst VARCHAR(50),
			 FOREIGN KEY (tconst) REFERENCES title(tconst)
);

-- directors of a given title
CREATE TABLE director (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 crew_id INT,
			 director_name VARCHAR(400),
			 FOREIGN KEY (crew_id) REFERENCES crew(id)
);

-- writers of a given title
CREATE TABLE writer (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 crew_id INT,
			 writer_name VARCHAR(400),
			 FOREIGN KEY (crew_id) REFERENCES crew(id)
);
