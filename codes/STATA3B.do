* STATA Tutorial for MGCS5010
* Bing TIAN, Oct 2024


* Contents
*************************************
* Common data structures
* Combine data (columns): merge
* Combine data (rows): append 
* Reshape data: reshape wide, reshape long
* Aggregate data: collapse
* Other useful commands coverd: duplicates, expand, preserve/restore
*************************************


************************************
* Preamble
************************************
version 15.1
clear /* Clear data in memory before loading new data*/


*************************************
* Common data structures
*************************************

*** cross-sectional
clear
set obs 6
gen id = _n
forval i=1/3 {
	gen var`i'=.
}
list, noobs clean

*** pooled cross-sectional
gen sample=2022 in 1/3
replace sample=2023 in 4/6
order sample id
list, noobs clean

*** time series data
drop sample
replace id=1
gen year=2015+_n
order id year
list, noobs clean

*** panel data
replace id=1 in 1/3
replace id=2 in 4/6
bysort id: replace year=2015+_n
list, noobs clean

*** multilevel data
drop year
rename id hid
bysort hid: gen pid=_n
order hid pid
list, noobs clean

*** paired data
gen sid = 2 if pid==1
replace sid = 1 if pid==2
gen sinfo = .
order hid pid sid sinfo
list, noobs clean


************************************
* Combine data: append and merge
************************************

************************
* prepare data
global datadir "."

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
list, noobs clean
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
list, noobs clean
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
replace dataset=3 if dataset==1
list in 1/10, noobs clean
save "$datadir/temp03", replace




************************

*** append data
use "$datadir/temp01", clear //main dataset; memory
append using "$datadir/temp02"
*use "$datadir/temp02", clear
*gen newid = dataset*100+id
*order newid
list, noobs clean

*** merge data (1:1)
use "$datadir/temp01", clear 
merge 1:1 id using "$datadir/temp02", keep(match) keepusing(male) nogen //merge by id
list, noobs clean 
*for matched cases, taking values from master data

*** merge data: m:1 
use "$datadir/temp03", clear
merge m:1 id using "$datadir/temp02" // , keep(match) nogen keepusing(edu)
list in 1/10, sepby(id) noobs clean

*** Try 1:m yourself
use "$datadir/temp02", clear
merge 1:m id using "$datadir/temp03"
*** m:m tends to generate wrong results

*** Duplicates
*merging data most times requires unique identifier
*you may need to check for duplicate cases using "duplicate"
help duplicates


************************************
* Reshape wide or reshape long
************************************
use "$datadir/temp03", clear
merge m:1 id using "$datadir/temp02", keepusing(edu) nogen
sort id age
bysort id: gen year=2000+_n
order id year
drop dataset 
list in 1/10, noobs clean 






*** reshape from long to wide
reshape wide edu age, i(id) j(year)  
	//don't need list constant varialbes, e.g. "male"
list id male edu2001 edu2002 age2001 age2002, noobs clean
* time-variant / time-invariant variables

*** reshape from wide to long
reshape long edu@ age@, i(id) j(time) 
	//unbalanced panel data problem
	//don't need list constant varialbes, e.g. "male"
*sort id 
drop if id==id[_n-1] & edu==. & age==.
	//drop empty observations
list in 1/10, noobs clean 

* balanced / unbalanced panel data

************************************
* Aggregate data and generate group-level statistics
************************************

*** Aggregate to group level statistics, e.g. mean, count, sum, %...
preserve //preserve current memory
collapse (max) maxage=age (mean) aveage=age (mean) edu, by(id)
list, noobs clean
restore //restore to the state when we "preserve"






