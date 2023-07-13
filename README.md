# CodeTricks
Useful R and SAS code/functions for the analysis of insurance claims data. Each script is an illustrative example of a technique.


##### **R**

  - **time_since_event.R** Creates a variable that represents how much time has
  occurred since the last user-defined (via indicator variable) event took place using data.table's nafill() function. This is particularly useful when there are many observations per patient, but only some of those observations qualify as an event of interest. Original purpose: Calculate the time since an opioid use disorder encounter for OUD patients.

  - **accumulate.R** This is an application of the accumulate() function from the purrr package that creates a cumulative sum variable (often of time) that resets after a certain threshold has been met. Can be used in conjunction with time_since_event.R. Originally used to identify birth-related encounters that were 6 months apart.


##### **SAS**
 - **proc_sql_into** This script extracts a variable from a data set and turns it into a macro variable. Originally used when we had an indicator that a medication code was used for a certain reason in one data set and we wanted to search another data set for observations with those same codes.
- **hash_tables.sas** Explores SAS's hash table functions
- **pcp attribution.sas** Attributes patients (bene_id) to the primary care physician (rfring_npi) they had the most encounters with during a calendar year.
- **continous_enrollment_ident.sas ** Identifies whether patients were continously enrolled in Part A and Part B medicare.
