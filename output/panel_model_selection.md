# Panel Model Selection Report

- Dataset: D:\VsCode\Projek-2\output\panel_dataset_template.csv
- Dependent: price
- Regressors: roa der eps size growth age vol aid ii dgenai
- Success steps: 3
- Failed steps: 5

## Execution Log
- [OK] load_dataset
- [OK] pagestruct
- [OK] smpl_all
- [FAILED] pooled_ls: Near singular matrix in "EQUATION EQ_POOL.LS PRICE C ROA DER EPS SIZE GROWTH AGE VOL AID II DGENAI".
- [FAILED] fixed_effects: Near singular matrix in "EQUATION EQ_FE.LS(PANEL=FIXED) PRICE C ROA DER EPS SIZE GROWTH AGE VOL AID II DGENAI".
- [FAILED] random_effects: Near singular matrix in "EQUATION EQ_RE.LS(PANEL=RANDOM) PRICE C ROA DER EPS SIZE GROWTH AGE VOL AID II DGENAI".
- [FAILED] chow_test_attempt: EQ_FE is not defined in "FREEZE(TAB_CHOW) EQ_FE.REDTEST".
- [FAILED] hausman_test_attempt: EQ_RE is not defined in "FREEZE(TAB_HAUSMAN) EQ_RE.HAUSMAN EQ_FE".

## Decision Guidance
1. If eq_pool, eq_fe, and eq_re all succeed, compare test outputs (Chow/Hausman) in output folder.
2. If test attempts fail, run corresponding tests manually in EViews GUI on the generated equations.
3. Record final model choice in Plan.md after real dataset run.
