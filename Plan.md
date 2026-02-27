# Plan: Tesis S2 — Analisis Fundamental Sektor Teknologi BEI di Era AI (2019–2025)

> Dokumen ini adalah rencana langkah-demi-langkah yang detail untuk menyelesaikan tesis S2 dari tahap awal hingga final, berdasarkan analisis chat transcript dari ChatGPT.

---

## FASE 0: FONDASI & PERSIAPAN

### Step 0.1 — Finalisasi Topik & Judul
- [x] Review 7 opsi judul di `analysis_output.md` bagian 6 ✅ (7 judul tersedia)
- [ ] ⏳ **BUTUH AKSI MANUSIA**: Diskusikan dengan dosen pembimbing, pilih 1 judul final
- [x] **Rekomendasi utama**: "Relevansi Rasio Fundamental di Era Artificial Intelligence: Moderasi AI Disclosure Index pada Perusahaan Sektor Teknologi BEI Periode 2019–2025"
- [x] Konfirmasi rumusan masalah (4 pertanyaan penelitian, lihat `analysis_output.md` bagian 7) ✅
- [x] Tetapkan hipotesis penelitian berdasarkan rumusan masalah ✅ (lihat `output/hipotesis.md`)

### Step 0.2 — Persiapan Administratif
- [ ] ⏳ **BUTUH AKSI MANUSIA**: Daftarkan judul ke program studi / kaprodi
- [ ] ⏳ **BUTUH AKSI MANUSIA**: Dapatkan persetujuan pembimbing
- [ ] ⏳ **BUTUH AKSI MANUSIA**: Siapkan proposal awal (format sesuai panduan kampus)
- [x] Template outline proposal awal disiapkan ✅ (`draft/proposal_awal_outline.md`)
- [x] Pastikan akses ke:
  - IDX website (idx.co.id) untuk laporan keuangan & annual report ✅
  - Database harga saham (Yahoo Finance / IDX / Bloomberg jika tersedia) ✅
  - Software statistik (Stata / EViews / R) ✅ (R packages + pipeline tersedia)

### Step 0.3 — Setup Environment Teknis
- [x] Install software statistik pilihan (Stata 17+ / EViews 13+ / R + RStudio) ✅ (Pipeline scripts tersedia)
- [x] Jika pakai R: install packages `plm`, `lmtest`, `sandwich`, `stargazer`, `readxl`, `tidyverse` ✅ (lihat `scripts/r_setup.R`)
- [x] Setup folder kerja: ✅
  ```
  tesis/
  ├── data/
  │   ├── raw/               # Data mentah dari IDX
  │   ├── processed/         # Data yang sudah diolah
  │   ├── annual_reports/    # PDF annual report untuk content analysis
  │   └── prices/            # Data harga saham
  ├── scripts/               # Script statistik
  ├── output/                # Hasil regresi, tabel, grafik
  └── draft/                 # Draft bab tesis
  ```
- [x] (Opsional) Setup `scripts/sec_fetch.ps1` dan `scripts/price_fetch.ps1` dari project ini untuk data pembanding AS ✅ (sudah tersedia)
- [x] Integrasi EViews 12 via COM automation selesai (script: `scripts/eviews_run.ps1`, template: `scripts/eviews/panel_analysis_template.prg`)

---

## FASE 1: TINJAUAN PUSTAKA & KERANGKA TEORI

### Step 1.1 — Mapping Literatur Tesis Pembanding
- [x] Kumpulkan minimal 6–10 tesis S2 yang relevan ✅ (8 tesis S2 terverifikasi: 4 sektor teknologi + 4 sektor lain)
- [x] Sumber pencarian: Google Scholar, repositori kampus (UNDIKSHA, ITB, UNISSULA, UNAND, UI, UPI, U.Bakrie) ✅
- [x] Verifikasi setiap tesis: Level S2, data sekunder, rasio fundamental ✅
- [x] Catat di tabel inventaris ✅ (lihat `output/literatur_tesis.md`)
- [x] Tambahan: 4 kandidat level tidak jelas + 3 artikel jurnal terkait ✅

### Step 1.2 — Mapping Artikel Jurnal Pendukung
- [x] Cari 20–30 artikel jurnal (nasional + internasional) yang relevan ✅ (28 artikel; lihat `output/literatur_jurnal.md`)
- [x] Topik yang harus dicakup ✅:
  - Analisis fundamental & harga/return/nilai perusahaan (minimal 10 artikel)
  - AI disclosure / digital transformation & firm performance (minimal 5 artikel)
  - Structural break / regime change dalam keuangan (minimal 3 artikel)
  - Sektor teknologi & valuasi (minimal 5 artikel)
- [x] Jurnal target ✅:
  - **Internasional**: Journal of Financial Economics, Journal of Accounting Research, Review of Financial Studies, Technological Forecasting & Social Change, International Review of Financial Analysis
  - **Nasional**: Jurnal Akuntansi dan Keuangan, Jurnal Dinamika Akuntansi, Jurnal Akuntansi Multiparadigma, Media Akuntansi
- [x] Buat literature matrix (tabel: penulis, tahun, variabel, metode, temuan, gap) ✅ (`output/literatur_jurnal.md`)

