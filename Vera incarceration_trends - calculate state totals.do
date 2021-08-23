***************************************************************
*Vera incarceration data - calculate state totals for jail & prison
*Rachael Druckhammer 03/10/21
***************************************************************

***************************************************************
*set file paths & names
***************************************************************
*set directory - be sure to update before running
cd "<whatever your path is>"

*data year - be sure to update before running
global curr_yr 2018

*raw data file path
global raw_path Raw data files/Vera/Incarceration Trends/data thru ${curr_yr}/files from Vera

*formatted data file path
global fmt_path Formatted data files/Vera
 

/*************************************************************
*NOTE: Stata variable names can only be 32 chars; can't rename 
variables to match db column headings so use variable labels 
instead; then export file to excel with variable labels
*************************************************************/
*install -labvars- package to label multiple variables at once 
*(if package is already installed, Stata will skip this automatically)
ssc install labutil2, replace

***************************************************************
*bring in raw Vera data & format
***************************************************************
import excel using `"${raw_path}/incarceration_trends.xlsx"', sheet("Sheet1") firstrow clear

*drop unnecessary variables 
drop yfips fips division commuting_zone metro_area land_area

*replace state abbreviations with state names 
rename state Abbreviation
generate State="Alabama" if Abbreviation=="AL"
replace State="Alaska" if Abbreviation=="AK"
replace State="Arizona" if Abbreviation=="AZ"
replace State="Arkansas" if Abbreviation=="AR"
replace State="California" if Abbreviation=="CA"
replace State="Colorado" if Abbreviation=="CO"
replace State="Connecticut" if Abbreviation=="CT"
replace State="Delaware" if Abbreviation=="DE"
replace State="District of Columbia" if Abbreviation=="DC"
replace State="Florida" if Abbreviation=="FL"
replace State="Georgia" if Abbreviation=="GA"
replace State="Hawaii" if Abbreviation=="HI"
replace State="Idaho" if Abbreviation=="ID"
replace State="Illinois" if Abbreviation=="IL"
replace State="Indiana" if Abbreviation=="IN"
replace State="Iowa" if Abbreviation=="IA"
replace State="Kansas" if Abbreviation=="KS"
replace State="Kentucky" if Abbreviation=="KY"
replace State="Louisiana" if Abbreviation=="LA"
replace State="Maine" if Abbreviation=="ME"
replace State="Maryland" if Abbreviation=="MD"
replace State="Massachusetts" if Abbreviation=="MA"
replace State="Michigan" if Abbreviation=="MI"
replace State="Minnesota" if Abbreviation=="MN"
replace State="Mississippi" if Abbreviation=="MS"
replace State="Missouri" if Abbreviation=="MO"
replace State="Montana" if Abbreviation=="MT"
replace State="Nebraska" if Abbreviation=="NE"
replace State="Nevada" if Abbreviation=="NV"
replace State="New Hampshire" if Abbreviation=="NH"
replace State="New Jersey" if Abbreviation=="NJ"
replace State="New Mexico" if Abbreviation=="NM"
replace State="New York" if Abbreviation=="NY"
replace State="North Carolina" if Abbreviation=="NC"
replace State="North Dakota" if Abbreviation=="ND"
replace State="Ohio" if Abbreviation=="OH"
replace State="Oklahoma" if Abbreviation=="OK"
replace State="Oregon" if Abbreviation=="OR"
replace State="Pennsylvania" if Abbreviation=="PA"
replace State="Rhode Island" if Abbreviation=="RI"
replace State="South Carolina" if Abbreviation=="SC"
replace State="South Dakota" if Abbreviation=="SD"
replace State="Tennessee" if Abbreviation=="TN"
replace State="Texas" if Abbreviation=="TX"
replace State="Utah" if Abbreviation=="UT"
replace State="Vermont" if Abbreviation=="VT"
replace State="Virginia" if Abbreviation=="VA"
replace State="Washington" if Abbreviation=="WA"
replace State="West Virginia" if Abbreviation=="WV"
replace State="Wisconsin" if Abbreviation=="WI"
replace State="Wyoming" if Abbreviation=="WY"

*reorder variables to put year & state info at front
order Abbreviation State year region county_name urbanicity

*drop abbreviation variable after spot checking data
drop Abbreviation

*save formatted file before splitting out jail and prison files
save `"${fmt_path}/incarceration trends 1970-${curr_yr}.dta"', replace

