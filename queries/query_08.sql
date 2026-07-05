-- REACALLING NOTES FROM SUSPECT Jeremy Bowers

-- ANNUAL INCOME FROM EACH SUSPECT
SELECT
    p.name,
    i.annual_income
FROM (
  SELECT
    ssn, name
  FROM person
  WHERE name IN('Red Korb', 'Regina George', 'Miranda Priestly')
) AS p

LEFT JOIN (
	SELECT ssn, annual_income
  	FROM income
) AS i
ON i.ssn = p.ssn

ORDER BY i.annual_income DESC;

-- name	annual_income
-- Miranda Priestly	310000
-- Red Korb	278000
-- Regina George	null

--  SQL Symphony Concert
SELECT *
FROM (
	SELECT id, name
  	FROM person
  	WHERE name IN ('Red Korb', 'Regina George', 'Miranda Priestly')
) AS p

JOIN (
	SELECT person_id, event_name, date
  	FROM facebook_event_checkin
	WHERE date LIKE '201712%'
) AS fb
ON p.id = fb.person_id

-- id	name	person_id	event_name	date
-- 99716	Miranda Priestly	99716	SQL Symphony Concert	20171206
-- 99716	Miranda Priestly	99716	SQL Symphony Concert	20171212
-- 99716	Miranda Priestly	99716	SQL Symphony Concert	20171229

-- OR IF YOU WANT TO USE SUBQUERIES:
WITH sub_concert AS (
	SELECT
  		p.name,
  		count(event_name) as total_times
	FROM (
		SELECT id, name
		FROM person
		WHERE name IN ('Red Korb', 'Regina George', 'Miranda Priestly')
	) AS p

	JOIN (
		SELECT person_id, event_name, date
		FROM facebook_event_checkin
	  	WHERE event_name LIKE 'SQL Symphony Concert'
	  		AND date LIKE '201712%'
	) AS fb
	ON p.id = fb.person_id
  	GROUP BY p.name
)

SELECT * 
FROM sub_concert
WHERE total_times = 3

-- name	total_times
-- Miranda Priestly	3