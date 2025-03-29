-- recursion.sql




use playground;

-- drop table if exists input;
-- create table input (
-- 			 n int
-- );

-- INSERT INTO input (n) VALUES (49);

-- CTE with recursion
-- with recursive T(n, i, d)
-- as (
-- 	 select (SELECT n from input WHERE n = 49),2,0
-- 	 union all
-- 	 select n,i+1,(case when n%(i+1) = 0 then 1 else 0 end) from T where i*i < (n-1)
-- ) select * from T WHERE D=1;


-- WITH RECURSIVE T(f, t, step, path_found)
-- AS (
-- 	 SELECT ('Raider Camp'), (SELECT to_ FROM Flights WHERE from_ = 'Raider Camp'), 0, 'FALSE'
-- 	 UNION ALL
-- 	 SELECT t, (SELECT to_ FROM Flights WHERE from_ = t), step+1,(CASE WHEN ((SELECT to_ FROM Flights WHERE from_ = t) = 'Rebel Depot') THEN 'TRUE' ELSE 'FALSE' END) FROM T WHERE step < 10 AND (SELECT COUNT(to_) FROM Flights WHERE from_ = t) > 0
-- ) SELECT step AS steps_to_take from T WHERE path_found = 'TRUE';



drop table IF EXISTS edges;
create table edges
(
	end varchar(5),
	start varchar(5)
);

insert into edges value
('a', NULL),
('b', 'a'),
('c', 'a'),
('d', 'b'),
('e', 'd'),
('f', 'd'),
('f', 'c');


WITH RECURSIVE PATHS (end_, path_) AS
(
	SELECT end_, convert(end_, varchar(256))
	FROM edges
	WHERE start_ = NULL
	UNION ALL
	SELECT e.end_, concat(p.path_, ',', e.end_)
	FROM paths as p, edges as e
	WHERE p.end_ e.start_
) SELECT * FROM paths;
