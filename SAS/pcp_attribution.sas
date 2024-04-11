
/* Title: PROC SQL: INTO Examples */
/* Date:  6/29/2023               */
/* By: Ben Buzzee                 */

/* This bit of code will perform primary care physician attribution
  Based on a numer of occurences of a particular code in a given calendar year.

  The data: BENE_ID - beneficary ID
			CLM_FROM_DT - claim date
			ICD_DGNS_CD1-ICD_DGNS_CD25 - codes identifying diagnosis, first is principal diagnosis
			RFRG_NPI - The NPI number that uniquely defines the referring physicians*/

/* Dummy data */

%let pcp_codes = (11111, 22222);

data carrier;
input bene_id clm_from_dt MMDDYY8. ICD_DGNS_CD1 ICD_DGNS_CD2 rfrg_npi;
datalines;
1 01/01/23  33333   11111   10
2 01/02/23	22222	33333	10
1 02/01/23  33333   11111   10
2 03/02/23	22222	33333	10
3 01/03/23	11111	33333	11
4 01/04/23	22222	33333	10
5 01/05/23	33333	33333	11
1 01/06/23	11111	11111	10
2 01/07/23	11111	33333	11
3 01/08/23	22222	33333	10
4 01/09/23	11111	44444	10
5 01/10/23	33333	44444	12
5 07/10/19	33333	11111	12
;
run;



proc print data=carrier;
run;

/* Identify all claims that had a PCP visit diagnosis code */
/* creating pcp_enc indicator*/
data had_pcp_visit; 
set carrier;

/* create time variables and initialize pcp_enc indicator */
year = year(clm_from_dt);
month = month(clm_from_dt);
pcp_enc = 0;

/* Loop rowwoise through diagnosis for each claim
   and indicate if one is a pcp visit */
array diags [*] ICD_DGNS_CD1 - ICD_DGNS_CD2; 
	do i=1 to dim(diags); 
	 if diags[i] IN &pcp_codes then pcp_enc = 1;
end;
if pcp_enc = 0 then delete;
run;

proc print data=had_pcp_visit;
run;

/* count how many visits they had - could substitute claim ID for claim date */
PROC SQL;
create table pcp_enc_counts as select bene_id, rfrg_npi, COUNT(DISTINCT clm_from_dt) as count
from had_pcp_visit
group by bene_id, rfrg_npi;
quit;

proc print data=pcp_enc_counts;
run;

/* Select only the rows where the max count is observed. The rfrg_npi will be their assigned PCP. */
PROC SQL;
create table pcp_assigned as select bene_id, rfrg_npi
from pcp_enc_counts 
group by bene_id, rfrg_npi
having max(count);
quit;

proc print data=pcp_assigned;
run;
