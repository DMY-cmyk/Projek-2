# Projek-2

Rust workspace for thesis analysis tooling with SEC `data.sec.gov` integration.

## Structure
- `Cargo.toml`: Workspace root.
- `crates/app/`: Main CLI application.
- `scripts/`: PowerShell helpers for SEC data.
- `scripts/eviews_run.ps1`: EViews COM automation runner for panel analysis.
- `scripts/build_ai_disclosure_index.ps1`: AI disclosure index builder from annual report text.
- `chat_transcript.md`: Input transcript (reference).
- `Plan.md`: Analysis plan.

## Quick Start
```powershell
# Build
cargo build

# Ready check
cargo run -p projek-2 -- ready
```

## SEC Tools
### 1) Download SEC tickers map
```powershell
.\scripts\sec_tickers.ps1 -UserAgent "Your Name your.email@example.com"
```

### 2) Fetch companyfacts + ratios
```powershell
.\scripts\sec_fetch.ps1 -Ticker AAPL -UserAgent "Your Name your.email@example.com"
```

### 3) Fetch with PBV (price CSV)
Price CSV format:
```csv
fy,price
2019,68.31
2020,132.69
2021,177.57
```

Run:
```powershell
.\scripts\sec_fetch.ps1 -Ticker AAPL -UserAgent "Your Name your.email@example.com" -PriceCsv .\data\prices_aapl.csv
```

### 4) Fetch with PBV (auto price fetch)
```powershell
.\scripts\sec_fetch.ps1 -Ticker AAPL -UserAgent "Your Name your.email@example.com" -PriceTicker AAPL -PriceStartYear 2019 -PriceEndYear 2025
```

## Price CSV Helper (Yahoo Finance)
Generate yearly closing prices for PBV input:
```powershell
.\scripts\price_fetch.ps1 -Ticker AAPL -StartYear 2019 -EndYear 2025 -Out .\data\prices_aapl.csv
```

IDX batch price fetch for candidate sample tickers:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\fetch_all_prices.ps1 -StartYear 2019 -EndYear 2025 -OutDir .\data\prices
```

Quick Yahoo connectivity check:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\test_yahoo.ps1
```

## EViews Integration (Automated Analysis)
Detected on this PC:
- `EViews 12 (64-bit)` at `C:\Program Files\EViews 12\`

### 1) Prepare dataset
Required columns:
`firm_id,year,price,ret,tq,roa,roe,npm,cr,der,tato,eps,size,growth,age,vol,aid,ii,dgenai`

Start template:
- `output/panel_dataset_template.csv`

### 2) Run EViews automation
```powershell
.\scripts\eviews_run.ps1 -DatasetPath .\output\panel_dataset_template.csv
```

Quick smoke check with small/synthetic data:
```powershell
.\scripts\eviews_run.ps1 -DatasetPath .\output\panel_dataset_template.csv -SmokeMode
```

Adaptive fallback spec (for small/collinear datasets):
```powershell
.\scripts\eviews_run.ps1 -DatasetPath .\output\panel_dataset_template.csv -AdaptiveSpec
```

Generated outputs:
- `output/eviews/panel_2019_2025.wf1`
- `output/eviews/eq_*.txt`
- `output/eviews/eviews_run_summary.md`

### 3) Build AI disclosure index (semi-automated)
Place annual report text files as:
- `output/annual_reports_txt/{TICKER}_{YEAR}_AR.txt`

Run:
```powershell
.\scripts\build_ai_disclosure_index.ps1
```

Output:
- `output/ai_disclosure_index.csv`

Build 10% spot-check template for manual validation:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build_ai_spotcheck_template.ps1 `
  -MasterCsv .\output\data_collection_master_status.csv `
  -OutCsv .\output\ai_disclosure_spotcheck_10pct.csv `
  -OutMd .\output\ai_disclosure_spotcheck_note.md
```

Outputs:
- `output/ai_disclosure_spotcheck_10pct.csv`
- `output/ai_disclosure_spotcheck_note.md`

Build full manual coding sheet (all firm-year rows):
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build_ai_manual_sheet.ps1 `
  -CollectionStatus .\output\data_collection_master_status.csv `
  -OutCsv .\output\ai_disclosure_manual_sheet_interim.csv `
  -OutMd .\output\ai_disclosure_manual_sheet_note.md
