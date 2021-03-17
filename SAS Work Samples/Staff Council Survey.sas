/* Import survey responses */

proc import datafile="C:\Users\tportis\Downloads\results-survey984266.xlsx"
out=Survey_Responses dbms=xlsx replace;
sheet="2020 Staff Council Survey";
getnames=yes;
run;

	proc contents data=survey_responses order=varnum;
	run;
/*Import sample spreadsheet */

proc import datafile="C:\Users\tportis\Downloads\staff council survey 2020 sample full.xlsx"
out=Survey_Sample dbms=xlsx replace;
sheet="staff council survey 2020 sampl";
getnames=yes;
run;

/*Merge survey responses and sample spreadsheet on pidm*/

proc sort data=Survey_Responses; by attribute_1;
proc sort data=Survey_Sample; by attribute_1;

data Survey_Responses_Merged;
merge Survey_Sample(in=in1) Survey_Responses(in=in2);
by attribute_1;
if in1;
run;

/*Changes merge dataset to include an indicator for survey completion.*/
data Survey_Responses_Merged (drop=);
set Survey_Responses_Merged;
response_indicator=1;
if startdate__Date_started ='' then response_indicator = 0;
run;

/*Create table indicating total responses */
proc tabulate data=Survey_Responses_Merged;
class response_indicator;
var attribute_1;
table response_indicator* all (attribute_1="Headcount"*n="") /nocellmerge;
title "Survey Response Rate";
run;


/*Create survey response tables by sex, race, and unit name*/
proc tabulate data=Survey_Responses_Merged;
class Unitname IPEDsRace Sex response_indicator;
var attribute_1;
table Unitname*response_indicator* all (attribute_1="Headcount"*n="") /nocellmerge;
title "Survey Responses by Unit";
run;

proc tabulate data=Survey_Responses_Merged;
class Unitname IPEDsRace Sex response_indicator;
var attribute_1;
table IPEDsRace*response_indicator all (attribute_1="Headcount"*n="") /nocellmerge;
title "Survey Responses by Race";
run;

proc tabulate data=Survey_Responses_Merged;
class Unitname IPEDsRace Sex response_indicator;
var attribute_1;
table Sex*response_indicator all (attribute_1="Headcount"*n="") /nocellmerge;
title "Survey Responses by Sex";
run;


proc import datafile="C:\Users\tportis\Downloads\results-survey984266.xlsx"
out=Survey_Responses dbms=xlsx replace;
sheet="2020 Staff Council Survey";
getnames=yes;
run;

/*Creates frequency tables on familiarity with staff council. Includes by unit and by full-time/part-time*/
proc tabulate data=Survey_Responses_Merged;
class A5__How_familiar_are_you_with_th;
var attribute_1;
table A5__How_familiar_are_you_with_th all  /nocellmerge;
where response_indicator = 1;
title "How Familiar Are You With Staff Council";
run;

proc tabulate data=Survey_Responses_Merged;
class A5__How_familiar_are_you_with_th Unitname IPEDS_FTPT;
var attribute_1;
table Unitname*A5__How_familiar_are_you_with_th all  /nocellmerge;
title "How Familiar Are You With Staff Council";
title2 "By Unit";
where response_indicator = 1;
run;

proc tabulate data=Survey_Responses_Merged;
class A5__How_familiar_are_you_with_th Unitname IPEDS_FTPT;
var attribute_1;
table ipeds_ftpt*A5__How_familiar_are_you_with_th all  /nocellmerge;
title "How Familiar Are You With Staff Council";
title2 "By Full-Time/Part-Time";
where response_indicator = 1;
run;

/*Creates table displaying means for likert questions regarding staff council*/
proc means data=survey_responses_merged mean nway;
var var9 var10 var11 var12 var13 var14 var15 var16 var17;
where response_indicator = 1;
output out=want (drop= _: ) mean=;
title "Means of Likert Questions Regarding Staff Council";
run;

/*Creates frequency tables on knowing staff council rep. Then by unit and by full time part time */
proc tabulate data=Survey_Responses_Merged;
class A14__Do_you_know_who_your_Staff;
var attribute_1;
table A14__Do_you_know_who_your_Staff all /nocellmerge;
where response_indicator = 1;
title "How Familiar Are You With Staff Council";
run;

proc tabulate data=Survey_Responses_Merged;
class A14__Do_you_know_who_your_Staff Unitname IPEDS_FTPT;
var attribute_1;
table Unitname*A14__Do_you_know_who_your_Staff all /nocellmerge;
title "How Familiar Are You With Staff Council";
title2 "By Unit";
where response_indicator = 1;
run;

proc tabulate data=Survey_Responses_Merged;
class A14__Do_you_know_who_your_Staff Unitname IPEDS_FTPT;
var attribute_1;
table ipeds_ftpt*A14__Do_you_know_who_your_Staff all /nocellmerge;
title "How Familiar Are You With Staff Council";
title2 "By Full-Time/Part-Time";
where response_indicator = 1;
run;

