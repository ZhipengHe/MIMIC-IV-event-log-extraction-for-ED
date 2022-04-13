
/*
Split mimic_ed.edstays to Activity 
- Enter the ED
- Discharge from the ED
*/

DROP TABLE IF EXISTS "mimic_insights"."ed_edstays_activity_enter";
SELECT subject_id, stay_id, hadm_id, intime AS timestamps, 'Enter the ED' AS activity, 
	gender, CAST(anchor_age AS text), CAST(anchor_year AS text), anchor_year_group
INTO TABLE "mimic_insights"."ed_edstays_activity_enter"
FROM "mimic_insights"."edstays_with_patients"
ORDER BY stay_id;

DROP TABLE IF EXISTS "mimic_insights"."ed_edstays_activity_discharge";
SELECT subject_id, stay_id, hadm_id, outtime AS timestamps, 'Discharge from the ED' AS activity,
    NULL AS gender, NULL AS anchor_age, NULL AS anchor_year, NULL AS anchor_year_group
INTO TABLE "mimic_insights"."ed_edstays_activity_discharge"
FROM "mimic_insights"."edstays_with_patients"
ORDER BY stay_id;


/*
Add diagnosis table to discharge
*/

DROP TABLE IF EXISTS "mimic_insights"."ed_edstays_activity_with_diagnosis";
SELECT *, NULL AS seq_num, NULL AS icd_code, NULL AS icd_version, NULL AS icd_title
INTO TABLE "mimic_insights"."ed_edstays_activity_with_diagnosis"
FROM "mimic_insights"."ed_edstays_activity_enter"
UNION ALL
SELECT dis.subject_id, dis.stay_id, dis.hadm_id, dis.timestamps, 
	CONCAT(dis.activity, ' + diagnosis ', CAST(dia.seq_num AS text)) AS activity,
	dis.gender, dis.anchor_age, dis.anchor_year, dis.anchor_year_group,
	CAST(dia.seq_num AS text), dia.icd_code, CAST(dia.icd_version AS text), dia.icd_title
FROM "mimic_insights"."ed_edstays_activity_discharge" dis
INNER JOIN "mimic_ed"."diagnosis" dia
ON dis.stay_id = dia.stay_id
ORDER BY stay_id, timestamps, seq_num;

/*
Add activity to mimic_ed.triage
*/

DROP TABLE IF EXISTS "mimic_insights"."ed_triage_activity";
SELECT e.stay_id, e.subject_id, (e.intime + interval '1' second) AS timestamps, 'Triage in the ED' AS activity, 
    temperature, heartrate, resprate, o2sat, sbp, dbp, pain, acuity, chiefcomplaint
INTO TABLE "mimic_insights"."ed_triage_activity"
FROM "mimic_ed"."triage" t
INNER JOIN "mimic_ed"."edstays" e
    ON e.stay_id = t.stay_id;


/*
Add activity to mimic_ed.vitalsign
*/

DROP TABLE IF EXISTS "mimic_insights"."ed_vitalsign_activity";
SELECT e.stay_id, e.subject_id, charttime AS timestamps, 'Vital sign check' AS activity, 
    temperature, heartrate, resprate, o2sat, sbp, dbp, pain, rhythm
INTO TABLE "mimic_insights"."ed_vitalsign_activity"
FROM "mimic_ed"."vitalsign" v
INNER JOIN "mimic_ed"."edstays" e
    ON e.stay_id = v.stay_id;

/*
Add activity to mimic_ed.medrecon
*/

DROP TABLE IF EXISTS "mimic_insights"."ed_medrecon_activity";
SELECT e.stay_id, e.subject_id, charttime AS timestamps, 'Medicine reconciliation' AS activity,
    name, gsn, ndc, etc_rn, etccode, etcdescription
INTO TABLE "mimic_insights"."ed_medrecon_activity"
FROM "mimic_ed"."medrecon" m
INNER JOIN "mimic_ed"."edstays" e
    ON e.stay_id = m.stay_id;

/*
Add activity to mimic_ed.pyxis
*/

DROP TABLE IF EXISTS "mimic_insights"."ed_pyxis_activity";
SELECT e.stay_id, e.subject_id, charttime AS timestamps, 'Medicine dispensations' AS activity,
    name, gsn, med_rn, gsn_rn
INTO TABLE "mimic_insights"."ed_pyxis_activity"
FROM "mimic_ed"."pyxis" p
INNER JOIN "mimic_ed"."edstays" e
    ON e.stay_id = p.stay_id;