```

Outputs:
- `output/ai_disclosure_manual_sheet_interim.csv`
- `output/ai_disclosure_manual_sheet_note.md`

## Sample Estimation Automation (Step 2.2 / 3.1)
Prepare input file:
- `output/sample_selection_template.csv`

Columns expected:
- `ticker,company_name,listing_date,active_status,idx_ic_sector,has_fs_2019_2025,has_ar_2019_2025,has_price_data,idr_reporting`

Run:
```powershell
.\scripts\estimate_sample.ps1
```

Optional relaxed listing cutoff (<= 2020-01-01):
```powershell
.\scripts\estimate_sample.ps1 -RelaxListingTo2020
```

Outputs:
- `output/sample_selection_result.csv`
- `output/sample_estimation.md`
- `output/sample_selection_result_relaxed.csv`
- `output/sample_estimation_relaxed.md`
- `output/sample_analysis_comprehensive.md`
- `output/sample_selection_flow_interim.md`

## Data Collection Master Builder (Step 3.2 / 3.6)
Run:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build_collection_master.ps1 `
  -SampleTemplate .\output\sample_selection_template.csv `
  -StartYear 2019 `
  -EndYear 2025
```

Outputs:
- `output/data_collection_master_interim.csv`
- `output/manual_crosscheck_10pct.csv`
- `output/data_collection_manifest_interim.md`

Build daily ticker batch for manual collection:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build_daily_collection_batch.ps1 `
  -StatusCsv .\output\data_collection_master_status.csv `
  -BatchSize 5 `
  -OutMd .\output\daily_collection_batch.md
```

Output:
- `output/daily_collection_batch.md`

Refresh file-availability status against expected paths:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\update_collection_availability.ps1 `
  -MasterCsv .\output\data_collection_master_interim.csv `
  -OutStatusCsv .\output\data_collection_master_status.csv `
  -OutReportMd .\output\data_collection_availability_report.md
```

Outputs:
- `output/data_collection_master_status.csv`
- `output/data_collection_availability_report.md`

Build pending download queues (FS/AR/Price):
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build_download_queues.ps1 `
  -StatusCsv .\output\data_collection_master_status.csv `
  -OutFsCsv .\output\download_queue_fs.csv `
  -OutArCsv .\output\download_queue_ar.csv `
  -OutPriceCsv .\output\download_queue_price.csv `
  -OutSummaryMd .\output\download_queue_summary.md
```

Outputs:
- `output/download_queue_fs.csv`
- `output/download_queue_ar.csv`
- `output/download_queue_price.csv`
- `output/download_queue_summary.md`
- `output/manual_data_collection_runbook.md`

Sync availability status into sample-selection result:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync_sample_from_collection.ps1 `
  -SampleTemplate .\output\sample_selection_template.csv `
  -CollectionStatus .\output\data_collection_master_status.csv `
  -OutCsv .\output\sample_selection_result_interim.csv `
  -OutSummaryMd .\output\sample_selection_interim_summary.md
```

Outputs:
- `output/sample_selection_result_interim.csv`
- `output/sample_selection_interim_summary.md`

### IDX Population Ingestion (before sample estimation)
If you export IDX issuer list to CSV, normalize it first:
```powershell
.\scripts\ingest_idx_population.ps1 -InputCsv .\output\idx_population_template.csv
```

Outputs:
- `output/idx_population_normalized.csv`
- `output/sample_selection_template.csv` (prefilled from IDX population)
- `output/idx_population_summary.md`

## Panel Dataset Builder (Step 3.5 / 3.6)
Template inputs:
- `output/financial_master_template.csv`
- `output/price_master_template.csv`
- `output/ai_disclosure_index_template.csv`

Run (example with templates):
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build_panel_dataset.ps1 `
  -FinancialCsv .\output\financial_master_template.csv `
  -PriceCsv .\output\price_master_template.csv `
  -AidCsv .\output\ai_disclosure_index_template.csv `
  -OutCsv .\data\processed\panel_dataset.csv `
  -OutCleaningLog .\output\data_cleaning_log.md
```

Optional winsorization:
```powershell
.\scripts\build_panel_dataset.ps1 -Winsorize
```

Outputs:
- `data/processed/panel_dataset.csv` (default path)
- `output/data_cleaning_log.md`

## Descriptive Stats Automation (Step 4.1)
Run:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\descriptive_stats.ps1 -InputCsv .\data\processed\panel_dataset.csv
```

Outputs:
- `output/descriptive_stats.md`
- `output/correlation_matrix.csv`

## Assumption Tests Automation (Step 4.2)
Run:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\assumption_tests.ps1 -InputCsv .\data\processed\panel_dataset.csv -Dependent price
```

