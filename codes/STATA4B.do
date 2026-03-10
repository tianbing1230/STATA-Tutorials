* STATA Tutorial for MGCS5010
* Bing TIAN, Oct 2023


* Contents
*************************************
* Summary Statistics: summarize, tabulate, correlate
* The main ways to export the numbers are through 
		*1) copy table 
		*2) dtable
		*3) some user-written packages for output: eststo, esttab
		
* 
*************************************


************************************
* Preamble
************************************
version 15.1
clear

************************************
* Working Directory
************************************
global stata "."
cd $stata


************************************
*** Summary Statistics
* "summarize" for continuous/quantitative variables
* "tabulate" for categorical variables
************************************
use "$stata/data/cfps10_foruse.dta", clear


*** Summarize income and logincome
replace income = . if income<=0
gen loginc = log(income+1)
label variable loginc "Logged Annual Earnings"

summarize income
sum loginc //sum for short
sum loginc, detail //detail for detailed statistics


*** Tabulate gender
gen female =  gender==0
label variable female "Female"

tabulate gender //marginal distribution
tab gender, nolab
	//tab for short; nolab to suppress value labels
tab female
*summarize female 
	//think about it, why the mean value equals %female


*** Subgroup summary statistics
* Method 1
bysort gender: sum income loginc
* Method 2
tab gender, sum(loginc)


*** Twoway tabulate table / crosstable
*help tabulate
tab urban hukou //tabulate twoway
tab urban hukou, cell //joint distribution
tab urban hukou, row //conditional distribution
tab urban hukou, column //conditional distribution


*** Correlation coefficient
correlate loginc eduy
pwcorr loginc eduy, sig


************************************
* Generate Publishable Tables
************************************
* Don't use screeshot of the stata output!	

*gender pay gap
bysort gender: sum income loginc

*** Method 1: copy table

* dtable

*** Method 2: some user-written packages for output, here I use esttab
*ssc install esttab
est clear
bysort female: eststo: estpost sum income loginc
eststo: estpost sum income loginc

esttab est1 est2 est3 using "$stata/output/descrip.rtf", ///
	replace cell(mean(fmt(%10.3fc)) sd(fmt(%10.3f)par)) ///
	label nonumber nomtitle nogaps ///
	title("Average Income by Gender")

* Normally for a project, we will have many "control variables".
* When you work on a project, you may need to revise your tables many times.
* These are reasons are why we use codes to automate the output!

	
************************************
* Survey Data
************************************

* weight
help weight
sum rswt_nat

sum loginc 
sum loginc [iweight=rswt_nat]

tab gender
tab gender [iweight=rswt_nat]



