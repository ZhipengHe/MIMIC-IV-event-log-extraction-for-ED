
/*
Combine all activity tables into one event log
- edstay
- triage
- vitalsign
- medrecon
- pyxis
*/


DROP TABLE IF EXISTS "mimic_insights"."ed_tables";
-- edstay 
SELECT fc.stay_id, st.subject_id, fc.hadm_id, st.timestamps, st.activity, st.gender, st.race, st.arrival_transport, st.disposition,
	st.seq_num, st.icd_code, st.icd_version, st.icd_title,
	NULL AS temperature, NULL AS heartrate, NULL AS resprate, NULL AS o2sat, NULL AS sbp, NULL AS dbp, NULL AS pain, NULL AS acuity, NULL AS chiefcomplaint,
    NULL AS rhythm,
    NULL AS name, NULL AS gsn, NULL AS ndc, NULL AS etc_rn, NULL AS etccode, NULL AS etcdescription,
    NULL AS med_rn, NULL AS gsn_rn
INTO "mimic_insights"."ed_tables"
FROM "mimic_insights"."ed_ids" fc
INNER JOIN "mimic_insights"."ed_edstays_activity_with_diagnosis" st
    ON fc.stay_id = st.stay_id
UNION ALL
-- triage 
SELECT fc.stay_id, tr.subject_id, fc.hadm_id, tr.timestamps, tr.activity, NULL AS gender, NULL AS race, NULL AS arrival_transport, NULL AS disposition,
	NULL AS seq_num, NULL AS icd_code, NULL AS icd_version, NULL AS icd_title,
	tr.temperature, tr.heartrate, tr.resprate, tr.o2sat, tr.sbp, tr.dbp, CAST(tr.pain AS text), tr.acuity, tr.chiefcomplaint,
    NULL AS rhythm,
    NULL AS name, NULL AS gsn, NULL AS ndc, NULL AS etc_rn, NULL AS etccode, NULL AS etcdescription,
    NULL AS med_rn, NULL AS gsn_rn
FROM "mimic_insights"."ed_ids" fc
INNER JOIN "mimic_insights"."ed_triage_activity" tr
    ON fc.stay_id = tr.stay_id
UNION ALL 
-- vitalsign 
SELECT fc.stay_id, vt.subject_id, fc.hadm_id, vt.timestamps, vt.activity, NULL AS gender, NULL AS race, NULL AS arrival_transport, NULL AS disposition,
    NULL AS seq_num, NULL AS icd_code, NULL AS icd_version, NULL AS icd_title,
	vt.temperature, vt.heartrate, vt.resprate, vt.o2sat, vt.sbp, vt.dbp, vt.pain, NULL AS acuity, NULL AS chiefcomplaint,
    vt.rhythm,
    NULL AS name, NULL AS gsn, NULL AS ndc, NULL AS etc_rn, NULL AS etccode, NULL AS etcdescription,
    NULL AS med_rn, NULL AS gsn_rn
FROM "mimic_insights"."ed_ids" fc
INNER JOIN "mimic_insights"."ed_vitalsign_activity" vt
    ON fc.stay_id = vt.stay_id
UNION ALL
-- medrecon
SELECT fc.stay_id, med.subject_id, fc.hadm_id, med.timestamps, med.activity, NULL AS gender, NULL AS race, NULL AS arrival_transport, NULL AS disposition,
	NULL AS seq_num, NULL AS icd_code, NULL AS icd_version, NULL AS icd_title,
	NULL AS temperature, NULL AS heartrate, NULL AS resprate, NULL AS o2sat, NULL AS sbp, NULL AS dbp, NULL AS pain, NULL AS acuity, NULL AS chiefcomplaint,
    NULL AS rhythm,
    med.name, med.gsn, med.ndc, CAST(med.etc_rn AS text), med.etccode, med.etcdescription,
    NULL AS med_rn, NULL AS gsn_rn
FROM "mimic_insights"."ed_ids" fc
INNER JOIN "mimic_insights"."ed_medrecon_activity" med
    ON fc.stay_id = med.stay_id
UNION ALL
-- pyxis
SELECT fc.stay_id, py.subject_id, fc.hadm_id, py.timestamps, py.activity, NULL AS gender, NULL AS race, NULL AS arrival_transport, NULL AS disposition,
	NULL AS seq_num, NULL AS icd_code, NULL AS icd_version, NULL AS icd_title,
	NULL AS temperature, NULL AS heartrate, NULL AS resprate, NULL AS o2sat, NULL AS sbp, NULL AS dbp, NULL AS pain, NULL AS acuity, NULL AS chiefcomplaint,
    NULL AS rhythm,
    py.name, py.gsn, NULL AS ndc, NULL AS etc_rn, NULL AS etccode, NULL AS etcdescription,
    CAST(py.med_rn AS text), CAST(py.gsn_rn AS text)
FROM "mimic_insights"."ed_ids" fc
INNER JOIN "mimic_insights"."ed_pyxis_activity" py
    ON fc.stay_id = py.stay_id
ORDER BY stay_id, subject_id, hadm_id, timestamps;


/*
Change the file path for exported CSV data
*/
COPY "mimic_insights"."ed_tables" TO 'your_file_path_here.csv' DELIMITER ',' CSV HEADER;

-- export compressed CSV
-- COPY "mimic_insights"."ed_tables" TO PROGRAM 'gzip > your_file_path_here.csv.gz' DELIMITER ',' CSV HEADER;
