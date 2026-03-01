# Relevansi Rasio Fundamental di Era AI
## Moderasi AI Disclosure Index pada Perusahaan Sektor Teknologi BEI 2019–2025

Magister Akuntansi
[Nama Mahasiswa] - [NIM]

---

# Latar Belakang

- Sektor teknologi dan telekomunikasi BEI tumbuh dinamis dengan 66 emiten (IDX-IC).
- Rasio fundamental (ROA, ROE, NPM, CR, DER, TATO, EPS) merupakan sinyal utama bagi investor (Brigham & Houston, 2021; Piotroski, 2000).
- Studi terdahulu menunjukkan hasil tidak konsisten: Dayanti *et al.* (2024) — hanya TATO signifikan; Kusdwiantara (2025) — rasio berpengaruh terhadap nilai perusahaan.
- Era GenAI pasca-2023 berpotensi mengubah relevansi informasi fundamental (Das *et al.*, 2024; Abuzayed *et al.*, 2023).

---

# Research Gap

1. Belum ada pengujian moderasi AI disclosure di sektor teknologi BEI.
2. Belum ada pengujian structural break era GenAI (2023).
3. Belum ada studi multi-dependen (PRICE + RET + TQ) dalam satu desain.
4. Metode kausal (GMM) belum digunakan sebagai robustness.
5. Periode penuh 2019–2025 belum tercakup.

---

# Rumusan Masalah dan Tujuan

**Rumusan Masalah:**
1. Apakah rasio fundamental berpengaruh terhadap PRICE, RET, TQ?
2. Apakah AI Disclosure Index memoderasi hubungan tersebut?
3. Apakah terjadi perubahan relevansi pasca era GenAI (2023)?
4. Apakah hasil konsisten pada robustness checks?

**Tujuan:** Menguji dan menganalisis keempat pertanyaan di atas secara empiris.

---

# Kerangka Teori

| Teori | Peran dalam Penelitian |
|-------|----------------------|
| Signaling Theory (Spence, 1973; Ross, 1977) | Rasio fundamental sebagai sinyal kinerja ke investor |
| Efficient Market Hypothesis (Fama, 1970) | Harga mencerminkan informasi publik |
| Resource-Based View (Barney, 1991) | Kapabilitas AI sebagai sumber daya strategis (VRIN) |
| Value Relevance Theory (Ohlson, 1995) | Informasi akuntansi berasosiasi dengan nilai pasar |
| Innovation Diffusion Theory (Rogers, 1962) | Tahapan adopsi AI berbeda antar perusahaan |

---

# Kerangka Pemikiran dan Hipotesis

**11 kelompok hipotesis, 25+ sub-hipotesis:**
- H1–H7: Pengaruh langsung rasio fundamental → PRICE, RET, TQ
- H8–H9: Moderasi AI Disclosure Index (RBV)
- H10–H11: Structural break era GenAI (EMH)

---

# Data dan Sampel

- **Populasi**: 66 perusahaan (44 Teknologi + 22 Telekomunikasi, IDX-IC)
- **Sampel**: 26 perusahaan (purposive sampling, listing sebelum 2019)
- **Periode**: 2019–2025 (7 tahun) → balanced panel
- **Observasi**: 26 × 7 = **182**
- **Sumber data**: Laporan keuangan (IDX), annual report (IDX), harga saham (Yahoo Finance)
- Memenuhi Hair's 10-times rule (min 70 observasi untuk 7 variabel independen)

---

# Variabel Penelitian

| Jenis | Variabel | Pengukuran |
|-------|----------|------------|
| Dependen | PRICE, RET, TQ | Closing price, return tahunan, Tobin's Q |
| Independen | ROA, ROE, NPM, CR, DER, TATO, EPS | Rasio dari laporan keuangan |
| Moderasi | AID | Skor analisis konten annual report |
| Moderasi | DGENAI | Dummy: 1 jika tahun ≥ 2023 |
| Kontrol | SIZE, GROWTH, AGE, VOL | Ln(aset), pertumbuhan penjualan, umur listing, SD return |

---

# Model Penelitian (9 Regresi)

**Model 1 (Baseline — H1–H7):**
Y = f(ROA, ROE, NPM, CR, DER, TATO, EPS, Kontrol)

**Model 2 (Moderasi AID — H8–H9):**
Y = f(Rasio, AID, Rasio×AID, Kontrol)

**Model 3 (Structural Break — H10–H11):**
Y = f(Rasio, DGENAI, Rasio×DGENAI, Kontrol)

Masing-masing diestimasi 3× (Y = PRICE, RET, TQ) → **total 9 regresi**.

---

# Metode Analisis

1. **Statistik deskriptif** dan matriks korelasi Pearson
2. **Uji asumsi**: VIF, Breusch-Pagan, Wooldridge, Pesaran CD
3. **Pemilihan model**: Uji Chow → Uji Hausman → Uji BP-LM
4. **Pengujian hipotesis**: Uji F (simultan), Uji t (parsial), R² adjusted
5. **Robustness checks**: Subsampel, winsorization, proksi alternatif PBV, exclude 2020, System GMM

---

# Hasil (Menunggu Data Final)

- BAB I–III telah disusun dalam format akademis lengkap
- Struktur BAB IV siap diisi dengan 9 tabel regresi dan pembahasan
- Keputusan hipotesis akan ditentukan setelah estimasi model pada dataset panel final

---

# Kontribusi Penelitian

1. **Konteks**: Sektor teknologi + telekomunikasi BEI, horizon 7 tahun (2019–2025)
2. **Variabel**: Integrasi rasio fundamental + AI disclosure + dummy GenAI
3. **Metodologi**: Tiga variabel dependen simultan + System GMM robustness

---

# Keterbatasan dan Rencana

**Keterbatasan:**
- Sampel 26 perusahaan (sektor spesifik)
- Konstruksi AID bersifat semi-manual
- Potensi endogeneity meskipun dimitigasi GMM

**Rencana Penyelesaian:**
1. Finalisasi pengumpulan data (FS, AR, harga)
2. Estimasi 9 model regresi utama
3. Robustness checks
4. Finalisasi BAB IV–V

---

# Antisipasi Pertanyaan

- **Mengapa sektor teknologi?** → Sektor paling terdampak AI, volatilitas tinggi, pertumbuhan cepat
- **Mengapa 2023 sebagai cutoff?** → Peluncuran ChatGPT Nov 2022, adopsi massal 2023 (Das *et al.*, 2024)
- **Validitas AI Disclosure Index?** → Analisis konten dengan spot-check 10% manual
- **Bagaimana mengatasi sampel kecil?** → Balanced panel 182 obs, winsorization, GMM robustness

---

# Penutup

Terima kasih.
Diskusi dan masukan sangat diharapkan untuk penyempurnaan tesis.
