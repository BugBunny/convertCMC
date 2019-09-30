*
* _gconvertCMC
*
* egen extension to convert a CMC date (i.e. coded in months since the  
* start of the year 1900) into a Stata date, randomly imputing the day of 
* the month if it is not supplied
*
* Author: Ian Timaeus, LSHTM (ian.timaeus@lshtm.ac.uk)
* Initiated: 7-Mar-2015
*! version 3.0  30-Sep-2019
*
program define _gconvertCMC
	version 10
	syntax newvarname=/exp [if] [in] [, Dayofmonth(varname numeric) ///
		Earliestdate(varname numeric) Latestdate(varname numeric)]
	marksample touse, novarlist

	quietly {
		tempvar yr mo start dcm maxd day
		* Calculate the components of the date
		gen int `yr' = 1900 + int((`exp' - 1) /12)
		gen byte `mo' = `exp' - 12*(`yr' - 1900)
		* Use day of month if one is supplied, but otherwise impute it
		if "`dayofmonth'" != "" {
			gen byte `day' = `dayofmonth'
		} 
		else {
			gen byte `dcm' = `mo'==12
			gen byte `maxd' = day(mdy(cond(`dcm',1,`mo'+1),1,`yr'+`dcm')-1)
			* Ensure imputed day of month is no earlier than first possible date
			gen byte `start' = 1			
			if "`earliestdate'" != "" {
				replace `start' = day(`earliestdate') ///
					if `yr'==year(`earliestdate') & `mo'==month(`earliestdate')
			}
			* Ensure imputed day of month is no later than last possible date	
			if "`latestdate'" != "" {
				replace `maxd' = day(`latestdate') ///
					if `yr'==year(`latestdate') & `mo'==month(`latestdate')
			}		
			gen int `day' = floor(`start'+(`maxd'-`start'+1)*uniform())
		}
	* Ignore user-supplied type
	gen long `varlist' = mdy(`mo', `day', `yr') if `touse'
	format `varlist' %td
	}
end
