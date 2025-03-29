/**
 * File : main.sql
 * Location: a/a02/a02q03
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

/* Clean Up Tables */
-- temporarily disable foreign key checks so we can delete all row data
SET FOREIGN_KEY_CHECKS = 0; 
DELETE FROM person;
DELETE FROM instructor;
DELETE FROM student;
DELETE FROM year;
DELETE FROM season;
DELETE FROM semester;
DELETE FROM course;
DELETE FROM section;
-- re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO person (firstname, lastname, username, password) 
VALUES
('Yihsiang', 'Liow', 'yliow', 'password'),
('John', 'Doe', 'jdoe', 'secret');


INSERT INTO instructor (person_id) 
VALUES
((SELECT id FROM person WHERE username = 'yliow')),
((SELECT id FROM person WHERE username = 'jdoe'));

INSERT INTO year (year_value) 
VALUES (2017), (2018);

INSERT INTO season (season_name) 
VALUES ('Spring'), ('Fall');

INSERT INTO semester (year_id, season_id, start_date, end_date) 
VALUES
(
	(SELECT id FROM year WHERE year_value = 2017),
	(SELECT id FROM season WHERE season_name = 'Spring'),
	'2017-01-15',
	'2017-05-15'
),
(
	(SELECT id FROM year WHERE year_value = 2017),
	(SELECT id FROM season WHERE season_name = 'Fall'),
	'2017-08-15',
	'2017-12-15'
),
(
	(SELECT id FROM year WHERE year_value = 2018),
	(SELECT id FROM season WHERE season_name = 'Spring'),
	'2018-01-15',
	'2018-05-15'
);


INSERT INTO course (program, course_number, course_name) 
VALUES ('CISS', 145, 'Python Programming'),
       ('CISS', 240, 'Introduction to Programming'),
       ('CISS', 245, 'Advanced Programming'),
       ('CISS', 350, 'Data Structures and Advanced Algorithms'),
       ('CISS', 430, 'Database Systems'),
       ('MATH', 225, 'Discrete Mathematics I'),
       ('MATH', 325, 'Discrete Mathematics II');


-- Spring 2017
INSERT INTO section (course_id, semester_id, instructor_id, section_letter) 
VALUES
(
    (SELECT id FROM course WHERE program = 'CISS' AND course_number = 240),
    (SELECT id FROM semester WHERE start_date = '2017-01-15'),
    (SELECT id FROM instructor WHERE person_id = (SELECT id FROM person WHERE username = 'yliow')),
    'A'
),
(
    (SELECT id FROM course WHERE program = 'CISS' AND course_number = 350),
    (SELECT id FROM semester WHERE start_date = '2017-01-15'),
    (SELECT id FROM instructor WHERE person_id = (SELECT id FROM person WHERE username = 'yliow')),
    'A'
),
(
    (SELECT id FROM course WHERE program = 'CISS' AND course_number = 430),
    (SELECT id FROM semester WHERE start_date = '2017-01-15'),
    (SELECT id FROM instructor WHERE person_id = (SELECT id FROM person WHERE username = 'yliow')),
    'A'
),
(
    (SELECT id FROM course WHERE program = 'CISS' AND course_number = 145),
    (SELECT id FROM semester WHERE start_date = '2017-01-15'),
    (SELECT id FROM instructor WHERE person_id = (SELECT id FROM person WHERE username = 'jdoe')),
    'B'
),
(
    (SELECT id FROM course WHERE program = 'CISS' AND course_number = 240),
    (SELECT id FROM semester WHERE start_date = '2017-01-15'),
    (SELECT id FROM instructor WHERE person_id = (SELECT id FROM person WHERE username = 'jdoe')),
    'B'
);

-- Fall 2017
INSERT INTO section (course_id, semester_id, instructor_id, section_letter) 
VALUES
(
    (SELECT id FROM course WHERE program = 'CISS' AND course_number = 245),
    (SELECT id FROM semester WHERE start_date = '2017-08-15'),
    (SELECT id FROM instructor WHERE person_id = (SELECT id FROM person WHERE username = 'yliow')),
    'C'
),
(
    (SELECT id FROM course WHERE program = 'CISS' AND course_number = 350),
    (SELECT id FROM semester WHERE start_date = '2017-08-15'),
    (SELECT id FROM instructor WHERE person_id = (SELECT id FROM person WHERE username = 'yliow')),
    'C'
),
(
    (SELECT id FROM course WHERE program = 'MATH' AND course_number = 325),
    (SELECT id FROM semester WHERE start_date = '2017-08-15'),
    (SELECT id FROM instructor WHERE person_id = (SELECT id FROM person WHERE username = 'yliow')),
    'C'
),
(
    (SELECT id FROM course WHERE program = 'CISS' AND course_number = 240),
    (SELECT id FROM semester WHERE start_date = '2017-08-15'),
    (SELECT id FROM instructor WHERE person_id = (SELECT id FROM person WHERE username = 'jdoe')),
    'A'
),
(
    (SELECT id FROM course WHERE program = 'CISS' AND course_number = 350),
    (SELECT id FROM semester WHERE start_date = '2017-08-15'),
    (SELECT id FROM instructor WHERE person_id = (SELECT id FROM person WHERE username = 'jdoe')),
    'A'
),
(
    (SELECT id FROM course WHERE program = 'MATH' AND course_number = 225),
    (SELECT id FROM semester WHERE start_date = '2017-08-15'),
    (SELECT id FROM instructor WHERE person_id = (SELECT id FROM person WHERE username = 'jdoe')),
    'A'
);

-- Spring 2018
INSERT INTO section (course_id, semester_id, instructor_id, section_letter) 
VALUES
(
    (SELECT id FROM course WHERE program = 'CISS' AND course_number = 245),
    (SELECT id FROM semester WHERE start_date = '2018-01-15'),
    (SELECT id FROM instructor WHERE person_id = (SELECT id FROM person WHERE username = 'yliow')),
    'A'
),
(
    (SELECT id FROM course WHERE program = 'CISS' AND course_number = 350),
    (SELECT id FROM semester WHERE start_date = '2018-01-15'),
    (SELECT id FROM instructor WHERE person_id = (SELECT id FROM person WHERE username = 'yliow')),
    'A'
),
(
    (SELECT id FROM course WHERE program = 'CISS' AND course_number = 430),
    (SELECT id FROM semester WHERE start_date = '2018-01-15'),
    (SELECT id FROM instructor WHERE person_id = (SELECT id FROM person WHERE username = 'yliow')),
    'A'
);

SELECT season.season_name, year.year_value, person.firstname, person.lastname, course.program, course.course_number, section.section_letter, course.course_name
FROM section
JOIN semester ON section.semester_id = semester.id
JOIN year ON semester.year_id = year.id
JOIN season ON semester.season_id = season.id
JOIN course ON section.course_id = course.id
JOIN instructor ON section.instructor_id = instructor.id
JOIN person ON instructor.person_id = person.id
WHERE year.year_value = 2017;
