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
- [ ] **Hitung estimasi sampel**: Periksa IDX-IC Technology sector → list semua perusahaan → filter kriteria
- [ ] **Catatan penting**: Sektor teknologi BEI relatif baru (banyak IPO post-2019). Pertimbangkan:
- [x] Automation siap: `scripts/estimate_sample.ps1` + template `output/sample_selection_template.csv` + summary `output/sample_estimation.md`
  - Relaksasi kriteria (misal listing sebelum 2020)
  - Unbalanced panel (izinkan entry/exit)
  - Atau perluas ke sektor terkait (Technology + Telecommunication)

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
- [x] **Langkah 6**: Dokumentasikan prosedur lengkap untuk lampiran tesis (`output/metodologi_penelitian.md`)

### Step 2.6 — Metode Analisis Data
- [ ] **Statistik deskriptif**: Mean, median, std dev, min, max untuk semua variabel
- [ ] **Uji asumsi klasik**:
  - Multikolinearitas: VIF < 10 (atau < 5 untuk konservatif)
  - Heteroskedastisitas: Breusch-Pagan / White test
  - Autokorelasi: Wooldridge test untuk panel data
  - Normalitas: Jarque-Bera (opsional untuk panel besar)
- [ ] **Pemilihan model panel**:
  - Pooled OLS vs Fixed Effect: Chow test / F-test
  - Fixed Effect vs Random Effect: Hausman test
  - Jika heteroskedastisitas: gunakan robust standard errors (HAC)
- [x] **Model regresi** (3 model utama) (otomasi tersedia di `scripts/eviews_run.ps1`):
  - Model 1 (Baseline): Y_it = α + βX_it + γControls_it + μ_i + ε_it
  - Model 2 (Moderasi AID): Y_it = α + βX_it + θAID_it + λ(X_it × AID_it) + γControls_it + μ_i + ε_it
  - Model 3 (Structural Break): Y_it = α + βX_it + δD_GenAI + φ(X_it × D_GenAI) + γControls_it + μ_i + ε_it
  - Masing-masing diestimasi 3x (Y = PRICE, RET, TQ) → total 9 regresi utama
- [ ] **Robustness checks**:
  - System GMM (menangani endogeneity)
  - Subsample: 2019–2022 vs 2023–2025
  - Winsorizing 1%/99%
  - Alternatif proksi: PBV sebagai pengganti Tobin's Q
  - Exclude 2020 (COVID effect) sebagai sensitivity

---

## FASE 3: PENGUMPULAN & PENGOLAHAN DATA

### Step 3.1 — Identifikasi Populasi & Sampel
- [ ] Akses IDX → daftar perusahaan sektor Teknologi (IDX-IC)
- [ ] Catat semua perusahaan: ticker, nama, tanggal listing, status (aktif/delisted)
- [ ] Filter berdasarkan kriteria inklusi → daftar sampel final
- [ ] Hitung total observasi: jumlah perusahaan × jumlah tahun
- [ ] Dokumentasikan proses seleksi sampel (tabel: populasi → kriteria → sampel final)
- [x] Template + script seleksi sampel disiapkan (`output/sample_selection_template.csv`, `scripts/estimate_sample.ps1`)

### Step 3.2 — Download Data Laporan Keuangan
- [ ] Untuk setiap perusahaan sampel, download laporan keuangan tahunan 2019–2025
- [ ] Sumber: IDX (idx.co.id) → Listed Companies → Financial Statements & Annual Report
- [ ] Simpan di `data/raw/` dengan penamaan: `{TICKER}_{YEAR}_FS.pdf`
- [ ] Buat spreadsheet master: 1 baris per perusahaan per tahun
- [ ] Ekstrak data berikut dari setiap laporan keuangan:
  - Total Assets, Total Liabilities, Total Equity
  - Current Assets, Current Liabilities
  - Net Income, Revenue
  - Intangible Assets
  - Shares Outstanding
  - (Dari catatan atas laporan keuangan jika perlu)

