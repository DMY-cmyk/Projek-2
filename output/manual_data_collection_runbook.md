# Manual Data Collection Runbook (Interim)

## Objective
Menutup gap data untuk 189 firm-year rows pada skenario rekomendasi (27 emiten x 2019-2025).

## Input Utama
- `output/data_collection_master_status.csv`
- `output/download_queue_fs.csv`
- `output/download_queue_ar.csv`
- `output/download_queue_price.csv`

## Urutan Eksekusi
1. Unduh laporan keuangan (FS) sesuai `download_queue_fs.csv`.
2. Unduh annual report sesuai `download_queue_ar.csv`.
3. Unduh data harga saham sesuai `download_queue_price.csv`.
4. Simpan file sesuai path target di kolom `expected_*`.
5. Jalankan:
   - `scripts/update_collection_availability.ps1`
   - `scripts/build_download_queues.ps1`
6. Ulangi hingga queue mendekati nol.
7. Lakukan cross-check 10% menggunakan:
   - `output/manual_crosscheck_10pct.csv`
   - `output/ai_disclosure_spotcheck_10pct.csv`

## Daily Checkpoint
- FS tersedia: __ / 189
- AR tersedia: __ / 189
- Price tersedia: __ / 189
- Fully complete rows: __ / 189

## Exit Criteria
- Semua row `fs_downloaded=1`, `ar_downloaded=1`, `price_downloaded=1`.
- `output/sample_selection_result_interim.csv` telah menunjukkan kandidat yang lolos kriteria availability.
- Dataset panel final dapat dibangun ulang dari master aktual.
