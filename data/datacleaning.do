cd "." //change to your own working directory

use "cfps2010adult_10%.dta", clear

**********************************
* Part0. Identifiers
**********************************
mvdecode pid fid rswt_nat, mv(-10/-1)
* Individual ID / 个人ID
    clonevar a_pid = pid
* Family ID / 家庭ID
    clonevar a_fid = fid
* Weight_National / 个人权重-全国样本
    clonevar a_rswt_nat = rswt_nat

**********************************
* Part1. Basic Demographics
**********************************
* Age in Survey Year / 年龄（调查年）
    gen a_age = qa1age
* Gender / 性别
    gen a_gender = gender
* Han / 汉族
    gen a_han = qa5code==1
    replace a_han = . if qa5code<0
* Residence (Urban/Rural) / 居住地（城乡）
    gen a_urban= urban
* Hukou / 户口
    recode qa2 (-10/-1=.) (1=0) (3=1) (5 79=2), gen(a_hukou)

**********************************
* Part2. Education
**********************************
* Highest Educational Level Attained / 最高学历
    gen a_edu = cfps2010edu_best if cfps2010edu_best > 0
* Years of Education Received / 教育年限
    gen a_eduy = cfps2010eduy_best if cfps2010eduy_best >= 0

**********************************
* Part3. Labor Market Outcomes
**********************************
* Labor Market Participation / 经济活动情况
    gen a_employ = .
    replace a_employ = 0 if (qg3 == 0 | qg2 == 0) & qj1 == 1
    replace a_employ = 1 if qg3 == 1
    replace a_employ = 2 if (qg3 == 0 | qg2 == 0) & a_employ == .
* Current Occupation Employment Status / 当前职业就业身份
    gen a_employs = .
    replace a_employs = 1 if qg303 == 3
    replace a_employs = 2 if qg303 == 1
    replace a_employs = 3 if qg303 == 5 | qg4 == 1
* Current Occupation Type (ISCO88) / 当前职业（ISCO88）
    clonevar a_occtype_isco = qg307isco if qg307isco > 0
* Current Occupation (10 Categories) / 当前职业（10类）
    gen a_occtype_crude = floor(a_occtype_isco/1000)
* Current Occupation ISEI / 当前职业ISEI
    gen a_occisei = qg307isei if qg307isei > 0
* Tenure of Current Occupation / 当前职业工龄
    gen a_tenure = 2010 - qg311 if qg311 > 1000
* Working Hours Per Week / 每周工作小时数
    gen a_wkhr = (qg402/(30/7))*qg403 if qg403 >= 0 & qg402 >= 0
    replace a_wkhr = . if a_wkhr >=  168

**********************************
* Part4. Income
**********************************
* Annual Total Income / 年总收入
    gen a_income = income if income>=0

**********************************
* Part5. Family Socioecnomic Status
**********************************
* Number of Siblings / 兄弟姐妹数
    gen a_nsib = qb1 if qb1 >=0
* Father's Highest Educational Level Attained / 父亲最高学历
* Mother's Highest Educational Level Attained / 母亲最高学历
    gen a_fedu = feduc if feduc > 0
    gen a_medu = meduc if meduc > 0
* Father's Occupation (ISCO88) / 父亲职业（ISCO88）
* Mother's Occupation (ISCO88) / 母亲职业（ISCO88）
    gen a_focctype_isco = foccupisco if foccupisco > 0
    gen a_mocctype_isco = moccupisco if moccupisco > 0
* Father's Occupation ISEI / 父亲职业ISEI
* Mother's Occupation ISEI / 母亲职业ISEI
    *ssc install isko
    iskoisei a_foccisei, isko(a_focctype_isco)
    iskoisei a_moccisei, isko(a_mocctype_isco)
* Whether Father's a CCP Member / 父亲是否共产党员
* Whether Mother's a CCP Member / 母亲是否共产党员
    recode fparty (1=1) (2/4=0) (else=.), gen(a_fccp)
    recode mparty (1=1) (2/4=0) (else=.), gen(a_mccp)

**********************************
* Part6. Cognitive/Non-cognitive/Language Abilities
**********************************
* Original Score for Word Test / 字词测试原始得分
    gen a_word = wordtest if wordtest >= 0
* Original Score for Math Test / 数学测试原始得分
    gen a_math = mathtest if mathtest >= 0

**********************************
* Part7. Marriage and Family
**********************************
* Current Marital Status / 当前婚姻状况
    gen a_marriage = qe1 if qe1 > 0
* Spouse's Birth Year / 配偶出生年份
    gen a_sbirthy = qe211y if qe211y > 0
    replace a_sbirthy = tb1y_a_s if tb1y_a_s > 0 & a_sbirthy == .