### Step 1.3 — Identifikasi Teori Dasar
- [x] Pilih dan jelaskan teori yang mendasari ✅ (lihat `output/kerangka_teori.md`):
  - **Signaling Theory** (Spence 1973, Ross 1977) ✅
  - **Efficient Market Hypothesis** (Fama 1970) ✅
  - **Resource-Based View** (Barney 1991) ✅
  - **Value Relevance Theory** (Ohlson 1995, Ball & Brown 1968) ✅
  - **Innovation Diffusion Theory** (Rogers 1962) ✅
- [x] Hubungkan setiap teori ke hipotesis penelitian ✅
- [x] Buat kerangka pemikiran (conceptual framework diagram) ✅

### Step 1.4 — Finalisasi Research Gap
- [x] Konfirmasi 5 gap masih valid setelah tinjauan pustaka diperluas (8 tesis S2) ✅
- [x] Narasi gap research lengkap dengan novelty statement ✅ (lihat `output/research_gap.md`)
- [x] Semua gap terkonfirmasi: AI moderator, structural break, GMM, multi-dependen, periode 2019–2025 ✅

### Step 1.5 — Susun Hipotesis
- [x] Hipotesis lengkap dengan 11 kelompok, 25+ sub-hipotesis ✅ (lihat `output/hipotesis.md`)
- [x] Arah hipotesis ditentukan berdasarkan teori ✅
- [x] Tabel ringkasan hipotesis tersedia ✅

---

## FASE 2: METODOLOGI PENELITIAN

### Step 2.1 — Desain Penelitian
- [x] Jenis: Kuantitatif, kausal/asosiatif (set in `output/metodologi_penelitian.md`)
- [x] Pendekatan: Deduktif (teori -> hipotesis -> pengujian)
- [x] Data: Sekunder (panel data)

### Step 2.2 — Populasi & Sampel
- [x] **Populasi**: Seluruh perusahaan sektor Teknologi (IDX-IC) yang terdaftar di BEI
- [x] **Periode**: 2019-2025 (7 tahun)
- [x] **Teknik sampling**: Purposive sampling
- [x] **Kriteria inklusi**:
  1. Terdaftar di BEI dalam klasifikasi IDX-IC sektor Teknologi
  2. Listing sebelum 1 Januari 2019 (agar ada data penuh 2019–2025)
  3. Menerbitkan laporan keuangan & annual report lengkap selama periode observasi
  4. Tidak delisting selama periode observasi
  5. Data harga saham tersedia
  6. Laporan keuangan dalam mata uang Rupiah
- [x] **Hitung estimasi sampel**: Periksa IDX-IC Technology sector → list semua perusahaan → filter kriteria ✅ (66 perusahaan: 44 Technology + 22 Telecom; lihat `output/sample_analysis_comprehensive.md`)
- [x] **Catatan penting**: Sektor teknologi BEI relatif baru (banyak IPO post-2019). Analisis 6 skenario selesai ✅:
- [x] Automation siap: `scripts/estimate_sample.ps1` + template `output/sample_selection_template.csv` + summary `output/sample_estimation.md`
  - Relaksasi kriteria (misal listing sebelum 2020) ✅ dianalisis
  - Output relaksasi terdokumentasi ✅ (`output/sample_estimation_relaxed.md`, `output/sample_selection_result_relaxed.csv`)
  - Unbalanced panel (izinkan entry/exit) ✅ dianalisis
  - Atau perluas ke sektor terkait (Technology + Telecommunication) ✅ **Rekomendasi utama: Tech + Telecom balanced panel (27 perusahaan, 189 observasi)**

### Step 2.3 — Definisi Operasional Variabel
- [x] Gunakan tabel definisi variabel dari `analysis_output.md` bagian 8.A
- [x] Untuk setiap variabel, tentukan (lihat `output/metodologi_penelitian.md`):
  - Nama variabel
  - Definisi konseptual
  - Definisi operasional (rumus)
  - Skala pengukuran (rasio/nominal/ordinal)
  - Sumber data

### Step 2.4 — Metode Pengumpulan Data
- [ ] **Laporan keuangan**: Download dari IDX (idx.co.id → Listed Companies → Financial Statements)
- [ ] **Annual report**: Download dari IDX atau website perusahaan
- [ ] **Harga saham**: Download dari Yahoo Finance atau IDX (closing price akhir tahun)
- [ ] **Data pendukung**: Website perusahaan untuk informasi AI/digital transformation
- [x] Buat checklist data per perusahaan per tahun (`output/data_collection_checklist.md`)

### Step 2.5 — Konstruksi AI Disclosure Index (Variabel Moderasi Kunci)
- [x] **Langkah 1**: Buat daftar kata kunci (keyword list) (implemented in `scripts/build_ai_disclosure_index.ps1`)
  ```
  Kategori 1 (AI Core): "artificial intelligence", "kecerdasan buatan", "AI",
    "machine learning", "deep learning", "neural network"
  Kategori 2 (Digital Tech): "big data", "cloud computing", "IoT",
    "internet of things", "blockchain", "automation", "robotics"
  Kategori 3 (Digital Transformation): "digital transformation",
    "transformasi digital", "digitalisasi", "digitization"
  ```
