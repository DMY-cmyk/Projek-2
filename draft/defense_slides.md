# Relevansi Rasio Fundamental di Era AI
## Sektor Teknologi BEI 2019-2025

Magister Akuntansi  
[Nama Mahasiswa] - [NIM]

---

# Latar Belakang

- Sektor teknologi BEI tumbuh cepat dan volatil.
- Narasi AI/digital disclosure meningkat pasca 2023.
- Hasil riset rasio fundamental pada sektor ini masih tidak konsisten.

---

# Rumusan Masalah

1. Apakah rasio fundamental memengaruhi `PRICE`, `RET`, `TQ`?
2. Apakah `AI Disclosure Index` memoderasi hubungan tersebut?
3. Apakah terjadi perubahan sensitivitas pasca 2023 (`DGENAI`)?

---

# Tujuan dan Kontribusi

- Uji pengaruh rasio fundamental multi-dependen.
- Uji moderasi AI disclosure.
- Uji structural break era GenAI.
- Sediakan pipeline analisis reproducible.

---

# Kerangka Variabel

- Dependen: `PRICE`, `RET`, `TQ`
- Independen: `ROA`, `ROE`, `NPM`, `CR`, `DER`, `TATO`, `EPS`
- Moderasi: `AID`, `DGENAI`
- Kontrol: `SIZE`, `GROWTH`, `AGE`, `VOL`, `II`

---

# Data dan Sampel

- Populasi: emiten sektor teknologi BEI.
- Periode: 2019-2025.
- Data sekunder: laporan keuangan, annual report, harga saham.
- Sampling: purposive berdasarkan kelengkapan data.

---

# Metode

- Panel regression (baseline, moderation, structural break).
- Uji asumsi: deskriptif, korelasi, VIF, BP, DW.
- Model selection: pooled/FE/RE (dengan fallback teknis).
- Robustness: subsample, winsorize, exclude 2020, alt proxy PBV.

---

# Pipeline Otomasi

- Seleksi sampel: `scripts/ingest_idx_population.ps1`, `scripts/estimate_sample.ps1`
- Build dataset: `scripts/build_panel_dataset.ps1`
- EViews runner: `scripts/eviews_run.ps1`
- Robustness: `scripts/robustness_checks.ps1`
- Hipotesis: `scripts/hypothesis_decision.ps1`

---

# Hasil Sementara

- Draft BAB I-V sudah disusun dengan template kampus.
- Uji statistik dan robustness pipeline sudah tersedia.
- Keputusan hipotesis final menunggu hasil regresi dataset lengkap.

---

# Nilai Tambah Penelitian

- Integrasi fundamental + AI disclosure + regime change.
- Multi-output market metrics (`PRICE`, `RET`, `TQ`) dalam satu desain.
- Reproducible workflow untuk audit trail akademik.

---

# Keterbatasan

- Complete-case masih terbatas pada data uji/template.
- Beberapa model sensitif terhadap collinearity dan ukuran sampel.
- Estimasi final perlu dataset panel lengkap 2019-2025.

---

# Rencana Penyelesaian

1. Finalisasi dataset panel lengkap.
2. Rerun 9 model utama + robustness.
3. Sinkronisasi BAB IV-V dengan output final.
4. Final check sitasi dan format kampus.

---

# Antisipasi Pertanyaan Ujian

- Mengapa sektor teknologi?
- Mengapa cutoff 2023?
- Bagaimana validitas AI disclosure index?
- Bagaimana menangani sampel kecil dan endogeneity?

---

# Penutup

Terima kasih.  
Diskusi dan masukan sangat diharapkan untuk penyempurnaan tesis.
