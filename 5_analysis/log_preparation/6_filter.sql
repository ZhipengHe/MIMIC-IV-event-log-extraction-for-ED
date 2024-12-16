/*
Add 6_filter.sql
Usage notes: for analysis purpose
- Remove events that happen before or have the same timestamp as "Enter the ED"
 
*/
DROP TABLE IF EXISTS "mimic_insights"."ed_tables_los_filtered";
CREATE TABLE "mimic_insights"."ed_tables_los_filtered" as
  SELECT * FROM "mimic_insights"."ed_tables_los_cleaned";  
-- SELECT 7568824

-- SELECT COUNT(DISTINCT stay_id)
-- FROM "mimic_insights"."ed_tables_los_filtered";
-- -- 425028 cases

DELETE FROM "mimic_insights"."ed_tables_los_filtered" edlf
WHERE EXISTS
    (SELECT 1 FROM "mimic_insights"."ed_edstays_activity_enter" i
    WHERE edlf.stay_id = i.stay_id AND i.timestamps - edlf.timestamps >=  INTERVAL '0 DAY' AND edlf.activity != 'Enter the ED');
-- DELETE 80581 events (~1.06% events)

/* Export "mimic_insights"."ed_tables_los_filtered" to a csv file "filtered_mimicel.csv" for the following analyses, use the following command in bash:
    \copy "mimic_insights"."ed_tables_los_filtered" TO 'Your_own_folder_dir\filtered_mimicel.csv' DELIMITER ',' CSV HEADER ENCODING 'utf8';
*/

-- SELECT COUNT(*)
-- FROM "mimic_insights"."ed_tables_los_filtered";
-- -- 7488243 events

-- SELECT COUNT(DISTINCT stay_id)
-- FROM "mimic_insights"."ed_tables_los_filtered";
-- -- 425028 cases