***************************************************************
*create & save jail data files
***************************************************************
*get formatted data
use `"${fmt_path}/incarceration trends 1970-${curr_yr}.dta"', clear

*drop prison variables
drop total_prison_pop-white_male_prison_adm total_prison_pop_rate-white_prison_adm_rate
*Note: do not need to reorder variables to match database!

*label variables 
labvars State year region county_name urbanicity total_pop total_pop_15to64 female_pop_15to64 male_pop_15to64 aapi_pop_15to64 black_pop_15to64 latinx_pop_15to64 native_pop_15to64 white_pop_15to64 total_jail_pop female_jail_pop male_jail_pop female_adult_jail_pop female_juvenile_jail_pop male_adult_jail_pop male_juvenile_jail_pop aapi_jail_pop black_jail_pop latinx_jail_pop native_jail_pop white_jail_pop other_race_jail_pop total_jail_pretrial total_jail_from_prison total_jail_from_other_jail total_jail_from_fed total_jail_from_bia total_jail_from_bop total_jail_from_ice total_jail_from_marshals total_jail_from_other_fed total_jail_adm total_jail_dis total_jail_pop_dcrp female_jail_pop_dcrp male_jail_pop_dcrp total_jail_adm_dcrp female_jail_adm_dcrp male_jail_adm_dcrp jail_rated_capacity private_jail_flag regional_jail_flag total_jail_pop_rate female_jail_pop_rate male_jail_pop_rate aapi_jail_pop_rate black_jail_pop_rate latinx_jail_pop_rate native_jail_pop_rate white_jail_pop_rate total_jail_adm_rate total_jail_pretrial_rate "State" "Year" "Region" "County" "Urbanicity" "Resident_Population" "Population15to64_Total_forRates" "Population15to64_Females_forRates" "Population15to64_Males_forRates" "Population15to64_Asian_Pacific_Islander_forRates" "Population15to64_Black_forRates" "Population15to64_Hispanic_forRates" "Population15to64_Native_American_forRates" "Population15to64_White_forRates" "Jail_Population_Total" "Jail_Population_Females" "Jail_Population_Males" "Jail_Population_Females_Adult" "Jail_Population_Females_Juv" "Jail_Population_Males_Adult" "Jail_Population_Males_Juv" "Jail_Population_Asian_Pacific_Islander" "Jail_Population_Black" "Jail_Population_Hispanic" "Jail_Population_Native_American" "Jail_Population_White" "Jail_Population_Other_Race" "Jail_Population_Pretrial" "Jail_Population_Hold_Prison" "Jail_Population_Hold_Other_Jail" "Jail_Population_Hold_All_Federal" "Jail_Population_Hold_Indian_Affairs" "Jail_Population_Hold_Bureau_of_Prisons" "Jail_Population_Hold_ICE" "Jail_Population_Hold_US_Marshals" "Jail_Population_Hold_Other_Federal" "Jail_Admissions_Total" "Jail_Discharges_Total" "Jail_Population_Total_DCRP" "Jail_Population_Females_DCRP" "Jail_Population_Males_DCRP" "Jail_Admissions_Total_DCRP" "Jail_Admissions_Females_DCRP" "Jail_Admissions_Males_DCRP" "Jail_Capacity" "County_Had_Private_Jail" "County_Had_Regional_Jail" "Jail_Population_Rate_Total" "Jail_Population_Rate_Females" "Jail_Population_Rate_Males" "Jail_Population_Rate_Asian_Pacific_Islander" "Jail_Population_Rate_Black" "Jail_Population_Rate_Hispanic" "Jail_Population_Rate_Native_American" "Jail_Population_Rate_White" "Jail_Admission_Rate_Total" "Jail_Population_Rate_Pretrial"

*select just the current year of data
drop if year < ${curr_yr}
tab year

*aggregate county numbers to get state totals (collapse step will drop county variables)
collapse (sum) total_pop-total_jail_from_other_fed total_jail_adm-male_jail_adm_dcrp, by(State year)

*re-label collapsed jail variables
labvars total_pop total_pop_15to64 female_pop_15to64 male_pop_15to64 aapi_pop_15to64 black_pop_15to64 latinx_pop_15to64 native_pop_15to64 white_pop_15to64 total_jail_pop female_jail_pop male_jail_pop female_adult_jail_pop female_juvenile_jail_pop male_adult_jail_pop male_juvenile_jail_pop aapi_jail_pop black_jail_pop latinx_jail_pop native_jail_pop white_jail_pop other_race_jail_pop total_jail_pretrial total_jail_from_prison total_jail_from_other_jail total_jail_from_fed total_jail_from_bia total_jail_from_bop total_jail_from_ice total_jail_from_marshals total_jail_from_other_fed total_jail_adm total_jail_dis total_jail_pop_dcrp female_jail_pop_dcrp male_jail_pop_dcrp total_jail_adm_dcrp female_jail_adm_dcrp male_jail_adm_dcrp "Resident_Population" "Population15to64_Total_forRates" "Population15to64_Females_forRates" "Population15to64_Males_forRates" "Population15to64_Asian_Pacific_Islander_forRates" "Population15to64_Black_forRates" "Population15to64_Hispanic_forRates" "Population15to64_Native_American_forRates" "Population15to64_White_forRates" "Jail_Population_Total" "Jail_Population_Females" "Jail_Population_Males" "Jail_Population_Females_Adult" "Jail_Population_Females_Juv" "Jail_Population_Males_Adult" "Jail_Population_Males_Juv" "Jail_Population_Asian_Pacific_Islander" "Jail_Population_Black" "Jail_Population_Hispanic" "Jail_Population_Native_American" "Jail_Population_White" "Jail_Population_Other_Race" "Jail_Population_Pretrial" "Jail_Population_Hold_Prison" "Jail_Population_Hold_Other_Jail" "Jail_Population_Hold_All_Federal" "Jail_Population_Hold_Indian_Affairs" "Jail_Population_Hold_Bureau_of_Prisons" "Jail_Population_Hold_ICE" "Jail_Population_Hold_US_Marshals" "Jail_Population_Hold_Other_Federal" "Jail_Admissions_Total" "Jail_Discharges_Total" "Jail_Population_Total_DCRP" "Jail_Population_Females_DCRP" "Jail_Population_Males_DCRP" "Jail_Admissions_Total_DCRP" "Jail_Admissions_Females_DCRP" "Jail_Admissions_Males_DCRP"

*loop through variables to calculate rates based on state totals
foreach v of varlist total_jail_adm total_jail_pop female_jail_pop male_jail_pop aapi_jail_pop black_jail_pop latinx_jail_pop native_jail_pop white_jail_pop total_jail_pretrial {
	*generate rate variable name based on var name
	local ratevar = "`v'"+"_rate"
	
	*get name of population group based on first part of var name (total, males, black, etc.)
	local popvar = substr("`v'",1,strpos("`v'","_"))+"pop_15to64"
	
	*calculate rate for each variable
	generate `ratevar' = (`v' / `popvar') * 100000
}

