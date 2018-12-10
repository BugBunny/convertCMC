{smcl}
{* *! version 2.0.0  10-Dec-2018}{...}
{viewerjumpto "Syntax" "convertCMC##syntax"}{...}
{viewerjumpto "Description" "convertCMC##description"}{...}
{viewerjumpto "Options" "convertCMC##options"}{...}
{viewerjumpto "Remarks" "convertCMC##remarks"}{...}
{viewerjumpto "Examples" "convertCMC##examples"}{...}
{title:Title}

{phang}
{bf:convertCMC} {hline 2} Convert century month codes (CMCs) into Stata dates


{marker syntax}{...}
{title:Syntax}

{bf:convertCMC} {cmd:egen} function:

{p 8 17 2}
{cmd:egen} {newvar} {cmd:= convertCMC(}{it:{help exp}}{cmd:)} {ifin} 
[{cmd:,} {opt d:ayofmonth} {opt e:arliestdate} {opt l:atestdate}]

{bf:convertCMC} command:

{p 8 17 2}
{cmd:convertCMC} {varlist}

options for the {bf:convertCMC} {cmd:egen} function:

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}

{synopt:{opth d:ayofmonth(varname)}}calculate the Stata date using values
of varname for the day of the month{p_end} 
{synopt:{opth e:arliestdate(varname)}}lower bound for the imputed date if it 
falls in the same month and year as Stata date {varname}{p_end} 
{synopt:{opth l:atestdate(varname)}}upper bound for the imputed date if it 
falls in the same month and year as Stata date {varname}{p_end} 
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:convertCMC} converts one or more variables containing century month codes
(i.e. dates coded as months since the start of the year 1900), such as those in
Demographic and Health Surveys data, into Stata internal form
{help datetime: dates}, randomly imputing the exact day of the month if it is 
not known. The command version of {cmd:convertCMC} converts a list of CMC 
variables into Stata dates {it:in situ}, imputing day, and does not allow 
{help if} or {help in}. 


{marker options}{...}
{title:Options}
{dlgtab:Main}
{phang}
{opt d:ayofmonth} If the day of the month of the date represented by 
the CMC code applies is stored in another variable specified by 
{opt dayofmonth}, the {bf:convertCMC} {cmd:egen} function uses it to calculate
an exact date, rather than imputing a value for day.

{phang}
{opt e:arliestdate} If two events occur in the same month, one may constrain
how early in the month the other can occur. For example, a baby cannot die
before his or her birthday. If the former date is supplied in a Stata date 
variable specified by {opt earliestdate}, the {bf:convertCMC} {cmd:egen}
function imputes a day for the latter date that falls either on the same day or 
later in the month.

{phang}
{opt l:atestdate} If two events occur in the same month, one may also constrain
how late in the month the other can occur. For example, a woman can only report
events that occur before she is interviewed. If the former date is supplied 
in a Stata date variable specified by {opt lastestdate}, the {bf:convertCMC}
{cmd:egen} function imputes a day for the latter date that falls either on the
same day or earlier in the month.

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
{cmd:convertCMC} uses random numbers in the imputation of days of the month.
If you wish to produce reproducible dates, it is your responsibility 
to {help set seed:seed} Stata's random number generator before calling 
the program.

{pstd}
Any variable to which {cmd:convertCMC} assigns a Stata internal form date 
also has its display {help datetime display formats:format} set to {cmd:%td}.

{pstd}
This program does not carry out any checks on the validity of the data 
supplied to it. Missing or impossible input data will produce missing values in
{newvar}.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. egen date_interview = convertCMC(v008), day(v016)}

{phang}{cmd:. egen date_marriage = convertCMC(v509), latest(date_interview)}

{phang}{cmd:. convertCMC v008 v011 v211}


{title:Author}

{col 6}Ian M. Timaeus
{col 6}London School of Hygiene & Tropical Medicine
{col 6}United Kingdom
{col 6}email: ian.timaeus@lshtm.ac.uk
