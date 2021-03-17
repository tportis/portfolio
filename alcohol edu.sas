proc import datafile="C:\Users\tportis\Downloads\Benefits Crosswalk - 201920.xlsx"

out=Benefits_Cross_Long dbms=xlsx replace;

getnames=yes;

sheet="Sheet1";

run;

 

proc transpose data=Benefits_Cross_Long out=Benefits_Cross_Wide;

id variable;

var amount;

run;

 

/*Drop the variables that we don't need.*/

data Final_Benefits_Cross (drop=_NAME_ _LABEL_);

set Benefits_Cross_Wide;

run;


/* Import spreadsheet */

proc import datafile="\\winfiles1.campus.ad.uvm.edu\tportis\MyDocs\OIR\Alcohol Edu\uVermont_ResponseData_AlcEduPart1_Survey1_20200218.xlsx"
out=Survey_Responses dbms=xlsx replace;

getnames=yes;

run; 

/*Creates table and filters to only include responses related to AlcoholEdu */

data AlcoholEdu_Responses (drop=);
set Survey_Responses;
run;


/*Transpose Data */

proc sort data=AlcoholEdu_Responses
out= AlcoholEdu_Responses_Sorted;
by section_id masked_user_id;
where response_id ^= 0;
where question_id in (4462 4465);  
run;

proc transpose data=AlcoholEdu_Responses_Sorted out=Alcoholedu_transposed name= column;
by masked_user_id;
id question_text;
run;

proc transpose data=AlcoholEdu_Responses_Sorted out=Alcoholedu_transposed;
var answer_text;
id question_text;
by masked_user_id;
run;
