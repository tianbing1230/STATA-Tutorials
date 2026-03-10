* STATA Tutorial for MGCS5010
* Bing TIAN, Oct 2023


* Contents
*************************************
* Data Visualization

* I. Choose Appropriate Plot Types
* II. Plot Placement
* III. Customizing Appearance
* IV. Save and Export Plots
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


use "$stata/data/cfps10_foruse.dta", clear
**********************
* I. Choose Appropriate Plot Types
**********************

*** Categorical Variable
* bar
graph bar (count), over(gender)
graph hbar (count), over(gender)
graph bar (percent), over(gender)
graph hbar (percent), over(gender)
graph export "$stata/output/hbar.pdf", replace

* pie
graph pie, over(gender)


*** Continuous Variable
gen loginc= log(income+1) if income>0
label var loginc "Logged Annual Income"

* boxplot
graph box income
graph box loginc

* histogram 
histogram income
histogram loginc
graph export "$stata/output/hist.pdf", replace

* density curve
kdensity loginc


*** Two Continuous Variables
* scatter plot
twoway scatter loginc eduy
graph export "$stata/output/scatter.pdf", replace

*** Two Categorical Variables
graph bar, percentages over(edu) over(urban) asyvars stack
graph export "$stata/output/twowaybar.pdf", replace

*** Categorical + Continuous
histogram loginc, by(gender)
graph export "$stata/output/twowayhist1.pdf", replace
graph box loginc, by(gender)
graph box loginc, over(gender)


**********************
* II. Plot Placement
**********************
*** Juxtapose
histogram loginc, by(gender)
graph box loginc, over(gender)
* check the help document for proper options

*** Superimpose
* Method 1: ||
twoway histogram loginc if gender==1 || histogram loginc if gender==0
* Method 2: ()
twoway (histogram loginc if gender==1) (histogram loginc if gender==0)
graph export "$stata/output/twowayhist2.pdf", replace

**********************
* III. Customizing Appearance
**********************

*** Appearance for readability and ascetic reasons
twoway (hist loginc if gender==1, color(green)) ///
	(hist loginc if gender==0, fcolor(none)), ///
	legend(order(1 "Male" 2 "Female"))
*help twoway_options
graph export "$stata/output/twowayhist3.pdf", replace

twoway (scatter loginc eduy) (lfit loginc eduy), ///
	legend(off) ///
	ytitle("Logged Annual Income") ///
	note("Correlation Coefficient=0.4273")
graph export "$stata/output/twoway.pdf", replace

graph pie, over(gender) 

#delimit ;
graph pie, over(gender) 
	pie(1, color(navy%30)) 
	pie(2, color(olive)) 
	plabel(_all percent) ;
#delimit cr
graph export "$stata/output/pie.pdf", replace
* There are a lot of options for you to explore

*** Schemes
* brewscheme
*https://www.stata.com/meeting/switzerland16/slides/bischof-switzerland16.pdf
*ssc install brewscheme
*you can also set your own schemes
graph box eduy
graph box loginc, scheme(economist)
graph box eduy, scheme(plotplain)
graph box loginc, scheme(plottig)


*the default scheme is s2color
*set scheme for current environment
set scheme plotplain
twoway (hist loginc if gender==1, color(green)) ///
	(hist loginc if gender==0, fcolor(none)), ///
	legend(order(1 "Male" 2 "Female"))
graph export "$stata/output/twowayhist4.pdf", replace
*jpeg png
**********************
* IV. Save and Export Plots
**********************
*** Save .gph file
*graph save ...
 
*** Export other plot types
*graph export ...
