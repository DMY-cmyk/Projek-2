# Comprehensive Sample Estimation Analysis

**Date**: 2026-02-27
**Research Period**: 2019–2025 (7 years)
**Population Source**: IDX-IC Classification (Sector I: Technology + Sector J3: Telecommunication)

---

## 1. Population Summary

| Category | Count |
|----------|-------|
| Total population identified | 66 |
| Technology sector (IDX-IC I) | 44 |
| Telecommunication sector (IDX-IC J3) | 22 |
| Listed before 2019-01-01 (strict) | 26 (FREN excluded) |
| Listed before 2020-01-01 (relaxed) | 32 |
| Active status | 66 |

---

## 2. Scenario Analysis

### Scenario A: Technology Only, Strict Cutoff (before 2019-01-01) — BALANCED PANEL

**Qualifying companies (11):**

| No | Ticker | Company Name | Listing Date | Sub-sector |
|----|--------|-------------|-------------|------------|
| 1 | MTDL | Metrodata Electronics Tbk | 1990-04-09 | I221 Computer Hardware |
| 2 | LMAS | Limas Indonesia Makmur Tbk | 2001-12-28 | I121 IT Services |
| 3 | PTSN | Sat Nusapersada Tbk | 2007-11-08 | I211 Networking |
| 4 | SKYB | Northcliff Citranusa Indonesia Tbk | 2010-07-07 | I131 Software |
| 5 | MLPT | Multipolar Technology Tbk | 2013-07-08 | I121 IT Services |
| 6 | ATIC | Anabatic Technologies Tbk | 2015-07-08 | I121 IT Services |
| 7 | KIOS | Kioson Komersial Indonesia Tbk | 2017-10-05 | I111 Applications |
| 8 | MCAS | M Cash Integrasi Tbk | 2017-11-01 | I111 Applications |
| 9 | NFCX | NFC Indonesia Tbk | 2018-07-12 | I111 Applications |
| 10 | DIVA | Distribusi Voucher Nusantara Tbk | 2018-11-27 | I111 Applications |
| 11 | LUCK | Sentral Mitra Informatika Tbk | 2018-11-28 | I221 Computer Hardware |

- **Total observations**: 11 × 7 = **77**
- **Assessment**: ⚠️ Terlalu kecil untuk panel regression yang robust (rule of thumb: N×T > 100)

---

### Scenario B: Technology Only, Relaxed Cutoff (before 2020-01-01) — BALANCED PANEL

**Additional qualifying companies (+4 = 15 total):**

| No | Ticker | Company Name | Listing Date | Sub-sector |
|----|--------|-------------|-------------|------------|
| 12 | ENVY | Envy Technologies Indonesia Tbk | 2019-07-08 | I121 IT Services |
| 13 | HDIT | Hensel Davest Indonesia Tbk | 2019-07-12 | I111 Applications |
| 14 | DMMX | Digital Mediatama Maxima Tbk | 2019-10-21 | I121 IT Services |
| 15 | GLVA | Galva Technologies Tbk | 2019-12-23 | I231 Electronic Equipment |

- **Total observations**: 15 × 7 = **105** (catatan: 4 perusahaan listing mid-2019, data 2019 mungkin parsial)
- **Assessment**: ✅ Marginal — memenuhi minimum tetapi tight

---

### Scenario C: Technology + Telecom, Strict Cutoff (before 2019-01-01) — BALANCED PANEL ⭐ RECOMMENDED

**Additional telecom companies (+15 = 26 total):**