/*Creates table displaying means for likert questions regarding staff council rep. Then by unit*/
proc means data=survey_responses_merged mean nway;
var var19 var20 var21 var22;
where response_indicator = 1;
output out=want (drop= _: ) mean=;
title "Means of Likert Questions Regarding Staff Council Rep.";
run;

proc means data=survey_responses_merged mean nway;
var var19 var20 var21 var22;
class unitname;
where response_indicator = 1;
output out=want (drop= _: ) mean=;
title "Means of Likert Questions Regarding Staff Council Rep. by Unit";
run;

/*Creates table displaying frequency in reading staff line */
proc tabulate data=Survey_Responses_Merged;
class A10__How_frequently_do_you_read;
var attribute_1;
table A10__How_frequently_do_you_read all /nocellmerge;
where response_indicator = 1;
title "How Often Staff Line is Read";
run;

/*Creates frequency table of what respondants would like to see more of from staff line */
proc tabulate data=survey_responses_merged;
class var24 var25 var26 var27 var28 var29 var30 var31 var32;
var attribute_1;
table var24 var25 var26 var27 var28 var29 var30 var31 var32;
where response_indicator = 1;
title "Reasons Why Staff Have Not Used Tuition Remission";
run;

/*Ceates frequency table of who use tuition remission*/
proc tabulate data=Survey_Responses_Merged;
class G1__Have_you_ever_taken_advantag;
var attribute_1;
table G1__Have_you_ever_taken_advantag /nocellmerge;
where response_indicator = 1;
title "Use of Tuition Remission";
run;

/*Creates frequency table for reasons respondants not use tuition remission */
proc tabulate data=survey_responses_merged;
class var64 var65 var66 var67 var68 var69 var70 var71;
var attribute_1;
table var64 var65 var66 var67 var68 var69 var70 var71;
where response_indicator = 1;
where G1__Have_you_ever_taken_advantag = 'No'
title "Reasons Why Staff Have Not Used Tuition Remission";
run;

/*Ceates frequency table indicating amount that has done pd*/
proc tabulate data=Survey_Responses_Merged;
class G2__Have_you_been_able_to_take_a;
var attribute_1;
table G2__Have_you_been_able_to_take_a all /nocellmerge;
where response_indicator = 1;
title "Took Advantage of Professional Development";
run;


/*Ceates frequency table of reasons people have not done PD*/
proc tabulate data=survey_responses_merged;
class var82 var83 var84 var85 var86 var87;
var attribute_1;
table var82 var83 var84 var85 var86 var87;
where response_indicator = 1;
where G2__Have_you_been_able_to_take_a = 'Never'
title "Reasons Why Staff Have Not Took Advantage of Professional Development";
run;

/*Computes mean for PD likert questions. Then by unit */
proc means data=survey_responses_merged mean nway;
var var90 var91 var92 var93 var94;
where response_indicator = 1;
title "Means of Likert Questions About Supervisor";
output out=want (drop= _: ) mean=;
run;

/*Takes PD likert questions and compare it to supervisor type*/
proc means data=survey_responses_merged mean nway;
var var90 var91 var92 var93 var94;
class G24__My_immediate_supervisor_is;
where response_indicator = 1;
title "Means of Likert Questions About Supervisor";
title2 "By Supervisor Type";
output out=want (drop= _: ) mean=;
run;


/*Ceates frequency table for desire to telecommute*/
proc tabulate data=Survey_Responses_Merged;
class G19__If_allowed__I_would_prefer;
var attribute_1;
table G19__If_allowed__I_would_prefer all /nocellmerge;
where response_indicator = 1;
title "Desire to Telecommute";
run;

/*Ceates frequency table for reasons to telecommute*/
proc tabulate data=survey_responses_merged;
class var97 var98 var99 var100 var101;
var attribute_1;
table var97 var98 var99 var100 var101;
where response_indicator = 1;
title "Reasons to Telecommute";
run;

/*Ceates frequency table displaying people last performance review*/
proc tabulate data=Survey_Responses_Merged;
class G4__When_was_your_last_performan;
var attribute_1;
table G4__When_was_your_last_performan all /nocellmerge;
where response_indicator = 1;
title "When was your last performance review?";
run;

/*Ceates frequency table for supporting merit raises. Then by if they received a merit increase in 2019*/
proc tabulate data=Survey_Responses_Merged;
class G5__I_prefer_annual_raises_to_be;
var attribute_1;
table G5__I_prefer_annual_raises_to_be all /nocellmerge;
where response_indicator = 1;
title "Support for Merit Raises";
run;

proc tabulate data=Survey_Responses_Merged;
class G5__I_prefer_annual_raises_to_be G16__Did_you_receive_a_merit_inc;
var attribute_1;
table G16__Did_you_receive_a_merit_inc*G5__I_prefer_annual_raises_to_be all /nocellmerge;
where response_indicator = 1;
title "Support for Merit Raises";
title2 "By Whether Employee Received a Merit Raise Last Year"
run;



/*Export tables*/
