/* Add a column 'Los' to cleansed mimicel*/
DROP TABLE IF EXISTS "mimic_insights"."ed_los_cleaned";
SELECT stay_id, (max(timestamps) - min (timestamps)) AS LoS
INTO "mimic_insights"."ed_los_cleaned"
FROM "mimic_insights"."ed_tables_clean_rule"
GROUP BY stay_id;
-- SELECT 425028

-- LoS is counted by minutes
-- EXTRACT(epoch FROM LoS)/60 AS LoS
DROP TABLE IF EXISTS "mimic_insights"."ed_tables_los_cleaned";
SELECT ed.*, (
CASE 
    WHEN ed.activity = 'Discharge from the ED' THEN EXTRACT(epoch FROM edl.LoS)/60
    ELSE NULL
END
) AS LoS
INTO "mimic_insights"."ed_tables_los_cleaned"
FROM "mimic_insights"."ed_tables_clean_rule" ed
INNER JOIN "mimic_insights"."ed_los_cleaned" edl
ON ed.stay_id = edl.stay_id
ORDER BY stay_id, subject_id, hadm_id, timestamps;
-- SELECT 7568824

-- /* extract case attributes in cleaned mimicel*/
DROP TABLE IF EXISTS "mimic_insights"."case_attributes_ed_cleaned";
SELECT ed.stay_id, ed.gender, ed.race, ed.arrival_transport, ed.disposition, (EXTRACT(epoch FROM edl.LoS)/60) AS Los
INTO "mimic_insights"."case_attributes_ed_cleaned"
FROM "mimiciv_ed"."edstays" ed
inner JOIN "mimic_insights"."ed_los_cleaned" edl
ON ed.stay_id = edl.stay_id;
-- -- SELECT 425028

-- /* extract static attributes in cleaned mimicel */
DROP TABLE IF EXISTS "mimic_insights"."static_attributes_ed_cleaned";
SELECT cae.*, tri.acuity
INTO "mimic_insights"."static_attributes_ed_cleaned"
FROM "mimic_insights"."case_attributes_ed_cleaned" cae
inner JOIN "mimiciv_ed"."triage" tri
ON cae.stay_id = tri.stay_id;
-- -- SELECT 425028