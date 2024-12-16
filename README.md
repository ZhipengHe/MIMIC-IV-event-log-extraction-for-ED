# MIMICEL: MIMIC-IV Event Log for Emergency Department

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> **Note**
> If you encounter trouble when importing XES file into ProM, please check [issue #4](https://github.com/ZhipengHe/MIMIC-IV-event-log-extraction-for-ED/issues/4), we have updated `csv2xes.ipynb` and solved the bugs. Feel free to submit any issue to this project!

## Abstract
In this work, we extract an event log from the MIMIC-IV-ED datasets by adopting an existing event log generation methodology, and we name this event log MIMICEL. The data tables in the existing datasets relate to each other based on the relational database schema and each table records the individual activities of patients along their journey in the emergency department (ED). While the MIMIC-IV-ED datasets catch snapshots of a patient journey in the ED, the extracted event log MIMICEL aims to capture an end-to-end process of the patient journey. This will enable us to analyse the existing patient flows, thereby improving the efficiency of an ED process.
## Prerequisite

1. PostgreSQL >= 11
    Loading MIMIC-IV-ED into a PostgreSQL database, referring to:
    - [MIMIC-IV-ED Loading Scripts](https://github.com/MIT-LCP/mimic-code/tree/main/mimic-iv-ed/buildmimic/postgres)

2. Python >= 3.7,
    Reuqired packages:
    - `pm4py`
    - `pandas`
    - `jupyterlab`


## Usage

### 1. Data Extraction: [1_extarct_eventlog](./1_extract_eventlog/)

This folder contains PostgreSQL scripts for extracting the event log from the MIMIC-IV-ED database and exporting them as CSV files. It includes three SQL scripts:

The SQL scripts are designed for PostgreSQL. If you are using other SQL database, you can adapt them freely under MIT license.

- [1_preprocessing.sql](./1_extract_eventlog/1_preprocessing.sql): preprocessing the `ed` moudle and preparing for converting them to activities with timestamps
- [2_to_activity.sql](./1_extract_eventlog/2_to_activity.sql): converting the processed tables in `ed` module into activity tables
- [3_to_eventlog.sql](./1_extract_eventlog/3_to_eventlog.sql): combining all activity tables into a whole event log

### 2. XES Log Conversion: [2_to_xes](./2_to_xes/)

This part is running on Python environment. Here provides both `.py` and jupyter notebook for converting `.csv` file to `.xes` file.

### 3. Technical Validation: [3_validation](./3_validation/)

This part cooperates R package `DaQAPO` for validating the data quality of event log.

- [data_quality.Rmd](./3_validation/data_quality.Rmd): R markdown file for detecting event log data quality issues, such as missing values, incomplete cases, violations of activity order, etc.
- [data_quality.html](./3_validation/data_quality.html) & [data_quality_revised.html](./3_validation/data_quality_revised.html): the output of `data_quality.Rmd` file. Revised version is the updated version after removing the long long case lists in the output of some evaluation functions. Improved readability.

### 4. Post-processing: [4_post_processing](./4_post_processing/)

A post-processing step was performed to clean the event log further. This step resulted in a cleaned version of the MIMICEL log, facilitated by:

- [4_clean.sql](./1_extract_eventlog/4_clean.sql):  cleaning invalid cases from event log where the intime is not earlier than the outtime. 

### 5. Log Preparation: [5_analysis/log_preparation](./5_analysis/log_preparation/)

Based on the extracted event log, we can perform further analysis by generating insights and filtering the event log using SQL scripts. Then, we can use the filtered event log for further analysis in process mining tools and python environment.

- [5_insights.sql](./4_analysis/5_insights.sql): SQL script for generating insights from the event log, such as the length of stay, static attributes, etc.
- [6_filter.sql](./4_analysis/6_filter.sql): SQL script for filtering the event log based on the insights generated from the previous step, removing events that happen before or have the same timestamp as "Enter the ED".

### 6. Log Analysis: [5_analysis/log_analysis](./5_analysis/log_analysis/)

The cleaned event log was used for further analysis with process mining tools and the Python environment. This analysis focused on:

- [acuity_cohorts.sql](./4_analysis/log_analysis/acuity_cohorts.sql) & [throughput.sql](./4_analysis/log_analysis/throughput.sql): SQL scripts for extracting sublogs by acuity levels and discharge types for further analyses.
- [acuity_LoS.ipynb](./4_analysis/log_analysis/acuity_LoS.ipynb) & [crowdedness.ipynb](./4_analysis/log_analysis/crowdedness.ipynb): Jupyter notebook for further analysis on the filtered event log, such as the relationship between acuity and length of stay, the relationship between crowdedness and length of stay, etc.


## About the dataset

### XES event log

XES is a XML-based format event log. In specific, ``eXtensible Event Stream" (XES) is the standard format for logging events that can be supported by the majority of process mining tools. XES has become an official IEEE standard in 2016. XES maintains the general structure of an event log. In particular, an event log is composed of a set of traces, each containing a sequence of events. In addition, XES records trace-level and event-level attributes and their corresponding values in the event log, as illustrated in the following schema.

```xml
<trace>
    <!-- Trace attributes -->
    <event>
        <!-- Event attributes -->
    </event>
    ...
</trace>
```

In our settings, we use standard name labels in XES standard for CaseID, activity, timestamp and case attributes:

- Case ID --> case:concept:name
- Activity --> concept:name
- Timestamps --> time:timestamp
- Case attributes -->  start with `case:`

When importing XES file into [Disco](https://fluxicon.com/disco/), it might notify the warning about the activity classifier. You can ignore the message since we are using standard classifier.

![1](./assets/Disco_warning.png)

## ChangeLog

Check [CHANGELOG.md](./CHANGELOG.md)