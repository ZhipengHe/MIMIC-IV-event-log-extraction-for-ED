# %% [markdown]
# ## MIMIC-IV EventLog Curation
# 1. import CSV into pandas dataframe
# 2. convert processed dataframe to event log structure by `pm4py`
# 3. export event log to XES file by `pm4py`

# %%
# import required library
import os
import pm4py
import numpy as np
import pandas as pd
from pm4py.objects.log.util import dataframe_utils
from pm4py.objects.conversion.log import converter as log_converter
from pm4py.objects.log.exporter.xes import exporter as xes_exporter

# %% [markdown]
# ### Import CSV log into pandas dataframe
# Please change the path for your CSV file below.

# %%
csv_file_path = "mimicel.csv.gz" # or "your_file_path_here.csv"

# log_csv = pd.read_csv(csv_file_path, sep=',')
log_csv = pd.read_csv(csv_file_path, sep=',', compression='gzip', header=0)

# %%
log_csv.head(20)

# %% [markdown]
# ### Process the dataframe and convert it to `pm4py` event log structure
# The default attributes in `pm4py` package:
# 
# - Case ID --> case:concept:name
# - Activity --> concept:name
# - Timestamps --> time:timestamp
# - Case attributes -->  start with `case:`

# %%
# rename some attributes name
log_csv.rename(columns=
    {
        # Standardization for CaseID, activity and timestamp
        'stay_id':'case:concept:name',
        'activity':'concept:name',
        'timestamps':'time:timestamp', 

        # Standardization for Case attributes
        'subject_id': 'case:subject_id', 
        'hadm_id':'case:hadm_id', 
        'acuity': 'case:acuity', 
        'chiefcomplaint': 'case:chiefcomplaint',
        
        # new case attributes
        'gender': 'case:gender',
        'race': 'case:race',
    }, inplace=True)

# %% [markdown]
# `pm4py` will select values in the first row of each case for case attributes. Thus, we need fill in rows with empty case attribute
# 
# For example: `case:acuity`, `case:chiefcomplaint`

# %%
log_csv['case:acuity'] = log_csv.groupby('case:concept:name')['case:acuity'].transform(lambda v: v.ffill().bfill())
log_csv['case:chiefcomplaint'] = log_csv.groupby('case:concept:name')['case:chiefcomplaint'].transform(lambda v: v.ffill().bfill())
log_csv['case:gender'] = log_csv.groupby('case:concept:name')['case:gender'].transform(lambda v: v.ffill().bfill())
log_csv['case:race'] = log_csv.groupby('case:concept:name')['case:race'].transform(lambda v: v.ffill().bfill())

# %% [markdown]
# `pm4py` has built-in fuctions for transforming the data type of timestamp in the dataframe.
# 
# Function `pm4py.objects.log.util.dataframe_utils.convert_timestamp_columns_in_df`
# 
# When using this function, make sure that the column name of timestamp is `timestamp`.

# %%
log_csv = dataframe_utils.convert_timestamp_columns_in_df(log_csv)
log_csv = log_csv.sort_values('time:timestamp')

# %%
# check the first 20 rows
log_csv.head(20)

# %% [markdown]
# ### Export event log data to XES file
# 
# The default export setting for exporting XES file requires using the default column name of case id `case:concept:name`. But you can use parameters to specify a different name.

# %%
dataframe = log_csv.head(200000)

event_log_selected = log_converter.apply(dataframe, variant=log_converter.Variants.TO_EVENT_LOG)

# %%
xes_file_path = "mimicel-test.xes"
xes_exporter.apply(event_log_selected, xes_file_path, parameters={xes_exporter.Variants.ETREE.value.Parameters.COMPRESS: True})

# %%
# # You can set parameters for using different column name of case id
# parameters = {log_converter.Variants.TO_EVENT_LOG.value.Parameters.CASE_ID_KEY: 'case:stay_id'}
# event_log = log_converter.apply(log_csv, parameters=parameters, variant=log_converter.Variants.TO_EVENT_LOG)

# default usage
event_log = log_converter.apply(log_csv, variant=log_converter.Variants.TO_EVENT_LOG)

# %%
xes_file_path = "mimicel.xes" # or "your_file_path_here.xes"
xes_exporter.apply(event_log, xes_file_path, parameters={xes_exporter.Variants.ETREE.value.Parameters.COMPRESS: True})

# %%



