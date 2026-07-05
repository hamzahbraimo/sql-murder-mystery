# SQL Murder Mystery
Showing how I solved the SQL City murder mystery using SQL queries.
Available at the website: https://mystery.knightlab.com/

***
# About
In this website you can learn SQL having fun and practicing with the murder case, by just using queries. But you can also skip to the murder scene if you're already comfortable with SQL

***
# Exploring the database
Before jumping, let's see how the schema is structured:

<img width="815" height="399" alt="image" src="https://github.com/user-attachments/assets/61d1419e-2212-4b99-91dd-a31c100e59ef" />

We can see key tables here as `interview` and `crime_scene_report`. For more info., just check the queries located on the directory `queries/query01.sql`, where all the queries are stored.

***
# Solving the mystery using queries
# 1. Checking the crime reports
The first step is to check the crime scene reports table using two keywords: `SQL City` and `murder`.

```
SELECT * FROM crime_scene_report
WHERE city LIKE '%SQL%City%'
AND type LIKE '%murder%';
```

Output:
<table>
  <tr>
    <th>date</th>
    <th>type</th>
    <th>description</th>
    <th>city</th>
  </tr>
  <tr>
    <td>20180215</td>
    <td>murder</td>
    <td>REDACTED REDACTED REDACTED</td>
    <td>SQL City</td>
  </tr>
  <tr>
    <td>20180215</td>
    <td>murder</td>
    <td>Someone killed the guard! He took an arrow to the knee!D</td>
    <td>SQL City</td>
  </tr>
  <tr>
    <td>20180215</td>
    <td>murder</td>
    <td>Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave".</td>
    <td>SQL City</td>
  </tr>
</table>

We can see that the last row has some useful information, so far we have two witnesses.


# 2. Finding the witnesses:
The first witness lives at the last house on "Northwestern Dr".

```
SELECT
	name,
	address_number,
	address_street_name
FROM person
WHERE address_street_name LIKE '%Northwestern%Dr%'
ORDER BY address_number DESC
LIMIT 1;
```

Output:
<table>
  <tr>
    <th>name</th>
    <th>address_number</th>
    <th>address_street_name</th>
  </tr>
  <tr>
    <td>Morty Schapiro</td>
    <td>4919</td>
    <td>Northwestern Dr</td>
  </tr>
</table>

The second witness, named Annabel, lives somewhere on "Franklin Ave".
```
SELECT
	name,
	address_number,
	address_street_name
FROM person
WHERE Name LIKE '%Annabel%M%ller%';
```

Output:
<table>
  <tr>
    <th>name</th>
    <th>address_number</th>
    <th>address_street_name</th>
  </tr>
  <tr>
    <td>Annabel Miller</td>
    <td>103</td>
    <td>Franklin Ave</td>
  </tr>
</table>


# 3. Interviewing the witnesses:
```
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
```

Output:
<table>
	<tr>
		<th>name</th>
		<th>transcript</th>
	</tr>
	<tr>
		<td>Morty Schapiro</td>
		<td>
			I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".
		</td>
	</tr>
	<tr>
		<td>Annabel Miller</td>
		<td>
			I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.
		</td>
	</tr>
</table>


# 4. New suspect(s):
Going for each element reported, `Morty` saw a car plate that included `'H42W'`.

```
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
```

Output:
<table>
	<tr>
		<th>name</th>
		<th>plate_number</th>
	</tr>
	<tr>
		<td>Tushar Chandra</td>
		<td>4H42WR</td>
	</tr>
	<tr>
		<td>Jeremy Bowers</td>
		<td>0H42W2</td>
	</tr>
	<tr>
		<td>Maxine Whitely</td>
		<td>H42W0X</td>
	</tr>
</table>


Going now for the membership number:
```
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
```

Output:
<table>
	<tr>
		<th>id</th>
		<th>name</th>
	</tr>
	<tr>
		<td>48Z38</td>
		<td>Tomas Baisley</td>
	</tr>
	<tr>
		<td>48Z7A</td>
		<td>Joe Germuska</td>
	</tr>
	<tr>
		<td>48Z55</td>
		<td>Jeremy Bowers</td>
	</tr>