| No | Ticker | Company Name | Listing Date | Sub-sector |
|----|--------|-------------|-------------|------------|
| 12 | ISAT | Indosat Tbk | 1994-10-19 | J312 Integrated Telecom |
| 13 | TLKM | Telkom Indonesia (Persero) Tbk | 1995-11-14 | J312 Integrated Telecom |
| 14 | KBLV | First Media Tbk | 2000-02-25 | J311 Wired Telecom |
| 15 | CENT | Centratama Telekomunikasi Indonesia Tbk | 2001-11-01 | J321 Wireless Telecom |
| 16 | EXCL | XL Axiata Tbk | 2005-09-29 | J321 Wireless Telecom |
| 17 | BTEL | Bakrie Telecom Tbk | 2006-02-03 | J321 Wireless Telecom |
| 18 | TOWR | Sarana Menara Nusantara Tbk | 2010-03-08 | J321 Wireless Telecom |
| 19 | TBIG | Tower Bersama Infrastructure Tbk | 2010-10-26 | J321 Wireless Telecom |
| 20 | SUPR | Solusi Tunas Pratama Tbk | 2011-10-11 | J321 Wireless Telecom |
| 21 | IBST | Inti Bangun Sejahtera Tbk | 2012-08-31 | J321 Wireless Telecom |
| 22 | BALI | Bali Towerindo Sentra Tbk | 2014-03-13 | J321 Wireless Telecom |
| 23 | LINK | Link Net Tbk | 2014-06-02 | J311 Wired Telecom |
| 24 | OASA | Maharaksa Biru Energi Tbk | 2016-07-18 | J321 Wireless Telecom |
| 25 | LCKM | LCK Global Kedaton Tbk | 2018-01-16 | J321 Wireless Telecom |
| 26 | GHON | Gihon Telekomunikasi Indonesia Tbk | 2018-04-09 | J321 Wireless Telecom |

- **Total observations**: 26 × 7 = **182**
- **Assessment**: ✅ **Sangat memadai** — cukup untuk panel regression dengan moderasi dan interaksi
- **Justifikasi perluasan ke telecom**: Sektor teknologi dan telekomunikasi saling terkait erat dalam ekosistem digital; banyak studi serupa mengelompokkan keduanya (ICT sector)
- **Catatan eksklusi FREN**: Smartfren Telecom Tbk (FREN) dikeluarkan dari sampel karena: (1) saham efektif tidak aktif/suspended di bursa, (2) harga di level penny-stock (Rp 23), (3) dilusi saham ekstrem (477,9 miliar lembar), dan (4) data harga tidak tersedia di Yahoo Finance. Eksklusi ini menghasilkan panel 26 perusahaan yang lebih bersih dan tetap memadai secara statistik untuk panel regression dengan moderasi dan interaksi.

---

### Scenario D: Technology + Telecom, Relaxed Cutoff (before 2020-01-01) — BALANCED PANEL

**Additional companies (+5 = 31 total):**

Adding from tech: ENVY, HDIT, DMMX, GLVA
Adding from telecom: JAST (Jasnita Telekomindo, listing 2019-05-16)

- **Total observations**: 31 × 7 = **217**
- **Assessment**: ✅ Sangat memadai, namun data 2019 untuk 5 perusahaan bisa parsial

---

### Scenario E: Technology Only, Unbalanced Panel (all 44 companies)

| Listing Year | Companies | Years of Data | Observations |
|-------------|-----------|---------------|-------------|
| Before 2019 | 11 | 7 | 77 |
| 2019 | 4 | 7* | 28 |
| 2020 | 4 | 6 | 24 |
| 2021 | 7 | 5 | 35 |
| 2022 | 5 | 4 | 20 |
| 2023 | 10 | 3 | 30 |
| 2024 | 3 | 2 | 6 |
| **Total** | **44** | | **220** |

*\* Companies listing mid-2019 may have partial year data*

- **Assessment**: ✅ Jumlah observasi memadai, tetapi unbalanced panel memerlukan justifikasi metodologis tambahan

---

### Scenario F: Technology + Telecom, Unbalanced Panel (all 66 companies)

| Listing Year | Tech | Telecom | Total | Years | Observations |
|-------------|------|---------|-------|-------|-------------|
| Before 2019 | 11 | 15 | 26 | 7 | 182 |
| 2019 | 4 | 1 | 5 | 7 | 35 |
| 2020 | 4 | 0 | 4 | 6 | 24 |
| 2021 | 7 | 1 | 8 | 5 | 40 |
| 2022 | 5 | 2 | 7 | 4 | 28 |
| 2023 | 10 | 1 | 11 | 3 | 33 |
| 2024 | 3 | 1 | 4 | 2 | 8 |
| **Total** | **44** | **21** | **65** | | **350** |

- **Assessment**: ✅ Dataset terbesar, sangat memadai untuk semua analisis

---

## 3. Summary Comparison

