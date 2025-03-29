
DROP DATABASE IF EXISTS test;
CREATE DATABASE test;

Use test;

-- Create tables
CREATE TABLE Flights (
			 fno INT AUTO_INCREMENT PRIMARY KEY,
			 from_ VARCHAR(100),
			 to_ VARCHAR(100),
			 distance INT,
			 departs TIME,
			 arrives TIME
);
CREATE TABLE Aircraft (
			 aid INT AUTO_INCREMENT PRIMARY KEY,
			 aname VARCHAR(200),
			 cruisingrange INT
);
CREATE TABLE Certified (
			 eid INT,
			 aid INT,
			 PRIMARY KEY (eid, aid)
);
CREATE TABLE Employee (
			 eid INT AUTO_INCREMENT PRIMARY KEY,
			 ename VARCHAR(200),
			 salary INT
);

-- Insert Data
INSERT INTO Aircraft (aname, cruisingrange)
VALUES
('Flight Crew Shuttle', 3000),
('Ship #1', 2000),
('Ship #2', 3000),
('Ship #3', 1500);

INSERT INTO Employee (ename, salary)
VALUES
('Joe', 130),
('Bob', 80),
('Nate', 130),
('Kayla', 48),
('Ben', 185);

INSERT INTO Flights (from_, to_, distance, departs, arrives) VALUES
('Beggars Canyon', 'Dune Sea Exchange', 2000, '00:00:00', '8:8:24'),
('Raider Camp', 'Location #1', 3000, '00:00:00', '8:8:24'),
('Location #1', 'Location #2', 1500, '00:00:00', '8:8:24'),
('Location #2', 'Rebel Depot', 2000, '00:00:00', '8:8:24');


INSERT INTO Certified (eid, aid) VALUES
((SELECT eid FROM Employee WHERE ename = 'Joe'), (SELECT aid FROM Aircraft WHERE aname = 'Flight Crew Shuttle')),
((SELECT eid FROM Employee WHERE ename = 'Joe'), (SELECT aid FROM Aircraft WHERE aname = 'Ship #1')),
((SELECT eid FROM Employee WHERE ename = 'Joe'), (SELECT aid FROM Aircraft WHERE aname = 'Ship #2')),
((SELECT eid FROM Employee WHERE ename = 'Kayla'), (SELECT aid FROM Aircraft WHERE aname = 'Flight Crew Shuttle')),
((SELECT eid FROM Employee WHERE ename = 'Bob'), (SELECT aid FROM Aircraft WHERE aname = 'Ship #3')),
((SELECT eid FROM Employee WHERE ename = 'Bob'), (SELECT aid FROM Aircraft WHERE aname = 'Ship #2')),
((SELECT eid FROM Employee WHERE ename = 'Ben'), (SELECT aid FROM Aircraft WHERE aname = 'Ship #3')),
((SELECT eid FROM Employee WHERE ename = 'Ben'), (SELECT aid FROM Aircraft WHERE aname = 'Ship #1')),
((SELECT eid FROM Employee WHERE ename = 'Nate'), (SELECT aid FROM Aircraft WHERE aname = 'Ship #1'));


