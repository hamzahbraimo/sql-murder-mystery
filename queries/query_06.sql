SELECT *
FROM (
	SELECT
        license_id,
        name
  	FROM person
) AS p

JOIN (
	SELECT
        id,
        height,
        hair_color,
        car_make,
        car_model
  	FROM drivers_license
  	WHERE gender = 'female'
  		AND hair_color LIKE '%red%'
  		AND (height BETWEEN 65 AND 67)
  		AND car_make LIKE '%Tesla%'
  		AND car_model LIKE '%Model%S%'
) AS dl
ON dl.id = p.license_id

-- license_id	name	id	height	hair_color	car_make	car_model
-- 918773	Red Korb	918773	65	red	Tesla	Model S
-- 291182	Regina George	291182	66	red	Tesla	Model S
-- 202298	Miranda Priestly	202298	66	red	Tesla	Model S