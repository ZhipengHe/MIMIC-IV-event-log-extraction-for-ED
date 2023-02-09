
/*
Split mimiciv_ed.edstays to Activity 
- Enter the ED
- Discharge from the ED
*/

DROP TABLE IF EXISTS "mimic_insights"."ed_edstays_activity_enter";
SELECT subject_id, stay_id, hadm_id, intime AS timestamps, 'Enter the ED' AS activity, gender, race, arrival_transport,  NULL AS disposition
INTO TABLE "mimic_insights"."ed_edstays_activity_enter"
FROM "mimiciv_ed"."edstays"
ORDER BY stay_id;

DROP TABLE IF EXISTS "mimic_insights"."ed_edstays_activity_discharge";
SELECT subject_id, stay_id, hadm_id, outtime AS timestamps, 'Discharge from the ED' AS activity, NULL AS gender, NULL AS race, NULL AS arrival_transport, disposition
INTO TABLE "mimic_insights"."ed_edstays_activity_discharge"
FROM "mimiciv_ed"."edstays"
ORDER BY stay_id;


/*
Add diagnosis table to discharge
*/

DROP TABLE IF EXISTS "mimic_insights"."ed_edstays_activity_with_diagnosis";
SELECT *, NULL AS seq_num, NULL AS icd_code, NULL AS icd_version, NULL AS icd_title
INTO TABLE "mimic_insights"."ed_edstays_activity_with_diagnosis"
FROM "mimic_insights"."ed_edstays_activity_enter"
UNION ALL
SELECT dis.*, CAST(dia.seq_num AS text), dia.icd_code, CAST(dia.icd_version AS text), dia.icd_title
FROM "mimic_insights"."ed_edstays_activity_discharge" dis
LEFT JOIN "mimiciv_ed"."diagnosis" dia
ON dis.stay_id = dia.stay_id
ORDER BY stay_id, timestamps, seq_num;

/*
Add activity to mimiciv_ed.triage
*/

DROP TABLE IF EXISTS "mimic_insights"."ed_triage_activity";
SELECT e.stay_id, e.subject_id, (e.intime + interval '1' second) AS timestamps, 'Triage in the ED' AS activity, 
    temperature, heartrate, resprate, o2sat, sbp, dbp, pain, acuity, chiefcomplaint
INTO TABLE "mimic_insights"."ed_triage_activity"
FROM "mimiciv_ed"."triage" t
INNER JOIN "mimiciv_ed"."edstays" e
    ON e.stay_id = t.stay_id;


/*
Add activity to mimiciv_ed.vitalsign
*/

DROP TABLE IF EXISTS "mimic_insights"."ed_vitalsign_activity";
SELECT e.stay_id, e.subject_id, charttime AS timestamps, 'Vital sign check' AS activity, 
    temperature, heartrate, resprate, o2sat, sbp, dbp, pain, rhythm
INTO TABLE "mimic_insights"."ed_vitalsign_activity"
FROM "mimiciv_ed"."vitalsign" v
INNER JOIN "mimiciv_ed"."edstays" e
    ON e.stay_id = v.stay_id;

/*
Add activity to mimiciv_ed.medrecon
*/

DROP TABLE IF EXISTS "mimic_insights"."ed_medrecon_activity";
SELECT e.stay_id, e.subject_id, charttime AS timestamps, 'Medicine reconciliation' AS activity,
    name, gsn, ndc, etc_rn, etccode, etcdescription
INTO TABLE "mimic_insights"."ed_medrecon_activity"
FROM "mimiciv_ed"."medrecon" m
INNER JOIN "mimiciv_ed"."edstays" e
    ON e.stay_id = m.stay_id;

/*
Add activity to mimiciv_ed.pyxis
*/

DROP TABLE IF EXISTS "mimic_insights"."ed_pyxis_activity";
SELECT e.stay_id, e.subject_id, charttime AS timestamps, 'Medicine dispensations' AS activity,
    name, gsn, med_rn, gsn_rn
INTO TABLE "mimic_insights"."ed_pyxis_activity"
FROM "mimiciv_ed"."pyxis" p
INNER JOIN "mimiciv_ed"."edstays" e
    ON e.stay_id = p.stay_id;

