
/* Title: PROC SQL: INTO Examples */
/* Date:  6/29/2023               */
/* By: Ben Buzzee                 */

/* This bit of code will extract the IDs from the small dataset and turn them into an macro
   variable we can use to search other datasets . */

/* Dummy data */
data attendance;
input date mmddyy8. id_num id_char $;
datalines;
10/27/11 1245 1245
10/27/11 4555 4555
10/27/11 1456 1456
10/29/11 4567 4567
10/29/11 1245 1245
10/29/11 4555 4555
10/31/11 1245 1245
10/31/11  787 787
;
run;

proc print data = attendance;
run;

/* For character IDs */
PROC SQL;
SELECT DISTINCT quote(trim(id_char), "'") INTO :CHAR_IDS SEPARATED BY ","
FROM attendance;
quit;

%put (&CHAR_IDS);


/* For numieric IDs */
PROC SQL;
SELECT DISTINCT id_num INTO :NUM_IDS SEPARATED BY ","
FROM attendance;
quit;

%put (&NUM_IDS);
