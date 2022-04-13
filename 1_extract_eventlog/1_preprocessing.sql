/*
Here names the new schema as "mimic_insights" for storing the temp table and event log tables. 
Also, the schema names for `core` and `ed` modules are "mimic_core" and "mimic_ed"

If you have different schema names, please change code below.
*/

CREATE SCHEMA IF NOT EXISTS "mimic_insights";

/*
Combine edstays table in ED with patients table in CORE
*/

DROP TABLE IF EXISTS "mimic_insights"."ed_subject_id";
SELECT DISTINCT subject_id, hadm_id, stay_id
INTO TABLE "mimic_insights"."ed_subject_id"
FROM "mimic_ed"."edstays";

DROP TABLE IF EXISTS "mimic_insights"."ed_patients";
SELECT *
INTO TABLE "mimic_insights"."ed_patients"
FROM "mimic_core"."patients"
WHERE subject_id IN (
	SELECT DISTINCT subject_id FROM "mimic_ed"."edstays"
);

/*
Calculate the data shifting for each ED stay.

Why?
Addmision table in CORE module only records the age and years of one addmission for each patient,
but each ed stay may from different years.
*/

DROP TABLE IF EXISTS "mimic_insights"."edstays";
SELECT *, EXTRACT(YEAR FROM intime) AS ed_year
INTO TABLE "mimic_insights"."edstays"
FROM "mimic_ed"."edstays";

DROP TABLE IF EXISTS "mimic_insights"."edstays_with_patients_no_shift";
SELECT e.stay_id, e.subject_id, e.hadm_id, p.gender, 
    p.anchor_age, p.anchor_year, p.anchor_year_group, p.dod,
    e.intime, e.outtime, CAST((e.ed_year - p.anchor_year) AS smallint) AS year_diff, 
	CAST(LEFT(p.anchor_year_group, 4) AS smallint) AS anchor_year_group_1,
	CAST(RIGHT(p.anchor_year_group, 4) AS smallint) AS anchor_year_group_2
INTO TABLE "mimic_insights"."edstays_with_patients_no_shift"
FROM "mimic_insights"."edstays" e
INNER JOIN "mimic_core"."patients" p
    ON e.subject_id = p.subject_id
ORDER BY e.stay_id;

DROP TABLE IF EXISTS "mimic_insights"."edstays_with_patients";
SELECT stay_id, subject_id, hadm_id, gender, 
    (anchor_age + year_diff) AS anchor_age, 
	(anchor_year + year_diff) as anchor_year, 
	CONCAT (CAST(anchor_year_group_1 + year_diff AS text), ' - ', CAST(anchor_year_group_2 + year_diff AS text) )AS anchor_year_group, dod,
    intime, outtime
INTO TABLE "mimic_insights"."edstays_with_patients"
FROM "mimic_insights"."edstays_with_patients_no_shift";

