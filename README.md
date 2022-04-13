# MIMIC-IV Event Log Extraction for ED

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Abstract
In this work, we extract an event log from the MIMIC-IV-ED and MIMIC-IV Core datasets by adopting an existing event log generation methodology. The data tables in the existing datasets relate to each other based on relational database schema and each table records individual activities of patients along their journey in the emergency department. While the MIMIC-IV dataset captures snapshots of patients journey, the extracted event log aims to capture an end-to-end process of patient journey in the emergency department. This will enable us to analyse the existing patients flow, thereby improving the efficiency of ED process.

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
