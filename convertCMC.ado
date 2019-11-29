*
* convertCMC
*
* Converts CMC dates (i.e. months since the start of the year
* 1900) into Stata dates, randomly imputing day of the month
*
* Author: Ian Timaeus, LSHTM (ian.timaeus@lshtm.ac.uk)
* Initiated: 7-Mar-2015
*! version 2.1  30-Sep-2019
*
program define convertCMC
	version 10
	syntax varlist(min=1 numeric)
	tokenize `varlist'
	quietly {
		tempvar yr mo dcm maxd
		gen int `yr' = .
		gen byte `mo' = .
		gen byte `dcm' = .
		gen byte `maxd' = .
	}
	quietly while "`1'" != "" {
		local cmc_date `1'
		local s_date `1'
		* calculate the components of the date
		replace `yr' = 1900 + int((`cmc_date' - 1) /12)
		replace `mo' = `cmc_date' - 12*(`yr' - 1900)
		replace `dcm' = `mo'==12
		replace `maxd' = day(mdy(cond(`dcm',1,`mo'+1),1,`yr'+`dcm')-1)
		recast long `s_date'
		replace `s_date' = mdy(`mo', floor(1+`maxd'*uniform()), `yr')
		* assign default date format to Stata date variables
		format `s_date' %td
		macro shift
	}
end
