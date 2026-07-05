-- Schema exploration

-- TABLE person
SELECT * FROM person
LIMIT 20;

-- TABLE interview
SELECT * FROM interview
WHERE LEN(transcript) > 1; -- in this case, this is the same as saying WHERE transcript IS NOT NULL

-- TABLE crime_scene_report
SELECT * FROM crime_scene_report;