*label rate variables
labvars total_jail_pop_rate female_jail_pop_rate male_jail_pop_rate aapi_jail_pop_rate black_jail_pop_rate latinx_jail_pop_rate native_jail_pop_rate white_jail_pop_rate total_jail_adm_rate total_jail_pretrial_rate "Jail_Population_Rate_Total" "Jail_Population_Rate_Females" "Jail_Population_Rate_Males" "Jail_Population_Rate_Asian_Pacific_Islander" "Jail_Population_Rate_Black" "Jail_Population_Rate_Hispanic" "Jail_Population_Rate_Native_American" "Jail_Population_Rate_White" "Jail_Admission_Rate_Total" "Jail_Population_Rate_Pretrial" 

*save formatted file to excel
export excel using `"${fmt_path}/Jail - State Totals ${curr_yr}.xlsx"', firstrow(varlabels) replace


***************************************************************
*create & save prison data files
***************************************************************
*get formatted data
use `"${fmt_path}/incarceration trends 1970-${curr_yr}.dta"', clear

*drop jail variables
drop total_jail_pop-male_jail_adm_dcrp total_jail_pop_rate-total_jail_pretrial_rate
*Note: do not need to reorder variables to match database!

*label prison variables
labvars State year total_pop total_pop_15to64 female_pop_15to64 male_pop_15to64 aapi_pop_15to64 black_pop_15to64 latinx_pop_15to64 native_pop_15to64 white_pop_15to64 total_prison_pop female_prison_pop male_prison_pop aapi_prison_pop black_prison_pop latinx_prison_pop native_prison_pop other_race_prison_pop white_prison_pop aapi_female_prison_pop aapi_male_prison_pop black_female_prison_pop black_male_prison_pop latinx_female_prison_pop latinx_male_prison_pop native_female_prison_pop native_male_prison_pop other_race_female_prison_pop other_race_male_prison_pop white_female_prison_pop white_male_prison_pop total_prison_adm female_prison_adm male_prison_adm aapi_prison_adm black_prison_adm latinx_prison_adm native_prison_adm other_race_prison_adm white_prison_adm aapi_female_prison_adm aapi_male_prison_adm black_female_prison_adm black_male_prison_adm latinx_female_prison_adm latinx_male_prison_adm native_female_prison_adm native_male_prison_adm other_race_female_prison_adm other_race_male_prison_adm white_female_prison_adm white_male_prison_adm total_prison_pop_rate female_prison_pop_rate male_prison_pop_rate aapi_prison_pop_rate black_prison_pop_rate latinx_prison_pop_rate native_prison_pop_rate white_prison_pop_rate total_prison_adm_rate female_prison_adm_rate male_prison_adm_rate aapi_prison_adm_rate black_prison_adm_rate latinx_prison_adm_rate native_prison_adm_rate white_prison_adm_rate "State" "Year" "Resident_Population" "Population15to64_Total_forRates" "Population15to64_Females_forRates" "Population15to64_Males_forRates" "Population15to64_Asian_Pacific_Islander_forRates" "Population15to64_Black_forRates" "Population15to64_Hispanic_forRates" "Population15to64_Native_American_forRates" "Population15to64_White_forRates" "Prison_Population_Total" "Prison_Population_Females" "Prison_Population_Males" "Prison_Population_Asian_Pacific_Islander" "Prison_Population_Black" "Prison_Population_Hispanic" "Prison_Population_Native_American" "Prison_Population_Other" "Prison_Population_White" "Prison_Population_Asian_Pacific_Islander_Females" "Prison_Population_Asian_Pacific_Islander_Males" "Prison_Population_Black_Females" "Prison_Population_Black_Males" "Prison_Population_Hispanic_Females" "Prison_Population_Hispanic_Males" "Prison_Population_Native_American_Females" "Prison_Population_Native_American_Males" "Prison_Population_Other_Females" "Prison_Population_Other_Males" "Prison_Population_White_Females" "Prison_Population_White_Males" "Prison_Admissions_Total" "Prison_Admissions_Females" "Prison_Admissions_Males" "Prison_Admissions_Asian_Pacific_Islander" "Prison_Admissions_Black" "Prison_Admissions_Hispanic" "Prison_Admissions_Native_American" "Prison_Admissions_Other" "Prison_Admissions_White" "Prison_Admissions_Asian_Pacific_Islander_Females" "Prison_Admissions_Asian_Pacific_Islander_Males" "Prison_Admissions_Black_Females" "Prison_Admissions_Black_Males" "Prison_Admissions_Hispanic_Females" "Prison_Admissions_Hispanic_Males" "Prison_Admissions_Native_American_Females" "Prison_Admissions_Native_American_Males" "Prison_Admissions_Other_Females" "Prison_Admissions_Other_Males" "Prison_Admissions_White_Females" "Prison_Admissions_White_Males" "Prison_Population_Rate_Total" "Prison_Population_Rate_Females" "Prison_Population_Rate_Males" "Prison_Population_Rate_Asian_Pacific_Islander" "Prison_Population_Rate_Black" "Prison_Population_Rate_Hispanic" "Prison_Population_Rate_Native_American" "Prison_Population_Rate_White" "Prison_Admission_Rate_Total" "Prison_Admission_Rate_Females" "Prison_Admission_Rate_Males" "Prison_Admission_Rate_Asian_Pacific_Islander" "Prison_Admission_Rate_Black" "Prison_Admission_Rate_Hispanic" "Prison_Admission_Rate_Native_American" "Prison_Admission_Rate_White"

