{smcl}
{* *! version 1.1.0  28-Jan-2017}{...}
{viewerjumpto "Syntax" "convertCMC##syntax"}{...}
{viewerjumpto "Description" "convertCMC##description"}{...}
{viewerjumpto "Remarks" "convertCMC##remarks"}{...}
{viewerjumpto "Examples" "convertCMC##examples"}{...}
{title:Title}

{phang}
{bf:convertCMC} {hline 2} Convert century month codes (CMCs) into Stata dates


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:convertCMC}
{varlist}
{ifin}
{cmd:,} {it:options}


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}

{synopt:{opt re:place}}converts the values of each variable in {varlist} into 
the corresponding Stata dates.{p_end}
{synopt:{opth gen:erate(newvar)}}expects a single variable in {varlist} and 
generates a new variable that contains the corresponding Stata date.{p_end} 
{synoptline}
{p2colreset}{...}
{p 4 6 2}
Either {opt replace} or {opt generate} is required.


{marker description}{...}
{title:Description}

{pstd}
{cmd:convertCMC} converts century month codes (i.e. dates coded as months
since the start of the year 1900), such as those in Demographic and Health
Surveys data, into Stata {help datetime:dates}, randomly imputing an exact
day of the month to each value.


{marker remarks}{...}
{title:Remarks}

{pstd}
Imputing a day of the month to dates in CMC format avoids the systematic bias
that can result when doing arithmetic with dates (or using commands that do
these sums, such as the {help st} commands).

{pstd}
For example, working with CMCs,
the age of a woman born in January 1995 who was interviewed in January 2013
will always be computed as 18 (i.e. (1357-1141)/12 = 18). In fact, if she was
born on a later day of the month than the day on which she was interviewed,
she will still have been only 17 years old.

{pstd}
If one randomly imputes a day of the month to each date then, in aggregate,
the exact intervals between any pair of dates will be unbiased and the
correct proportion of cases will be assigned to interval categories (such
as age in completed years).

{pstd}
{cmd:convertCMC} takes into account the length of each month and knows 
about leap years.

{pstd}
{cmd:convertCMC} uses {help runiform} in the imputation of days of the month.
If you wish to produce reproducible dates, it is your responsibility 
to {help set seed:seed} Stata's random number generator before calling 
{cmd:convertCMC}.

{pstd}
In both {opt generate} and {opt replace} modes, any variable to which 
{cmd:convertCMC} assigns Stata dates also has its display
{help datetime display formats:format} set to {cmd:%td}. 


{marker examples}{...}
{title:Examples}

{phang}{cmd:. convertCMC v008 v011 v211, replace}{p_end}

{phang}{cmd:. convertCMC v011, gen(dateofbirth)}{p_end}


{title:Author}

{col 6}Ian M. Timaeus
{col 6}London School of Hygiene & Tropical Medicine
{col 6}United Kingdom
{col 6}email: ian.timaeus@lshtm.ac.uk
