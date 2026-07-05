-- interview to: Jeremy Bowers
SELECT
	p.name,
	i.transcript
FROM (
	SELECT
  		id,
		name
	FROM person
 	WHERE name LIKE '%Jeremy%Bowers%'
) AS p

JOIN (
	SELECT * FROM interview
) AS i
ON p.id = i.person_id;

-- name	transcript
-- Jeremy Bowers	I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.