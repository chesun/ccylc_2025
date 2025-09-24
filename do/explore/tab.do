/* tabulate all questions */

/* 
do $projdir/do/explore/tab.do
 */

log close _all

log using $projdir/log/explore/tab.txt, text replace  

graph drop _all
set more off
set varabbrev off
set graphics off
set scheme s1color
set seed 1984


use $projdir/dta/cln/ccylc_2025_clean.dta, clear

include $projdir/do/macros.doh


*** respondent types 
foreach v of local type_qs {
    tab `v'
}

*** High school
di "High school question block"

foreach v of local hs_qs {
    count if ``v'_crit'
    di "population for the following question based on display logic: `r(N)' "
    tab `v'
}

*** transfer
di "Transfer question block"
foreach v of local transfer_qs {
    count if ``v'_crit'
    di "population for the following question based on display logic: `r(N)' "
    tab `v'
}

*** middle school
di "Middle school question block"
foreach v of local ms_qs {
    count if ``v'_crit'
    di "population for the following question based on display logic: `r(N)' "
    tab `v'
}

*** all students
di "All students question block"
foreach v of local allstudent_qs {
    count if ``v'_crit'
    di "population for the following question based on display logic: `r(N)' "
    tab `v'
}

*** parent 
di "Parent question block"
foreach v of local parent_qs {
    count if ``v'_crit'
    di "population for the following question based on display logic: `r(N)' "
    tab `v'
}

*** staff
di "Staff question block"
foreach v of local staff_qs {
    count if ``v'_crit'
    di "population for the following question based on display logic: `r(N)' "
    tab `v'
}

log close 