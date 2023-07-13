
/* Title: Continuous enrollment identification*/
/* Date:  7/13/2023               */
/* By: Ben Buzzee                 */

/* This bit of code will identify patients that have been continuosly enrolled in medicare
   each year without end state renal disease (ESRD), sourced from the master beneficiaries summary file.
	
   Documentaiton: https://resdac.org/cms-data/files/mbsf-base/data-documentation

  Variables: BENE_ID - beneficary ID
			 BENE_ENROLLMT_REF_YR - Reference year 
	         ESRD_IND - indicator for end-stage renal failure (kidneys)
`			 MDCR_ENTLMT_BUYIN_IND_01 - MDCR_ENTLMT_BUYIN_IND_12


MDCR_ENTLMT_BUYIN_IND_01 values:
Code	Code value
0		Not entitled
1		Part A only
2		Part B only
3		Part A and Part B
A		Part A state buy-in
B		Part B state buy-in
C		Part A and Part B state buy-in

ESRD_IND values:
0 - No
Y - Yes


/* Dummy data */
/* Setup: 5 patients -  patient 1 is not eligible the first year, but is after 2019.
						pt 2 is always eligible,
						pt 3 is eligible with ESRD,
						pt 4 is never eligible
						pt 5 is enrolled in 2020 but not 2021*/
data mbsf;
input bene_id BENE_ENROLLMT_REF_YR ESRD_IND $ MDCR_ENTLMT_BUYIN_IND_01 $ MDCR_ENTLMT_BUYIN_IND_02 $;
datalines;
1 2019 0 0 0
2 2019 0 3 3
1 2020 0 0 3
2 2020 0 3 3
3 2020 Y 3 3
4 2020 0 0 0
5 2020 0 3 0
1 2021 0 3 3
2 2021 0 3 3
3 2021 Y 3 3
4 2021 0 0 0
5 2021 0 5 0
run;

proc print data=mbsf;
run;


data were_enrlld;
	cont_enrlled = 0;
	set mbsf (WHERE=(ESRD_IND NE 'Y'));

	array enrolled [*] MDCR_ENTLMT_BUYIN_IND_01 - MDCR_ENTLMT_BUYIN_IND_02;
 		do i=1 to dim(enrolled);
 			if enrolled [i] = 3 then cont_enrlled = 1;
	end;
run;

proc print data=were_enrlld;
run;

