*
* convertCMC
*
* Converts CMC dates (i.e. months since the start of the year
* 1900) into Stata dates, randomly imputing day of the month
*
* Author: Ian Timaeus, LSHTM (ian.timaeus@lshtm.ac.uk)
* Initiated: 7-Mar-2015
* Last modified: 27-Jan-2017
*
program define convertCMC
	version 14.2
	syntax varlist(min=1 numeric) [if] [in] [, REplace GENerate(name)]
	marksample touse, nov
	tokenize `varlist'
	* force replace or gen() to impede overwriting of input data
	if ("`replace'"!="replace" & "`generate'"=="")   /// 
		| ("`replace'"=="replace" & "`generate'"!="") {
		display as error   ///
			"Select either the {opt replace} or {opt generate} option"
		exit
	}
	quietly {
		keep if `touse'
		tempvar yr mo maxd
		gen `yr' = .
		gen `mo' = .
		gen `maxd' = .
	}
	while "`1'" != "" {
		local cmc_date `1'
		if  "`generate'" != "" {
			confirm new variable `generate'
			gen long `generate' = -`cmc_date' /* reports N of missing cases */
			local stata_date `generate'
		} 
		else {
			local stata_date `1'
			recast long `stata_date'
		}
		quietly {
			* assign default date format to Stata date variables
			format `stata_date' %td
			* calculate the components of the date
			replace `yr' = 1900 + int((`cmc_date' - 1) /12)
			replace `mo' = `cmc_date' - 12*(`yr' - 1900)
			replace `maxd' = cond(inlist(`mo', 4,6,9,11), 30, 31)
			replace `maxd' = cond(mod(`yr', 4)==0, 29, 28) if `mo'==2
			replace `maxd' = 28 if `maxd'==29 & mod(`yr',100)==0 /*
				*/ & mod(`yr',400)!=0
		}
		replace `stata_date' = mdy(`mo', 1+int(`maxd'*runiform()), `yr')

		if "`generate'" != "" exit  /* ignore any further arguments */
		macro shift
	}
end
