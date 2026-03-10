* STATA Tutorial for MGCS5010
* Bing TIAN, Oct 2024


* Contents
*************************************
* Index data: _n, _N, [n], [_n-k], [_n+k]
* Macros: global, local
* Loops: forvalues, foreach, for
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

******************************************
* Index data: _n, _N, [_n-k], [_n+k]
******************************************

clear
set obs 5
gen x = _n
gen X = _n*100
dis X[1] 
dis X[2] " " X[3] " " X[4] " " X[5]
dis _N
gen Y = _N

replace X = X[_n+1]
list X
replace X = X[_n-1]
list X

******************************************
* Macros: global and local
******************************************

*** global vs local
local city Beijing Shanghai Tianjin Chongqing
display "local: `city'"
global city Beijing Shanghai Tianjin Chongqing
display "global: $city"
* global tells Stata to store everything in its memory until you exit Stata. 
* local tells Stata to keep everything in memory only until the program or do-file ends.

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

* macro 宏
*** local with extended functions
local city Beijing Shanghai Tianjin Chongqing
local n: word count `city'
dis `n'
local city Beijing Shanghai Tianjin Chongqing
local three: word 3 of `city'
dis "`three'"
local city Beijing Shanghai Tianjin Chongqing
local l: length local city
dis `l'
local pdir: sysdir PERSONAL
dis "`pdir'"



******************************************
* Loops: forvalues, foreach, for
******************************************

*** forvalues loop
* use proper indentation
forvalues m=1/4 {
  dis "num: `m'"
}

forvalues i = 4(-1)1 {
  dis `i'
}

forvalues i=1(8)20 {
  dis `i'
}


clear
set obs 5
forvalues i=1/5 {
  gen x`i' = `i'
  label var x`i' "variable `i'"
  *label define x`i'_label 1 ""
  *label value x`i' x`i'_label
}
list
des x1-x4



local city Beijing Shanghai Tianjin Chongqing 
local code 010 021 022 023
forvalues i=1/4 {
  local name : word `i' of `city'
  local num  : word `i' of `code'
  dis "The area code of `name' is: `num'"
}



*** foreach loop
foreach A in a b c {
	dis "`A'"
}


local city Beijing Shanghai Tianjin Chongqing
foreach A of local city {
	dis " City: `A' "
}


foreach A of global city {
	dis "City: `A'"
}



foreach A of varlist x1-x4 {
	dis "Summary Statistic of `A'"
	summarize `A'
	tab `A'
}

foreach A in x1-x4 {
	dis "Summary Statistic of `A'"
	sum `A'
	tab `A'
}
sum x1-x4

foreach A in x1 x2 x3 x4 {
	dis "Summary Statistic of `A'"
	sum `A'
	tab `A'
}




*** nested loops
clear
foreach var in X Y Z {
	forval i=1/3 {
		gen `var'`i'=.
	}
}

clear
forval i=1/3 {
	foreach var in X Y Z {
		gen `var'`i'=.
	}
}
des, simple



******************************************
*Application 1: assign numbers to a set of newly-generated variables
******************************************
clear
set obs 10

* method 1
*local i=0
foreach j of numlist 2 9 10 89 {
    local i=`i'+1
    gen Avar`i'=`j'
}
sum Avar*

* method 2
local A 2 9 10 89
forvalues i=1/4 {
  local j: word `i' of `A'
  gen Bvar`i'=`j'
}
sum Bvar*

* method3
local A xa xb xc xd
local B 2 9 10 89
forvalues i=1/4 {
    local m: word `i' of `A'
    local n: word `i' of `B'
    gen `m'=`n'
}
sum x*



******************************************
*Application 2: Process survey data quicker
******************************************
global datadir "."
use "$datadir/cfps2010adult_10%.dta", clear

forvalues i=1/15 {
    label var qb301_a_`i' "Relation for sibling `i'"
}

foreach i of numlist 1 3/4 {
    label var qb303b_a_`i' "Age of sibling `i'"
}

foreach var in qb303y_a_1 qb303m_a_1 qb303b_a_1 {
    sum `var'
}

local B qb301_a_*
sum `B'
for varlist `B': sum X
foreach i of local B {
    sum `i'
}