| Scenario | Panel Type | N (firms) | T (years) | N×T (obs) | Feasibility |
|----------|-----------|-----------|-----------|-----------|-------------|
| A | Balanced | 11 | 7 | 77 | ⚠️ Terlalu kecil |
| B | Balanced | 15 | 7 | 105 | ✅ Marginal |
| C | Balanced | 26 | 7 | 182 | ✅ **Recommended** |
| D | Balanced | 31 | 7 | 217 | ✅ Sangat baik |
| E | Unbalanced | 44 | 2–7 | 220 | ✅ Baik (perlu justifikasi) |
| F | Unbalanced | 65 | 2–7 | 350 | ✅ Sangat baik |

---

## 4. Recommendation

### Primary Recommendation: Scenario C (Technology + Telecom, Strict Cutoff)

**Alasan:**
1. **Jumlah observasi memadai (182)** — cukup untuk 9 regresi utama dengan ~10 variabel independen
2. **Balanced panel** — lebih mudah diestimasi, tidak memerlukan justifikasi unbalanced panel
3. **Justifikasi akademis kuat** — sektor Technology dan Telecommunication sering dikelompokkan bersama sebagai sektor ICT (Information & Communication Technology) dalam literatur:
   - World Bank menggunakan klasifikasi ICT yang mencakup keduanya
   - Banyak studi empiris di pasar modal emerging menggabungkan tech + telecom
   - Perusahaan telecom Indonesia (TLKM, ISAT, EXCL) aktif dalam transformasi digital dan AI adoption
4. **Kriteria sampling yang jelas dan defensible** di sidang

### Alternative: Scenario D (Relaxed Cutoff to 2020)

Jika Scenario C masih dirasa kurang, relaksasi cutoff ke 2020-01-01 menambah 5 perusahaan (31 total, 217 observasi). Ini memerlukan catatan bahwa data FY2019 untuk 5 perusahaan tersebut mungkin tidak mencakup setahun penuh.

### Robustness Strategy

Gunakan subsample analysis sebagai robustness check:
- **Subsample 1**: Technology-only (11 perusahaan) — untuk memastikan hasil tidak didorong oleh telecom
- **Subsample 2**: Pre-GenAI (2019–2022) vs Post-GenAI (2023–2025)
- **Subsample 3**: Exclude 2020 (COVID effect)

---

## 5. Next Steps (Requires Human Action)

Setelah skenario dipilih, langkah selanjutnya yang memerlukan aksi manual:

1. [ ] **Verifikasi data availability**: Untuk setiap perusahaan sampel, verifikasi ketersediaan:
   - Laporan keuangan tahunan 2019–2025 di idx.co.id
   - Annual report 2019–2025 untuk AI Disclosure Index
   - Data harga saham (Yahoo Finance: {TICKER}.JK)
   - Pelaporan dalam mata uang Rupiah (IDR)

2. [ ] **Update `output/sample_selection_template.csv`**: Isi kolom `has_fs_2019_2025`, `has_ar_2019_2025`, `has_price_data`, `idr_reporting` dengan "1" atau "0"

3. [ ] **Re-run `scripts/estimate_sample.ps1`**: Untuk mendapatkan sampel final setelah data availability diverifikasi

4. [ ] **Dokumentasikan proses seleksi**: Buat tabel seleksi sampel untuk BAB III (Populasi → Kriteria → Sampel Final)

---

## 6. Notes on Data Concerns

### BTEL (Bakrie Telecom)
- Status: Suspended trading sejak 2019. **Pertimbangkan untuk diexclude** jika data tidak tersedia lengkap.

### OASA (Maharaksa Biru Energi)
- Berganti nama dan bisnis utama di 2022 (dari telecom ke energi). **Pertimbangkan untuk diexclude** atau dicatat sebagai catatan.

### CENT (Centratama Telekomunikasi)
- Perusahaan dengan kapitalisasi sangat kecil. Cek apakah laporan keuangan lengkap.

### SKYB (Northcliff Citranusa Indonesia)
- Dulu bernama First Asia Consultants, sempat berubah bisnis. Verifikasi konsistensi data.

### Yahoo Finance Tickers for IDX
Format: `{TICKER}.JK` (contoh: `TLKM.JK`, `MTDL.JK`, `GOTO.JK`)
