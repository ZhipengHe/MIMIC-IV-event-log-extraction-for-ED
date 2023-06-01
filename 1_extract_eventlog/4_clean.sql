/*
Add 4_clean.sql
1. remove cases of which intime >= outtime - validity
*/

/*
1. Remove cases of which intime >= outtime
*/

DROP TABLE IF EXISTS "mimic_insights"."ed_tables_clean_rule";
SELECT * 
INTO "mimic_insights"."ed_tables_clean_rule"
FROM "mimic_insights"."ed_tables"
WHERE stay_id IN (
    SELECT stay_id
    FROM "mimiciv_ed"."edstays"
    WHERE intime < outtime
)
ORDER BY stay_id, subject_id, hadm_id, timestamps;

