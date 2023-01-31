/*
Here names the new schema as "mimic_insights" for storing the temp table and event log tables. 
Also, the schema names for `ed` module is "mimic_ed"

If you have different schema names, please change code below.
*/

CREATE SCHEMA IF NOT EXISTS "mimic_insights";

/*
Extract three id in ed tables
*/

DROP TABLE IF EXISTS "mimic_insights"."ed_ids";
SELECT DISTINCT subject_id, hadm_id, stay_id
INTO TABLE "mimic_insights"."ed_ids"
FROM "mimiciv_ed"."edstays";
