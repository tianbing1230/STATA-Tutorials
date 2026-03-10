global outer "."


sjlog using "$outer/output/preamble", replace
* STATA Tutorial for MGCS5010
* Bing TIAN, Feb 2023

* Contents
*************************************
* Notes: *, //, /* */
* Set preambles: version, clear, ...
* Set working directories: pwd, cd
*************************************

************************************
* Preamble
************************************
version 15.1
clear /* Clear data in memory before loading new data*/
program drop _all /* clear active programs */
macro drop _all /* clear active macro */
sjlog close, replace


sjlog using "$outer/output/directory", replace
************************************
* Working Directory
************************************
* use "cfps2010adult_10%.dta" 
pwd
cd "data"
use "cfps2010adult_10%.dta"
sjlog close, replace

************************************
* Stata as Calculator
************************************
sjlog using "$outer/output/calculator", replace
* addition
display 3+6 //for addition calulation 
* substraction
display 109-5.6
* multiplication
dis 11*35
* division
dis 34/8
* power
dis 23^3
sjlog close, replace

sjlog using "$outer/output/mathfunction", replace
*** some math functions
dis sqrt(6)
dis int(5.2)
dis log(4)
dis exp(2.39)
dis min(2.1, 3, 7)
dis max(2.1, 3, 7)
dis sum(2 3 4 5 6)
*NOTE: type "help math_functions" to see available math functions

** more complicated calculations
dis (min(2.1,3,9)*max(2.1,3,9)/sqrt(2))^2
dis exp(1.2)/(exp(1.2)+1)
sjlog close, replace

************************************
* String Functions
************************************
* https://www.stata.com/manuals/fnstringfunctions.pdf
sjlog using "$outer/output/stringfunction", replace
display "Hello there" //Strings should be put in quotation marks: ""

dis length("This string has 29 characters")
dis strpos("Stata", "a")
dis substr("Stata", 3, 5)
dis regexr("My string", "My", "Your")
dis trim(" leading / trailing spaces ")
dis strlower("STATA should not be ALL-CAPS")
sjlog close, replace




************************************
* Read in and Export Data
************************************

sjlog using "$outer/output/input", replace
*** Input data
clear //clear data in memory
input x y
    6 0
    7 .
end
save "$outer/data/input.dta", replace 
	// save the input data to .dta form
* use "replace" 
sjlog close, replace

sjlog using "$outer/output/use", replace
*** Read in and save Stata format data
use "$outer/data/cfps2010adult_10%.dta", clear 
	// open .dta data
* We can also put "clear" as the option for use.
	keep pid provcd urban gender
save "$outer/data/cfps10_part.dta", replace 
	// save data with a new name
* Why don't we just overwrite the original data ???
* Use "replace" to replace the already existed file, when we rerun the codes.
saveold "$outer/data/cfps10_part_old.dta", replace 
	//save old version data
sjlog close, replace

sjlog using "$outer/output/import", replace
*** Other data formats
help import
* Let's first export current data into excel file
export excel "$outer/data/cfps10_part.xlsx", first(varl) replace 
	//save current data to excel 
import excel "$outer/data/cfps10_part.xlsx", first clear 
	//open excel format data
* Note that after such transformation, the variable pid has some problem
	* 1. It is due to the data format: string vs number, and the lenghth of the variable.
	* 2. Be careful when we use other forms of data.
sjlog close, replace


************************************
* Explore Data and Variables
************************************

use "$outer/data/cfps10_foruse.dta", clear

help browse
browse
browse pid fid

describe
sjlog using "$outer/output/describe", replace
describe age gender
sjlog close, replace

codebook
sjlog using "$outer/output/codebook", replace
codebook han
sjlog close, replace

sjlog using "$outer/output/count", replace
count // count the number of observations
count if age==20 // count N whose age equals 20
sjlog close, replace

list 
list pid
sjlog using "$outer/output/list", replace
list pid if age==94
list pid in 1/10
sjlog close, replace

************************************
* Manage Data and Variables
************************************
use "$outer/data/cfps10_foruse.dta", clear

*** Convert variable types: to(de)string, en(de)code

sjlog using "$outer/output/tostring", replace
* convert numeric variables to string variables: tostring, decode
tostring gender, gen(Gender)
decode gender, gen(GENDER)
describe gender Gender GENDER
* compare between tostring and decode
* tabulate categorical variables
tab Gender // tostring convert the "values" of a numeric variable
tab GENDER // decode convert the "labels" of a numeric variable
sjlog close, replace

