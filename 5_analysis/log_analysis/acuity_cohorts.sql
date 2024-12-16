/* Analysis */
/* Cohorts with different acuity levels*/

---- Cohort with acuity level = 1 ---------------
DROP TABLE IF EXISTS "mimic_filtered"."acuity_1_ids";
SELECT saf.stay_id
INTO "mimic_filtered"."acuity_1_ids"
FROM "mimic_insights"."static_attributes_ed_cleaned" saf
WHERE acuity= 1;
-- SELECT 24013

DROP TABLE IF EXISTS "mimic_filtered"."acuity_1";
SELECT etlf.*
INTO "mimic_filtered"."acuity_1"
FROM "mimic_insights"."ed_tables_los_filtered" etlf
WHERE stay_id IN (SELECT stay_id FROM "mimic_filtered"."acuity_1_ids");
-- SELECT 525592



---- Cohort with acuity level = 2 ---------------
DROP TABLE IF EXISTS "mimic_filtered"."acuity_2_ids";
SELECT saf.stay_id
INTO "mimic_filtered"."acuity_2_ids"
FROM "mimic_insights"."static_attributes_ed_cleaned" saf
WHERE acuity= 2;
-- SELECT 139403

DROP TABLE IF EXISTS "mimic_filtered"."acuity_2";
SELECT etlf.*
INTO "mimic_filtered"."acuity_2"
FROM "mimic_insights"."ed_tables_los_filtered" etlf
WHERE stay_id IN (SELECT stay_id FROM "mimic_filtered"."acuity_2_ids");
-- SELECT 2884474



---- Cohort with acuity level = 3 ---------------
DROP TABLE IF EXISTS "mimic_filtered"."acuity_3_ids";
SELECT saf.stay_id
INTO "mimic_filtered"."acuity_3_ids"
FROM "mimic_insights"."static_attributes_ed_cleaned" saf
WHERE acuity= 3;
-- SELECT 225045

DROP TABLE IF EXISTS "mimic_filtered"."acuity_3";
SELECT etlf.*
INTO "mimic_filtered"."acuity_3"
FROM "mimic_insights"."ed_tables_los_filtered" etlf
WHERE stay_id IN (SELECT stay_id FROM "mimic_filtered"."acuity_3_ids");
-- SELECT 3685834



---- Cohort with acuity level = 4 ---------------
DROP TABLE IF EXISTS "mimic_filtered"."acuity_4_ids";
SELECT saf.stay_id
INTO "mimic_filtered"."acuity_4_ids"
FROM "mimic_insights"."static_attributes_ed_cleaned" saf
WHERE acuity= 4;
-- SELECT 28496

DROP TABLE IF EXISTS "mimic_filtered"."acuity_4";
SELECT etlf.*
INTO "mimic_filtered"."acuity_4"
FROM "mimic_insights"."ed_tables_los_filtered" etlf
WHERE stay_id IN (SELECT stay_id FROM "mimic_filtered"."acuity_4_ids");
-- SELECT 284767




---- Cohort with acuity level = 5 ---------------
DROP TABLE IF EXISTS "mimic_filtered"."acuity_5_ids";
SELECT saf.stay_id
INTO "mimic_filtered"."acuity_5_ids"
FROM "mimic_insights"."static_attributes_ed_cleaned" saf
WHERE acuity= 5;
-- SELECT 1095

DROP TABLE IF EXISTS "mimic_filtered"."acuity_5";
SELECT etlf.*
INTO "mimic_filtered"."acuity_5"
FROM "mimic_insights"."ed_tables_los_filtered" etlf
WHERE stay_id IN (SELECT stay_id FROM "mimic_filtered"."acuity_5_ids");
-- SELECT 8747




---- Cohort with acuity level is null ---------------
DROP TABLE IF EXISTS "mimic_filtered"."acuity_null_ids";
SELECT saf.stay_id
INTO "mimic_filtered"."acuity_null_ids"
FROM "mimic_insights"."static_attributes_ed_cleaned" saf
WHERE acuity is null;
-- SELECT 6976

DROP TABLE IF EXISTS "mimic_filtered"."acuity_null";
SELECT etlf.*
INTO "mimic_filtered"."acuity_null"
FROM "mimic_insights"."ed_tables_los_filtered" etlf
WHERE stay_id IN (SELECT stay_id FROM "mimic_filtered"."acuity_null_ids");
-- SELECT 98829