*select just the current year of data 
drop if year < ${curr_yr}
tab year

*aggregate county numbers to get state totals (collapse step will drop county variables)
collapse (sum) total_pop-white_male_prison_adm, by(State year)

*re-label collapsed prison variables
labvars total_pop total_pop_15to64 female_pop_15to64 male_pop_15to64 aapi_pop_15to64 black_pop_15to64 latinx_pop_15to64 native_pop_15to64 white_pop_15to64 total_prison_pop female_prison_pop male_prison_pop aapi_prison_pop black_prison_pop latinx_prison_pop native_prison_pop other_race_prison_pop white_prison_pop aapi_female_prison_pop aapi_male_prison_pop black_female_prison_pop black_male_prison_pop latinx_female_prison_pop latinx_male_prison_pop native_female_prison_pop native_male_prison_pop other_race_female_prison_pop other_race_male_prison_pop white_female_prison_pop white_male_prison_pop total_prison_adm female_prison_adm male_prison_adm aapi_prison_adm black_prison_adm latinx_prison_adm native_prison_adm other_race_prison_adm white_prison_adm aapi_female_prison_adm aapi_male_prison_adm black_female_prison_adm black_male_prison_adm latinx_female_prison_adm latinx_male_prison_adm native_female_prison_adm native_male_prison_adm other_race_female_prison_adm other_race_male_prison_adm white_female_prison_adm white_male_prison_adm "Resident_Population" "Population15to64_Total_forRates" "Population15to64_Females_forRates" "Population15to64_Males_forRates" "Population15to64_Asian_Pacific_Islander_forRates" "Population15to64_Black_forRates" "Population15to64_Hispanic_forRates" "Population15to64_Native_American_forRates" "Population15to64_White_forRates" "Prison_Population_Total" "Prison_Population_Females" "Prison_Population_Males" "Prison_Population_Asian_Pacific_Islander" "Prison_Population_Black" "Prison_Population_Hispanic" "Prison_Population_Native_American" "Prison_Population_Other" "Prison_Population_White" "Prison_Population_Asian_Pacific_Islander_Females" "Prison_Population_Asian_Pacific_Islander_Males" "Prison_Population_Black_Females" "Prison_Population_Black_Males" "Prison_Population_Hispanic_Females" "Prison_Population_Hispanic_Males" "Prison_Population_Native_American_Females" "Prison_Population_Native_American_Males" "Prison_Population_Other_Females" "Prison_Population_Other_Males" "Prison_Population_White_Females" "Prison_Population_White_Males" "Prison_Admissions_Total" "Prison_Admissions_Females" "Prison_Admissions_Males" "Prison_Admissions_Asian_Pacific_Islander" "Prison_Admissions_Black" "Prison_Admissions_Hispanic" "Prison_Admissions_Native_American" "Prison_Admissions_Other" "Prison_Admissions_White" "Prison_Admissions_Asian_Pacific_Islander_Females" "Prison_Admissions_Asian_Pacific_Islander_Males" "Prison_Admissions_Black_Females" "Prison_Admissions_Black_Males" "Prison_Admissions_Hispanic_Females" "Prison_Admissions_Hispanic_Males" "Prison_Admissions_Native_American_Females" "Prison_Admissions_Native_American_Males" "Prison_Admissions_Other_Females" "Prison_Admissions_Other_Males" "Prison_Admissions_White_Females" "Prison_Admissions_White_Males"

