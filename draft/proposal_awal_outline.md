# Proposal Awal Tesis

## 1. Judul

Relevansi Rasio Fundamental di Era Artificial Intelligence: Moderasi AI Disclosure Index pada Perusahaan Sektor Teknologi BEI Periode 2019–2025

## 2. Latar Belakang

Sektor teknologi dan telekomunikasi di Bursa Efek Indonesia (BEI) mengalami pertumbuhan dinamis sepanjang 2019–2025, dengan peningkatan jumlah emiten dan transformasi digital yang substansial. Analisis fundamental melalui rasio keuangan seperti ROA, ROE, NPM, CR, DER, TATO, dan EPS merupakan pendekatan yang telah lama digunakan investor untuk menilai kinerja perusahaan (Brigham dan Houston, 2021; Piotroski, 2000).

Namun, studi terdahulu pada sektor teknologi BEI menunjukkan hasil yang tidak konsisten. Dayanti *et al.* (2024) menemukan hanya TATO yang signifikan terhadap harga saham, sementara penelitian di UNISSULA (2025) menunjukkan rasio fundamental berpengaruh terhadap nilai perusahaan. Di sisi lain, era Generative AI pasca-2023 berpotensi mengubah cara investor memproses informasi fundamental (Das *et al.*, 2024; Abuzayed *et al.*, 2023).

Terdapat lima celah penelitian utama: (1) belum ada pengujian moderasi AI disclosure di sektor teknologi BEI, (2) belum ada pengujian structural break era GenAI, (3) dominasi metode asosiatif tanpa robustness kausal, (4) belum ada studi multi-dependen dalam satu desain terpadu, dan (5) keterbatasan periode observasi penelitian terdahulu.

## 3. Rumusan Masalah

