DROP TABLE IF EXISTS "mimic_insights"."home_ids";
SELECT DISTINCT stay_id
INTO "mimic_insights"."home_ids"
FROM "mimic_insights"."static_attributes_ed_cleaned" sa
WHERE sa.disposition = 'HOME';
-- SELECT 241626 (cases)

DROP TABLE IF EXISTS "mimic_insights"."home_log";
SELECT *
INTO "mimic_insights"."home_log"
FROM "mimic_insights"."ed_tables_los_filtered" edlf
WHERE edlf.stay_id IN (SELECT stay_id FROM "mimic_insights"."home_ids");
-- SELECT 3675508 (events)


DROP TABLE IF EXISTS "mimic_insights"."home_discharge";
SELECT stay_id,outtime
INTO "mimic_insights"."home_discharge"
FROM "mimiciv_ed"."edstays"
WHERE stay_id IN (SELECT stay_id FROM "mimic_insights"."home_ids");
-- SELECT 241626 


DROP TABLE IF EXISTS "mimic_insights"."admitted_ids";
SELECT DISTINCT stay_id
INTO "mimic_insights"."admitted_ids"
FROM "mimic_insights"."static_attributes_ed_cleaned" sa
WHERE sa.disposition = 'ADMITTED';
-- SELECT 158010 (cases)


DROP TABLE IF EXISTS "mimic_insights"."admitted_log";
SELECT *
INTO "mimic_insights"."admitted_log"
FROM "mimic_insights"."ed_tables_los_filtered" edlf
WHERE edlf.stay_id IN (SELECT stay_id FROM "mimic_insights"."admitted_ids");
-- SELECT 3474363 (events)


DROP TABLE IF EXISTS "mimic_insights"."admitted_discharge";
SELECT stay_id,outtime
INTO "mimic_insights"."admitted_discharge"
FROM "mimiciv_ed"."edstays"
WHERE stay_id IN (SELECT stay_id FROM "mimic_insights"."admitted_ids");
-- SELECT 158010