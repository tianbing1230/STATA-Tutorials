* STATA Tutorial for MGCS5010
* Bing TIAN, Oct 2024


* Contents
*************************************
* 0. display
* 1. Open and save data: input, use, import, compress, save, export, clear, replace
* 2. Explore data: browse, describe, codebook, list, count...
* 3. Variables types in stata: numeric vs string. 
*	    Convert between types: destring/tostring, encode/decode
* 4. Storage types: byte, int, long, float, double; str1, str2, ..., strL; recast
* 5. Display format: %fmt; format
* 6. Change values: rename, generate, ege, replace, recode, mvdecode, 
* 7. Label: label variable; label define, label values; label data
* 8. Work on variables: keep, drop, sort, order
*************************************



************************************
* Preamble
************************************
version 15.1
clear /* Clear data in memory before loading new data*/

************************************
* Working Directory
************************************
global stata "."
cd $stata

************************************
* Stata as Calculator
************************************
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

*** Math functions
dis sqrt(4)
dis int(8.9)
dis log(4)
dis exp(2.39)
dis min(2.1, 3, 7)
dis max(2.1, 3, 7)
*NOTE: type "help math_functions" to see available math functions

** more complicated calculations
dis (min(2.1,3,9)*max(2.1,3,9)/sqrt(2))^2
dis exp(1.2)/(exp(1.2)+1)

************************************
* String Functions
************************************
* https://www.stata.com/manuals/fnstringfunctions.pdf
* help string_functions
display "Hello world!" //Strings should be put in quotation marks: ""

display 10 //number
dis 10*2
display "10" //string
display "10"*2

dis length("This string has 29 characters")
dis strpos("Stata", "a")
dis substr("Stata", 3, 2)
dis regexr("My string", "My", "Your")
dis trim(" leading / trailing spaces ")
dis strlower("STATA should not be ALL-CAPS")


************************************
* Other Functions: explore yourself
* datetime
* random number
* statistical functions
* ...
************************************


************************************
* Read in and Export Data
************************************

*** 1. Input data
clear //clear data in memory
input x y str1 z
    6 0 "a"
    7 . "b"
	8 9 ""
end

*save input.dta, replace
save "$stata/data/input.dta", replace
	// save the input data to .dta form

	
*** 2. Read in and save Stata format data
use "$stata/data/cfps2010adult_10%.dta", clear
	// open .dta data
* We can also put "clear" as the option for use.
	keep pid provcd urban gender
save "$stata/data/cfps10_part.dta", replace 
	// save data with a new name
* Why don't we just overwrite the original data ???
* Use "replace" to replace the already existed file, when we rerun the codes.

*** Other data formats
help import
* Let's first export current data into excel file
export excel "$stata/data/cfps10_part.xlsx", replace first(varl) 
	//save current data to excel 
import excel "$stata/data/cfps10_part.xlsx", clear first 
	//open excel format data
* Note that after such transformation, the variable pid has some problem
	* 1. It is due to the data format: string vs number, and the lenghth of the variable.
	* 2. Be careful when we use other forms of data.
*use "$stata/data/cfps10_part.dta", clear
	
	
	
************************************
* Explore Data and Variables
************************************

use "$stata/data/cfps10_foruse.dta", clear

help browse
browse
browse pid fid tenure //select columns
browse pid tenure if tenure==10 //select rows
browse pid tenure in 1/10 

describe
describe age gender

codebook
codebook han 

count // count the number of observations
count if age!=20 // count N whose age equals 20

list 
list pid
list pid age if age>=90
list pid in 1/10
list pid in 26



************************************
* Manage Data and Variables
************************************
use "$stata/data/cfps10_foruse.dta", clear


*** Convert variable types: to(de)string, en(de)code

* convert numeric variables to string variables: tostring, decode
tostring gender, generate(Gender)
decode gender, gen(GENDER)
describe gender Gender GENDER
* compare between tostring and decode
* tabulate categorical variables
tab Gender // tostring convert the "values" of a numeric variable
tab GENDER // decode convert the "labels" of a numeric variable

