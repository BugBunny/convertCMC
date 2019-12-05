# convertCMC
*Stata* package to convert century month codes (CMCs) into *Stata* dates.

CMCs (i.e. dates coded as months since the start of the year 1900), are widely used by the *Demographic and Health Surveys* program and others.

`convertCMC` can randomly impute an exact day of the month to each date. This avoids (at least in aggregate) the biases that can arise when doing arithmetic with CMCs. For example, a child that was born in January 2013, whose mother was interviewed in January 2018, may have been either 4 or 5 completed years old at that time depending on whether the mother was interviewed before or after the child's birthday.

`convertCMC` takes into account the length of each month and knows about leap years.

The currrent release of `convertCMC` has two flavours. The `convertCMC` command converts a list of variables containing CMC codes to Stata dates *in situ*, imputing day of the month. It does not allow `if` or `in`. The `convertCMC` `egen` function generates a new variable containing a Stata date from a single CMC code. It allows both `if` or `in`. Moreover, it provides the option to calculate an exact date, rather than imputing  day of the month, if the days have been recorded and are supplied to it in a second variable.

The `convertCMC` `egen` function can also address the situation in which the day imputed for a CMC code is potentially constrained by another date falling in the same month. For example, children born in the month that their mother is interviewed must have been born by the interview date to get reported. Similarly, neonates cannot die before their birthday. Variables containing Stata dates with the potential to impose such upper and lower bounds on day of the month can be provided as options to the `convertCMC` `egen` function, which will then ensure that the imputed dates are feasible.

`convertCMC` can be installed from within *Stata* by:
```
net install convertCMC, from(https://raw.githubusercontent.com/bugbunny/convertCMC/master)
```

DOI: [10.5281/zenodo.3557305](https://doi.org/10.5281/zenodo.3557305)
