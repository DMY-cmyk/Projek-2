# Next Actions Sprint (Priority Queue)

- Source queue: .\output\pending_actions.csv
- Total pending: 48
- Sprint size (top priority): 20

## Top Priority Tasks
| Priority | Phase | Step | Owner Hint | Task |
|---:|---|---|---|---|
| 1 | 4: ANALISIS DATA & PENGUJIAN HIPOTESIS | 4.4 — Estimasi Model Utama (9 Regresi) | mixed | Fokus interpretasi: koefisien interaksi (X×AID) — apakah signifikan dan arahnya? |
| 2 | 3: PENGUMPULAN & PENGOLAHAN DATA | 3.1 — Identifikasi Populasi & Sampel | mixed | Filter berdasarkan kriteria inklusi → daftar sampel final (⏳ menunggu verifikasi data availability) |
| 3 | 3: PENGUMPULAN & PENGOLAHAN DATA | 3.2 — Download Data Laporan Keuangan | manual | Untuk setiap perusahaan sampel, download laporan keuangan tahunan 2019–2025 |
| 4 | 3: PENGUMPULAN & PENGOLAHAN DATA | 3.2 — Download Data Laporan Keuangan | mixed | Sumber: IDX (idx.co.id) → Listed Companies → Financial Statements & Annual Report |
| 5 | 3: PENGUMPULAN & PENGOLAHAN DATA | 3.2 — Download Data Laporan Keuangan | mixed | Ekstrak data berikut dari setiap laporan keuangan: |
| 6 | 3: PENGUMPULAN & PENGOLAHAN DATA | 3.3 — Download Data Harga Saham | manual | Download closing price akhir tahun (31 Desember atau hari bursa terakhir) untuk setiap sampel |
| 7 | 3: PENGUMPULAN & PENGOLAHAN DATA | 3.3 — Download Data Harga Saham | manual | Download juga harga bulanan (untuk menghitung volatilitas) |
| 8 | 3: PENGUMPULAN & PENGOLAHAN DATA | 3.4 — Download & Analisis Annual Report (untuk AI Disclosure Index) | manual | Download annual report (bukan laporan keuangan) untuk setiap sampel 2019–2025 |
| 9 | 3: PENGUMPULAN & PENGOLAHAN DATA | 3.4 — Download & Analisis Annual Report (untuk AI Disclosure Index) | mixed | Lakukan content analysis sesuai Step 2.5 |
| 10 | 3: PENGUMPULAN & PENGOLAHAN DATA | 3.6 — Cleaning & Validasi Data | manual | Cross-check 10% sampel secara manual dengan laporan keuangan asli |
| 11 | 2: METODOLOGI PENELITIAN | 2.5 — Konstruksi AI Disclosure Index (Variabel Moderasi Kunci) | mixed | **Langkah 3**: Lakukan content analysis: |
| 12 | 2: METODOLOGI PENELITIAN | 2.4 — Metode Pengumpulan Data | manual | **Laporan keuangan**: Download dari IDX (idx.co.id → Listed Companies → Financial Statements) |
| 13 | 2: METODOLOGI PENELITIAN | 2.4 — Metode Pengumpulan Data | manual | **Annual report**: Download dari IDX atau website perusahaan |
| 14 | 2: METODOLOGI PENELITIAN | 2.4 — Metode Pengumpulan Data | manual | **Harga saham**: Download dari Yahoo Finance atau IDX (closing price akhir tahun) |
| 15 | 2: METODOLOGI PENELITIAN | 2.5 — Konstruksi AI Disclosure Index (Variabel Moderasi Kunci) | manual | **Langkah 2**: Download annual report semua sampel (2019–2025) |
| 16 | 4: ANALISIS DATA & PENGUJIAN HIPOTESIS | 4.3 — Pemilihan Model Panel | mixed | Pilih model terbaik berdasarkan hasil uji |
| 17 | 4: ANALISIS DATA & PENGUJIAN HIPOTESIS | 4.4 — Estimasi Model Utama (9 Regresi) | mixed | Catatan: mungkin perlu memilih 2–3 rasio utama saja untuk interaksi (hindari overfitting) |
| 18 | 4: ANALISIS DATA & PENGUJIAN HIPOTESIS | 4.4 — Estimasi Model Utama (9 Regresi) | mixed | Fokus interpretasi: koefisien interaksi (X×DGENAI) — apakah relevansi rasio berubah post-2023? |
| 19 | 4: ANALISIS DATA & PENGUJIAN HIPOTESIS | 4.5 — Robustness Checks | mixed | **System GMM**: Estimasi ulang model baseline dengan Arellano-Bond GMM |
| 20 | 3: PENGUMPULAN & PENGOLAHAN DATA | 3.2 — Download Data Laporan Keuangan | mixed | Simpan di `data/raw/` dengan penamaan: `{TICKER}_{YEAR}_FS.pdf` |

## Suggested Execution Order
1. Selesaikan seluruh item data collection (FS/AR/Price) sampai availability >= 80%.
2. Finalisasi sampel berdasarkan availability nyata, lalu rebuild panel dataset.
3. Jalankan ulang model panel + hypothesis extraction pada dataset final.
4. Tutup sisa item finalisasi administratif (konsultasi pembimbing dan sidang).
