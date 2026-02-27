# Data Collection Checklist (Step 2.4 / 3.x)

## Struktur Folder Kerja
- `data/raw` -> laporan keuangan mentah
- `data/annual_reports` -> annual report PDF
- `data/prices` -> data harga mentah
- `data/processed` -> dataset panel final

## Checklist Perusahaan x Tahun (2019-2025)
Gunakan tabel ini per emiten:

| Ticker | Tahun | FS PDF | AR PDF | Closing Price | Monthly Prices | Notes |
|---|---|---|---|---|---|---|
| | 2019 | [ ] | [ ] | [ ] | [ ] | |
| | 2020 | [ ] | [ ] | [ ] | [ ] | |
| | 2021 | [ ] | [ ] | [ ] | [ ] | |
| | 2022 | [ ] | [ ] | [ ] | [ ] | |
| | 2023 | [ ] | [ ] | [ ] | [ ] | |
| | 2024 | [ ] | [ ] | [ ] | [ ] | |
| | 2025 | [ ] | [ ] | [ ] | [ ] | |

## Validasi Data Minimum
- FS: Total Assets, Total Liabilities, Total Equity, Current Assets, Current Liabilities, Net Income, Revenue, Intangible Assets, Shares Outstanding.
- Price: penutupan akhir tahun dan seri bulanan.
- Annual report: tersedia untuk ekstraksi AI disclosure.

## Output yang Wajib Terbentuk
- `data/processed/panel_dataset.csv`
- `output/ai_disclosure_index.csv`
- `output/eviews/*.txt`