sjlog using "$outer/output/destring", replace
* convert string variables to numeric variables: destring, encode
destring GENDER, gen(gender1) //destring cannot work with string variable with "words"
destring Gender, gen(gender2)
encode GENDER, gen(gender3) //encode generate numeric variable with values
encode Gender, gen(gender4) //again, encode generate numeric variable with values
tab gender3
tab gender3, nolabel // tab without label
label list gender3
label list gender4
sjlog close, replace


*** Formats
sjlog using "$outer/output/format", replace
format %9.0g pid //change the format for pid
format pid //check the format for pid
format %12.0g pid
format pid
sjlog close, replace

sjlog using "$outer/output/format2", replace
list rswt_nat in 1/5
des rswt_nat
format %9.2f rswt_nat
list rswt_nat in 1/5
des rswt_nat
sjlog close, replace

*** Storage types
sjlog using "$outer/output/storage", replace
des pid
recast float pid
des pid
sjlog close, replace


*** Variable names
sjlog using "$outer/output/rename", replace
* rename a single variable
rename gender sex
* help rename group
rename (gender2 gender3 gender4) (sex2 sex3 sex4)
rename sex* gender*
drop GENDER
rename gender*, upper
rename GENDER, lower
sjlog close, replace


*** Generate new variables
sjlog using "$outer/output/generate", replace
generate birthy = 2010 - age
egen meanage = mean(age)
tab meanage
bysort gender: egen meaneduy = mean(eduy)
tab meaneduy
sjlog close, replace
* help egen


*** Change values

* replace
sjlog using "$outer/output/replace", replace
gen educated = . //generate a numeric variable with missing values .
replace educated = 0 if eduy==0
replace educated = 1 if eduy>0 & eduy!=.
tab educated

gen EDUCATED = "" //generate a string variable with missing values ""
replace EDUCATED = "Not Educated" if eduy==0
replace EDUCATED = "Educated" if eduy>0 & eduy!=.
tab EDUCATED
sjlog close, replace

* recode
sjlog using "$outer/output/recode", replace
recode age (16/25=1) (26/35=2) (36/45=3) (46/55=4) (56/65=5) (else=.), gen(age_cut)
tab age_cut
sjlog close, replace

*** Missing values
replace income=-10 if income==.
replace income=-9 if income==0
sjlog using "$outer/output/mvdecode", replace
count if income==.
count if income<0
mvdecode income, mv(-9 10)
count if income==.
sjlog close, replace

*** Label variables

* add label to variables
sjlog using "$outer/output/labelvar", replace
label variable educated "Ever received any education"
label variable age_cut "Age Categories"
des educated age_cut
sjlog close, replace

* add label to values
sjlog using "$outer/output/labelval", replace
label define yesno 1 "Yes" 2 "No" //define value label
label value educated yesno //add value label to categorical variables
tab educated
tab educated, nolab
des educated
sjlog close, replace
*Try add value labels for age_cut


* add labels to data
sjlog using "$outer/output/labeldata", replace
label data "CFPS 2010 for STATS Tutorial"
describe, short
sjlog close, replace



*** Keep and drop rows or columns
sjlog using "$outer/output/keepdrop", replace
* keep and drop rows
keep if income!=.
drop if age>65

* keep and drop variables
drop Gender GENDER2
drop birthy-age_cut
keep pid-ccp
sjlog close, replace


*** Sort and order
sjlog using "$outer/output/sortorder", replace
sort age
gsort -age
gsort -age eduy

order pid fid urban hukou han
order rswt_nat, last
sjlog close, replace


sjlog using "$outer/output/compress", replace
compress //compress to proper storage type to save storage
sjlog close, replace

******************************************
* Index data: _n, _N, [_n-k], [_n+k]
******************************************
sjlog using "$outer/output/index", replace
clear
set obs 5
gen X=_n*100
dis X[1] " " X[2] " " X[3] " " X[4] " " X[5]
dis _N
replace X=X[_n+1]
list X
replace X=X[_n-1]
sjlog close, replace
list X


******************************************
* Macros
******************************************

*** global vs local
sjlog using "$outer/output/micromacro", replace
local city Beijing Shanghai Tianjin Chongqing
global city Beijing Shanghai Tianjin Chongqing
display "local: `city'"
display "global: $city"
sjlog close, replace

sjlog using "$outer/output/local1", replace
*** local for Numeric Values
local A 5
display `A'
local A=5
display `A'
local A 3+2
display `A'
local A=`A'+1
display `A'
*if we don't assign values, by default it is 0
local B=`B'+1 
display `B'
*** local for Strings
local C Beijing
dis "`C'"
sjlog close, replace

