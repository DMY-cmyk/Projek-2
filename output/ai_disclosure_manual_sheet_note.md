# AI Disclosure Manual Sheet Note (Interim)

- Source collection status: .\output\data_collection_master_status.csv
- Total firm-year rows: 182
- AR-ready rows currently: 0
- Manual sheet output: .\output\ai_disclosure_manual_sheet_interim.csv

## Field Guide
- `k1_ai_core`, `k2_digital_tech`, `k3_digital_transformation`: isi 1 jika kategori terdeteksi, selain itu 0.
- `aid_binary`: (k1+k2+k3)/3.
- `ai_keyword_hits`: total kemunculan keyword AI dari text mining/manual count.
- `aid_frequency`: ai_keyword_hits/total_words.
- `coder`, `review_date`, `notes`: untuk jejak audit coding.
