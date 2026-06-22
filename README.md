# Cesar Chavez Youth Leadership Conference 2025 — `ccylc_2025`

A lightweight Stata analysis of the survey fielded to attendees **after the 2025 Cesar Chavez
Youth Leadership Conference (CCYLC)**. It cleans the Qualtrics export into an analysis dataset
and tabulates every question by the population that saw it.

**Lab:** California Education Lab (CEL), UC Davis
**Author:** Christina Sun (`christinasun101@gmail.com` / `ucsun@ucdavis.edu`)
**Status:** Offboarding — small/one-off analysis

> New here? This README is written for someone comfortable with Stata but possibly new to git.
> You only need Stata and access to the project folder on the lab's Scribe server to run it.

---

## 1. What this repo is

The repo holds the Stata pipeline for the post-conference survey. It takes the raw Qualtrics
export, cleans it into a labeled analysis dataset, and produces tabulation logs for each survey
question. It does **not** currently produce paper-ready tables or figures — its outputs are the
cleaned `.dta` and the tabulation `.txt` logs.

Respondents are students (middle school, high school, community/4-year college), parents/
guardians, and school staff. The survey uses Qualtrics display logic, so different respondent
types see different question blocks; the cleaning and tabulation code reproduces that logic.

> **Note:** This is a lightweight project. There is no `decisions/` folder or golden-master
> comparison; the load-bearing documentation is §4 (the per-file input/output map) below.

## 2. How to run

The pipeline runs on the lab's **Scribe** server (the restricted data lives only there).

```bash
# On Scribe, from the project folder:
cd /home/research/ca_ed_lab/projects/ccylc
stata-mp -b do do/main.do
```

⚠️ **Important — `do/main.do` is currently a stub.** As of this writing it only `cd`s to the
project folder and sources `do/settings.do`; it does **not** yet call the cleaning or
tabulation steps. So `do do/main.do` alone will not reproduce the analysis. To run the full
pipeline today, run the steps in order:

```bash
cd /home/research/ca_ed_lab/projects/ccylc
stata-mp -b do do/settings.do                 # defines $projdir
stata-mp -b do do/clean/clean_qualtrics.do    # raw export -> cleaned .dta
stata-mp -b do do/explore/tab.do              # tabulations -> log
```

(Or, since each sub-do reads the `$projdir` global, source `settings.do` first within an
interactive/batch session and then run the two sub-dos.)

**Recommended fix for offboarding:** wire `do/main.do` to source `settings.do` and then call
`do/clean/clean_qualtrics.do` and `do/explore/tab.do`, so there is a single entry point. See
§8.

- **Runtime:** seconds to a couple of minutes (small survey).
- **One-time setup:** standard Stata; no special SSC packages are required by the current code.
- **Seed:** `set seed 1984` is set in both `clean_qualtrics.do` and `tab.do`.

## 3. Project structure

```
ccylc_2025/
├── do/
│   ├── main.do                 # entry point (currently a stub — see §2)
│   ├── settings.do             # defines global projdir
│   ├── macros.doh              # question-group lists + display-logic criteria
│   ├── clean/
│   │   └── clean_qualtrics.do  # cleans the Qualtrics export
│   └── explore/
│       └── tab.do              # tabulates every question
├── dta/                        # data — Scribe only, gitignored
│   ├── raw/                    #   ccylc_export_value.csv, ccylc_export_label.csv
│   └── cln/                    #   ccylc_2025_clean.dta
└── log/                        # Stata logs — gitignored
    ├── clean/
    └── explore/
```

Only `do/` and the dotfiles are tracked on GitHub. `dta/` and `log/` are gitignored (§5–6).

## 4. Inputs and outputs of each do file

The core of the handoff. Inputs not produced by any code in this repo are marked **[external]**.
All paths are relative to `$projdir` = `/home/research/ca_ed_lab/projects/ccylc`.

