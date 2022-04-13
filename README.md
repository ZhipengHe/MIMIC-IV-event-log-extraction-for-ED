# MIMIC-IV-EventLog-Curation

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Abstract
 In this work, we extract an event log from the MIMIC-IV-ED and MIMIC-IV Core datasets by adopting an existing event log generation methodology. While such relational database shows explicit patterns and relationships of patient data, it cannot clearly display the overall flow of a patient’s journey through the ED, as well as the patient’s activities and their whereabouts after leaving the ED. The curated event log thus enables us to obtain an overview of the patient's end-to-end process in the emergency department. By analysing the current patient process, the efficiency of the emergency department process can be further improved.

## Prerequisite

1. PostgreSQL >= 11
    Loading MIMIC-IV and MIMIC-IV-ED into a PostgreSQL database, referring to:
    - [MIMIC-IV Loading Scripts](https://github.com/MIT-LCP/mimic-code/tree/main/mimic-iv/buildmimic/postgres)
    - [MIMIC-IV-ED Loading Scripts](https://github.com/MIT-LCP/mimic-code/tree/main/mimic-iv-ed/buildmimic/postgres)

2. Python >= 3.7,
    Reuqired packages:
    - `pm4py`
    - `pandas`
    - `jupyterlab`


## Usage

### [1_extarct_eventlog](./1_extract_eventlog/)

This part is operated by PostgreSQL for extracting the event log from MIMIC-IV database, involving two modules `core` and `ed`.

The SQL scripts are designed for PostgreSQL. If you are using other SQL database, you can adapt them freely under MIT license.

- [1_preprocessing.sql](./1_preprocessing.sql): preprocessing the `core` and `ed` moudle and preparing for converting them to activities with timestamps
- [2_to_activity.sql](./2_to_activity.sql): converting the processed tables in `core` and `ed` modules into activity tables
- [3_to_eventlog.sql](./3_to_eventlog.sql): combining all activity tables into a whole event log

### [2_to_xes](./2_to_xes/)

This part is running on Python environment. Here provides both `.py` and jupyter notebook for converting `.csv` file to `.xes` file.
