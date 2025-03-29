-- Common Table Expression


-- CTE
WITH T(n)
AS
(
	SELECT 0
	UNION ALL
	SELECT (n + 1) FROM T where n < 5
) SELECT * FROM T;


-- CTE with recursion
with recursive T(n, step)
as (
	 select 0,1
	 union all
	 select ((n + 1) % 4),step+1 from T where step < 10
) select * from T;
