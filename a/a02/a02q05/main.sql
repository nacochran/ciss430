/**
* Instructions:
* Tom Smith (a student) has decided to register for CISS430A.
* Design table(s) to allow students to register for classes.
* Write SQL statements (in your main.sql) to create enough
tables to handle registrations, add Tom Smith, and add Tom Smith to the CISS430A class.
* Write an SQL statement that prints Tom Smith and all his classes
**/

USE cms;

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





