/**
 * File : main.sql
 * Location: a/a02/a02q04
 * Author: Nathan Cochran
**/

/**
 * Precondition:
 * Assumes that a02aq01/main.sql, a02aq02/main.sql, a02aq03/main.sql have all been run already.
 **/

USE cms;

-- CREATE TABLES

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

SELECT course.program,course.course_number,section.section_letter,class_meeting.day_of_week,class_meeting.start_time,class_meeting.end_time,building.building_name,room.room_number FROM class
JOIN section ON section.id = class.section_id
JOIN course ON course.id = section.course_id
JOIN instructor ON section.instructor_id = instructor.id
JOIN person ON instructor.person_id = person.id
JOIN semester ON semester.id = section.semester_id
JOIN year ON semester.year_id = year.id
JOIN season ON semester.season_id = season.id
JOIN class_meeting ON class_meeting.class_id = class.id
JOIN room ON class_meeting.room_id = room.id
JOIN building ON room.building_id = building.id
WHERE person.firstname = 'Yihsiang' AND person.lastname = 'Liow' AND season.season_name = 'Spring' AND year.year_value = 2017;
