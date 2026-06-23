# Cesar Chavez Youth Leadership Conference 2025 — `ccylc_2025`

> **Part of the [CEL Resource Hub](https://christinasun.net/cel_resource_hub/)** — Christina Sun's index of CEL code handoffs plus setup and workflow guides for inheriting them. Hub page for this repo: <https://christinasun.net/cel_resource_hub/repositories/ccylc-2025/>.

A lightweight Stata analysis of the survey fielded to attendees **after the 2025 Cesar Chavez
Youth Leadership Conference (CCYLC)**. It cleans the Qualtrics survey export into an analysis
dataset and tabulates every question by the population that saw it.

**Lab:** California Education Lab (CEL), UC Davis
**Author:** Christina Sun (`christinasun101@gmail.com` / `ucsun@ucdavis.edu`)
**Status:** Archived — offboarding complete (small/one-off analysis)

> **The survey data lives only on Scribe.** It includes respondent emails and minors' responses,
> so it stays on the lab's server — never on a local machine and never in this repo. The code
> here runs against that data on Scribe.

> New here? This README assumes you're comfortable with Stata but possibly new to git.

---

## 1. What this repo is

The repo holds the Stata code for the post-conference survey: a cleaning step that turns the
Qualtrics export into a labeled analysis dataset, and an exploration step that tabulates every
question. It does not produce paper-ready tables or figures — its products are the cleaned
dataset and tabulation logs, which live on Scribe alongside the data.

Respondents are students (middle school, high school, community/4-year college), parents/
guardians, and school staff. The survey uses Qualtrics display logic, so different respondent
types see different question blocks; the cleaning and tabulation code reproduces that logic.

> **Note:** This is a lightweight project. There is no `decisions/` folder or golden-master
> comparison; the load-bearing documentation is §4 (the per-file input/output map) below.

## 2. How to run

The analysis runs on the lab's **Scribe** server, where the data lives. `do/main.do` is the
single entry point — it sets the path global and runs the whole pipeline in dependency order:

```bash
# On Scribe, from the project folder:
cd /home/research/ca_ed_lab/projects/ccylc
stata-mp -b do do/main.do
```

That runs `do/settings.do` (defines `$projdir`), then `do/clean/clean_qualtrics.do`, then
`do/explore/tab.do`. To re-run a single step on its own, source `settings.do` first so
`$projdir` is defined, e.g. `do do/settings.do` then `do $projdir/do/clean/clean_qualtrics.do`.

- **Runtime:** seconds to a couple of minutes (small survey).
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
└── log/                        # run logs (committed; PII-free)
```

Only `do/`, the run logs, and the dotfiles are tracked on GitHub. The data lives on Scribe and
is never committed; the run logs *are* committed (PII-free) as a record of the run.

## 4. Inputs and outputs of each do file

The core of the handoff. The data files all live on Scribe (never local, never in the repo);
this maps what each step reads and writes there.

| File | Purpose | Reads | Writes |
|---|---|---|---|
| `do/main.do` | Entry point: `cd`s to the project folder, sources `settings.do`, then runs `clean/clean_qualtrics.do` and `explore/tab.do` in order | — | — |
| `do/settings.do` | Defines `global projdir`; sourced first | — | — |
| `do/macros.doh` | Defines question-group locals (`hs_qs`, `ms_qs`, `transfer_qs`, `allstudent_qs`, `parent_qs`, `staff_qs`, `text_qs`) and each question's display-logic population criterion (`*_crit`). `include`d by `tab.do`. | — | — |
| `do/clean/clean_qualtrics.do` | Renames Q-codes to readable variables, applies value labels, builds multi-select "check all that apply" dummies, merges them by `responseid` | the Qualtrics survey export (on Scribe) **[external]** | a cleaned analysis dataset (on Scribe) + a clean log (committed under `log/`) |
| `do/explore/tab.do` | For each question, counts the display-logic population and `tab`s the variable, by respondent block | the cleaned dataset; `include`s `do/macros.doh` | a tabulation log (committed under `log/`) |

**Why the cleaning step reads two exports:** `clean_qualtrics.do` reads the **value** export for
most variables, and re-imports the **label** export inside `preserve`/`restore` blocks to parse
the free-text labels of the multi-select "check all that apply" questions (e.g. `why_coll_*`,
`ms_why_coll_*`, `parent_why_coll_*`, `staff_fund_*`, `staff_barrier_*`).

## 5. Outputs

The pipeline writes a cleaned analysis dataset (stays on Scribe, not tracked) and run logs,
which **are** committed to this repo under `log/` (PII-free) as a record of what ran. There are
no tracked tables or figures.

## 6. What NOT to commit

- **Never commit the survey data, and never copy it off Scribe.** The survey collected
  **respondent emails** and **minors' responses**; that data lives only on the server. (Run logs
  *are* committed — but only because they're PII-free; never commit a log that prints identifiers
  or raw data rows.) See the
  [data-safety guidance](https://chesun.github.io/cel_resource_hub/workflow-tips/data-safety/).
- Do not copy `.git/` onto Scribe, and do not put GitHub credentials on the server.

## 7. Why it's built this way

- **`settings.do` holds the one path global (`$projdir`).** Change the location in one place.
- **Display logic is reconstructed in code.** Qualtrics only showed each block to the relevant
  respondents; `macros.doh` encodes each question's population criterion so `tab.do` reports the
  correct denominator (`count if` the criterion) before each tabulation.
- **Multi-select questions become dummies.** "Check all that apply" answers arrive as a single
  delimited string; the cleaning code expands each option into a 0/1 variable.

## 8. Offboarding record / when something breaks

First places to look: the run logs on Scribe (the `log/` tree).

Offboarding is complete — this repo is archived as a clean code handoff. The full
offboarding record:

- [x] **Handoff `README.md` with per-file I/O map** — written in the repo.
- [x] **`do/main.do` wired to run the full pipeline** (`settings.do` → `clean/clean_qualtrics.do` → `explore/tab.do`).
- [x] **End-to-end server run recorded — 2026-06-21.** `do/main.do` ran clean on Scribe: both logs closed at `2026-06-21 20:28:49`, `dta/cln/ccylc_2025_clean.dta` was written, and neither log contains a Stata error (`r(###);`). The run logs live on Scribe under `log/`.

Two kinds of log notes are expected and are **not** errors: the clean log's
`(file ... not found)` lines are normal `save tempfile, replace` notices (one per
multi-select block), and the tab log's `no observations` lines are questions whose
display-logic population was 0.

**Contacts:**

- **Author:** Christina Sun — `christinasun101@gmail.com` / `ucsun@ucdavis.edu`
- **Data-management custodian / Scribe access:** CEL data management (see the resource hub).
- **Lab IT:** provisions Scribe SSH accounts.

> More of my workflow notes (git, Scribe & SSH, data safety) live in the
> [CEL Resource Hub](https://chesun.github.io/cel_resource_hub/).
