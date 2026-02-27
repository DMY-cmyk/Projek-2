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

Generated outputs:
- `output/eviews/panel_2019_2025.wf1`
- `output/eviews/eq_*.txt`

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
