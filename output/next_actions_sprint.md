# Next Actions Sprint (Priority Queue)

- Source queue: .\output\pending_actions.csv
- Total pending: 42
- Sprint size (top priority): 20

## Top Priority Tasks
| Priority | Phase | Step | Owner Hint | Task |
|---:|---|---|---|---|
| 1 | 3: PENGUMPULAN & PENGOLAHAN DATA | 3.1 — Identifikasi Populasi & Sampel | mixed | Filter berdasarkan kriteria inklusi → daftar sampel final (⏳ menunggu verifikasi data availability) |
| 2 | 3: PENGUMPULAN & PENGOLAHAN DATA | 3.2 — Download Data Laporan Keuangan | manual | Untuk setiap perusahaan sampel, download laporan keuangan tahunan 2019–2025 |
| 3 | 3: PENGUMPULAN & PENGOLAHAN DATA | 3.2 — Download Data Laporan Keuangan | mixed | Sumber: IDX (idx.co.id) → Listed Companies → Financial Statements & Annual Report |
| 4 | 3: PENGUMPULAN & PENGOLAHAN DATA | 3.2 — Download Data Laporan Keuangan | mixed | Ekstrak data berikut dari setiap laporan keuangan: |
| 5 | 3: PENGUMPULAN & PENGOLAHAN DATA | 3.4 — Download & Analisis Annual Report (untuk AI Disclosure Index) | manual | Download annual report (bukan laporan keuangan) untuk setiap sampel 2019–2025 |
| 6 | 3: PENGUMPULAN & PENGOLAHAN DATA | 3.4 — Download & Analisis Annual Report (untuk AI Disclosure Index) | mixed | Lakukan content analysis sesuai Step 2.5 |
| 7 | 3: PENGUMPULAN & PENGOLAHAN DATA | 3.6 — Cleaning & Validasi Data | manual | Cross-check 10% sampel secara manual dengan laporan keuangan asli |
| 8 | 4: ANALISIS DATA & PENGUJIAN HIPOTESIS | 4.4 — Estimasi Model Utama (9 Regresi) | mixed | Fokus interpretasi: koefisien interaksi (X×AID) — apakah signifikan dan arahnya? |
| 9 | 2: METODOLOGI PENELITIAN | 2.4 — Metode Pengumpulan Data | manual | **Laporan keuangan**: Download dari IDX (idx.co.id → Listed Companies → Financial Statements) |
| 10 | 2: METODOLOGI PENELITIAN | 2.4 — Metode Pengumpulan Data | manual | **Annual report**: Download dari IDX atau website perusahaan |
| 11 | 2: METODOLOGI PENELITIAN | 2.5 — Konstruksi AI Disclosure Index (Variabel Moderasi Kunci) | manual | **Langkah 2**: Download annual report semua sampel (2019–2025) |
| 12 | 2: METODOLOGI PENELITIAN | 2.5 — Konstruksi AI Disclosure Index (Variabel Moderasi Kunci) | mixed | **Langkah 3**: Lakukan content analysis: |
| 13 | 3: PENGUMPULAN & PENGOLAHAN DATA | 3.2 — Download Data Laporan Keuangan | mixed | Simpan di `data/raw/` dengan penamaan: `{TICKER}_{YEAR}_FS.pdf` |
| 14 | 3: PENGUMPULAN & PENGOLAHAN DATA | 3.4 — Download & Analisis Annual Report (untuk AI Disclosure Index) | mixed | Simpan di `data/annual_reports/` dengan penamaan: `{TICKER}_{YEAR}_AR.pdf` |
| 15 | 3: PENGUMPULAN & PENGOLAHAN DATA | 3.4 — Download & Analisis Annual Report (untuk AI Disclosure Index) | mixed | Hasilkan skor AI Disclosure Index per perusahaan per tahun |
| 16 | 3: PENGUMPULAN & PENGOLAHAN DATA | 3.4 — Download & Analisis Annual Report (untuk AI Disclosure Index) | mixed | Simpan hasil di spreadsheet master |
| 17 | 4: ANALISIS DATA & PENGUJIAN HIPOTESIS | 4.3 — Pemilihan Model Panel | mixed | Pilih model terbaik berdasarkan hasil uji |
| 18 | 4: ANALISIS DATA & PENGUJIAN HIPOTESIS | 4.4 — Estimasi Model Utama (9 Regresi) | mixed | Catatan: mungkin perlu memilih 2–3 rasio utama saja untuk interaksi (hindari overfitting) |
| 19 | 4: ANALISIS DATA & PENGUJIAN HIPOTESIS | 4.4 — Estimasi Model Utama (9 Regresi) | mixed | Fokus interpretasi: koefisien interaksi (X×DGENAI) — apakah relevansi rasio berubah post-2023? |
| 20 | 4: ANALISIS DATA & PENGUJIAN HIPOTESIS | 4.5 — Robustness Checks | mixed | **System GMM**: Estimasi ulang model baseline dengan Arellano-Bond GMM |

## Suggested Execution Order
1. Selesaikan seluruh item data collection (FS/AR/Price) sampai availability >= 80%.
2. Finalisasi sampel berdasarkan availability nyata, lalu rebuild panel dataset.
3. Jalankan ulang model panel + hypothesis extraction pada dataset final.
4. Tutup sisa item finalisasi administratif (konsultasi pembimbing dan sidang).
