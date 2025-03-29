/**
 * File : main.sql
 * Location: a/a02/a02q01
 * Author: Nathan Cochran
**/ 

DROP DATABASE IF EXISTS cms;
CREATE DATABASE cms;
USE cms;

CREATE TABLE year (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 year_value INT NOT NULL UNIQUE
);

CREATE TABLE season (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 season_name VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE semester (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 year_id INT NOT NULL,
			 season_id INT NOT NULL,
			 start_date DATE NOT NULL,
			 end_date DATE NOT NULL,
			 UNIQUE (year_id, season_id),
			 FOREIGN KEY (year_id) REFERENCES year(id),
			 FOREIGN KEY (season_id) REFERENCES season(id)
);

CREATE TABLE course (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 program VARCHAR(10) NOT NULL,
			 course_number INT NOT NULL,
			 course_name VARCHAR(100) NOT NULL,
			 UNIQUE (program, course_number)
);

CREATE TABLE person(
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 firstname VARCHAR(50) NOT NULL,
			 lastname VARCHAR(50) NOT NULL,
			 email VARCHAR(100) UNIQUE,
			 username VARCHAR(50) NOT NULL UNIQUE,
			 password VARCHAR(255) NOT NULL
);

CREATE TABLE instructor (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 person_id INT NOT NULL,
			 FOREIGN KEY (person_id) REFERENCES person(id)
);

CREATE TABLE student (
			id INT AUTO_INCREMENT PRIMARY KEY,
			person_id INT NOT NULL,
			FOREIGN KEY (person_id) REFERENCES person(id)
);

CREATE TABLE section (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 course_id INT NOT NULL,
			 semester_id INT NOT NULL,
			 instructor_id INT NOT NULL,
			 section_letter CHAR(1) NOT NULL,
			 UNIQUE (course_id, semester_id, section_letter),
			 FOREIGN KEY (course_id) REFERENCES course(id),
			 FOREIGN KEY (instructor_id) REFERENCES instructor(id),
			 FOREIGN KEY (semester_id) REFERENCES semester(id)
);