* convert string variables to numeric variables: destring, encode
destring GENDER, gen(gender1) //destring cannot work with string variable with "words"
destring Gender, gen(gender2)
encode GENDER, gen(gender3) //encode generate numeric variable with values
encode Gender, gen(gender4) //again, encode generate numeric variable with values
tab gender3
tab gender3, nolabel // tab without label
label list gender3
label list gender4


*** Storage types
des pid fid gender
recast float pid, force
des pid fid gender
compress


*** Display Formats
format %9.0g pid //change the format for pid
format pid //check the format for pid
format %12.0f pid
format pid

list rswt_nat in 1/5
des rswt_nat
format %12.5fc rswt_nat
list rswt_nat in 1/5
des rswt_nat
format %12.5f rswt_nat






*** Variable names
* rename a single variable
rename gender sex
* help rename group
rename (gender2 gender3 gender4) (sex2 sex3 sex4)
rename sex* gender*
drop GENDER
rename gender*, upper
rename GENDER, lower
*browse gender2 gender3 gender4






*** Generate new variables
*generate x = .
gen birthy = 2010 - age // ==
*generate newid = _n

egen meanage = mean(age)
tab meanage
bysort gender: egen meaneduy = mean(eduy)
tab meaneduy
* help egen







*** Change values

* educated or not
* 1 if eduy>0; 0 if eduy==0

* replace
gen educated = . //generate a numeric variable with missing values .
replace educated = 0 if eduy==0
replace educated = 1 if eduy>0 & eduy!=. //~=
tab educated, mi
*replace educated = .

// recode 

/*
gen educated = 1 //1 for educated
replace educated = 0 if eduy==0 //0 for not educated
replace educated = . if eduy==.
label define
label value

recode eduy (0=0 "No") (1/19=1 "Yes") (else=.), gen(educated)
*/


gen EDUCATED = "" //generate a string variable with missing values ""
replace EDUCATED = "Not Educated" if eduy==0
replace EDUCATED = "Educated" if eduy>0 & eduy!=.
tab EDUCATED

replace gender = 2 if gender==0

* recode
*recode age (16/25=1) (26/35=2) (36/45=3) (46/55=4) (56/65=5) (else=6)
recode age (16/25=1) (26/35=2) (36/45=3) (46/55=4) (56/65=5) (else=6), ///
	gen(age_cut) //cohort
tab age_cut

// generate & replace


*** Missing values
replace income=-10 if income==. // not applicable
replace income=-9 if income==0 // refuse to answer
 // CGSS, 999 missing, not applicable
count if income==.
count if income<0
*replace income = . if income<0
mvdecode income age han urban, mv(-10/-1) //income==-9 | income==-10 
count if income==.


*** Label variables

*3 types of labels
* 1. data label 
* 2. variable label
* 3. value label

* add labels to data
label data "subset of CFPS 2010, for STATA Tutorial"
describe, short


* add/change label to variables
label variable educated "Ever received any education"
label variable age_cut "Age Categories / Cohort"
des educated age_cut


* add label to values 值标签
label define educated_lab 1 "Yes" 0 "No" //define value label "yesno" 1
label value educated educated_lab //add value label to categorical variables 2
tab educated
tab educated, nolab
des educated
*label drop yesno

*Try add value labels for age_cut
label define age_cut_label ///
	1 "Cohort: 16-25" ///
	2 "Cohort: 26-35" ///
	3 "Cohort: 36-45" ///
	4 "Cohort: 46-55" ///
	5 "Cohort: 56-65" ///
	6 "Cohort: >65"
label list age_cut_label

label value age_cut age_cut_label
tab age_cut
tab age_cut, nolab




*** Keep and drop rows or columns
* keep and drop rows
keep if income!=. // drop if income==.
//keep if income~=.
drop if age>65 //keep if age<=65
count

* keep and drop variables
drop Gender GENDER2
drop birthy-age_cut
keep pid-ccp //drop GENDER3 GENDER4


*** Sort and order
sort pid
sort age
gsort -age
gsort -age eduy

order pid fid urban hukou han
order rswt_nat, last


*** Save data
sort pid
compress //compress to proper storage type to save storage

* save ...











