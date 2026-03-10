// STATA Tutorial for MGCS5010
* Bing TIAN


* Contents
*************************************
* Notes: *, //, /* */
* Set preambles: version, clear, ...
* Set working directories: pwd, cd
*************************************


***********************************
* Preamble
************************************
version 15.1 //specify the versions 

************************************
* Working Directory
************************************
pwd //print working directory
cd "./data"
pwd



global stata "."
cd $stata
use "$stata/data/cfps2010adult_10%.dta", clear // open data from a specified folder
graph bar, over(urban)
graph export "$stata/output/bar.pdf", replace // save pdf file to a specified folder

cd "./data"
use cfps2010adult_10%.dta, clear

