

/*Import housing files */

	proc import datafile="C:\Users\tportis\Downloads\Housing Files\FS16.xlsx"
	out=fs16 dbms=xlsx replace;
	sheet="Sheet1";
	getnames=yes;
	run;

	proc import datafile="C:\Users\tportis\Downloads\Housing Files\FS17.xlsx"
	out=fs17 dbms=xlsx replace;
	sheet="Sheet1";
	getnames=yes;
	run;

	proc import datafile="C:\Users\tportis\Downloads\Housing Files\FS18.xlsx"
	out=fs18 dbms=xlsx replace;
	sheet="all residents";
	getnames=yes;
	run;


	proc import datafile="C:\Users\tportis\Downloads\Housing Files\FS19.xlsx"
	out=fs19 dbms=xlsx replace;
	sheet="201909 census";
	getnames=yes;
	run;

/*Convert databases to needed format. Keeps id and community. Create a column and LC indicator */

	data fs16_clean (keep = id community term lc_indicator);
	set fs16;
	rename resident_id_number=id;
	term=2016;
	lc_indicator=1;
	if community ='' then lc_indicator = 0;
	if community ='' then community = 'No Community';
	run;

	data fs17_clean (keep = id community term lc_indicator);
	set fs17;
	rename _95x=id;
	term=2017;
	lc_indicator=1;
	if community ='' then lc_indicator = 0;
	if community ='' then community = 'No Community';
	run;

	data fs18_clean (keep = id community term lc_indicator residential_student);
	set fs18;
	term=2018;
	lc_indicator=1;
	if community ='' then lc_indicator = 0;
	if community ='' then community = 'Non-Residential Student';
	residential_student = 'Yes';
	if community = 'Non-Residential Student' then residential_student = 'No';
	run;

	data fs19_clean (keep = id community term lc_indicator);
	set fs19;
	rename student_id=id;
	rename learning_community=community;
	term=2019;
	lc_indicator=1;
	if community ='' then lc_indicator = 0;
	if community ='' then community = 'No Community';
	run;

/* 2018 housing data filted out the non-residential students*/

	data fs18_residential_only (keep = id community term lc_indicator);
	set fs18;
	term=2018;
	lc_indicator=1;
	if community ='' then lc_indicator = 0;
	if community ='' then community = 'Non-Residential Student';
	where (community ^= '');
	run;

/* Combine data sets to include the three variables term, id, and LC */

	data all_roster;
		set fs16_clean fs17_clean fs18_clean fs19_clean;
	run;




/* Create table that showcases number of students per LC, number of 
	students not in LC, and total students in 2016, 2017, and 2018*/


	proc tabulate data=fs16_clean;
	class community id;
	var lc_indicator;
	table community* all (lc_indicator="Headcount"*n="") /nocellmerge;
	title "Headcounts of Students in Each LC 2016";
	run;

	proc tabulate data=fs17_clean;
	class community id;
	var lc_indicator;
	table community* all (lc_indicator="Headcount"*n="") /nocellmerge;
	title "Headcounts of Students in Each LC 2017";
	run;

	proc tabulate data=fs18_residential_only;
	class community id;
	var lc_indicator;
	table community* all (lc_indicator="Headcount"*n="") /nocellmerge;
	title "Headcounts of Students in Each LC 2018";
	run;



	proc tabulate data=fs19_clean;
	class community id;
	var lc_indicator;
	table community* all (lc_indicator="Headcount"*n="") /nocellmerge;
	title "Headcounts of Students in Each LC 2019";
	run;

	proc tabulate data=fs18_clean;
	class community residential_student;
	var id;
	table residential_student* all (id="Headcount"*n="") /nocellmerge;
	title "Headcounts of Students in Each LC 2018";
	run;




/*Output tables to excel */

ods excel file="Housing Data Fall 16 - Fall 19.xlsx" 
	options (embedded_titles='on' sheet_interval="none" flow='tables' sheet_name='Fall 16');
		proc print data=fs16_clean noobs;
		title "Fall 16 Dataset";
		run;
	

	ods excel options(sheet_interval="now" sheet_name='Fall 17 Dataset');								/*[tell ods excel to create a new sheet]*/
		proc print data=fs17_clean noobs;
		title "Fall 17 Dataset";
		run;


	ods excel options(sheet_interval="now" sheet_name='Fall 18 Dataset');								/*[tell ods excel to create a new sheet]*/
		proc print data=fs18_residential_only noobs;
		title "Fall 18 Dataset";
		run;

	ods excel options(sheet_interval="now" sheet_name='Fall 19 Dataset');								/*[tell ods excel to create a new sheet]*/
		proc print data=fs19_clean noobs;
		title "Fall 19 Dataset";
		run;
		
	ods excel options(sheet_interval="now" sheet_name='Tables');								/*[tell ods excel to create a new sheet]*/
	proc tabulate data=fs16_clean;
	class community id;
	var lc_indicator;
	table community* all (lc_indicator="Headcount"*n="") /nocellmerge;
	title "Headcounts of Students in Each LC 2016";
	run;

	proc tabulate data=fs17_clean;
	class community id;
	var lc_indicator;
	table community* all (lc_indicator="Headcount"*n="") /nocellmerge;
	title "Headcounts of Students in Each LC 2017";
	run;

	proc tabulate data=fs18_residential_only;
	class community id;
	var lc_indicator;
	table community* all (lc_indicator="Headcount"*n="") /nocellmerge;
	title "Headcounts of Students in Each LC 2018";
	run;



	proc tabulate data=fs19_clean;
	class community id;
	var lc_indicator;
	table community* all (lc_indicator="Headcount"*n="") /nocellmerge;
	title "Headcounts of Students in Each LC 2019";
	run;

	proc tabulate data=fs18_clean;
	class community residential_student;
	var id;
	table residential_student* all (id="Headcount"*n="") /nocellmerge;
	title "Headcounts of Students in Each LC 2018";
	run;

ods excel close;


