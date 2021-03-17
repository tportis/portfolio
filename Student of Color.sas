OPTIONS NOCENTER;    
libname oir "S:\is\__aaaa New Folder Structure\Data\SAS Datasets" ACCESS=READONLY; 
%include "S:\is\__aaaa New Folder Structure\Data\UVM Student Information\SAS datasets\dataset_formats.sas"; 

data CESS_All_Enrol (keep=namel namef levl term styp Class recat re majr majr12 majr2 minr minr12 minr2 minr22 cumgpa cumhrs);
set oir.allenrol;
if term=202001 and recat not in ('White','Unknown');
if col="30" or col="50";
/*Set the class variable*/
length Class $20.;
	if levl="UG" and cumhrs<27 then Class='1. First Year';                                  
	if levl="UG" and cumhrs>26.99 AND cumhrs<57 then Class='2. Sophomore ';                 
	if levl="UG" and cumhrs>56.99 AND cumhrs<87 then Class='3. Junior';                 
	if levl="UG" and cumhrs>86.99 then Class='4. Senior';                               
	if levl="UG" and styp=1 then Class='1. First Year'; 
run;

proc import datafile="C:\Users\tportis\Downloads\Spring 2020 CESS.xlsx"
out=CESS_all_enrol dbms=xlsx replace;
getnames=yes;
sheet="Spring 2020 CESS";
run;

/* Brings in major crosswalk*/

proc import datafile="C:\Users\tportis\Downloads\stvmajr.xlsx"
out=major_desc_crosswalk dbms=xlsx replace;
getnames=yes;
sheet="Sheet1";
run;

data use_major_desc_cross (keep=majr majr_desc);
set major_desc_crosswalk;
majr_desc=Long_Description;
majr=Subject;
run;

proc sort data=CESS_All_Enrol; by majr;
proc sort data=use_major_desc_cross; by majr;
data CESS_stv;
merge cess_all_enrol(in=in1) use_major_desc_cross(in=in2);
by majr;
if in1;
run;


/* Filters table by CESS undergrads and grad students in CESS programs*/
data cess_all_enrol_corrected(keep =  namel namef levl majr_desc Class cumgpa recat);
set cess_stv;
if levl in ('UG') or majr in ('CNSL', 'CI', 'CNSL', 'EL', 'ELPS', 'HESA', 'INTR', 'SWSS', 'SPED');
run;



/*Eport table*/

/*
proc export data=CESS_all_enrol_corrected
dbms=xlsx
outfile="Spring 2020 CESS Undergrad & Grad.xlsx" 
replace;
run;
*/

/*
data CESSsocGR(keep=namel namef recat majr majr12 majr2 cumgpa cumhrs degc);
set allGRenrol;
if majr in ('CNSL', 'CI', 'ELPS', 'EL', 'INTR', 'HESA', 'SWSS', 'SPED');
run;
*/