Outputs:
- `output/assumption_tests.md`
- `output/vif_table.csv`

## Interim Data Validation (Step 3.6)
Run:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate_panel_data.ps1 `
  -PanelCsv .\data\processed\panel_dataset.csv `
  -FinancialCsv .\data\processed\financial_master.csv `
  -OutMd .\output\data_validation_interim.md
```

Output:
- `output/data_validation_interim.md`

## Panel Model Selection Automation (Step 4.3)
Run (EViews COM):
```powershell
.\scripts\panel_model_selection.ps1 -DatasetPath .\output\panel_dataset_template.csv -Dependent price
```

Outputs:
- `output/panel_model_selection.md`
- `output/eviews_model_selection/eq_pool.txt`
- `output/eviews_model_selection/eq_fe.txt` (if FE command succeeds)
- `output/eviews_model_selection/eq_re.txt` (if RE command succeeds)
- `output/eviews_model_selection/chow_test.txt` and `hausman_test.txt` (if supported by command path)

Model readiness check (recommended before interpreting regressions):
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\model_readiness_report.ps1 `
  -EViewsSummary .\output\eviews\eviews_run_summary.md `
  -PanelCsv .\data\processed\panel_dataset.csv `
  -OutMd .\output\model_readiness_report.md
```

Output:
- `output/model_readiness_report.md`
- `output/model_selection_decision_template.md`

## Robustness Dataset Pipeline (Step 4.5)
Run:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\robustness_checks.ps1 -InputCsv .\data\processed\panel_dataset.csv
```

Outputs:
- `output/robustness_checks.md`
- `output/robustness/panel_pre_2019_2022.csv`
- `output/robustness/panel_post_2023_2025.csv`
- `output/robustness/panel_exclude_2020.csv`
- `output/robustness/panel_winsor_1_99.csv`
- `output/robustness/panel_winsor_5_95.csv`
- `output/robustness/panel_alt_proxy_pbv.csv`

## US vs Indonesia Supplementary Comparison (Step 7)
Run:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\compare_id_us.ps1 `
  -IdCsv .\data\processed\panel_dataset.csv `
  -UsDir .\data\sec_cache `
  -StartYear 2019 `
  -EndYear 2025
```

Outputs:
- `output/us_sec_ratios_2019_2025.csv`
- `output/us_id_descriptive_comparison.md`
- `output/us_id_context_discussion.md`
- `output/supplementary_analysis_scope_note.md`

## Hypothesis Decision Table (Step 4.6)
Run:
```powershell
.\scripts\hypothesis_decision.ps1 -EViewsOutDir .\output\eviews -Alpha 0.05
```

Outputs:
- `output/hypothesis_results.csv`
- `output/hypothesis_decision.md`

## Model Interpretation Templates (Step 4.4 / 4.5)
Run:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build_model_interpretation_templates.ps1
```

Outputs:
- `output/regression_reporting_template.csv`
- `output/interaction_interpretation_template.md`
- `output/system_gmm_preparation_note.md`

## Thesis Draft Exports (Phase 5)
Generated draft files:
- `draft/thesis_draft.md`
- `draft/thesis_draft.docx`
- `draft/thesis_draft.pdf`
- `draft/daftar_pustaka_draft.md`
- `draft/lampiran_draft.md`

Campus-ready template used:
- `Skripsi_31998_DZAKI.docx`
- `Skripsi_31998_DZAKI.pdf`

Regenerate DOCX:
```powershell
pandoc .\draft\thesis_draft.md --reference-doc=.\Skripsi_31998_DZAKI.docx -o .\draft\thesis_draft.docx
```

Regenerate PDF:
```powershell
pandoc .\draft\thesis_draft.md -s -o .\draft\thesis_draft.html
& "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" --headless --disable-gpu --print-to-pdf="D:\VsCode\Projek-2\draft\thesis_draft.pdf" "file:///D:/VsCode/Projek-2/draft/thesis_draft.html"
```

## Internal Review Progress (Step 6.1)
- `output/review_internal_checklist.md`
- `output/plan_progress_dashboard.md`
- `output/pending_actions.csv`
- `output/pending_actions_summary.md`
- `output/next_actions_sprint.md`
- `output/critical_blockers_report.md`

Regenerate pending action queue from `Plan.md`:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build_pending_actions.ps1 `
  -PlanPath .\Plan.md `
  -OutCsv .\output\pending_actions.csv `
  -OutMd .\output\pending_actions_summary.md
