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
.\scripts\build_panel_dataset.ps1 `
  -FinancialCsv .\output\financial_master_template.csv `
  -PriceCsv .\output\price_master_template.csv `
  -AidCsv .\output\ai_disclosure_index_template.csv `
  -OutCsv .\output\panel_dataset_built.csv `
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
.\scripts\descriptive_stats.ps1 -InputCsv .\output\panel_dataset_built.csv
```

Outputs:
- `output/descriptive_stats.md`
- `output/correlation_matrix.csv`

## Assumption Tests Automation (Step 4.2)
Run:
```powershell
.\scripts\assumption_tests.ps1 -InputCsv .\output\panel_dataset_built.csv -Dependent price
```

Outputs:
- `output/assumption_tests.md`
- `output/vif_table.csv`

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

## Robustness Dataset Pipeline (Step 4.5)
Run:
```powershell
.\scripts\robustness_checks.ps1 -InputCsv .\output\panel_dataset_built.csv
```

Outputs:
- `output/robustness_checks.md`
- `output/robustness/panel_pre_2019_2022.csv`
- `output/robustness/panel_post_2023_2025.csv`
- `output/robustness/panel_exclude_2020.csv`
- `output/robustness/panel_winsor_1_99.csv`
- `output/robustness/panel_winsor_5_95.csv`
- `output/robustness/panel_alt_proxy_pbv.csv`

## Hypothesis Decision Table (Step 4.6)
Run:
```powershell
.\scripts\hypothesis_decision.ps1 -EViewsOutDir .\output\eviews -Alpha 0.05
```

Outputs:
- `output/hypothesis_results.csv`
- `output/hypothesis_decision.md`

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

## Supervisor and Exam Package (Step 6.2 / 6.3)
Prepared files:
- `output/supervisor_submission_checklist.md`
- `draft/consultation_revision_log.md`
- `draft/one_page_summary_penguji.md`
- `draft/one_page_summary_penguji.docx`
- `draft/one_page_summary_penguji.pdf`
- `draft/slides_outline.md`
- `draft/faq_sidang.md`

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

## Research Plan Progress Snapshot
- Step 1.1 complete: thesis inventory/classification.
- Step 1.2 complete: 28 journal references matrix.
- Step 1.3-1.5 complete: theory, gap, and hypotheses.
- Step 2 scaffolding complete in tooling/docs (methodology templates and automation scripts).
- EViews COM connection validated with smoke test.

## Notes
- SEC API requires a descriptive `User-Agent`.
- Default ratios are FY-only from 10-K/20-F; pass `-NoFyOnly` to include interim values.
- `data/` is gitignored.
- Keep secrets/credentials out of repo.
