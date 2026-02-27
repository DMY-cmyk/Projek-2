# Daily Collection Batch

- Source: .\output\data_collection_master_status.csv
- Batch size: 5

| Ticker | Company | Missing FS | Missing AR | Missing Price |
|---|---|---:|---:|---:|
| ATIC | Anabatic Technologies Tbk | 7 | 7 | 7 |
| BALI | Bali Towerindo Sentra Tbk | 7 | 7 | 7 |
| BTEL | Bakrie Telecom Tbk | 7 | 7 | 7 |
| CENT | Centratama Telekomunikasi Indonesia Tbk | 7 | 7 | 7 |
| DIVA | Distribusi Voucher Nusantara Tbk | 7 | 7 | 7 |

## Execution Checklist (Today)
1. Download FS PDFs for selected tickers (2019-2025) to data/raw/.
2. Download AR PDFs for selected tickers (2019-2025) to data/annual_reports/.
3. Download/prepare price CSV for selected tickers in data/prices/.
4. Run scripts/refresh_operational_dashboard.ps1.
5. Confirm queue shrink in output/download_queue_summary.md.