### Step 3.3 — Download Data Harga Saham
- [ ] Download closing price akhir tahun (31 Desember atau hari bursa terakhir) untuk setiap sampel
- [ ] Sumber: Yahoo Finance, IDX, atau `scripts/price_fetch.ps1` (untuk saham AS)
- [ ] Download juga harga bulanan (untuk menghitung volatilitas)
- [ ] Simpan di `data/prices/`

### Step 3.4 — Download & Analisis Annual Report (untuk AI Disclosure Index)
- [ ] Download annual report (bukan laporan keuangan) untuk setiap sampel 2019–2025
- [ ] Simpan di `data/annual_reports/` dengan penamaan: `{TICKER}_{YEAR}_AR.pdf`
- [ ] Lakukan content analysis sesuai Step 2.5
- [ ] Hasilkan skor AI Disclosure Index per perusahaan per tahun
- [ ] Simpan hasil di spreadsheet master

### Step 3.5 — Hitung Semua Variabel
- [ ] Dari data mentah, hitung semua variabel:
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

- [ ] Masukkan semua ke dataset panel (1 file CSV/Excel)
- [x] Template input disiapkan (`output/financial_master_template.csv`, `output/price_master_template.csv`, `output/ai_disclosure_index_template.csv`)
- [ ] Simpan di `data/processed/panel_dataset.csv`

### Step 3.6 — Cleaning & Validasi Data
- [ ] Cek missing values → tentukan treatment (exclude / interpolate / 0)
- [ ] Cek outlier (> 3 std dev dari mean) → winsorize pada 1%/99%
- [ ] Cek konsistensi: total aset = total liabilitas + ekuitas
- [ ] Cek variabel negatif yang tidak seharusnya negatif (misal CR < 0)
- [ ] Cross-check 10% sampel secara manual dengan laporan keuangan asli
- [x] Logging cleaning decision otomatis tersedia (`output/data_cleaning_log.md` dari `scripts/build_panel_dataset.ps1`)
- [ ] Dokumentasikan semua data cleaning decisions

---

## FASE 4: ANALISIS DATA & PENGUJIAN HIPOTESIS

### Step 4.1 — Statistik Deskriptif
- [ ] Hitung mean, median, std dev, min, max untuk semua variabel
- [ ] Buat tabel statistik deskriptif (format jurnal)
- [ ] Interpretasi: apakah ada variabel dengan distribusi ekstrem?
- [ ] Buat correlation matrix (Pearson) antar semua variabel
- [ ] Cek korelasi tinggi antar independen (> 0.8) → pertimbangkan drop atau PCA

### Step 4.2 — Uji Asumsi Klasik
- [ ] **Multikolinearitas**: Hitung VIF untuk semua model
  - Jika VIF > 10: drop variabel atau gunakan PCA
  - Catatan: ROA, ROE, NPM kemungkinan berkorelasi tinggi
- [ ] **Heteroskedastisitas**: Breusch-Pagan test / White test
  - Jika signifikan: gunakan robust standard errors (White/HAC)
- [ ] **Autokorelasi**: Wooldridge test for serial correlation in panel data
  - Jika signifikan: gunakan clustered standard errors
- [ ] **Cross-sectional dependence**: Pesaran CD test (jika N besar)
- [ ] Dokumentasikan semua hasil uji dan keputusan yang diambil

### Step 4.3 — Pemilihan Model Panel
- [ ] Estimasi Pooled OLS, Fixed Effect, Random Effect untuk model baseline
- [ ] **Chow test**: Pooled OLS vs Fixed Effect (H0: pooled lebih baik)
- [ ] **Hausman test**: Fixed Effect vs Random Effect (H0: RE konsisten)
- [ ] Pilih model terbaik berdasarkan hasil uji
- [ ] Jika FE terpilih: gunakan entity-fixed effects (firm dummies)
- [ ] Pertimbangkan time-fixed effects juga (year dummies)

### Step 4.4 — Estimasi Model Utama (9 Regresi)

**Blok A — Model Baseline (3 regresi):**
- [ ] Model 1a: PRICE_it = f(ROA, ROE, NPM, CR, DER, TATO, EPS, Controls) + μ_i + ε_it
- [ ] Model 1b: RET_it = f(ROA, ROE, NPM, CR, DER, TATO, EPS, Controls) + μ_i + ε_it
- [ ] Model 1c: TQ_it = f(ROA, ROE, NPM, CR, DER, TATO, EPS, Controls) + μ_i + ε_it
- [ ] Catat: koefisien, t-stat/z-stat, p-value, R², adjusted R², F-stat
- [ ] Interpretasi: rasio mana yang signifikan untuk masing-masing dependen?

