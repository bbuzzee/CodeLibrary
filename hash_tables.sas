/* Title: Hash Tables       */
/* Date:  6/29/2023         */
/* By:    Ben Buzzee        */


/*You are faced with the straightforward task of adding the plan_desc column from the plans123 dataset to the Members dataset by matching the */
/*values in the column Plan_ID on the Members table to the Plan_ID on the plans123  table. Before hash tables, you */
/*might have used a proc sort and a data step. This would involve sorting the Members dataset, which might */
/*be very large, on a variable that is unlikely to be the desired final sort key—a waste of time and resources. There */
/*are other solutions (see Loren, 2005) but the purpose of this paper is to introduce you to hash tables in a simple */
/*setting. This example does not highlight the reason for using hash tables but it does show how to use them.*/

data members;
input id plan_id $;
datalines;
123		ABC
456		DEF
789		XYZ
1122	XYZ
1455	XYZ
1788	ABC
2121	DEF
2454	ABC
2787	DEF
3120	ABC
3453	DEF
;
run;

data plans123;
input plan_id $ plan_desc $;
datalines;
ABC UMASS HMO
DEF Harvard PPO
WTF MIT PPO
;
run;

/* The name rc is reused and overwritten - the name does not matter. The method being run on the plan object is what matters.
 eof1 = end of dataset 1
 eof2 = end of dataset 2 */
data all; 
 declare Hash Plan (); 					/* declare the Hash table and call it Plan */ 
 	rc = plan.DefineKey ('plan_id'); 	/* identify fields to use as keys */
 	rc = plan.DefineData ('plan_desc'); /* identify fields to use as data */ 
 	rc = plan.DefineDone ();			/* complete hash table definition */

 do until (eof1); 					    /* loop to read records from Plan */
 set plans123 end = eof1; 			    /* eof1 is a numeric variable initialized to 0 and set to 1 when the last observation is read */
  rc = plan.add();						/* add each record of plans_desc to the hash table - no conditions*/
 end;                             

 do until (eof2); 					    /* loop to read records from Members */ 
 set members end = eof2; 
  call missing(plan_desc); 			    /* initialize the variable we intend to fill */
  rc = plan.find (); 					/* lookup each plan_id in hash Plan */ 
 output; 								/* write record to Both */ 
 end;
 stop; 
run;

proc print data=all;
run;


/* Only read out data that has a key in the hash table */

data both (drop=rc); 
 declare Hash Plan (); 					
 	rc = plan.DefineKey ('plan_id'); 	
 	rc = plan.DefineData ('plan_desc'); 
 	rc = plan.DefineDone ();			

 do until (eof1) ; 					    /* loop to read records from Plan */
 set plans_desc end = eof1; 			/* eof1 is a numeric variable that gets set to 1 when the last observation is read */
  rc = plan.add (); 					/* add each record pf plans_desc to the hash table - no conditions */
 end; 

 do until (eof2); 					    /* loop to read records from Members */ 
 set members end = eof2; 
  rc = plan.find(); 					/* lookup each plan_id in the hash table Plan */ 
  if rc = 0 then output;				/* write record to Both only if the hash key is found in the members table (rc = plan.find() = 0 */ 
 end; 									/* Note: since we only output matches, we don't need to initialize plan_desc to missing as above */
 stop; 
run; 

proc print data=both;
run;

