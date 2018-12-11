*
* convertCMC
*
* Converts CMC dates (i.e. months since the start of the year
* 1900) into Stata dates, randomly imputing day of the month
*
* Author: Ian Timaeus, LSHTM (ian.timaeus@lshtm.ac.uk)
* Initiated: 7-Mar-2015
*! version 2.0  10-Dec-2018
*
program define convertCMC
	version 13
	syntax varlist(min=1 numeric)
	tokenize `varlist'
	quietly {
		tempvar yr mo maxd
		gen `yr' = .
		gen `mo' = .
		gen `maxd' = .
	}
	quietly while "`1'" != "" {
		local cmc_date `1'
		local s_date `1'
		* calculate the components of the date
		replace `yr' = 1900 + int((`cmc_date' - 1) /12)
		replace `mo' = `cmc_date' - 12*(`yr' - 1900)
		replace `maxd' = cond(inlist(`mo', 4,6,9,11), 30, 31)
		replace `maxd' = cond(mod(`yr', 4)==0, 29, 28) if `mo'==2
		replace `maxd' = 28 if `maxd'==29 & mod(`yr',100)==0 /*
			*/ & mod(`yr',400)!=0
		recast long `s_date'
		replace `s_date' = mdy(`mo', floor(1+`maxd'*runiform()), `yr')
		* assign default date format to Stata date variables
		format `s_date' %td
		macro shift
	}
end
