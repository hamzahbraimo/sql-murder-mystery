-- INTERVIEW TO THE THREE NEW SUSPECTS
SELECT
	p.name,
	i.transcript
FROM (
	SELECT
  		id,
		name
	FROM person
 	WHERE name IN('Red Korb', 'Regina George', 'Miranda Priestly')
) AS p
LEFT JOIN (
	SELECT * FROM interview
) AS i
ON p.id = i.person_id;

-- name	transcript
-- Red Korb	null
-- Regina George	null
-- Miranda Priestly	null