# convertCMC
Stata package to convert century month codes (CMCs) into Stata dates.

CMCs (i.e. dates coded as months since the start of the year 1900), are widely used by the *Demographic and Health Surveys* program and others.

`convertCMC` randomly imputes an exact day of the month to each date. This avoids (at least in aggregate) the biases that can arise when doing arithmetic with CMCs. For example, a child that was born in January 2013, whose mother was interviewed in January 2018, may have been either 4 or 5 completed years old at that time depending on whether the mother was interviewed before or after the child's birthday.

`convertCMC` takes into account the length of each month and knows about leap years.

N.B. The current release of `convertCMC` does **not** address the situation in which the two CMCs that are being differenced are the same. If the day of the month of each date is imputed independently, they can end up sequenced in either order, when this may in reality be impossible (e.g. a liveborn neonate cannot die any earlier in the month than his or her birthday).

`convertCMC` can be installed from within *Stata* by:
```
net install convertCMC, from(https://bugbunny.github.io/convertCMC)
```
