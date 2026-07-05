SELECT * FROM crime_scene_report
WHERE city LIKE '%SQL%City%'
	AND type LIKE '%murder%';


-- Security footage shows that there were 2 witnesses.

-- The first witness lives at the last house on "Northwestern Dr".
SELECT
	name,
	address_number,
	address_street_name
FROM person
WHERE address_street_name LIKE '%Northwestern%Dr%'
ORDER BY address_number DESC
LIMIT 1;

-- name	address_number	address_street_name
-- Morty Schapiro	4919	Northwestern Dr
              
              

--The second witness, named Annabel, lives somewhere on "Franklin Ave".
SELECT
	name,
	address_number,
	address_street_name
FROM person
WHERE Name LIKE '%Annabel%M%ller%';

-- name	address_number	address_street_name
-- Annabel Miller	103	Franklin Ave