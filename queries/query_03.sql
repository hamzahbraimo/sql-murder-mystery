-- interview to the two witnesses
SELECT
	p.name,
	i.transcript
FROM (
	SELECT
  		id,
		name
	FROM person
 	WHERE name IN ('Morty Schapiro', 'Annabel Miller')
) AS p
JOIN (
	SELECT * FROM interview
) AS i
ON p.id = i.person_id;

-- name	transcript
-- Morty Schapiro	I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".
-- Annabel Miller	I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.