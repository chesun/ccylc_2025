/* master do file for CCYLC 2025 survey project */

/* 
do /home/research/ca_ed_lab/projects/ccylc/do/main.do
 */

cd "/home/research/ca_ed_lab/projects/ccylc"
do do/settings.do

/* run the pipeline in dependency order */
do $projdir/do/clean/clean_qualtrics.do     /* raw Qualtrics export -> dta/cln/ccylc_2025_clean.dta */
do $projdir/do/explore/tab.do               /* tabulations -> log/explore/tab.txt           */