* Spouse's Highest Educational Level Attained / 配偶最高学历
    gen a_sedu = tb4_a_s if tb4_a_s >= 0
    replace a_sedu = sedu if sedu >= 0 & a_sedu == .
* Spouse's Years of Education / 配偶受教育年限
    gen a_seduy = seduy if seduy >= 0
* Number of Children / 孩子数
    gen a_nchild = 0
    foreach var of varlist code_a_c* {
        replace a_nchild = a_nchild+1 if `var'>=0 & `var'!=.
    }

**********************************
* Part8. Political Experience & Attitudes
**********************************
* CCP Membership / 党员
    gen a_ccp = .
    forvalues i=1/14 {
        replace a_ccp = 1 if qa7_s_`i'==1
    }
    replace a_ccp = 0 if qa7_s_1>0 & a_ccp==.

**********************************
* Labeling
**********************************
* Keep Generated Variables
    keep a_*
* Rename Variables
    rename a_* *
* Label Variables
    label var pid "Individual ID"
    label var fid "Family ID"
    label var rswt_nat "Weight_National"
    label var age "Age in Survey Year"
    label var gender "Gender "
    label var han "Han"
    label var urban "Residence (Urban/Rural)"
    label var hukou "Hukou"
    label var edu "Highest Educational Level Attained"
    label var eduy "Years of Education Received"
    label var employ "Labor Market Participation"
    label var employs "Current Employment Status"
    label var occtype_isco "Current Occupation (ISCO88/08)"
    label var occtype_crude "Current Occupation (10 Categories)"
    label var occisei "Current Occupation ISEI"
    label var tenure "Tenure of Current Occupation"
    label var wkhr "Weekly Working Hours"
    label var income "Annual Total Income"
    label var nsib "Number of Siblings"
    label var fedu "Father's Highest Educational Level Attained"
    label var medu "Mother's Highest Educational Level Attained"
    label var focctype_isco "Father's Occupation (ISCO88)"
    label var mocctype_isco "Mother's Occupation (ISCO88)"
    label var foccisei "Father's Occupation ISEI"
    label var moccisei "Mother's Occupation ISEI"
    label var fccp "Whether Father's a CCP Member"
    label var mccp "Whether Mother's a CCP Member"
    label var word "Original Score for Word Test"
    label var math "Original Score for Math Test"
    label var marriage "Current Marriage Status"
    label var sbirthy "Spouse's Birth Year"
    label var sedu "Spouse's Highest Educational Level Attained"
    label var seduy "Spouse's Years of Education"
    label var nchild "Number of Children"
    label var ccp "CCP Membership"
* Define Label Values
	label drop _all
    label define gender 0 "Female" 1 "Male"
    label define han 0 "Ethnic Minorities" 1 "Han"
    label define urban 0 "Rural Areas" 1 "Urban Areas"
    label define hukou 0 "Rural" 1 "Non-Rural" 2 "Others"
	
	label define edu ///
			1 "Below Elementary" ///
			2 "Elementary School" ///
			3 "Junior High and Vocational School" ///
			4 "Senior High and Vocational School" ///
			5 "Vocational College or Some College" ///
			6 "Bachelor Degree" ///
			7 "Master Degree" /// 
			8 "PhD Degree" ///
	
	label define employ 0 "Unemployed" 1 "Currently Working" 2 "Not in Labor Market"
	label define employs 1 "Employed" 2 "Non-Farm Self-Employed" 3 "Farmer"
	
	label define occtype_crude ///
			1 "Legislators, Senior Officials And Managers" ///
			2 "Professionals" ///
			3 "Technicians And Associate Professionals" ///
			4 "Clerks" ///
			5 "Service Workers And Shop And Market Sales Workers" ///
			6 "Skilled Agricultural And Fishery Workers" ///
			7 "Craft And Related Trades Workers" ///
			8 "Plant And Machine Operators And Assemblers" ///
			9 "Elementary Occupations"
	
	label define marriage ///
			1 "Never Married" ///
			2 "Married" ///
			3 "Cohabiting" ///
			4 "Divorced" ///
			5 "Widowed"
	
	label define sedu ///
			1 "Below Elementary" ///
			2 "Elementary School" ///
			3 "Junior High and Vocational School" ///
			4 "Senior High and Vocational School" ///
			5 "Vocational College or Some College" ///
			6 "Bachelor Degree" ///
			7 "Master Degree" ///
			8 "PhD Degree"
			
* Label values	
	foreach var of varlist gender han urban hukou edu employ employs occtype_crude marriage sedu {
		label values `var' `var'
	}

**********************************
* Save Data
**********************************
    sort pid
    save "cfps10_foruse.dta", replace