sjlog using "$outer/output/local2", replace
*** local with extended functions
local n : word  count `city'
dis `n'
local one : word 1 of $city
dis "`one'"
local l :  length local city
dis `l'
local pdir: sysdir PERSONAL
dis "`pdir'"
sjlog close, replace


******************************************
* Loops: forvalues, foreach, for
******************************************

*** forvalues loop
sjlog using "$outer/output/forvalues1", replace
forvalues i=1/4 {
  dis "`i'"
}
forvalues i=4(-1)1 {
  dis "`i'"
}
forvalues i=1(8)20 {
  dis "`i'"
}
sjlog close, replace


sjlog using "$outer/output/forvalues2", replace
set obs 5
forval i=1/4 {
  gen x`i'=`i'
  label var x`i' "variable `i'"
}
list in 1/2
des x1-x4
sjlog close, replace


sjlog using "$outer/output/forvalues3", replace
local city Beijing Shanghai Tianjin Chongqing
local code 010 021 022 023
forvalues i=1/4 {
  local name : word `i' of `city'
  local num  : word `i' of `code'
  dis "The area code of `name' is: `num'"
}
sjlog close, replace



*** foreach loop
sjlog using "$outer/output/foreach1", replace
foreach A of any a b c {
	dis "`A'"
}
foreach A of local city {
	dis "City: `A'"
}
foreach A of global city {
	dis "City: `A'"
}
sjlog close, replace

sjlog using "$outer/output/foreach2", replace
foreach A of varlist x1-x4 {
	sum `A'
}
foreach A in x1-x4 {
	sum `A'
}
sjlog close, replace



*** nested loops
clear
sjlog using "$outer/output/nested", replace
foreach var in X Y Z {
	forval i=1/3 {
		gen `var'`i'=.
	}
}
des, simple
sjlog close, replace




******************************************
*Application 1: assign numbers to a set of newly-generated variables
******************************************
clear
set obs 5

sjlog using "$outer/output/method1", replace
* method 1
foreach j of numlist 2 9 10 89 {
    local i=`i'+1  /*same as "local ++i"*/
    gen Avar`i'=`j'
 }
sum Avar*
sjlog close, replace

sjlog using "$outer/output/method2", replace
* method 2
local A 1 5 10 9
forvalues i=1/4 {
  local j: word `i' of `A'
  gen Bvar`i'=`j'
}
sum Bvar*
sjlog close, replace

sjlog using "$outer/output/method3", replace
* method3
local A xa xb xc xd
local B 9 10 7 83
forvalues i=1/4 {
    local m: word `i' of `A'
    local n: word `i' of `B'
    gen `m'=`n'
}
sum x*
sjlog close, replace


******************************************
*Application 2: Process survey data quicker
******************************************
global datadir "data"
use "$datadir/cfps2010adult_10%.dta", clear

sjlog using "$outer/output/survey1", replace
forvalues i=1/15 {
    label var qb301_a_`i' "Relation for sibling `i'"
}

foreach i of numlist 1 3/4 {
    label var qb303b_a_`i' "Age of sibling `i'"
}

foreach var in qb303y_a_1 qb303m_a_1 qb303b_a_1 {
    sum `var'
}
sjlog close, replace

sjlog using "$outer/output/survey2", replace
local B qb301_a_*
*sum `B'
*for varlist `B': sum X
foreach i of local B {
    sum `i'
}
sjlog close, replace





*************************************
* Common data structures: 
*************************************