1. Apakah rasio profitabilitas (ROA, ROE, NPM), rasio likuiditas (CR), rasio leverage (DER), rasio aktivitas (TATO), dan rasio pasar (EPS) berpengaruh signifikan terhadap harga saham, return saham, dan nilai perusahaan (Tobin's Q) pada perusahaan sektor teknologi BEI periode 2019–2025?

2. Apakah AI Disclosure Index memoderasi hubungan antara rasio fundamental dan harga saham, return saham, serta nilai perusahaan?

3. Apakah terdapat perbedaan signifikan dalam relevansi rasio fundamental sebelum dan sesudah era Generative AI (2023)?

4. Sejauh mana hasil pengujian utama tetap konsisten pada pengujian robustness?

## 4. Tujuan Penelitian

1. Menguji dan menganalisis pengaruh rasio fundamental terhadap harga saham, return saham, dan Tobin's Q pada sektor teknologi BEI periode 2019–2025.

2. Menguji peran AI Disclosure Index sebagai variabel moderasi pada hubungan rasio fundamental dengan indikator pasar.

3. Menguji perbedaan relevansi rasio fundamental sebelum dan sesudah era Generative AI (2023).

4. Menilai konsistensi hasil melalui pengujian robustness (subsampel, winsorization, proksi alternatif, System GMM).

## 5. Manfaat Penelitian

### Teoretis
- Memperkaya literatur value relevance pada konteks sektor teknologi Indonesia di era AI.
- Mengintegrasikan Signaling Theory, EMH, RBV, dan Value Relevance Theory dalam satu kerangka.
- Memberikan bukti empiris mengenai dampak perubahan paradigma teknologi terhadap relevansi informasi akuntansi.

### Praktis
- Bagi investor: referensi evaluasi relevansi rasio fundamental di sektor teknologi.
- Bagi manajemen: masukan strategi pengungkapan AI dalam annual report.
- Bagi regulator (OJK, BEI): dasar pertimbangan pedoman pengungkapan adopsi AI.

## 6. Tinjauan Pustaka Ringkas

### Teori Utama
- **Signaling Theory** (Spence, 1973; Ross, 1977): rasio fundamental sebagai sinyal kinerja.
- **Efficient Market Hypothesis** (Fama, 1970): harga mencerminkan informasi publik.
- **Resource-Based View** (Barney, 1991): kapabilitas AI sebagai sumber daya strategis.
- **Value Relevance Theory** (Ohlson, 1995; Ball & Brown, 1968): informasi akuntansi berasosiasi dengan nilai pasar.
- **Innovation Diffusion Theory** (Rogers, 1962): tahapan adopsi teknologi AI.

### Posisi Penelitian
Berdasarkan telaah 8 tesis S2 dan 28 artikel jurnal, penelitian ini mengisi lima gap yang belum tercakup: moderasi AI disclosure, structural break GenAI, multi-dependen, robustness kausal, dan periode penuh 2019–2025.

## 7. Metodologi Ringkas

### Desain Penelitian
Kuantitatif, kausal/asosiatif, data panel sekunder, pendekatan deduktif.

### Populasi dan Sampel
- Populasi: 66 perusahaan sektor Teknologi (IDX-IC I) dan Telekomunikasi (IDX-IC J3).
- Sampel: 26 perusahaan dengan purposive sampling (listing sebelum 2019, data lengkap).
- Observasi: 26 × 7 tahun = 182 (balanced panel).

### Variabel
- **Dependen**: Harga Saham (PRICE), Return Saham (RET), Tobin's Q (TQ)
- **Independen**: ROA, ROE, NPM, CR, DER, TATO, EPS
- **Moderasi**: AI Disclosure Index (AID), Dummy GenAI (DGENAI)
- **Kontrol**: SIZE, GROWTH, AGE, VOL

### Model Penelitian
1. Model Baseline: Y = f(Rasio Fundamental, Kontrol) — 3 regresi
2. Model Moderasi: Y = f(Rasio, AID, Rasio×AID, Kontrol) — 3 regresi
3. Model Structural Break: Y = f(Rasio, DGENAI, Rasio×DGENAI, Kontrol) — 3 regresi
Total: 9 persamaan regresi data panel.

### Teknik Analisis
Regresi data panel (CEM/FEM/REM), Uji Chow, Uji Hausman, Uji BP-LM, Uji F, Uji t, R².

### Robustness Checks
System GMM, subsampel pre/post-GenAI, winsorization, proksi alternatif PBV, exclude 2020.

## 8. Rencana Data dan Analisis

### Sumber Data
- Laporan keuangan tahunan: idx.co.id
- Annual report: idx.co.id dan situs perusahaan
- Harga saham: BEI dan Yahoo Finance

### Alur Analisis
1. Seleksi sampel dengan purposive sampling
2. Pengumpulan dan tabulasi data keuangan, harga, dan annual report
3. Konstruksi variabel (rasio fundamental, AID, variabel kontrol)
4. Statistik deskriptif dan uji asumsi klasik
5. Pemilihan model panel (Chow, Hausman, BP-LM)
6. Estimasi 9 model regresi utama
7. Robustness checks
8. Keputusan hipotesis dan pembahasan

## 9. Jadwal Penelitian

| Tahap | Kegiatan | Bulan |
|-------|----------|-------|
| 1 | Finalisasi proposal dan persetujuan pembimbing | Bulan 1 |
| 2 | Tinjauan pustaka dan kerangka teori | Bulan 1–2 |
| 3 | Pengumpulan data (FS, AR, harga saham) | Bulan 2–4 |
| 4 | Konstruksi variabel dan AI Disclosure Index | Bulan 4–5 |
| 5 | Analisis data dan pengujian hipotesis | Bulan 5–6 |
| 6 | Penulisan BAB IV–V dan finalisasi draft | Bulan 6–7 |
| 7 | Konsultasi pembimbing dan revisi | Bulan 7–8 |
| 8 | Sidang tesis | Bulan 8–9 |

## 10. Daftar Pustaka Awal

1. Ball, R., & Brown, P. (1968). An empirical evaluation of accounting income numbers. *Journal of Accounting Research*, 6(2), 159–178.
2. Barney, J. (1991). Firm resources and sustained competitive advantage. *Journal of Management*, 17(1), 99–120.
3. Brigham, E. F., & Houston, J. F. (2021). *Fundamentals of Financial Management* (16th ed.). Cengage Learning.
4. Das, S. R., Guo, R. J., & Zhang, Y. (2024). The ChatGPT shock. *Technology in Society*, 78, 102756.
5. Dayanti, R., Primasatya, A., & Fernando, R. (2024). Pengaruh rasio fundamental terhadap harga saham teknologi BEI. *Owner*, 8(2).
6. Fama, E. F. (1970). Efficient capital markets. *The Journal of Finance*, 25(2), 383–417.
7. Gharbi, S., Sahut, J. M., & Teulon, F. (2025). AI and firm value: A systematic review. *FinTech*, 4(2), 20.
8. Gujarati, D. N., & Porter, D. C. (2009). *Basic Econometrics* (5th ed.). McGraw-Hill.
9. Hair, J. F., *et al.* (2019). *Multivariate Data Analysis* (8th ed.). Cengage Learning.
10. Ohlson, J. A. (1995). Earnings, book values, and dividends in equity valuation. *Contemporary Accounting Research*, 11(2), 661–687.
11. Piotroski, J. D. (2000). Value investing: The use of historical financial statement information. *Journal of Accounting Research*, 38(Suppl.), 1–41.
12. Rogers, E. M. (1962). *Diffusion of Innovations*. Free Press.
13. Ross, S. A. (1977). The determination of financial structure. *The Bell Journal of Economics*, 8(1), 23–40.
14. Spence, M. (1973). Job market signaling. *The Quarterly Journal of Economics*, 87(3), 355–374.
15. Sugiyono. (2013). *Metode Penelitian Kuantitatif, Kualitatif, dan R&D*. Alfabeta.
