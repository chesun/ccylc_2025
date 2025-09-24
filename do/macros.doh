/* project macros */


/* usage:
include $projdir/do/macros.doh
 */

#delimit ;

local type_qs 
    type 
    school_level
    ;

local hs_qs
    plan_post_hs
    highest_degree
    why_coll_job why_coll_money why_coll_learn why_coll_career
    why_coll_family why_coll_status why_coll_indep
    why_coll_promotion why_coll_expect why_coll_friends
    why_coll_contribute why_coll_grad why_coll_children
    major 
    ;

local transfer_qs
    age 
    children
    n_children
    employed
    intend_transfer
    where_transfer
    major_after_transfer
    knowhow_apply knowhow_class concern_credit
    ;

local ms_qs
    ms_coll
    ms_why_coll_job ms_why_coll_money ms_why_coll_learn
    ms_why_coll_career ms_why_coll_family ms_why_coll_status
    ms_why_coll_indep ms_why_coll_expect ms_why_coll_contribute
    ms_why_coll_grad ms_why_coll_children
    ms_major_business ms_major_engineering ms_major_science
    ms_major_social ms_major_humanity ms_major_health
    ms_major_education ms_major_applied ms_major_service ms_major_undecided
    ms_nocoll_plan ms_first_visit
    ;

local allstudent_qs
    all_exp_welcome all_exp_inspired all_exp_empowered
    all_exp_motivated all_exp_prepared all_exp_cost
    all_exp_represent
    all_ucd_ethnicity all_ucd_gender 
    all_ucd_background all_ucd_resource
    ;

local parent_qs
    parent_role
    parent_important_college
    parent_why_coll_job parent_why_coll_money parent_why_coll_learn
    parent_why_coll_career parent_why_coll_family parent_why_coll_status
    parent_why_coll_indep parent_why_coll_expect
    parent_why_coll_contribute parent_why_coll_grad
    parent_exp_welcome parent_exp_inspired parent_exp_empowered
    parent_exp_motivated parent_exp_prepared parent_exp_cost parent_exp_represent
    parent_ucd_ethnicity parent_ucd_gender parent_ucd_background parent_ucd_resource
    ;

local staff_qs
    staff_role
    staff_n_students
    staff_fund_fundraise staff_fund_grant staff_fund_sponsor
    staff_fund_donation staff_fund_partner staff_fund_other
    staff_fund_notsure
    staff_barrier_cost staff_barrier_transport
    staff_barrier_distance staff_barrier_interest
    staff_barrier_permission staff_fund_other
    staff_exp_welcome staff_exp_inspired staff_exp_empowered
    staff_exp_motivated staff_exp_prepared staff_exp_cost
    staff_exp_represent
    staff_expect 
    staff_likely_future
    ;

local text_qs
    type_other_text
    transfer_concern_text
    parent_concern_text
    parent_excite_text
    staff_role_other_text
    staff_fund_other_text
    staff_barrier_other_text
    what_take_attend_ucd_text
    eval_strongest_text
    eval_comment_text
    ;

#delimit cr
// population criteria 
local plan_post_hs_crit "school_level==2"
local highest_degree_crit "inrange(plan_post_hs,1,5)"
foreach v of varlist why_coll_* {
    local `v'_crit "inrange(plan_post_hs,1,5)"
}
local major_crit "inrange(plan_post_hs,1,5)"

local age_crit "inlist(school_level, 3,4)"
local children_crit "inlist(school_level, 3,4)"
local n_children_crit "children==1"
local employed_crit "inlist(school_level, 3,4)"
local intend_transfer_crit "inlist(school_level, 3,4)"
local where_transfer_crit "intend_transfer==1"
local major_after_transfer_crit "intend_transfer==1"
foreach v of varlist knowhow_apply knowhow_class concern_credit {
    local `v'_crit "inlist(intend_transfer,1,3)"
}

local ms_coll_crit "school_level==1"
foreach v of varlist ms_why_coll_* {
    local `v'_crit "school_level==1 & ms_coll==1"
}
foreach v of varlist ms_major_* {
    local `v'_crit "school_level==1 & ms_coll==1"
}
local ms_nocoll_plan_crit "school_level==1 & inlist(ms_coll,2,3)"
local ms_first_visit_crit "type==1 & school_level==1"

foreach v of varlist all_exp_* {
    local `v'_crit "type==1"
}
foreach v of varlist all_ucd_* {
    local `v'_crit "type==1"
}

local parent_role_crit "type==3"
local parent_important_college_crit "type==3"
foreach v of varlist parent_why_coll_* {
    local `v'_crit "type==3 & parent_important_college!=3"
}
foreach v of varlist parent_exp_* parent_ucd_* {
    local `v'_crit "type==3"
}

foreach v of varlist `staff_qs' {
    local `v'_crit "type==2"
}