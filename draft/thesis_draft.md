# DRAFT TESIS S2 AKUNTANSI

## Halaman Judul (Draft)
Judul:
Relevansi Rasio Fundamental di Era Artificial Intelligence: Moderasi AI Disclosure Index pada Perusahaan Sektor Teknologi BEI Periode 2019-2025

Program Studi:
Magister Akuntansi

Catatan:
Dokumen ini adalah draft awal untuk penyusunan tesis final.

## Rujukan Format (Web Reference Basis)
Format dokumen dan urutan bab pada draft ini mengikuti pola umum pedoman tesis pascasarjana dan contoh tesis S2 yang telah diinventarisasi, termasuk:
1. Pedoman Penulisan Tesis Magister Akuntansi FE UNJ (2022): https://fe.unj.ac.id/wp-content/uploads/2023/02/Pedoman-Penulisan-Tesis-magister-akuntansi.pdf
2. Pedoman Penulisan Tesis Sekolah Pascasarjana UMS: https://sps.ums.ac.id/pedoman-penulisan-tesis/
3. Pedoman pembimbingan/ujian tesis FEB UNAIR (halaman unduhan): https://feb.unair.ac.id/unduhan/
4. Tesis UNAIR (contoh struktur BAB I-V + daftar isi): https://repository.unair.ac.id/110062
5. Tesis UNDIKSHA (S2, sektor teknologi): https://repo.undiksha.ac.id/23085/
6. Tesis ITB (S2, sektor teknologi): https://digilib.itb.ac.id/gdl/view/79966
7. Tesis UNISSULA (S2): https://repository.unissula.ac.id/43161/
8. Tesis UNAND (S2): https://scholar.unand.ac.id/511212/

## Daftar Isi (Draft)
1. BAB I Pendahuluan
2. BAB II Tinjauan Pustaka
3. BAB III Metodologi Penelitian
4. BAB IV Hasil dan Pembahasan
5. BAB V Kesimpulan dan Saran
6. Daftar Pustaka
7. Lampiran

# BAB I PENDAHULUAN
## 1.1 Latar Belakang
Sektor teknologi di Bursa Efek Indonesia (BEI) mengalami pertumbuhan dan volatilitas yang tinggi dalam periode 2019-2025. Pada saat yang sama, adopsi teknologi AI dan narasi transformasi digital meningkat dalam komunikasi korporasi melalui annual report. Kondisi ini memunculkan pertanyaan apakah relevansi rasio fundamental tradisional (profitabilitas, likuiditas, leverage, efisiensi) masih konsisten dalam menjelaskan harga saham, return saham, dan nilai perusahaan.

Penelitian-penelitian terdahulu memperlihatkan hasil yang belum konsisten pada variabel fundamental terhadap berbagai proksi kinerja pasar. Selain itu, penelitian berbasis sektor teknologi Indonesia dengan integrasi indikator AI disclosure masih terbatas. Karena itu, penelitian ini menguji kembali relasi rasio fundamental dengan memasukkan AI Disclosure Index sebagai variabel moderasi serta pengujian perubahan rezim setelah era GenAI (dummy post-2023).

## 1.2 Rumusan Masalah
1. Apakah rasio fundamental berpengaruh terhadap harga saham, return saham, dan nilai perusahaan sektor teknologi BEI?
2. Apakah AI Disclosure Index memoderasi pengaruh rasio fundamental terhadap ketiga variabel dependen?
3. Apakah terdapat perubahan pengaruh rasio fundamental pada periode post-2023 (era GenAI)?

## 1.3 Tujuan Penelitian
1. Menganalisis pengaruh rasio fundamental terhadap harga, return, dan nilai perusahaan.
2. Menganalisis peran moderasi AI Disclosure Index.
3. Menguji perubahan koefisien pada rezim post-2023.

## 1.4 Manfaat Penelitian
- Teoretis: memperluas literatur value relevance rasio fundamental pada konteks teknologi dan AI.
- Praktis: memberikan masukan bagi investor, manajemen, dan regulator pasar modal.

## 1.5 Batasan Penelitian
- Objek: perusahaan sektor teknologi BEI.
- Periode: 2019-2025.
- Data: sekunder (laporan keuangan, annual report, harga saham).

# BAB II TINJAUAN PUSTAKA
## 2.1 Landasan Teori
1. Signaling Theory
2. Efficient Market Hypothesis
3. Resource-Based View
4. Value Relevance Theory

## 2.2 Penelitian Terdahulu
Ringkasan penelitian terdahulu disusun dari inventaris tesis dan jurnal pada proyek ini (`output/literatur_tesis.md` dan `output/literatur_jurnal.md`), dengan fokus:
- Fundamental analysis -> harga/return/nilai perusahaan
- AI disclosure/digital transformation -> firm performance
- Structural break/regime change