**Blok B — Model Moderasi AI Disclosure (3 regresi):**
- [ ] Model 2a: PRICE_it = f(X, AID, X×AID, Controls) + μ_i + ε_it
- [ ] Model 2b: RET_it = f(X, AID, X×AID, Controls) + μ_i + ε_it
- [ ] Model 2c: TQ_it = f(X, AID, X×AID, Controls) + μ_i + ε_it
- [ ] Fokus interpretasi: koefisien interaksi (X×AID) — apakah signifikan dan arahnya?
- [ ] Catatan: mungkin perlu memilih 2–3 rasio utama saja untuk interaksi (hindari overfitting)

**Blok C — Model Structural Break GenAI (3 regresi):**
- [ ] Model 3a: PRICE_it = f(X, DGENAI, X×DGENAI, Controls) + μ_i + ε_it
- [ ] Model 3b: RET_it = f(X, DGENAI, X×DGENAI, Controls) + μ_i + ε_it
- [ ] Model 3c: TQ_it = f(X, DGENAI, X×DGENAI, Controls) + μ_i + ε_it
- [ ] Fokus interpretasi: koefisien interaksi (X×DGENAI) — apakah relevansi rasio berubah post-2023?

### Step 4.5 — Robustness Checks
- [ ] **System GMM**: Estimasi ulang model baseline dengan Arellano-Bond GMM
  - Cek AR(1) signifikan, AR(2) tidak signifikan
  - Cek Hansen/Sargan test for overidentification
- [ ] **Subsample**: Estimasi model terpisah untuk 2019–2022 dan 2023–2025
  - Bandingkan koefisien dan signifikansi
- [ ] **Winsorizing**: Estimasi ulang setelah winsorize 1%/99% dan 5%/95%
  - Bandingkan apakah hasil konsisten
- [ ] **Alternatif proksi**: Ganti Tobin's Q dengan PBV, estimasi ulang
- [ ] **Exclude COVID**: Drop tahun 2020, estimasi ulang
- [ ] Dokumentasikan semua robustness results dalam tabel terpisah

### Step 4.6 — Uji Hipotesis & Keputusan
- [ ] Untuk setiap hipotesis, tentukan: diterima / ditolak
- [ ] Gunakan significance level: α = 0.05 (dan catat juga 0.01, 0.10)
- [ ] Buat tabel ringkasan hipotesis:
  | Hipotesis | Variabel | Dependen | Koefisien | Signifikansi | Keputusan |
  |-----------|----------|----------|-----------|--------------|-----------|
  | H1a | ROA | PRICE | ... | ... | Diterima/Ditolak |
  | ... | ... | ... | ... | ... | ... |

---

## FASE 5: PENULISAN TESIS

### Step 5.1 — BAB I: Pendahuluan
- [ ] Latar belakang masalah:
  - Perkembangan sektor teknologi di Indonesia
  - Pentingnya analisis fundamental bagi investor
  - Fenomena AI/GenAI dan dampaknya terhadap pasar modal
  - Inkonsistensi hasil penelitian terdahulu (cite tesis pembanding)
  - Gap research (lihat `analysis_output.md` bagian 4)
- [ ] Rumusan masalah (4 pertanyaan)
- [ ] Tujuan penelitian
- [ ] Manfaat penelitian (teoretis + praktis)
- [ ] Sistematika penulisan

### Step 5.2 — BAB II: Tinjauan Pustaka
- [ ] Landasan teori (Signaling Theory, EMH, RBV)
- [ ] Tinjauan literatur:
  - Analisis fundamental & harga/return/nilai perusahaan
  - AI disclosure & firm performance
  - Structural break dalam keuangan
  - Sektor teknologi & valuasi
- [ ] Penelitian terdahulu (tabel perbandingan minimal 10 penelitian)
- [ ] Kerangka pemikiran (diagram)
- [ ] Hipotesis penelitian

