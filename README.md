# CodeTricks
Useful R and SAS code/functions for the analysis of insurance claims data. Each script is an illustrative example of a technique.


##### **R**

  - **accumulate.R** This is an application of the accumulate() function from the purrr packagethat creates a cumulative variable (often of time) that resets after a certain amount of time has passed. Originally used to indicate birth-related encounters that were 6 months apart.


##### **SAS**
 - **proc_sql_into** This script extracts a variable from a data set and turns it into a macro variable. Originally used when we had an indicator that a medication/code was used for a certain reason in one data set and we wanted to search another data set to just observations with those same codes.
