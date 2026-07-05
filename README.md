# SQL Murder Mystery
Showing how I solved the SQL City murder mystery using SQL queries.
Available at the website: `https://mystery.knightlab.com/`

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

***
# 2. Witnesses interviews:
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