### Step 5.3 — BAB III: Metodologi Penelitian
- [ ] Jenis & pendekatan penelitian
- [ ] Populasi & sampel (kriteria, proses seleksi, jumlah final)
- [ ] Definisi operasional variabel (tabel lengkap)
- [ ] Metode pengumpulan data
- [ ] Metode analisis data (deskriptif, uji asumsi, panel regression, robustness)
- [ ] Konstruksi AI Disclosure Index (prosedur detail)

### Step 5.4 — BAB IV: Hasil & Pembahasan
- [ ] Deskripsi objek penelitian (profil sektor teknologi BEI)
- [ ] Statistik deskriptif (tabel + interpretasi)
- [ ] Hasil uji asumsi klasik
- [ ] Hasil pemilihan model panel
- [ ] Hasil estimasi model (9 regresi utama):
  - Model Baseline (Tabel + interpretasi)
  - Model Moderasi AID (Tabel + interpretasi)
  - Model Structural Break (Tabel + interpretasi)
- [ ] Hasil robustness checks (tabel ringkasan)
- [ ] Pembahasan:
  - Hubungkan temuan dengan teori
  - Bandingkan dengan penelitian terdahulu
  - Jelaskan mengapa hasil konsisten/berbeda
  - Implikasi dari moderasi AI dan structural break

### Step 5.5 — BAB V: Kesimpulan & Saran
- [ ] Kesimpulan (jawab setiap rumusan masalah)
- [ ] Implikasi:
  - Teoretis (kontribusi terhadap literatur)
  - Praktis (untuk investor, manajemen, regulator)
- [ ] Keterbatasan penelitian
- [ ] Saran untuk penelitian selanjutnya

### Step 5.6 — Kelengkapan
- [ ] Daftar pustaka (format APA 7th atau sesuai panduan kampus)
- [ ] Lampiran:
  - Daftar sampel perusahaan
  - Data mentah (ringkasan)
  - Output statistik (Stata/EViews/R)
  - Prosedur AI Disclosure Index + daftar kata kunci
  - Hasil robustness checks lengkap

---

## FASE 6: FINALISASI & UJIAN

### Step 6.1 — Review Internal
- [ ] Proofread seluruh draft
- [ ] Cek konsistensi angka antara tabel dan narasi
- [ ] Cek semua referensi tercantum di daftar pustaka
- [ ] Cek format sesuai panduan tesis kampus

### Step 6.2 — Konsultasi Pembimbing
- [ ] Submit draft ke pembimbing 1
- [ ] Revisi berdasarkan masukan
- [ ] Submit draft ke pembimbing 2 (jika ada)
- [ ] Revisi final

### Step 6.3 — Persiapan Ujian
- [ ] Siapkan presentasi (PPT/slides)
- [ ] Siapkan ringkasan 1 halaman untuk penguji
- [ ] Latihan presentasi (15–20 menit)
- [ ] Antisipasi pertanyaan:
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

---

## FASE 7: TOOLS & DATA PIPELINE (Opsional — Pembanding AS)

### Step 7.1 — SEC Data Pipeline (sudah tersedia di project)
- [ ] Gunakan `scripts/sec_tickers.ps1` untuk download peta ticker SEC
- [ ] Gunakan `scripts/sec_fetch.ps1` untuk fetch data keuangan perusahaan teknologi AS
- [ ] Target perusahaan: AAPL, MSFT, GOOGL, META, NVDA, AMZN, TSLA, CRM, ADBE, ORCL
- [ ] Hitung rasio yang sama (ROA, ROE, NPM, CR, DER, TATO, EPS, PBV)
- [ ] Gunakan `scripts/price_fetch.ps1` untuk data harga saham AS

### Step 7.2 — Analisis Komparatif
- [ ] Bandingkan statistik deskriptif rasio Indonesia vs AS
- [ ] Bandingkan signifikansi rasio fundamental di kedua pasar
- [ ] Diskusikan perbedaan konteks (market maturity, regulasi, adopsi AI)
- [ ] Catatan: ini sebagai supplementary analysis, bukan bagian utama tesis

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