## 2.3 Kerangka Konseptual
Variabel:
- Dependen: PRICE, RET, TQ
- Independen: ROA, ROE, NPM, CR, DER, TATO, EPS
- Moderasi: AID, DGENAI
- Kontrol: SIZE, GROWTH, AGE, VOL

## 2.4 Hipotesis
Contoh hipotesis:
- H1a: ROA berpengaruh positif terhadap PRICE.
- H2a: DER berpengaruh negatif terhadap PRICE.
- H3a: EPS berpengaruh positif terhadap PRICE.
- H4: AID memoderasi hubungan rasio fundamental dengan PRICE/RET/TQ.
- H5: DGENAI mengubah sensitivitas PRICE/RET/TQ terhadap rasio fundamental.

# BAB III METODOLOGI PENELITIAN
## 3.1 Jenis dan Desain Penelitian
Penelitian kuantitatif dengan desain panel data.

## 3.2 Populasi dan Sampel
- Populasi: emiten sektor teknologi BEI.
- Sampling: purposive sampling berdasarkan kriteria kelengkapan data.
- Pipeline seleksi pada proyek ini:
  - `scripts/ingest_idx_population.ps1`
  - `scripts/estimate_sample.ps1`

## 3.3 Definisi Operasional Variabel
Definisi operasional mengikuti `output/metodologi_penelitian.md`.

## 3.4 Sumber dan Teknik Pengumpulan Data
- Laporan keuangan dan annual report dari BEI/perusahaan.
- Harga saham tahunan/bulanan.
- AI disclosure text-mining dari annual report.

## 3.5 Teknik Analisis Data
1. Statistik deskriptif dan korelasi.
2. Uji asumsi klasik (VIF, heteroskedastisitas, autokorelasi).
3. Estimasi model panel (baseline, moderasi AID, structural break).
4. Robustness checks (subsample, winsorizing, exclude 2020, alt proxy PBV).

## 3.6 Model Empiris
Model baseline:
Y_it = alpha + beta X_it + gamma Controls_it + mu_i + e_it

Model moderasi AID:
Y_it = alpha + beta X_it + theta AID_it + lambda (X_it x AID_it) + gamma Controls_it + mu_i + e_it

Model structural break:
Y_it = alpha + beta X_it + delta DGENAI_t + phi (X_it x DGENAI_t) + gamma Controls_it + mu_i + e_it

# BAB IV HASIL DAN PEMBAHASAN
## 4.1 Gambaran Umum Objek Penelitian
Bagian ini memuat deskripsi sampel final perusahaan teknologi dan sebaran observasi panel.

## 4.2 Statistik Deskriptif
Merujuk hasil otomatis:
- `output/descriptive_stats.md`
- `output/correlation_matrix.csv`

## 4.3 Uji Asumsi dan Pemilihan Model
Merujuk hasil otomatis:
- `output/assumption_tests.md`
- `output/vif_table.csv`
- `output/panel_model_selection.md`

## 4.4 Hasil Estimasi Model
Merujuk hasil regresi EViews:
- `output/eviews/eq_price_base.txt`
- `output/eviews/eq_ret_base.txt`
- `output/eviews/eq_tq_base.txt`
- `output/eviews/eq_price_aid.txt`
- `output/eviews/eq_ret_aid.txt`
- `output/eviews/eq_tq_aid.txt`
- `output/eviews/eq_price_break.txt`
- `output/eviews/eq_ret_break.txt`
- `output/eviews/eq_tq_break.txt`

## 4.5 Robustness Checks
Merujuk:
- `output/robustness_checks.md`
- `output/robustness/`

## 4.6 Uji Hipotesis
Merujuk:
- `output/hypothesis_results.csv`
- `output/hypothesis_decision.md`

# BAB V KESIMPULAN DAN SARAN
## 5.1 Kesimpulan
Kesimpulan akhir diisi setelah estimasi pada dataset final berhasil.

## 5.2 Implikasi
- Implikasi teoretis untuk literatur fundamental analysis dan AI disclosure.
- Implikasi praktis untuk investor, manajemen emiten, dan regulator.

## 5.3 Keterbatasan
- Keterbatasan kelengkapan data publik.
- Potensi endogeneity.
- Sensitivitas model terhadap ukuran sampel sektor teknologi.

## 5.4 Saran
- Penguatan dataset panel final 2019-2025.
- Estimasi GMM dan validasi lanjutan.
- Replikasi lintas sektor untuk pembanding eksternal.

# Daftar Pustaka (Draft Ringkas)
Daftar pustaka final mengikuti gaya sitasi kampus (APA/Harvard sesuai pedoman prodi). Referensi awal dapat diambil dari:
- `output/literatur_jurnal.md`
- `output/literatur_tesis.md`

# Lampiran (Draft)
1. Tabel definisi variabel
2. Daftar sampel emiten
3. Output statistik/deskriptif
4. Output regresi EViews
5. Prosedur konstruksi AI Disclosure Index
