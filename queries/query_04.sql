-- Witnesses: Morty and Annabel

-- GOING FOR THE LICENSE PLATE
SELECT
    p.name,
    dl.plate_number
FROM (
	SELECT
        id,
         plate_number
  	FROM drivers_license
  	WHERE plate_number LIKE '%H42W%'
) AS dl

JOIN (
	SELECT
        id,
        name,
        license_id
  	FROM person
) AS p

ON p.license_id = dl.id

-- name	plate_number
-- Tushar Chandra	4H42WR
-- Jeremy Bowers	0H42W2
-- Maxine Whitely	H42W0X



-- GOING FOR MEMBERSHIP NUMBER
SELECT gm.id, p.name
FROM (
	SELECT
        id,
        name,
        license_id
  	FROM person
) AS p

JOIN (
	SELECT
        id,
        person_id
  	FROM get_fit_now_member
  	WHERE id LIKE '48Z%' 
) AS gm
ON p.id = gm.person_id

-- id	name
-- 48Z38	Tomas Baisley
-- 48Z7A	Joe Germuska
-- 48Z55	Jeremy Bowers

-- COMPLETE JOIN (WITH DATE INCLUDED)
SELECT
	p.name,
	chk.check_in_date,
	dl.plate_number
FROM (
	SELECT id, plate_number
  	FROM drivers_license
  	WHERE plate_number LIKE '%H42W%'
) AS dl

JOIN (
	SELECT id, name, license_id
  	FROM person
  	WHERE name IN ('Jeremy Bowers', 'Joe Germuska') 
) AS p
ON dl.id = p.license_id

JOIN (
	SELECT id, person_id
  	FROM get_fit_now_member
) AS gm
ON p.id = gm.person_id

JOIN (
	SELECT membership_id, check_in_date
  	FROM get_fit_now_check_in
  	WHERE check_in_date LIKE '%0109'
) AS chk
ON chk.membership_id = gm.id


-- name	check_in_date	plate_number
-- Jeremy Bowers	20180109	0H42W2