# Projek-2

Rust workspace for thesis analysis tooling with SEC `data.sec.gov` integration.

## Structure
- `Cargo.toml`: Workspace root.
- `crates/app/`: Main CLI application.
- `scripts/`: PowerShell helpers for SEC data.
- `chat_transcript.md`: Input transcript (reference).
- `Plan.md`: Analysis plan (gitignored).

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

## Outputs
- `sec_companyfacts.csv`: Raw SEC facts (filtered whitelist).
- `sec_ratios.csv`: FY-only ratios with EPS and optional PBV.

## Notes
- SEC API requires a descriptive `User-Agent`.
- Default ratios are FY-only from 10-K/20-F; pass `-NoFyOnly` to include interim values.

## Research Plan Summary
Scope from `Plan.md`:
- Tesis S2, analisis fundamental (rasio keuangan), data sekunder.
- Sektor teknologi (IDX-IC), periode 2019-2025.
- Dependen: harga, return, nilai perusahaan.
- Tambahan: indikator AI/teknologi (disclosure index, intangible intensity).
- Pembanding global opsional via SEC `data.sec.gov`.

Progress (from `Plan.md`):
- External-claim inventory complete.
- Thesis inventory/classification complete (provisional).
- Potential issues flagged (needs source verification).
- Scope reaffirmed.
- Inclusion/exclusion criteria drafted.
- Variable normalization and gap outline drafted.

## Verified S2 Tech Theses (Public Repos)
Note: Verified entries are limited by public access and filtered to **rasio fundamental** only.
- UNDIKSHA (2025) — Tesis Magister Akuntansi; sektor teknologi BEI 2021–2023; intellectual capital & working capital management → financial distress → return saham. `https://repo.undiksha.ac.id/23085/`
- ITB (2024) — Tesis; sektor teknologi BEI 2021Q1–2023Q2; EPS, PBV, TATO, FATO → financial distress (Altman Z-Score). `https://digilib.itb.ac.id/gdl/view/79966`
- UNISSULA (2025) — Tesis Magister Manajemen; sektor teknologi BEI 2020–2023; profitabilitas, likuiditas, leverage → nilai perusahaan. `https://repository.unissula.ac.id/43161/`
Target 6–10 tesis belum tercapai; perlu penelusuran repositori tambahan.

## Excluded (Not Fundamental Ratios)
- ITB (2022) — valuasi saham PT Bukalapak (DCF/valuasi relatif). `https://digilib.itb.ac.id/index.php/gdl/view/62708`
- ITB (2022) — penilaian saham relatif PT Bukalapak.com Tbk. `https://digilib.itb.ac.id/index.php/gdl/view/67225`
- UMB (2024) — board gender diversity & corporate governance → manajemen laba. `https://repository.mercubuana.ac.id/93450/1/01%20COVER.pdf`

## Candidates/Related (Unverified or Not Strictly Tech Sector)
- UNHAS (2024) — tesis sektor teknologi BEI 2020–2023; akses repo gagal saat penelusuran.
- UNEJ (2021) — tesis Magister Akuntansi tentang reaksi pasar atas pengumuman investasi TI pada emiten BEI (relevan teknologi/IT, bukan sektor teknologi).
- UNILA (2025) — tesis S2 Magister Ilmu Akuntansi; mobile banking & investasi TI → NPL dan fee based income (perbankan, bukan sektor teknologi).
- UNDIKSHA (2024) — tesis S2; CSER & investasi TI → nilai perusahaan pertambangan (bukan sektor teknologi).
- UNISSULA (2024) — tesis S2; TI memoderasi kompetensi SDM → kinerja perusahaan; studi perbankan syariah (bukan sektor teknologi).

## Search Status (2026-02-26)
- Additional searches for S2 tech-sector BEI theses using fundamental ratios returned mostly journal articles or non-tech-sector theses, with no new verifiable matches added in this round.

## Search Status (2026-02-26, Round 2)
- Follow-up searches confirmed the existing ITB 2024 thesis entry but found no additional publicly verifiable S2 tech-sector BEI theses using fundamental ratios in this round.

## Git Ignore
- `Plan.md` is gitignored.
- `data/` and credential/secret files are gitignored.