*** cross-sectional
clear
set obs 6
gen id=_n
forval i=1/3 {
	gen var`i'=.
}
sjlog using "$outer/output/crosssec", replace
list, noobs clean
sjlog close, replace


*** pooled cross-sectional
gen sample=2022 in 1/3
replace sample=2023 in 4/6
order sample id
sjlog using "$outer/output/pooled", replace
list, noobs clean
sjlog close, replace


*** time series data
drop sample
replace id=1
gen year=2015+_n
order id year
sjlog using "$outer/output/timeseries", replace
list, noobs clean
sjlog close, replace


*** panel data
replace id=1 in 1/3
replace id=2 in 4/6
qui bysort id: replace year=2015+_n
sjlog using "$outer/output/panel", replace
list, noobs clean
sjlog close, replace


*** multilevel data
drop year
rename id hid
bysort hid: gen pid=_n
order hid pid
sjlog using "$outer/output/multilevel", replace
list, noobs clean
sjlog close, replace


*** pair data
gen sid = 2 if pid==1
replace sid = 1 if pid==2
gen sinfo = .
order hid pid sid sinfo
sjlog using "$outer/output/pair", replace
list, noobs clean
sjlog close, replace




************************************
* Combine data: append and merge
************************************

************************
* prepare data
global datadir "data"

clear
input id male age
	1 0 20
	2 0 18 
	3 0 24
	4 1 32
	5 1 30
end
gen dataset=1
order dataset
sort id
sjlog using "$outer/output/combine1", replace
list, noobs clean
sjlog close, replace
save "$datadir/temp01", replace

clear
input id male edu
	1 1 8
	7 1 5 
	8 1 4
	9 1 3
	10 1 .
end
gen dataset=2
order dataset
sort id
sjlog using "$outer/output/combine2", replace
list, noobs clean
sjlog close, replace
save "$datadir/temp02", replace

* set up a life history from 18-yrs-old to current
use "$datadir/temp01", clear
gen a=age-17
expand a
bysort id: gen age0=17+_n
drop if age0>age
drop age a
rename age0 age
sort id age
sjlog using "$outer/output/combine3", replace
list in 1/10, noobs clean
sjlog close, replace
save "$datadir/temp03", replace



************************

*** append data
sjlog using "$outer/output/append", replace
use "$datadir/temp01", clear
append using "$datadir/temp02"
list, noobs clean
sjlog close, replace

*** merge data (1:1)
sjlog using "$outer/output/merge1", replace
use "$datadir/temp01", clear 
merge 1:1 id using "$datadir/temp02" //merge by id
list, noobs clean 
*for matched cases, taking values from master data
sjlog close, replace

*** merge data: m:1 
sjlog using "$outer/output/merge2", replace
use "$datadir/temp03", clear
merge m:1 id using "$datadir/temp02", keepusing(edu)
list in 1/10, sepby(id) noobs clean
sjlog close, replace


************************************
* Reshape wide or reshape long
************************************
use "$datadir/temp03", clear
merge m:1 id using "$datadir/temp02", keepusing(edu) nogen
sort id age
qui bysort id: gen year=2000+_n
order id year
drop dataset 
list in 1/10, noobs clean 


*** reshape from long to wide
sjlog using "$outer/output/reshapewide", replace
reshape wide edu age, i(id) j(year)  
	//don't need list constant varialbes, e.g. "male"
list id male edu2001 edu2002 age2001 age2002, noobs clean
sjlog close, replace

*** reshape from wide to long
sjlog using "$outer/output/reshapelong", replace
reshape long edu age, i(id) j(year) 
	//don't need list constant varialbes, e.g. "male"
drop if id==id[_n-1] & edu==. & age==.
	//drop empty observations
list in 1/10, noobs clean
sjlog close, replace



************************************
* Aggregate data and generate group-level statistics
************************************

*** Aggregate to group level statistics, e.g. mean, count, sum, %...
sjlog using "$outer/output/collapse", replace
preserve //preserve current memory
collapse (mean) age, by(id)
list, noobs clean
restore //restore to the state when we "preserve"
sjlog close, replace




************************************
* Working Directory
************************************
global outer "."
cd $outer


use "$outer/data/cfps10_foruse.dta", clear
**********************
* I. Choose Appropriate Plot Types
**********************

*** Categorical Variable
sjlog using "$outer/output/plotcat", replace
* bar
graph bar (count), over(gender)
graph hbar (count), over(gender)
graph bar (percent), over(gender)
graph hbar (percent), over(gender)

* pie
graph pie, over(gender)
sjlog close, replace

*** Continuous Variable
gen loginc= log(income+1) if income>0
label var loginc "Logged Annual Income"
sjlog using "$outer/output/plotcont", replace
* boxplot
graph box income
graph box loginc

* histogram 
histogram income
histogram loginc

* density curve
kdensity loginc
sjlog close, replace

*** Two Continuous Variables
sjlog using "$outer/output/plottwoway", replace
* scatter plot
twoway scatter loginc eduy

*** Two Categorical Variables
graph bar, percentages over(edu) over(urban) asyvars stack

*** Categorical + Continuous
histogram loginc, by(gender)
graph box loginc, by(gender)
graph box loginc, over(gender)
sjlog close, replace

**********************
* II. Plot Placement
**********************
sjlog using "$outer/output/plotplacement", replace
*** Juxtapose
histogram loginc, by(gender)
graph box loginc, over(gender)
* check the help document for proper options

*** Superimpose
* Method 1: ||
twoway histogram loginc if gender==1 || histogram loginc if gender==0
* Method 2: ()
twoway (histogram loginc if gender==1) (histogram loginc if gender==0)
sjlog close, replace

**********************
* III. Customizing Appearance
**********************

sjlog using "$outer/output/plotapp1", replace
*** Appearance for readability and ascetic reasons
twoway (hist loginc if gender==1, color(green)) ///
	(hist loginc if gender==0, fcolor(none)), ///
	legend(order(1 "Male" 2 "Female"))
*help help twoway_options
sjlog close, replace

sjlog using "$outer/output/plotapp2", replace
twoway (scatter loginc eduy) (lfit loginc eduy), ///
	legend(off) ///
	ytitle("Logged Annual Income") ///
	note("Correlation Coefficient=0.4273")
sjlog close, replace

sjlog using "$outer/output/plotapp3", replace
#delimit ;
graph pie, over(gender) 
	pie(1,color(navy%30)) 
	pie(2, color(olive)) 
	plabel(_all percent) ;
#delimit cr
sjlog close, replace

*** Schemes

*https://www.stata.com/meeting/switzerland16/slides/bischof-switzerland16.pdf
sjlog using "$outer/output/brewscheme", replace
*ssc install brewscheme
graph box eduy, scheme(plotplain)
graph box loginc, scheme(plottig)
*you can also set your own schemes


set scheme plotplain
twoway (hist loginc if gender==1, color(green)) ///
	(hist loginc if gender==0, fcolor(none)), ///
	legend(order(1 "Male" 2 "Female"))
sjlog close, replace

**********************
* IV. Save and Export Plots
**********************
sjlog using "$outer/output/plotsave", replace
*** Save .gph file
*graph save ...
 
*** Export other plot types
*graph export ...
sjlog close, replace



************************************
*** Summary Statistics
* "summarize" for continuous variables
* "tabulate" for categorical variables
************************************
use "$outer/data/cfps10_foruse.dta", clear

*** Tabulate gender
gen female=gender==0
label variable female "Female"

sjlog using "$outer/output/tabulate", replace
tabulate gender //marginal distribution
tab gender, nolab
	//tab for short; nolab to suppress value labels
tab female
summarize female 
	//think about it, why the mean value equals %female
sjlog close, replace

*** Summarize income and logincome
replace income = . if income<=0
gen loginc = log(income+1)
label variable loginc "Logged Annual Earnings"

sjlog using "$outer/output/summarize", replace
summarize income
sum loginc //sum for short
sum loginc, detail //detail for detailed statistics
sjlog close, replace

*** Subgroup summary statistics
sjlog using "$outer/output/bysum", replace
* Method 1
bysort gender: sum income
* Method 2
tab gender, sum(loginc)
sjlog close, replace

*** Twoway tabulate table / crosstable
sjlog using "$outer/output/crosstab1", replace
*help tabulate
tab urban hukou //tabulate twoway
tab urban hukou, cell //joint distribution
sjlog close, replace
sjlog using "$outer/output/crosstab2", replace
tab urban hukou, row //conditional distribution
tab urban hukou, column //conditional distribution
sjlog close, replace


*** Correlation coefficient
sjlog using "$outer/output/correlation", replace
cor loginc eduy
pwcorr loginc eduy
sjlog close, replace

************************************
* Generate Publishable Tables
************************************
* Don't use screenshot of the stata output!	

*** Method 1: copy table

*** Method 2: some user-written packages for output, here I use esttab
sjlog using "$outer/output/esttab", replace
est clear
qui bysort female: eststo: estpost sum income loginc
qui eststo: estpost sum income loginc

esttab est1 est2 est3 using "$outer/output/descrip.csv", ///
	replace cell(mean(fmt(%10.3f)) sd(fmt(%10.3f)par)) ///
	label nonumber nomtitle nogaps ///
	title("Average Income by Gender") ///
	note("Standard deviations in parentheses.")
sjlog close, replace
* Normally for a project, we will have many "control variables".
* When you work on a project, you may need to revise your tables many times.
* These are reasons are why we use codes to automate the output!

	
************************************
* Survey Data
************************************

* weight

sum rswt_nat

sjlog using "$outer/output/weight", replace
help weight

sum loginc 
sum loginc [iweight=rswt_nat]

tab gender
tab gender [iweight=rswt_nat]
sjlog close, replace