*output a list of variables & labels
describe

*loop through variables to calculate rates based on state totals
foreach var of varlist total_prison_pop female_prison_pop male_prison_pop aapi_prison_pop black_prison_pop latinx_prison_pop native_prison_pop white_prison_pop total_prison_adm female_prison_adm male_prison_adm aapi_prison_adm black_prison_adm latinx_prison_adm native_prison_adm white_prison_adm {
	*generate rate variable name based on var name
	local ratevar = "`v'"+"_rate"
	
	*get name of population group based on first part of var name (total, males, black, etc.)
	local popvar = substr("`v'",1,strpos("`v'","_"))+"pop_15to64"
	
	*calculate rate for each variable
	generate `ratevar' = (`v' / `popvar') * 100000
}

*label rate variables
labvars total_prison_pop_rate female_prison_pop_rate male_prison_pop_rate aapi_prison_pop_rate black_prison_pop_rate latinx_prison_pop_rate native_prison_pop_rate white_prison_pop_rate total_prison_adm_rate female_prison_adm_rate male_prison_adm_rate aapi_prison_adm_rate black_prison_adm_rate latinx_prison_adm_rate native_prison_adm_rate white_prison_adm_rate "Prison_Population_Rate_Total" "Prison_Population_Rate_Females" "Prison_Population_Rate_Males" "Prison_Population_Rate_Asian_Pacific_Islander" "Prison_Population_Rate_Black" "Prison_Population_Rate_Hispanic" "Prison_Population_Rate_Native_American" "Prison_Population_Rate_White" "Prison_Admission_Rate_Total" "Prison_Admission_Rate_Females" "Prison_Admission_Rate_Males" "Prison_Admission_Rate_Asian_Pacific_Islander" "Prison_Admission_Rate_Black" "Prison_Admission_Rate_Hispanic" "Prison_Admission_Rate_Native_American" "Prison_Admission_Rate_White"

*replace 0 values with missing (to match county-level file)
foreach v of varlist total_prison_pop-white_prison_adm_rate {
	replace `v'=. if `v'==0
}

*save formatted file to excel
export excel using `"${fmt_path}/Prison - State Totals ${curr_yr}.xlsx"', firstrow(varlabels) replace