| File | Purpose | Input | Output |
|---|---|---|---|
| `do/main.do` | Entry point: `cd`s to the project folder, sources `settings.do`. **Stub — does not yet run the pipeline (see §2).** | — | — |
| `do/settings.do` | Defines `global projdir`; sourced first | — | — |
| `do/macros.doh` | Defines question-group locals (`hs_qs`, `ms_qs`, `transfer_qs`, `allstudent_qs`, `parent_qs`, `staff_qs`, `text_qs`) and each question's display-logic population criterion (`*_crit`). `include`d by `tab.do`. | — | — |
| `do/clean/clean_qualtrics.do` | Imports the Qualtrics export, renames Q-codes to readable variables, applies value labels, builds multi-select "check all that apply" dummies, merges them back by `responseid` | `dta/raw/ccylc_export_value.csv`, `dta/raw/ccylc_export_label.csv` **[external — Qualtrics exports]** | `dta/cln/ccylc_2025_clean.dta`, `log/clean/clean_qualtrics.txt` |
| `do/explore/tab.do` | For each question, counts the display-logic population and `tab`s the variable, by respondent block | `dta/cln/ccylc_2025_clean.dta`; `include`s `do/macros.doh` | `log/explore/tab.txt` |

**Key intermediate dataset:** `dta/cln/ccylc_2025_clean.dta` — produced by `clean_qualtrics.do`
and read by everything downstream.

**Why two raw CSVs:** `clean_qualtrics.do` reads the **value** export for most variables, and
re-imports the **label** export inside `preserve`/`restore` blocks to parse the free-text labels
of the multi-select "check all that apply" questions (e.g. `why_coll_*`, `ms_why_coll_*`,
`parent_why_coll_*`, `staff_fund_*`, `staff_barrier_*`).

## 5. Where outputs go

- `dta/cln/ccylc_2025_clean.dta` — the cleaned analysis dataset (Scribe only; gitignored).
- `log/clean/clean_qualtrics.txt`, `log/explore/tab.txt` — run logs (Scribe only; gitignored).

There are no tracked tables or figures in this repo.

## 6. What NOT to touch / never commit

- **Raw data** in `dta/raw/` — the Qualtrics export. The survey collects **respondent emails**
  (and includes minors' responses), so this is confidential and must stay on Scribe.
- Anything under `dta/` or `log/` — gitignored for exactly this reason. Never `git add -f` a
  data or log file. See the lab's [data-safety guidance](https://chesun.github.io/cel_resource_hub/workflow-tips/data-safety/).
- Do not copy `.git/` onto Scribe, and do not put GitHub credentials on the server.

## 7. Why it's built this way

- **`settings.do` holds the one path global (`$projdir`).** Change the location in one place.
- **Display logic is reconstructed in code.** Qualtrics only showed each block to the relevant
  respondents; `macros.doh` encodes each question's population criterion so `tab.do` reports the
  correct denominator (`count if` the criterion) before each tabulation.
- **Multi-select questions become dummies.** "Check all that apply" answers arrive as a single
  delimited string; the cleaning code expands each option into a 0/1 variable.

## 8. When something breaks / known gaps

First places to look: the run logs in `log/clean/` and `log/explore/`.

**Known gaps to finish before final handoff:**

- [ ] **`do/main.do` does not run the pipeline.** Wire it to source `settings.do` and call
  `clean/clean_qualtrics.do` then `explore/tab.do`, so there is one true entry point.
- [ ] **Completed server run not yet recorded.** Run the full pipeline on Scribe end-to-end and
  record the date + that the logs are clean.
- [ ] **Cold-read test.** Have someone who is not the author reproduce the analysis on Scribe
  from this README alone.

**Contacts:**

- **Author:** Christina Sun — `christinasun101@gmail.com` / `ucsun@ucdavis.edu`
- **Data-management custodian / Scribe access:** CEL data management (see the lab resource hub).
- **Lab IT:** provisions Scribe SSH accounts.

> More lab-wide workflow guidance (git, Scribe & SSH, data safety) lives in the
> [CEL Resource Hub](https://chesun.github.io/cel_resource_hub/).