DROP TABLE IF EXISTS "mimic_insights"."edstays_with_patients_admissions_transfers";
SELECT DISTINCT tc.stay_id, tc.subject_id, tc.hadm_id, tc.intime, tc.outtime, ad.admittime, ad.dischtime, ad.edregtime, ad.edouttime, ad.deathtime
INTO "mimic_insights"."edstays_with_patients_admissions_transfers"
FROM "mimic_insights"."edstays_with_patients" tc
INNER JOIN "mimic_core"."transfers" tr
	ON tc.subject_id = tr.subject_id AND tc.hadm_id = tr.hadm_id
INNER JOIN "mimic_core"."admissions" ad
	ON tc.subject_id = ad.subject_id AND tc.hadm_id = ad.hadm_id;

/*
transfer table
*/
DROP TABLE IF EXISTS "mimic_insights"."ed_transfer_table";
SELECT subject_id, hadm_id, transfer_id, intime AS timestamps, eventtype AS activity, eventtype, careunit
INTO TABLE "mimic_insights"."ed_transfer_table"
FROM "mimic_core"."transfers"
WHERE subject_id IN (
    SELECT DISTINCT subject_id
    FROM "mimic_insights"."edstays_with_patients_admissions_transfers"
);

DROP TABLE IF EXISTS "mimic_insights"."ed_transfer_table_simple";
SELECT subject_id, hadm_id, transfer_id, timestamps, 'Admit to the care unit' AS activity, eventtype, careunit
INTO "mimic_insights"."ed_transfer_table_simple"
FROM "mimic_insights"."ed_transfer_table"
WHERE eventtype = 'admit'
UNION ALL
SELECT subject_id, hadm_id, transfer_id, timestamps, 'Intra-hospital transfer' AS activity, eventtype, careunit
FROM "mimic_insights"."ed_transfer_table"
WHERE eventtype = 'transfer'
UNION ALL
SELECT subject_id, hadm_id, transfer_id, timestamps, 'Leave the hospital' AS activity, eventtype, careunit
FROM "mimic_insights"."ed_transfer_table"
WHERE eventtype = 'discharge';



/*
Admision table
*/

DROP TABLE IF EXISTS "mimic_insights"."ed_admission_table";
SELECT subject_id, hadm_id, admittime AS timestamps, 'Admit to the hospital' AS activity, admission_type, admission_location, discharge_location, insurance, language, marital_status, ethnicity, hospital_expire_flag 
INTO TABLE "mimic_insights"."ed_admission_table"
FROM "mimic_core"."admissions"
WHERE subject_id IN (
    SELECT DISTINCT subject_id 
    FROM "mimic_insights"."edstays_with_patients_admissions_transfers"
)
UNION ALL
SELECT subject_id, hadm_id, dischtime AS timestamps, 'Discharge from the hospital' AS activity, admission_type, admission_location, discharge_location, insurance, language, marital_status, ethnicity, hospital_expire_flag 
FROM "mimic_core"."admissions"
WHERE subject_id IN (
    SELECT DISTINCT subject_id 
    FROM "mimic_insights"."edstays_with_patients_admissions_transfers"
)
UNION ALL
SELECT subject_id, hadm_id, edregtime AS timestamps, 'Register in the ED' AS activity, admission_type, admission_location, discharge_location, insurance, language, marital_status, ethnicity, hospital_expire_flag 
FROM "mimic_core"."admissions"
WHERE (subject_id,hadm_id) IN (
	SELECT DISTINCT fc.subject_id, fc.hadm_id
		FROM "mimic_insights"."edstays_with_patients_admissions_transfers" fc
		WHERE intime != edregtime
)
UNION ALL
SELECT subject_id, hadm_id, edouttime AS timestamps, 'Leave the ED' AS activity, admission_type, admission_location, discharge_location, insurance, language, marital_status, ethnicity, hospital_expire_flag 
FROM "mimic_core"."admissions"
WHERE (subject_id,hadm_id) IN (
	SELECT DISTINCT fc.subject_id, fc.hadm_id
		FROM "mimic_insights"."edstays_with_patients_admissions_transfers" fc
		WHERE outtime != edouttime
)
UNION ALL
SELECT subject_id, hadm_id, deathtime AS timestamps, 'In-hospital mortality' AS activity, admission_type, admission_location, discharge_location, insurance, language, marital_status, ethnicity, hospital_expire_flag 
FROM "mimic_core"."admissions"
WHERE subject_id IN (
    SELECT DISTINCT subject_id 
    FROM "mimic_insights"."edstays_with_patients_admissions_transfers" 
	WHERE deathtime IS NOT NULL
);

