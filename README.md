# Cesar Chavez Youth Leadership Conference 2025 — `ccylc_2025`

A lightweight Stata project for the survey fielded to attendees **after the 2025 Cesar Chavez
Youth Leadership Conference (CCYLC)**. It holds the code that cleaned the survey export into an
analysis dataset and tabulated every question by the population that saw it.

**Lab:** California Education Lab (CEL), UC Davis
**Author:** Christina Sun (`christinasun101@gmail.com` / `ucsun@ucdavis.edu`)
**Status:** Offboarding — code archive (survey data purged)

> **The survey data has been purged.** It included respondent emails and minors' responses, so
> the export and the cleaned dataset are **not retained** and are not in this repo. What remains
> is the **code** — a record of how the survey was cleaned and analyzed. Re-running it would
> require re-obtaining the original Qualtrics export.

> New here? This README assumes you're comfortable with Stata but possibly new to git.

---

## 1. What this repo is

This repo preserves the Stata code for the post-conference survey: a cleaning step that turned
the Qualtrics export into a labeled analysis dataset, and an exploration step that tabulated
every question. It did not produce paper-ready tables or figures — its products were the cleaned
dataset and tabulation logs, none of which are retained (see the note above).

Respondents were students (middle school, high school, community/4-year college), parents/
guardians, and school staff. The survey used Qualtrics display logic, so different respondent
types saw different question blocks; the cleaning and tabulation code reproduces that logic.

> **Note:** This is a lightweight project. There is no `decisions/` folder or golden-master
> comparison; the load-bearing documentation is §4 (the per-file input/output map) below.

## 2. How it ran

The code ran on the lab's **Scribe** server. `do/main.do` is the single entry point — it sets
the path global and runs the whole pipeline in dependency order:

```bash
# On Scribe, from the project folder:
cd /home/research/ca_ed_lab/projects/ccylc
stata-mp -b do do/main.do
```

That runs `do/settings.do` (defines `$projdir`), then `do/clean/clean_qualtrics.do`, then
`do/explore/tab.do`.

Because the survey data has been purged, this **won't run as-is** — the cleaning step has no
input to read. Reproducing the analysis would mean re-obtaining the original Qualtrics export
and placing it where `settings.do` expects the project to live.

- **Runtime (when it ran):** seconds to a couple of minutes (small survey).
- **Setup:** standard Stata; no special SSC packages are required by the code.
- **Seed:** `set seed 1984` is set in both `clean_qualtrics.do` and `tab.do`.

## 3. Project structure

```
ccylc_2025/
├── do/
│   ├── main.do                 # entry point — runs settings -> clean -> explore
│   ├── settings.do             # defines global projdir
│   ├── macros.doh              # question-group lists + display-logic criteria
│   ├── clean/
│   │   └── clean_qualtrics.do  # cleans the survey export
│   └── explore/
│       └── tab.do              # tabulates every question
└── log/                        # Stata logs (gitignored; not retained)
```

Only `do/` and the dotfiles are tracked on GitHub. Data and logs were never tracked, and the
data has been purged.

## 4. Inputs and outputs of each do file

The core of the handoff — a record of what each step read and wrote when it ran. (The data files
referenced here have been purged; this documents the code's logic, not files you'll find today.)

| File | Purpose | Read | Wrote |
|---|---|---|---|
| `do/main.do` | Entry point: `cd`s to the project folder, sources `settings.do`, then runs `clean/clean_qualtrics.do` and `explore/tab.do` in order | — | — |
| `do/settings.do` | Defines `global projdir`; sourced first | — | — |
| `do/macros.doh` | Defines question-group locals (`hs_qs`, `ms_qs`, `transfer_qs`, `allstudent_qs`, `parent_qs`, `staff_qs`, `text_qs`) and each question's display-logic population criterion (`*_crit`). `include`d by `tab.do`. | — | — |
| `do/clean/clean_qualtrics.do` | Renames Q-codes to readable variables, applies value labels, builds multi-select "check all that apply" dummies, merges them by `responseid` | the Qualtrics survey export **[external; purged]** | a cleaned analysis dataset + a clean log |
| `do/explore/tab.do` | For each question, counts the display-logic population and `tab`s the variable, by respondent block | the cleaned dataset; `include`s `do/macros.doh` | a tabulation log |

**Why the cleaning step reads two exports:** `clean_qualtrics.do` reads the **value** export for
most variables, and re-imports the **label** export inside `preserve`/`restore` blocks to parse
the free-text labels of the multi-select "check all that apply" questions (e.g. `why_coll_*`,
`ms_why_coll_*`, `parent_why_coll_*`, `staff_fund_*`, `staff_barrier_*`).

## 5. Outputs

When it ran, the pipeline produced a cleaned analysis dataset and tabulation logs. None of that
is in this repo — data and logs were never tracked, and the data has been purged. There are no
tracked tables or figures.

## 6. What NOT to commit

- **Never commit survey data or logs.** They are gitignored for a reason: the survey collected
  **respondent emails** and **minors' responses**. That sensitivity is why the data was purged,
  and why it must never be committed if it is ever re-obtained. See the
  [data-safety guidance](https://chesun.github.io/cel_resource_hub/workflow-tips/data-safety/).
- Do not copy `.git/` onto Scribe, and do not put GitHub credentials on the server.

## 7. Why it's built this way

- **`settings.do` holds the one path global (`$projdir`).** Change the location in one place.
- **Display logic is reconstructed in code.** Qualtrics only showed each block to the relevant
  respondents; `macros.doh` encodes each question's population criterion so `tab.do` reports the
  correct denominator (`count if` the criterion) before each tabulation.
- **Multi-select questions become dummies.** "Check all that apply" answers arrive as a single
  delimited string; the cleaning code expands each option into a 0/1 variable.

## 8. Status / notes

- The survey ran and was analyzed during the project; the data has since been **purged** (PII),
  so this repo now stands as a **code archive**.
- `do/main.do` is wired to run the full pipeline (`settings.do` → `clean/clean_qualtrics.do` →
  `explore/tab.do`); it can't be re-run as-is without re-obtaining the survey export.

**Contacts:**

- **Author:** Christina Sun — `christinasun101@gmail.com` / `ucsun@ucdavis.edu`
- **Data-management custodian / Scribe access:** CEL data management (see the resource hub).
- **Lab IT:** provisions Scribe SSH accounts.

> More of my workflow notes (git, Scribe & SSH, data safety) live in the
> [CEL Resource Hub](https://chesun.github.io/cel_resource_hub/).
