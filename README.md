# CodeTricks
Useful R and SAS code/functions for the analysis of insurance claims data. Each script is an illustrative example of a technique.


##### **R**

  - **accumulate.R** This is an application of the accumulate() function from the purrr package that creates a cumulative variable (often of time) that resets after a certain amount of time accumulates. Originally used to identify birth-related encounters that were 6 months apart.
  - **time_since_event_dt.R** Creates a variable that represents how much time (days) has
  occurred since the last event takes place using data.table's nafill() function. OG purpose: Calculate the time since an opioid use disorder encounter for OUD patients.

##### **SAS**
 - **proc_sql_into** This script extracts a variable from a data set and turns it into a macro variable. Originally used when we had an indicator that a medication/code was used for a certain reason in one data set and we wanted to search another data set for observations with those same codes.
