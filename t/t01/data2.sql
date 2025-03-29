
USE test;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS SupportTickets;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Notes;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE SupportTickets (
			 sid INT AUTO_INCREMENT PRIMARY KEY,
			 email VARCHAR(200),
			 subject VARCHAR(200)
);

CREATE TABLE Employees (
			 eid INT PRIMARY KEY,
			 name VARCHAR(200)
);

CREATE TABLE Notes (
			 nid INT AUTO_INCREMENT PRIMARY KEY,
			 sid INT,
			 eid INT,
			 state INT,
			 note VARCHAR(200),
			 time INT
);


INSERT INTO SupportTickets (email, subject) VALUES
('test_email@gmail.com', 'Question #1'),
('test2_email@gmail.com', 'Question #2'),
('test3_email@gmail.com', 'Question #3');

INSERT INTO Employees (eid, name) VALUES
(3, 'John Doe'),
(97, 'Blake Deere');


INSERT INTO Notes (sid, eid, state, note, time) VALUES
((SELECT sid FROM SupportTickets WHERE subject = 'Question #1'), (SELECT eid FROM Employees WHERE name = 'John Doe'), 0, 'Hey I have a problem X!', 5),
((SELECT sid FROM SupportTickets WHERE subject = 'Question #1'), (SELECT eid FROM Employees WHERE name = 'John Doe'), 0, 'Hurry Up!!!', 6),
((SELECT sid FROM SupportTickets WHERE subject = 'Question #1'), (SELECT eid FROM Employees WHERE name = 'Blake Deere'), 9, 'Here is the solution for X!', 10),
((SELECT sid FROM SupportTickets WHERE subject = 'Question #1'), (SELECT eid FROM Employees WHERE name = 'John Doe'), 0, 'That did not completely fix problem X!', 24),
((SELECT sid FROM SupportTickets WHERE subject = 'Question #1'), (SELECT eid FROM Employees WHERE name = 'Blake Deere'), 9, 'Try this other thing to fix X!', 30),
((SELECT sid FROM SupportTickets WHERE subject = 'Question #1'), (SELECT eid FROM Employees WHERE name = 'John Doe'), 0, 'That still does not fix it!', 45),
((SELECT sid FROM SupportTickets WHERE subject = 'Question #1'), (SELECT eid FROM Employees WHERE name = 'Blake Deere'), 9, 'Our apologies, try this last final solution!', 68);

CREATE TEMPORARY TABLE T1 AS
SELECT N1.sid, N1.note AS N1_note, N1.time AS N1_time, N2.note AS
N2_note, N2.time AS N2_time, N2.time - N1.time AS wait
FROM Notes AS N1
JOIN
Notes AS N2
ON N1.sid = N2.sid
WHERE N1.state = 0
AND N2.state = 9
AND N2.time > N1.time
AND N2.time = (SELECT MIN(N3.time) FROM Notes AS
N3 WHERE N3.time > N1.time AND N3.state = 9);

SELECT * FROM T1;
SELECT SUM(wait) FROM T1;

SELECT * FROM T1;
SELECT SUM(wait) FROM T1;
