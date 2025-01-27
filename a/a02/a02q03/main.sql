/**
 * File : main.sql
 * Location: a/a02/a02q03
 * Author: Nathan Cochran
**/

USE cms;

SELECT season.season_name, year.year_value, person.firstname, person.lastname, course.program, course.course_number, section.section_letter, course.course_name
FROM section
JOIN semester ON section.semester_id = semester.id
JOIN year ON semester.year_id = year.id
JOIN season ON semester.season_id = season.id
JOIN course ON section.course_id = course.id
JOIN instructor ON section.instructor_id = instructor.id
JOIN person ON instructor.person_id = person.id
WHERE year.year_value = 2017;