```

Build priority sprint queue from pending actions:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build_execution_sprint.ps1 `
  -PendingCsv .\output\pending_actions.csv `
  -OutMd .\output\next_actions_sprint.md
```

One-command refresh for all operational trackers:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\refresh_operational_dashboard.ps1 -PlanPath .\Plan.md
```

Output:
- `output/operational_refresh_summary.md`
- `output/progress_history.csv`
- `output/daily_standup.md`

Build critical blockers snapshot:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build_blocker_report.ps1 `
  -AvailabilityReport .\output\data_collection_availability_report.md `
  -ModelReadiness .\output\model_readiness_report.md `
  -PendingSummary .\output\pending_actions_summary.md `
  -OutMd .\output\critical_blockers_report.md
```

Record progress snapshot only:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\record_progress_snapshot.ps1 `
  -AvailabilityReport .\output\data_collection_availability_report.md `
  -DashboardReport .\output\plan_progress_dashboard.md `
  -PendingSummary .\output\pending_actions_summary.md `
  -OutCsv .\output\progress_history.csv
```

Build daily standup sheet:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build_daily_standup.ps1 `
  -ProgressHistory .\output\progress_history.csv `
  -BlockerReport .\output\critical_blockers_report.md `
  -DailyBatch .\output\daily_collection_batch.md `
  -OutMd .\output\daily_standup.md
```

## Proposal Kickoff Template
- `draft/proposal_awal_outline.md`

## Supervisor and Exam Package (Step 6.2 / 6.3)
Prepared files:
- `output/supervisor_submission_checklist.md`
- `output/supervisor_consultation_tracker.md`
- `output/supervisor_submission_email_template.md`
- `draft/consultation_revision_log.md`
- `draft/one_page_summary_penguji.md`
- `draft/one_page_summary_penguji.docx`
- `draft/one_page_summary_penguji.pdf`
- `draft/slides_outline.md`
- `draft/faq_sidang.md`
- `draft/defense_slides.md`
- `draft/defense_slides.pptx` (Canva-ready import)
- `draft/defense_slides_v2.md`
- `draft/defense_slides_v2.pptx`
- `draft/defense_speaker_notes.md`
- `output/presentation_rehearsal_plan.md`
- `output/presentation_rehearsal_log_template.md`
- `output/post_defense_revision_tracker.md`
- `output/defense_revision_response_matrix.md`
- `output/campus_repository_upload_checklist.md`

Canva note:
- `output/canva_integration_note.md`

One-command Canva-ready build:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\canva_ready.ps1
```

Build manifest:
- `output/canva_ready_manifest.md`

## Outputs
- `sec_companyfacts.csv`: Raw SEC facts (filtered whitelist).
- `sec_ratios.csv`: FY-only ratios with EPS and optional PBV.
- `analysis_output.md`: Final synthesis.
- `output/literatur_tesis.md`: Thesis matrix.
- `output/literatur_jurnal.md`: 28-article journal matrix.
- `output/research_gap.md`: Research gap narrative.
- `output/kerangka_teori.md`: Theoretical framework.
- `output/hipotesis.md`: Hypothesis set.
- `output/metodologi_penelitian.md`: Methodology implementation notes.
- `output/preliminary_analysis_note.md`: Preliminary interpretation on pilot panel dataset.
- `output/cross_sectional_dependence.md`: Preliminary Pesaran CD diagnostic (pilot only).

## Research Plan Progress Snapshot
- Step 1.1 complete: thesis inventory/classification.
- Step 1.2 complete: 28 journal references matrix.
- Step 1.3-1.5 complete: theory, gap, and hypotheses.
- Step 2 scaffolding complete in tooling/docs (methodology templates and automation scripts).
- EViews COM connection validated with smoke test.
- Step 3.5 pilot complete: `data/processed/panel_dataset.csv` generated from templates.
- Step 4.1 interpretation and high-correlation screening documented (preliminary, pilot basis).
- Step 4.2 cross-sectional dependence preliminary check documented (pilot basis).

## Current Limitation
- Current panel file is still pilot-sized (4 rows), so model selection and full inference remain pending until full real dataset collection is completed.

## Notes
- SEC API requires a descriptive `User-Agent`.
- Default ratios are FY-only from 10-K/20-F; pass `-NoFyOnly` to include interim values.
- `data/` is gitignored.
- Keep secrets/credentials out of repo.
