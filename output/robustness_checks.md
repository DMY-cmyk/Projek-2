# Robustness Checks Report

- Source dataset: .\output\panel_dataset_built.csv
- Available years: 2019, 2020
- Total rows: 4

## Generated Robustness Datasets
- Subsample pre (2019-2022): .\output\robustness\panel_pre_2019_2022.csv (rows: 4)
- Subsample post (2023-2025): .\output\robustness\panel_post_2023_2025.csv (rows: 0)
- Exclude 2020: .\output\robustness\panel_exclude_2020.csv (rows: 2)
- Winsor 1/99: .\output\robustness\panel_winsor_1_99.csv (rows: 4)
- Winsor 5/95: .\output\robustness\panel_winsor_5_95.csv (rows: 4)
- Alt proxy PBV dataset: .\output\robustness\panel_alt_proxy_pbv.csv (rows: 4)

## Notes
- This step prepares datasets for robustness reruns.
- Estimation reruns can be executed with scripts/eviews_run.ps1 per dataset.
- System GMM remains pending and should be executed in dedicated software workflow.
