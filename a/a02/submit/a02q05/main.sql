/**
 * File : main.sql
 * Location: a/a02/a02q05
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

-- CREATE NEW TABLES (for a02q04)

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS building;
DROP TABLE IF EXISTS room;
DROP TABLE IF EXISTS class;
DROP TABLE IF EXISTS class_meeting;
SET FOREIGN_KEY_CHECKS = 1;


CREATE TABLE building (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 building_name VARCHAR(100) NOT NULL
);

CREATE TABLE room (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 room_number VARCHAR(50) NOT NULL,
			 building_id INT NOT NULL,
			 UNIQUE (building_id, room_number),
			 FOREIGN KEY (building_id) REFERENCES building(id)
);

CREATE TABLE class (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 section_id INT NOT NULL,
			 FOREIGN KEY (section_id) REFERENCES section(id)
);

CREATE TABLE class_meeting (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 class_id INT NOT NULL,
			 day_of_week VARCHAR(10) NOT NULL,
			 start_time TIME NOT NULL,
			 end_time TIME NOT NULL,
			 room_id INT NOT NULL,
			 FOREIGN KEY (class_id) REFERENCES class(id),
			 FOREIGN KEY (room_id) REFERENCES room(id)
);

-- INSERT DATA

INSERT INTO building (building_name) VALUES ('Buchanan Hall');

INSERT INTO room (room_number, building_id) VALUES
('104', (SELECT id from building WHERE building_name = 'Buchanan Hall')),
('107', (SELECT id from building WHERE building_name = 'Buchanan Hall')),
('103', (SELECT id from building WHERE building_name = 'Buchanan Hall'));

INSERT INTO class (section_id) 
VALUES 
((SELECT id FROM section WHERE course_id = (
    SELECT id FROM course WHERE program = 'CISS' AND course_number = 240
	)
	AND section_letter = 'A'
	AND semester_id = (
	  SELECT id FROM semester WHERE year_id = (SELECT id FROM year WHERE year_value = 2017) AND season_id = (
		  SELECT id FROM season WHERE season_name = 'Spring'
		)
	)
)),
((SELECT id FROM section WHERE course_id = (SELECT id FROM course WHERE program = 'CISS' AND course_number = 350) AND section_letter = 'A' AND semester_id = (SELECT id FROM semester WHERE year_id = (SELECT id FROM year WHERE year_value = 2017) AND season_id = (SELECT id FROM season WHERE season_name = 'Spring')))),
((SELECT id FROM section WHERE course_id = (SELECT id FROM course WHERE program = 'CISS' AND course_number = 430) AND section_letter = 'A' AND semester_id = (SELECT id FROM semester WHERE year_id = (SELECT id FROM year WHERE year_value = 2017) AND season_id = (SELECT id FROM season WHERE season_name = 'Spring'))));




-- Class Times for CISS240A
INSERT INTO class_meeting (class_id, day_of_week, start_time, end_time, room_id) VALUES
((SELECT id from class WHERE section_id = (SELECT id from section WHERE course_id = (SELECT id from course WHERE program = 'CISS' AND course_number = 240) AND semester_id = (SELECT id FROM semester WHERE year_id = (SELECT id FROM year WHERE year_value = 2017) AND season_id = (SELECT id FROM season WHERE season_name = 'Spring')) AND section_letter = 'A')),
	'Monday',
	'13:00:00',
	'13:50:00',
	(SELECT id from room WHERE room_number = '104' AND building_id = (SELECT id FROM building WHERE building_name = 'Buchanan Hall'))
);
INSERT INTO class_meeting (class_id, day_of_week, start_time, end_time, room_id) VALUES
((SELECT id from class WHERE section_id = (SELECT id from section WHERE course_id = (SELECT id from course WHERE program = 'CISS' AND course_number = 240) AND semester_id = (SELECT id FROM semester WHERE year_id = (SELECT id FROM year WHERE year_value = 2017) AND season_id = (SELECT id FROM season WHERE season_name = 'Spring')) AND section_letter = 'A')),
	'Wednesday',
	'13:00:00',
	'13:50:00',
	(SELECT id from room WHERE room_number = '104' AND building_id = (SELECT id FROM building WHERE building_name = 'Buchanan Hall'))
);
INSERT INTO class_meeting (class_id, day_of_week, start_time, end_time, room_id) VALUES
((SELECT id from class WHERE section_id = (SELECT id from section WHERE course_id = (SELECT id from course WHERE program = 'CISS' AND course_number = 240) AND semester_id = (SELECT id FROM semester WHERE year_id = (SELECT id FROM year WHERE year_value = 2017) AND season_id = (SELECT id FROM season WHERE season_name = 'Spring')) AND section_letter = 'A')),
	'Friday',
	'13:00:00',
	'13:50:00',
	(SELECT id from room WHERE room_number = '104' AND building_id = (SELECT id FROM building WHERE building_name = 'Buchanan Hall'))
);
INSERT INTO class_meeting (class_id, day_of_week, start_time, end_time, room_id) VALUES
((SELECT id from class WHERE section_id = (SELECT id from section WHERE course_id = (SELECT id from course WHERE program = 'CISS' AND course_number = 240) AND semester_id = (SELECT id FROM semester WHERE year_id = (SELECT id FROM year WHERE year_value = 2017) AND season_id = (SELECT id FROM season WHERE season_name = 'Spring')) AND section_letter = 'A')),
	'Tuesday',
	'13:00:00',
	'13:50:00',
	(SELECT id from room WHERE room_number = '107' AND building_id = (SELECT id FROM building WHERE building_name = 'Buchanan Hall'))
);

-- CISS350A
INSERT INTO class_meeting (class_id, day_of_week, start_time, end_time, room_id) VALUES
((SELECT id from class WHERE section_id = (SELECT id from section WHERE course_id = (SELECT id from course WHERE program = 'CISS' AND course_number = 350) AND semester_id = (SELECT id FROM semester WHERE year_id = (SELECT id FROM year WHERE year_value = 2017) AND season_id = (SELECT id FROM season WHERE season_name = 'Spring')) AND section_letter = 'A')),
	'Monday',
	'11:00:00',
	'11:50:00',
	(SELECT id from room WHERE room_number = '103' AND building_id = (SELECT id FROM building WHERE building_name = 'Buchanan Hall'))
);
INSERT INTO class_meeting (class_id, day_of_week, start_time, end_time, room_id) VALUES
((SELECT id from class WHERE section_id = (SELECT id from section WHERE course_id = (SELECT id from course WHERE program = 'CISS' AND course_number = 350) AND semester_id = (SELECT id FROM semester WHERE year_id = (SELECT id FROM year WHERE year_value = 2017) AND season_id = (SELECT id FROM season WHERE season_name = 'Spring')) AND section_letter = 'A')),
	'Wednesday',
	'11:00:00',
	'11:50:00',
	(SELECT id from room WHERE room_number = '103' AND building_id = (SELECT id FROM building WHERE building_name = 'Buchanan Hall'))
);
INSERT INTO class_meeting (class_id, day_of_week, start_time, end_time, room_id) VALUES
((SELECT id from class WHERE section_id = (SELECT id from section WHERE course_id = (SELECT id from course WHERE program = 'CISS' AND course_number = 350) AND semester_id = (SELECT id FROM semester WHERE year_id = (SELECT id FROM year WHERE year_value = 2017) AND season_id = (SELECT id FROM season WHERE season_name = 'Spring')) AND section_letter = 'A')),
	'Friday',
	'11:00:00',
	'11:50:00',
	(SELECT id from room WHERE room_number = '103' AND building_id = (SELECT id FROM building WHERE building_name = 'Buchanan Hall'))
);

-- CISS430A
INSERT INTO class_meeting (class_id, day_of_week, start_time, end_time, room_id) VALUES
((SELECT id from class WHERE section_id = (SELECT id from section WHERE course_id = (SELECT id from course WHERE program = 'CISS' AND course_number = 430) AND semester_id = (SELECT id FROM semester WHERE year_id = (SELECT id FROM year WHERE year_value = 2017) AND season_id = (SELECT id FROM season WHERE season_name = 'Spring')) AND section_letter = 'A')),
	'Monday',
	'9:00:00',
	'9:50:00',
	(SELECT id from room WHERE room_number = '103' AND building_id = (SELECT id FROM building WHERE building_name = 'Buchanan Hall'))
);
INSERT INTO class_meeting (class_id, day_of_week, start_time, end_time, room_id) VALUES
((SELECT id from class WHERE section_id = (SELECT id from section WHERE course_id = (SELECT id from course WHERE program = 'CISS' AND course_number = 430) AND semester_id = (SELECT id FROM semester WHERE year_id = (SELECT id FROM year WHERE year_value = 2017) AND season_id = (SELECT id FROM season WHERE season_name = 'Spring')) AND section_letter = 'A')),
	'Wednesday',
	'9:00:00',
	'9:50:00',
	(SELECT id from room WHERE room_number = '103' AND building_id = (SELECT id FROM building WHERE building_name = 'Buchanan Hall'))
);
INSERT INTO class_meeting (class_id, day_of_week, start_time, end_time, room_id) VALUES
((SELECT id from class WHERE section_id = (SELECT id from section WHERE course_id = (SELECT id from course WHERE program = 'CISS' AND course_number = 430) AND semester_id = (SELECT id FROM semester WHERE year_id = (SELECT id FROM year WHERE year_value = 2017) AND season_id = (SELECT id FROM season WHERE season_name = 'Spring')) AND section_letter = 'A')),
	'Friday',
	'9:00:00',
	'9:50:00',
	(SELECT id from room WHERE room_number = '103' AND building_id = (SELECT id FROM building WHERE building_name = 'Buchanan Hall'))
);

-- New Stuff for a02q05

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS registered_students;
DELETE FROM person;
DELETE FROM student;
SET FOREIGN_KEY_CHECKS = 1;

-- Create registered_students table as a bridge between classes and students, creating a many-to-many relationship between the student and class tables
CREATE TABLE registered_students (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 student_id INT,
			 class_id INT,
			 FOREIGN KEY (student_id) REFERENCES student(id),
			 FOREIGN KEY (class_id) REFERENCES class(id)
);


-- Add student into database
INSERT INTO person (firstname, lastname, username, password)
VALUES
('Tom', 'Smith', 'tom_smith', 'notAGoodPassword');
INSERT INTO student (person_id) VALUES ((SELECT id FROM person WHERE firstname = 'Tom' AND lastname = 'Smith'));

-- Register student into courses
INSERT INTO registered_students (student_id, class_id)
VALUES (
(SELECT id FROM student WHERE person_id = (SELECT id from person WHERE firstname = 'Tom' AND lastname = 'Smith')),
(SELECT id FROM class WHERE section_id = (SELECT id from section WHERE section_letter = 'A' AND course_id = (SELECT id FROM course WHERE program = 'CISS' AND course_number = 430) AND semester_id = (SELECT id FROM semester WHERE year_id = (SELECT id FROM year WHERE year_value = 2017) AND season_id = (SELECT id FROM season WHERE season_name = 'Spring'))))
);

-- Display registered courses
select person.firstname, person.lastname, course.program, course.course_number, section.section_letter FROM registered_students
JOIN student ON student.id = registered_students.student_id
JOIN person ON person.id = student.person_id
JOIN class ON class.id = registered_students.class_id
JOIN section ON section.id = class.section_id
JOIN course ON course.id = section.course_id
JOIN semester ON semester.id = section.semester_id
JOIN year ON year.id = semester.year_id
JOIN season ON season.id = semester.season_id;


