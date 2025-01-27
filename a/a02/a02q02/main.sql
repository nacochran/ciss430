/**
 * File : main.sql
 * Location: a/a02/a02q02
 * Author: Nathan Cochran
**/ 

USE cms;

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


