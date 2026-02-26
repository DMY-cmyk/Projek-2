# Output: Analisis Tesis S2 Sektor Teknologi (Rasio Fundamental, 2019–2025)

## Ringkasan
Dokumen ini merangkum hasil eksekusi rencana pada `Plan.md` dengan fokus:
- Tesis S2, sektor teknologi BEI, periode 2019–2025.
- Metode kuantitatif berbasis data sekunder dan rasio fundamental.

Hasil verifikasi publik saat ini menghasilkan **3 tesis** yang memenuhi kriteria rasio fundamental secara ketat. Target 6–10 tesis belum tercapai karena keterbatasan akses publik.

## Tabel Tesis Terverifikasi (Rasio Fundamental)
| No | Tesis | Sektor/Periode | Variabel Utama | Metode |
|---|---|---|---|---|
| 1 | UNDIKSHA (2025) – Magister Akuntansi | Teknologi BEI, 2021–2023 | Intellectual Capital & Working Capital Mgmt → Financial Distress → Return Saham | Regresi, mediasi |
| 2 | ITB (2024) – Tesis | Teknologi BEI, 2021Q1–2023Q2 | EPS, PBV, TATO, FATO → Financial Distress (Altman Z-Score) | Regresi panel |
| 3 | UNISSULA (2025) – Magister Manajemen | Teknologi BEI, 2020–2023 | Profitabilitas, Likuiditas, Leverage → Nilai Perusahaan | PLS/Regresi |

## Perbandingan Temuan
- Ketiga tesis menegaskan **peran rasio fundamental** pada outcome perusahaan (distress/return/nilai).
- Variasi outcome: distress (ITB), return (UNDIKSHA), firm value (UNISSULA).
- Belum ada tesis yang memasukkan indikator **AI/teknologi** sebagai moderasi atau structural break.

## Research Gap (Terkuat)
1. **AI disclosure/technology intensity** belum diuji sebagai moderator pada sektor teknologi BEI.
2. **Perubahan era GenAI (2022/2023)** belum diuji sebagai structural break terhadap relevansi rasio fundamental.
3. **Metode kausal (DID/GMM/event study)** masih jarang dipakai untuk sektor teknologi BEI.

## Ide Judul & Rumusan Masalah (Contoh)
1. “Relevansi Rasio Fundamental di Era AI: Moderasi AI Disclosure pada Perusahaan Teknologi BEI 2019–2025.”
2. “Structural Break 2022/2023: Dampak Era GenAI terhadap Hubungan Rasio Fundamental dan Nilai Perusahaan Teknologi.”
3. “Intangible Intensity sebagai Proksi Kemajuan Teknologi: Pengaruhnya terhadap Return Saham Perusahaan Teknologi BEI.”

## Outline Metodologi (Ringkas)
- Data: BEI/IDX (laporan keuangan, annual report, harga saham).
- Model: Panel FE/RE + robust SE.
- Robustness: GMM / subsample / lagging.
- AI proxy: disclosure index dari annual report atau intangible intensity.

## Metodologi Appendix
### A. Definisi Variabel dan Rumus
- ROA = Laba Bersih / Total Aset
- ROE = Laba Bersih / (Total Aset - Total Liabilitas)
- NPM = Laba Bersih / Pendapatan
- CR = Aset Lancar / Liabilitas Lancar
- DER = Total Liabilitas / Ekuitas
- TATO = Pendapatan / Total Aset
- EPS = Laba Bersih / Jumlah Saham Beredar
- PBV = Harga Saham / Nilai Buku per Saham
- Tobin’s Q = (Nilai Pasar Ekuitas + Total Liabilitas) / Total Aset

### B. Skema Dataset (Minimal)
Kolom wajib:
- `firm_id`, `ticker`, `year`, `sector`
- `price`, `return`, `pbv`, `tobins_q`
- `roa`, `roe`, `npm`, `cr`, `der`, `tato`, `eps`
- `size`, `growth`, `volatility`, `firm_age`
- `ai_disclosure_index`, `intangible_intensity`

Kolom opsional:
- `macro_inflation`, `macro_fx`, `macro_rate`
- `event_dummy` (misal 2022/2023 sebagai era GenAI)

### C. Desain Empiris
- Model dasar: Y_it = α + βX_it + γControls_it + μ_i + ε_it
- Moderasi AI: Y_it = α + βX_it + θAI_it + λ(X_it * AI_it) + γControls_it + μ_i + ε_it
- Structural break: tambah dummy era GenAI + interaksi dummy dengan X_it

### D. Uji Diagnostik
- Multikolinearitas: VIF
- Heteroskedastisitas: White/Breusch-Pagan
- Autokorelasi: Durbin-Watson / Wooldridge
- Hausman: FE vs RE

### E. Robustness
- GMM (lagged dependent variable)
- Subsample pre/post 2022
- Winsorizing outlier 1%/5%

## Catatan Keterbatasan
Target 6–10 tesis belum tercapai karena akses publik terbatas. Disarankan melanjutkan penelusuran repositori kampus lain atau meminta akses via perpustakaan kampus.