</table>

Merging both `JOIN`'s, adding the date reported by `Annabel`:
```
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
```

Output:
<table>
	<tr>
		<th>name</th>
		<th>check_in_date</th>
		<th>plate_number</th>
	</tr>
	<tr>
		<td>Jeremy Bowers</td>
		<td>20180109</td>
		<td>0H42W2</td>
	</tr>
</table>

We can see that the only person that fits the whole description is `Jeremy Bowers`. He's the new suspect.


# 5. Interviewing Jeremy:
```
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
```

Output:
<table>
	<tr>
		<th>name</th>
		<th>transcript</th>
	</tr>
	<tr>
		<td>Jeremy Bowers</td>
		<td>
			I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.
		</td>
	</tr>
</table>

Seems like `Jeremy` is the murderer, yet we have to find the brain behind this, given the description.


# 6. Finding the woman:
```
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
```

Output:
<table>
	<tr>
		<th>license_id</th>
		<th>name</th>
		<th>height</th>
		<th>hair_color</th>
		<th>car_make</th>
		<th>car_model</th>
	</tr>
	<tr>
		<td>918773</td>
		<td>Red Korb</td>
		<td>65</td>
		<td>red</td>
		<td>Tesla</td>
		<td>Model S</td>
	</tr>
	<tr>
		<td>291182</td>
		<td>Regina George</td>
		<td>66</td>
		<td>red</td>
		<td>Tesla</td>
		<td>Model S</td>
	</tr>
	<tr>
		<td>202298</td>
		<td>Miranda Priestly</td>
		<td>68</td>
		<td>red</td>
		<td>Tesla</td>
		<td>Model S</td>
	</tr>
</table>


# 7. Interviewing the three women:
```
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
```

Output:
<table>
	<tr>
		<th>name</th>
		<th>transcipt</th>
	</tr>
	<tr>
		<td>Red Korb</td>
		<td>null</td>
	</tr>
	<tr>
		<td>Regina George</td>
		<td>null</td>
	</tr>
	<tr>
		<td>Miranda Priestly</td>
		<td>null</td>
	</tr>
</table>

In the `interview` table there's nothing associated to any of these women, so let's keep digging using what `Jeremy` has reported.


# 8. Recalling the notes from Jeremy:
Annual income from each suspect:
```
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
```

Output:
<table>
	<tr>
		<th>name</th>
		<th>annual_income</th>
	</tr>
	<tr>
		<td>Miranda Priestly</td>
		<td>310000</td>
	</tr>
	<tr>
		<td>Red Korb</td>
		<td>278000</td>
	</tr>
	<tr>
		<td>Regina George</td>
		<td>null</td>
	</tr>
</table>

We can see that `Regina` fits every description except having a lot of money, so the number of suspects is down to 2 now.

SQL Symphony Concert:
```
SELECT
	p.name,
	fb.date
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
```

Output:
<table>
	<tr>
		<th>name</th>
		<th>date</th>
	</tr>
	<tr>
		<td>Miranda Priestly</td>
		<td>20171206</td>
	</tr>
	<tr>
		<td>Miranda Priestly</td>
		<td>20171212</td>
	</tr>
	<tr>
		<td>Miranda Priestly</td>
		<td>20171229</td>
	</tr>
</table>

or if using subqueries (using a CTE):
```
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
```

Output:
<table>
	<tr>
		<th>name</th>
		<th>total_times</th>
	</tr>
	<tr>
		<td>Miranda Priestly</td>
		<td>3</td>
	</tr>
</table>

We can see that anyways, everything points to `Miranda Priestly`, she is the brain behind the murder.


# 9. Solution:
Queries to find the killer:
```
INSERT INTO solution VALUES (1, 'Jeremy Bowers');
        
SELECT value FROM solution;
```


Queries to find the brains:
```
INSERT INTO solution VALUES (1, 'Miranda Priestly');
        
SELECT value FROM solution;
```

***
# Concepts:
- `JOINs`
- `SUBQUERIES`
- `WHERE`
- `GROUP BY`
- `ORDER BY`
- `Aggregate functions`