- [ ] **Langkah 2**: Download annual report semua sampel (2019–2025)
- [ ] **Langkah 3**: Lakukan content analysis:
  - Opsi A (Manual): Baca setiap annual report, cari kata kunci, beri skor biner per kategori
  - Opsi B (Semi-otomatis): text mining sudah disiapkan via `scripts/build_ai_disclosure_index.ps1`
- [x] **Langkah 4**: Hitung indeks (binary + frequency methods tersedia di script)
  - Metode 1 (Biner): AID = jumlah kategori yang disebut / total kategori (skor 0–1)
  - Metode 2 (Frekuensi): AID = total kemunculan kata kunci / total kata dalam annual report
- [ ] **Langkah 5**: Validasi:
  - Jika manual: inter-coder reliability test (Cohen's Kappa > 0.7)
  - Jika semi-otomatis: spot-check 10% sampel secara manual
- [x] Paket template validasi semi-otomatis disiapkan ✅ (`output/ai_disclosure_spotcheck_10pct.csv`, `output/ai_disclosure_spotcheck_note.md`)
- [x] **Langkah 6**: Dokumentasikan prosedur lengkap untuk lampiran tesis (`output/metodologi_penelitian.md`)

### Step 2.6 — Metode Analisis Data
- [x] **Statistik deskriptif**: Mean, median, std dev, min, max untuk semua variabel ✅ (tersedia pada `output/descriptive_stats.md`, status pilot)
- [x] **Uji asumsi klasik**: ✅ (otomasi dan dokumentasi tersedia pada `output/assumption_tests.md`, status pilot)
  - Multikolinearitas: VIF < 10 (atau < 5 untuk konservatif)
  - Heteroskedastisitas: Breusch-Pagan / White test
  - Autokorelasi: Wooldridge test untuk panel data
  - Normalitas: Jarque-Bera (opsional untuk panel besar)
- [x] **Pemilihan model panel**: ✅ (pipeline + report tersedia `output/panel_model_selection.md`; keputusan final menunggu dataset final)
  - Pooled OLS vs Fixed Effect: Chow test / F-test
  - Fixed Effect vs Random Effect: Hausman test
  - Jika heteroskedastisitas: gunakan robust standard errors (HAC)
- [x] **Model regresi** (3 model utama) (otomasi tersedia di `scripts/eviews_run.ps1`):
  - Model 1 (Baseline): Y_it = α + βX_it + γControls_it + μ_i + ε_it
  - Model 2 (Moderasi AID): Y_it = α + βX_it + θAID_it + λ(X_it × AID_it) + γControls_it + μ_i + ε_it
  - Model 3 (Structural Break): Y_it = α + βX_it + δD_GenAI + φ(X_it × D_GenAI) + γControls_it + μ_i + ε_it
  - Masing-masing diestimasi 3x (Y = PRICE, RET, TQ) → total 9 regresi utama
- [x] **Robustness checks**: ✅ (dataset robustness tersedia di `output/robustness/`; inferensi final menunggu dataset final)
  - System GMM (menangani endogeneity)
  - Subsample: 2019–2022 vs 2023–2025
  - Winsorizing 1%/99%
  - Alternatif proksi: PBV sebagai pengganti Tobin's Q
  - Exclude 2020 (COVID effect) sebagai sensitivity

---

## FASE 3: PENGUMPULAN & PENGOLAHAN DATA

### Step 3.1 — Identifikasi Populasi & Sampel
- [x] Akses IDX → daftar perusahaan sektor Teknologi (IDX-IC) ✅ (44 perusahaan Technology + 22 Telecommunication)
- [x] Catat semua perusahaan: ticker, nama, tanggal listing, status (aktif/delisted) ✅ (`output/idx_population_template.csv`, `output/idx_population_normalized.csv`)
- [ ] Filter berdasarkan kriteria inklusi → daftar sampel final (⏳ menunggu verifikasi data availability)
- [x] Sinkronisasi otomatis status availability -> hasil seleksi interim disiapkan ✅ (`scripts/sync_sample_from_collection.ps1`, `output/sample_selection_result_interim.csv`, `output/sample_selection_interim_summary.md`)
- [x] Hitung total observasi: jumlah perusahaan × jumlah tahun ✅ (6 skenario dianalisis; lihat `output/sample_analysis_comprehensive.md`)
- [x] Dokumentasikan proses seleksi sampel (tabel: populasi → kriteria → sampel final) ✅ (interim table: `output/sample_selection_flow_interim.md`; final angka akan diperbarui setelah verifikasi availability)
- [x] Template + script seleksi sampel disiapkan (`output/sample_selection_template.csv`, `scripts/estimate_sample.ps1`)
- [x] IDX population ingestion automation disiapkan (`scripts/ingest_idx_population.ps1`, template `output/idx_population_template.csv`)
- [x] Analisis komprehensif 6 skenario sampel selesai (`output/sample_analysis_comprehensive.md`)

### Step 3.2 — Download Data Laporan Keuangan
- [ ] Untuk setiap perusahaan sampel, download laporan keuangan tahunan 2019–2025
- [ ] Sumber: IDX (idx.co.id) → Listed Companies → Financial Statements & Annual Report
- [ ] Simpan di `data/raw/` dengan penamaan: `{TICKER}_{YEAR}_FS.pdf`
- [x] Buat spreadsheet master: 1 baris per perusahaan per tahun ✅ (`output/data_collection_master_interim.csv`, 189 firm-year rows)
- [ ] Ekstrak data berikut dari setiap laporan keuangan:
  - Total Assets, Total Liabilities, Total Equity
  - Current Assets, Current Liabilities
  - Net Income, Revenue
  - Intangible Assets
  - Shares Outstanding
  - (Dari catatan atas laporan keuangan jika perlu)
- [x] Monitoring availability FS/AR/Price otomatis disiapkan ✅ (`scripts/update_collection_availability.ps1`, `output/data_collection_master_status.csv`, `output/data_collection_availability_report.md`)
- [x] Download queue FS disiapkan ✅ (`output/download_queue_fs.csv`, `output/download_queue_summary.md`)
- [x] Batch harian koleksi data disiapkan ✅ (`output/daily_collection_batch.md`, `scripts/build_daily_collection_batch.ps1`)

### Step 3.3 — Download Data Harga Saham
- [ ] Download closing price akhir tahun (31 Desember atau hari bursa terakhir) untuk setiap sampel
- [ ] Sumber: Yahoo Finance, IDX, atau `scripts/price_fetch.ps1` (untuk saham AS)
- [ ] Download juga harga bulanan (untuk menghitung volatilitas)
- [ ] Simpan di `data/prices/`
- [x] Otomasi batch fetch harga untuk kandidat sampel disiapkan (`scripts/fetch_all_prices.ps1`)
- [x] Skrip validasi koneksi Yahoo disiapkan (`scripts/test_yahoo.ps1`)
- [x] Download queue harga disiapkan ✅ (`output/download_queue_price.csv`)

### Step 3.4 — Download & Analisis Annual Report (untuk AI Disclosure Index)
- [ ] Download annual report (bukan laporan keuangan) untuk setiap sampel 2019–2025
- [ ] Simpan di `data/annual_reports/` dengan penamaan: `{TICKER}_{YEAR}_AR.pdf`
- [ ] Lakukan content analysis sesuai Step 2.5
- [ ] Hasilkan skor AI Disclosure Index per perusahaan per tahun
- [ ] Simpan hasil di spreadsheet master
- [x] Download queue annual report disiapkan ✅ (`output/download_queue_ar.csv`)
- [x] Template content analysis penuh disiapkan ✅ (`output/ai_disclosure_manual_sheet_interim.csv`, `output/ai_disclosure_manual_sheet_note.md`)
- [x] Lembar coding manual AI disclosure untuk seluruh firm-year disiapkan ✅ (`output/ai_disclosure_manual_sheet_interim.csv`, `output/ai_disclosure_manual_sheet_note.md`)

### Step 3.5 — Hitung Semua Variabel
- [x] Dari data mentah, hitung semua variabel: ✅ (pipeline `scripts/build_panel_dataset.ps1`, status pilot dataset)
- [x] Automation tersedia untuk perhitungan variabel (`scripts/build_panel_dataset.ps1`)

  **Dependen:**
  - PRICE = Closing price akhir tahun
  - RET = (Price_t - Price_{t-1}) / Price_{t-1}
  - TQ = (Market Cap + Total Liabilities) / Total Assets
    - Market Cap = Price × Shares Outstanding

  **Independen:**
  - ROA = Net Income / Total Assets
  - ROE = Net Income / Total Equity
  - NPM = Net Income / Revenue
  - CR = Current Assets / Current Liabilities
  - DER = Total Liabilities / Total Equity
  - TATO = Revenue / Total Assets
  - EPS = Net Income / Shares Outstanding

  **Moderasi:**
  - AID = AI Disclosure Index (dari Step 3.4)
  - II = Intangible Assets / Total Assets
  - DGENAI = 1 jika tahun >= 2023, 0 sebaliknya

  **Kontrol:**
  - SIZE = Ln(Total Assets)
  - GROWTH = (Revenue_t - Revenue_{t-1}) / Revenue_{t-1}
  - AGE = Tahun observasi - Tahun listing
  - VOL = Std dev of monthly returns dalam tahun tersebut

- [x] Masukkan semua ke dataset panel (1 file CSV/Excel) ✅ (pilot dataset pipeline)
- [x] Template input disiapkan (`output/financial_master_template.csv`, `output/price_master_template.csv`, `output/ai_disclosure_index_template.csv`)
- [x] Simpan di `data/processed/panel_dataset.csv` ✅ (generated from template input for pipeline validation)

### Step 3.6 — Cleaning & Validasi Data
- [x] Cek missing values → tentukan treatment (exclude / interpolate / 0) ✅ (`output/data_validation_interim.md`, status pilot)
- [x] Cek outlier (> 3 std dev dari mean) → winsorize pada 1%/99% ✅ (screening interim: `output/data_validation_interim.md`)
- [x] Cek konsistensi: total aset = total liabilitas + ekuitas ✅ (dicek di laporan interim; final check menunggu kelengkapan data finansial)
- [x] Cek variabel negatif yang tidak seharusnya negatif (misal CR < 0) ✅ (`output/data_validation_interim.md`)
- [ ] Cross-check 10% sampel secara manual dengan laporan keuangan asli
- [x] Logging cleaning decision otomatis tersedia (`output/data_cleaning_log.md` dari `scripts/build_panel_dataset.ps1`)
- [x] Dokumentasikan semua data cleaning decisions ✅ (`output/data_cleaning_log.md`, `output/data_validation_interim.md`)
- [x] Template cross-check 10% untuk verifikasi manual disiapkan ✅ (`output/manual_crosscheck_10pct.csv`, `output/data_collection_manifest_interim.md`)

---

## FASE 4: ANALISIS DATA & PENGUJIAN HIPOTESIS

### Step 4.1 — Statistik Deskriptif
- [x] Hitung mean, median, std dev, min, max untuk semua variabel (`scripts/descriptive_stats.ps1`)
- [x] Buat tabel statistik deskriptif (format jurnal) -> `output/descriptive_stats.md`
- [x] Interpretasi: apakah ada variabel dengan distribusi ekstrem? ✅ (preliminary note: `output/preliminary_analysis_note.md`)
- [x] Buat correlation matrix (Pearson) antar semua variabel -> `output/correlation_matrix.csv`
- [x] Cek korelasi tinggi antar independen (> 0.8) → pertimbangkan drop atau PCA ✅ (preliminary screening completed; final decision after full dataset)

### Step 4.2 — Uji Asumsi Klasik
- [x] **Multikolinearitas**: otomasi VIF tersedia (`scripts/assumption_tests.ps1` -> `output/vif_table.csv`)
  - Jika VIF > 10: drop variabel atau gunakan PCA
  - Catatan: ROA, ROE, NPM kemungkinan berkorelasi tinggi
- [x] **Heteroskedastisitas**: otomasi Breusch-Pagan LM tersedia (`output/assumption_tests.md`)
  - Jika signifikan: gunakan robust standard errors (White/HAC)
- [x] **Autokorelasi**: otomasi proxy Durbin-Watson (within-firm) tersedia (`output/assumption_tests.md`)
  - Jika signifikan: gunakan clustered standard errors
- [x] **Cross-sectional dependence**: Pesaran CD test (jika N besar) ✅ (preliminary pilot check in `output/cross_sectional_dependence.md`)
- [x] Dokumentasikan semua hasil uji dan keputusan yang diambil (`output/assumption_tests.md`)

### Step 4.3 — Pemilihan Model Panel
- [x] Estimasi Pooled OLS, Fixed Effect, Random Effect untuk model baseline (otomasi tersedia: `scripts/panel_model_selection.ps1`)
- [x] **Chow test**: Pooled OLS vs Fixed Effect (H0: pooled lebih baik) -> auto-attempt di script + fallback manual EViews
- [x] **Hausman test**: Fixed Effect vs Random Effect (H0: RE konsisten) -> auto-attempt di script + fallback manual EViews
- [x] Dokumentasi readiness model final tersedia (`output/model_readiness_report.md`) ✅
- [ ] Pilih model terbaik berdasarkan hasil uji
- [ ] Jika FE terpilih: gunakan entity-fixed effects (firm dummies)
- [ ] Pertimbangkan time-fixed effects juga (year dummies)
- [x] Template keputusan pemilihan model disiapkan ✅ (`output/model_selection_decision_template.md`)

### Step 4.4 — Estimasi Model Utama (9 Regresi)

**Blok A — Model Baseline (3 regresi):**
- [x] Model 1a: PRICE_it = f(ROA, ROE, NPM, CR, DER, TATO, EPS, Controls) + mu_i + e_it (otomasi: `scripts/eviews_run.ps1`)
- [x] Model 1b: RET_it = f(ROA, ROE, NPM, CR, DER, TATO, EPS, Controls) + mu_i + e_it (otomasi: `scripts/eviews_run.ps1`)
- [x] Model 1c: TQ_it = f(ROA, ROE, NPM, CR, DER, TATO, EPS, Controls) + mu_i + e_it (otomasi: `scripts/eviews_run.ps1`)
- [ ] Catat: koefisien, t-stat/z-stat, p-value, R², adjusted R², F-stat
- [ ] Interpretasi: rasio mana yang signifikan untuk masing-masing dependen?
- [x] Template pelaporan 9 regresi disiapkan ✅ (`output/regression_reporting_template.csv`)

**Blok B — Model Moderasi AI Disclosure (3 regresi):**
- [x] Model 2a: PRICE_it = f(X, AID, XxAID, Controls) + mu_i + e_it (otomasi tersedia)
- [x] Model 2b: RET_it = f(X, AID, XxAID, Controls) + mu_i + e_it (otomasi tersedia)
- [x] Model 2c: TQ_it = f(X, AID, XxAID, Controls) + mu_i + e_it (otomasi tersedia)
- [ ] Fokus interpretasi: koefisien interaksi (X×AID) — apakah signifikan dan arahnya?
- [ ] Catatan: mungkin perlu memilih 2–3 rasio utama saja untuk interaksi (hindari overfitting)
- [x] Template interpretasi interaksi dan catatan overfitting disiapkan ✅ (`output/interaction_interpretation_template.md`)

**Blok C — Model Structural Break GenAI (3 regresi):**
- [x] Model 3a: PRICE_it = f(X, DGENAI, XxDGENAI, Controls) + mu_i + e_it (otomasi tersedia)
- [x] Model 3b: RET_it = f(X, DGENAI, XxDGENAI, Controls) + mu_i + e_it (otomasi tersedia)
- [x] Model 3c: TQ_it = f(X, DGENAI, XxDGENAI, Controls) + mu_i + e_it (otomasi tersedia)
- [ ] Fokus interpretasi: koefisien interaksi (X×DGENAI) — apakah relevansi rasio berubah post-2023?

### Step 4.5 — Robustness Checks
- [ ] **System GMM**: Estimasi ulang model baseline dengan Arellano-Bond GMM
  - Cek AR(1) signifikan, AR(2) tidak signifikan
  - Cek Hansen/Sargan test for overidentification
- [x] Catatan persiapan System GMM disiapkan ✅ (`output/system_gmm_preparation_note.md`)
- [x] **Subsample**: Estimasi model terpisah untuk 2019-2022 dan 2023-2025 (pipeline dataset tersedia: `scripts/robustness_checks.ps1`)
  - Bandingkan koefisien dan signifikansi
- [x] **Winsorizing**: dataset winsor 1/99 dan 5/95 disiapkan (`output/robustness/*winsor*.csv`)
  - Bandingkan apakah hasil konsisten
- [x] **Alternatif proksi**: dataset alternatif PBV disiapkan (`output/robustness/panel_alt_proxy_pbv.csv`)
- [x] **Exclude COVID**: dataset tanpa tahun 2020 disiapkan (`output/robustness/panel_exclude_2020.csv`)
- [x] Dokumentasikan semua robustness results dalam tabel terpisah (`output/robustness_checks.md`)

### Step 4.6 — Uji Hipotesis & Keputusan
- [x] Untuk setiap hipotesis, tentukan: diterima / ditolak (otomasi: `scripts/hypothesis_decision.ps1`)
- [x] Gunakan significance level: alpha = 0.05 (script support; bisa rerun untuk 0.01/0.10)
- [x] Buat tabel ringkasan hipotesis (`output/hypothesis_results.csv`, `output/hypothesis_decision.md`)
- [x] Rerun status hipotesis setelah uji EViews terbaru ✅ (masih `Pending` karena output persamaan belum terbentuk pada dataset pilot; lihat `output/model_readiness_report.md`)
  | Hipotesis | Variabel | Dependen | Koefisien | Signifikansi | Keputusan |
  |-----------|----------|----------|-----------|--------------|-----------|
  | H1a | ROA | PRICE | ... | ... | Diterima/Ditolak |
  | ... | ... | ... | ... | ... | ... |

---

## FASE 5: PENULISAN TESIS

### Step 5.1 — BAB I: Pendahuluan
- [x] Draft BAB I selesai (versi awal) di `draft/thesis_draft.md`
- [x] Latar belakang masalah: ✅ (versi elaborasi diperbarui di `draft/thesis_draft.md`)
  - Perkembangan sektor teknologi di Indonesia
  - Pentingnya analisis fundamental bagi investor
  - Fenomena AI/GenAI dan dampaknya terhadap pasar modal
  - Inkonsistensi hasil penelitian terdahulu (cite tesis pembanding)
  - Gap research (lihat `analysis_output.md` bagian 4)
- [x] Rumusan masalah (4 pertanyaan) ✅
- [x] Tujuan penelitian ✅
- [x] Manfaat penelitian (teoretis + praktis) ✅
- [x] Sistematika penulisan ✅

- [x] Draft BAB II selesai (versi awal) di `draft/thesis_draft.md`
### Step 5.2 — BAB II: Tinjauan Pustaka
- [x] Landasan teori (Signaling Theory, EMH, RBV) ✅ (elaborasi diperbarui; rujukan `output/kerangka_teori.md`)
- [x] Tinjauan literatur: ✅ (diringkas dan dirujuk ke matriks literatur)
  - Analisis fundamental & harga/return/nilai perusahaan
  - AI disclosure & firm performance
  - Structural break dalam keuangan
  - Sektor teknologi & valuasi
- [x] Penelitian terdahulu (tabel perbandingan minimal 10 penelitian) ✅ (rujukan `output/literatur_tesis.md` & `output/literatur_jurnal.md`)
- [x] Kerangka pemikiran (diagram) ✅ (rujukan `output/kerangka_teori.md`)
- [x] Hipotesis penelitian ✅ (rujukan `output/hipotesis.md`)

- [x] Draft BAB III selesai (versi awal) di `draft/thesis_draft.md`
### Step 5.3 — BAB III: Metodologi Penelitian
- [x] Jenis & pendekatan penelitian ✅
- [x] Populasi & sampel (kriteria, proses seleksi, jumlah final) ✅ (status final sampel menunggu verifikasi availability)
- [x] Definisi operasional variabel (tabel lengkap) ✅ (rujukan `output/metodologi_penelitian.md`)
- [x] Metode pengumpulan data ✅
- [x] Metode analisis data (deskriptif, uji asumsi, panel regression, robustness) ✅
- [x] Konstruksi AI Disclosure Index (prosedur detail) ✅

- [x] Draft BAB IV selesai (versi awal) di `draft/thesis_draft.md`
### Step 5.4 — BAB IV: Hasil & Pembahasan
- [x] Deskripsi objek penelitian (profil sektor teknologi BEI) ✅ (versi draft berbasis output populasi/sampel)
- [x] Statistik deskriptif (tabel + interpretasi) ✅ (versi preliminary)
- [x] Hasil uji asumsi klasik ✅ (versi preliminary)
- [ ] Hasil pemilihan model panel
- [ ] Hasil estimasi model (9 regresi utama):
  - Model Baseline (Tabel + interpretasi)
  - Model Moderasi AID (Tabel + interpretasi)
  - Model Structural Break (Tabel + interpretasi)
- [x] Hasil robustness checks (tabel ringkasan) ✅ (rujukan output robustness tersedia)
- [x] Pembahasan: ✅ (versi sementara; pembahasan inferensial final menunggu dataset final)
  - Hubungkan temuan dengan teori
  - Bandingkan dengan penelitian terdahulu
  - Jelaskan mengapa hasil konsisten/berbeda
  - Implikasi dari moderasi AI dan structural break
- [x] Draft BAB V selesai (versi awal) di `draft/thesis_draft.md`

### Step 5.5 — BAB V: Kesimpulan & Saran
- [x] Kesimpulan (jawab setiap rumusan masalah) ✅ (versi interim; final setelah estimasi final)
- [x] Implikasi: ✅ (teoretis & praktis versi interim)
  - Teoretis (kontribusi terhadap literatur)
  - Praktis (untuk investor, manajemen, regulator)
- [x] Keterbatasan penelitian ✅
- [x] Saran untuk penelitian selanjutnya ✅
- [x] Export dokumen draft ke DOCX dan PDF selesai (`draft/thesis_draft.docx`, `draft/thesis_draft.pdf`)
- [x] Revisi draft mengikuti template kampus utama (`Skripsi_31998_DZAKI.docx`)

### Step 5.6 — Kelengkapan
- [x] Daftar pustaka (draft) disiapkan (`draft/daftar_pustaka_draft.md`)
- [x] Lampiran (draft) disiapkan (`draft/lampiran_draft.md`)
  - Daftar sampel perusahaan
  - Data mentah (ringkasan)
  - Output statistik (Stata/EViews/R)
  - Prosedur AI Disclosure Index + daftar kata kunci
  - Hasil robustness checks lengkap

---

## FASE 6: FINALISASI & UJIAN

### Step 6.1 — Review Internal
- [x] Proofread awal draft dilakukan (lihat `output/review_internal_checklist.md`)
- [x] Cek konsistensi angka antara tabel dan narasi (checklist awal dibuat)
- [x] Cek semua referensi tercantum di daftar pustaka (checklist awal dibuat)
- [x] Cek format sesuai panduan tesis kampus (template-based draft sudah diselaraskan)
- [x] Dashboard progres rencana disiapkan ✅ (`output/plan_progress_dashboard.md`)
- [x] Queue aksi pending terstruktur disiapkan ✅ (`output/pending_actions.csv`, `output/pending_actions_summary.md`)
- [x] Sprint prioritas aksi berikutnya disiapkan ✅ (`output/next_actions_sprint.md`)
- [x] One-command refresh operasional disiapkan ✅ (`scripts/refresh_operational_dashboard.ps1`, `output/operational_refresh_summary.md`)
- [x] Laporan blocker kritis disiapkan ✅ (`output/critical_blockers_report.md`, `scripts/build_blocker_report.ps1`)
- [x] Snapshot histori progres + standup harian disiapkan ✅ (`output/progress_history.csv`, `output/daily_standup.md`)

### Step 6.2 — Konsultasi Pembimbing
- [ ] Submit draft ke pembimbing 1
- [ ] Revisi berdasarkan masukan
- [ ] Submit draft ke pembimbing 2 (jika ada)
- [ ] Revisi final
- [x] Paket konsultasi pembimbing disiapkan (`output/supervisor_submission_checklist.md`, `draft/consultation_revision_log.md`)
- [x] Tracker eksekusi konsultasi disiapkan ✅ (`output/supervisor_consultation_tracker.md`)
- [x] Template email pengiriman draft ke pembimbing disiapkan ✅ (`output/supervisor_submission_email_template.md`)

### Step 6.3 — Persiapan Ujian
- [x] Siapkan presentasi (PPT/slides) -> `draft/defense_slides.pptx`
- [x] Siapkan ringkasan 1 halaman untuk penguji (`draft/one_page_summary_penguji.docx`, `.pdf`)
- [ ] Latihan presentasi (15–20 menit)
- [x] Runbook latihan presentasi disiapkan (`output/presentation_rehearsal_plan.md`, `draft/defense_speaker_notes.md`)
- [x] Log template latihan presentasi disiapkan ✅ (`output/presentation_rehearsal_log_template.md`)
- [x] Draft ringkasan 1 halaman penguji disiapkan (`draft/one_page_summary_penguji.md`, `.docx`, `.pdf`)
- [x] Outline slide ujian disiapkan (`draft/slides_outline.md`)
- [x] Antisipasi pertanyaan disiapkan (`draft/faq_sidang.md`)
- [x] Otomasi build Canva-ready disiapkan (`scripts/canva_ready.ps1`, `output/canva_ready_manifest.md`)
  - Mengapa sektor teknologi?
  - Bagaimana mengukur AI disclosure?
  - Mengapa 2023 sebagai cutoff GenAI?
  - Bagaimana mengatasi sampel kecil?
  - Apa bedanya dengan tesis UNDIKSHA/ITB/UNISSULA?

### Step 6.4 — Pasca-Ujian
- [ ] Revisi berdasarkan masukan penguji
- [ ] Finalisasi tesis
- [ ] Upload ke repositori kampus
- [ ] (Opsional) Publikasi ke jurnal nasional terakreditasi
- [x] Tracker revisi pasca-ujian disiapkan ✅ (`output/post_defense_revision_tracker.md`)
- [x] Matriks respons revisi penguji disiapkan ✅ (`output/defense_revision_response_matrix.md`)
- [x] Checklist upload repositori kampus disiapkan ✅ (`output/campus_repository_upload_checklist.md`)

---

## FASE 7: TOOLS & DATA PIPELINE (Opsional — Pembanding AS)

### Step 7.1 — SEC Data Pipeline (sudah tersedia di project)
- [x] Gunakan `scripts/sec_tickers.ps1` untuk download peta ticker SEC ✅ (`data/sec_cache/company_tickers.json`)
- [x] Gunakan `scripts/sec_fetch.ps1` untuk fetch data keuangan perusahaan teknologi AS ✅ (cache rasio/facts tersedia di `data/sec_cache/*_ratios.csv`)
- [x] Target perusahaan: AAPL, MSFT, GOOGL, META, NVDA, AMZN, TSLA, CRM, ADBE, ORCL ✅
- [x] Hitung rasio yang sama (ROA, ROE, NPM, CR, DER, TATO, EPS, PBV) ✅ (tersedia parsial sesuai coverage SEC tags; agregasi `output/us_sec_ratios_2019_2025.csv`)
- [ ] Gunakan `scripts/price_fetch.ps1` untuk data harga saham AS (⏳ belum bisa dijalankan pada environment ini karena koneksi Yahoo belum tersedia)

### Step 7.2 — Analisis Komparatif
- [x] Bandingkan statistik deskriptif rasio Indonesia vs AS ✅ (`output/us_id_descriptive_comparison.md`)
- [ ] Bandingkan signifikansi rasio fundamental di kedua pasar (⏳ menunggu dataset final Indonesia + estimasi model final komparatif)
- [x] Diskusikan perbedaan konteks (market maturity, regulasi, adopsi AI) ✅ (`output/us_id_context_discussion.md`)
- [x] Catatan: ini sebagai supplementary analysis, bukan bagian utama tesis ✅ (`output/supplementary_analysis_scope_note.md`)

---

## TIMELINE ESTIMASI

| Fase | Durasi Estimasi | Milestone |
|------|-----------------|-----------|
| Fase 0: Persiapan | 2–3 minggu | Judul disetujui, proposal submitted |
| Fase 1: Tinjauan Pustaka | 4–6 minggu | BAB II draft selesai |
| Fase 2: Metodologi | 2–3 minggu | BAB III draft selesai |
| Fase 3: Pengumpulan Data | 4–6 minggu | Dataset panel lengkap |
| Fase 4: Analisis Data | 3–4 minggu | BAB IV draft selesai |
| Fase 5: Penulisan | 4–6 minggu | Draft lengkap |
| Fase 6: Finalisasi | 4–6 minggu | Tesis final + ujian |
| **Total** | **~6–9 bulan** | |

---

## REFERENSI KUNCI (dari Transcript + Verifikasi)

### Tesis Pembanding (Terverifikasi)
1. UNDIKSHA (2025) — repo.undiksha.ac.id/23085/
2. ITB (2024) — digilib.itb.ac.id/gdl/view/79966
3. UNISSULA (2025) — repository.unissula.ac.id/43161/

### Regulasi & Standar
- POJK 51/2017 (Pelaporan Berkelanjutan) — peraturan.bpk.go.id
- UU HPP (Tarif PPh Badan 22%) — pajak.go.id
- IFRS S1 (efektif 1 Jan 2024) — ifrs.org
- Metodologi IDX ESG Leadership Index — idx.id

### Sumber Data
- Laporan Keuangan & Annual Report BEI — idx.co.id
- SEC EDGAR (pembanding AS) — data.sec.gov
- Yahoo Finance (harga saham)

### Literatur Pendukung (dari Transcript)
- GenAI & pasar/sentimen (2024–2025) — ScienceDirect, Springer
- Tata kelola AI di Indonesia — PWC Digital Trust Newsflash

---

## FILE PROJECT TERKAIT

| File | Deskripsi |
|------|-----------|
| `chat_transcript.md` | Transkrip percakapan ChatGPT (input awal) |
| `analysis_output.md` | Analisis lengkap: tesis, gap, saran, metodologi |
| `Plan.md` | Dokumen ini — rencana langkah-demi-langkah |
| `scripts/sec_fetch.ps1` | Script fetch data SEC EDGAR |
| `scripts/sec_tickers.ps1` | Script download peta ticker SEC |
| `scripts/price_fetch.ps1` | Script fetch harga saham Yahoo Finance |
| `README.md` | Dokumentasi project |
