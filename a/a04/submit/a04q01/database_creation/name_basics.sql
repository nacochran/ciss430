-- name_basics.sql
-- Nathan Cochran
-- a/a04/a04q01

-- Notes:

-- relevant tables for name.basics.tsv
-- name : first field from data output is nconst, second field is first_name and last_name, third field is year_of_bith, fourth field is year_of_death
-- profession : the fifth field from data output is a comma delimited list of professions: for each profession, we search through our profession table and if that profession does not already exist then we add it
-- name_basic_profession : for each of the professions in the fifth field, we also create a corresponding entry in name_basic_profession that connects a given profession with the name table
-- known_title : the sixth field has a list of tconst values that reference titles that the actor/actress (in the name table) is known for; don't worry about the fact that the title table is not created yet, we will generate it shortly; for now we just need to create the appropriate script for taking data from this name.basics.tsv file and insert the corresponding data into our tables


USE movie_db;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS name;
DROP TABLE IF EXISTS known_title;
DROP TABLE IF EXISTS profession;
DROP TABLE IF EXISTS name_basic_profession;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE name (
			 nconst VARCHAR(50) PRIMARY KEY,
			 first_name VARCHAR(200),
			 last_name VARCHAR(200),
			 year_of_birth INT,
			 year_of_death INT
);

CREATE TABLE known_title (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 nconst VARCHAR(50),
			 tconst VARCHAR(50),
			 FOREIGN KEY (nconst) REFERENCES name(nconst),
			 FOREIGN KEY (tconst) REFERENCES title(tconst)
);

CREATE TABLE profession (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 job_desc VARCHAR(200)
);

CREATE TABLE name_basic_profession (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 nconst VARCHAR(50),
			 profession_id INT,
			 FOREIGN KEY (nconst) REFERENCES name(nconst),
			 FOREIGN KEY (profession_id) REFERENCES profession (id)
);
