*
* _gconvertCMC
*
* egen extension to convert a CMC date (i.e. coded in months since the  
* start of the year 1900) into a Stata date, randomly imputing the day of 
* the month if it is not supplied
*
* Author: Ian Timaeus, LSHTM (ian.timaeus@lshtm.ac.uk)
* Initiated: 7-Mar-2015
*! version 2.0  10-Dec-2018
*
program define _gconvertCMC
	version 10
	syntax newvarname=/exp [if] [in] [, Dayofmonth(varname numeric) ///
		Earliestdate(varname numeric) Latestdate(varname numeric)]
	marksample touse, novarlist

	quietly {
		tempvar yr mo start maxd day 
		* calculate the components of the date
		gen int `yr' = 1900 + int((`exp' - 1) /12)
		gen int `mo' = `exp' - 12*(`yr' - 1900)
		gen int `start' = 1
		* ensure imputed day of month is no earlier than first possible date
		if "`earliestdate'" != "" {
			replace `start' = day(`earliestdate') ///
				if `yr'==year(`earliestdate') & `mo'==month(`earliestdate')
		}
		* use day of month if one is supplied, but otherwise impute it
		if "`dayofmonth'" != "" {
			gen int `day' = `dayofmonth'
		} 
		else {
			gen int `maxd' = cond(inlist(`mo', 4,6,9,11), 30, 31)
			replace `maxd' = cond(mod(`yr', 4)==0, 29, 28) if `mo'==2
			replace `maxd' = 28 if `maxd'==29 & mod(`yr',100)==0 ///
				& mod(`yr',400)!=0
			* ensure imputed day of month is no later than last possible date	
			if "`latestdate'" ~= "" {
				replace `maxd' = day(`latestdate') ///
					if `yr'==year(`latestdate') & `mo'==month(`latestdate')
			}		
			gen int `day' = floor(`start'+(`maxd'-`start'+1)*uniform())
		}
	* ignore user-supplied type
	gen long `varlist' = mdy(`mo', `day', `yr') if `touse'
	format `varlist' %td
	}
end
