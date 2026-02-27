# Research Gap — Narasi Lengkap

## Posisi Penelitian Ini dalam Literatur

Penelitian tentang analisis fundamental dan pengaruhnya terhadap kinerja pasar (harga saham, return, nilai perusahaan) telah dilakukan secara luas di Indonesia maupun internasional. Namun, berdasarkan analisis terhadap tesis-tesis S2 yang ada dan literatur terkini, terdapat beberapa celah (gap) yang belum diisi secara memadai, khususnya dalam konteks **sektor teknologi** dan **era Artificial Intelligence**.

---

## Gap 1: AI/Teknologi Belum Diuji sebagai Moderator pada Sektor Teknologi BEI

### Keadaan Saat Ini
Tesis S2 yang ada (UNDIKSHA 2025, ITB 2024, UNISSULA 2025) menguji pengaruh rasio fundamental terhadap financial distress, return saham, dan nilai perusahaan di sektor teknologi BEI. Namun, **tidak satupun** yang memasukkan indikator adopsi AI atau digital transformation sebagai variabel moderasi.

### Mengapa Ini Penting
Sektor teknologi adalah sektor yang paling terdampak oleh adopsi AI. Perusahaan yang aktif mengadopsi AI berpotensi memiliki efisiensi operasional lebih tinggi, yang seharusnya memperkuat hubungan antara rasio fundamental dan valuasi pasar. Literatur internasional 2024–2025 mulai menunjukkan bahwa pengungkapan AI berdampak pada sentimen investor dan valuasi perusahaan (ScienceDirect, Springer), namun bukti empiris dari pasar modal Indonesia masih **kosong**.

### Kontribusi Penelitian Ini
Mengisi gap dengan menguji **AI Disclosure Index** sebagai variabel moderasi pada hubungan rasio fundamental → outcome perusahaan di sektor teknologi BEI.

---

## Gap 2: Structural Break Era GenAI (2022/2023) Belum Diuji

### Keadaan Saat Ini
Peluncuran ChatGPT pada November 2022 dan adopsi massal Generative AI di 2023 telah mengubah lanskap industri teknologi secara fundamental. Namun, belum ada tesis S2 di Indonesia yang menguji apakah peristiwa ini menciptakan **structural break** dalam hubungan antara rasio fundamental dan kinerja pasar.

### Mengapa Ini Penting
Jika era GenAI mengubah cara investor memproses dan menilai informasi fundamental (misalnya, investor kini lebih memperhatikan investasi AI perusahaan daripada rasio tradisional), maka model analisis fundamental yang selama ini dipakai perlu direvisi. Ini memiliki implikasi besar bagi:
- Investor dalam pengambilan keputusan investasi
- Analis keuangan dalam penilaian saham
- Perusahaan dalam strategi komunikasi keuangan

### Kontribusi Penelitian Ini
Menguji **dummy GenAI (2023)** dan interaksinya dengan rasio fundamental untuk mendeteksi perubahan struktural dalam relevansi analisis fundamental.

---

## Gap 3: Metode Kausal Masih Jarang Dipakai

### Keadaan Saat Ini
Mayoritas tesis S2 tentang rasio fundamental di Indonesia menggunakan **regresi panel standar** (OLS pooled, Fixed Effect, Random Effect) tanpa menangani masalah **endogeneity**. Tidak ditemukan tesis yang menggunakan GMM, Difference-in-Differences, Instrumental Variables, atau event study dalam konteks sektor teknologi BEI.

### Mengapa Ini Penting
Tanpa metode yang menangani endogeneity, hasil penelitian hanya menunjukkan **korelasi/asosiasi**, bukan kausalitas. Hal ini membatasi kekuatan kesimpulan dan rekomendasi kebijakan.

### Kontribusi Penelitian Ini
Menggunakan **System GMM** sebagai robustness check untuk menangani potensi endogeneity (reverse causality: kinerja pasar yang baik → rasio fundamental meningkat karena akses modal lebih mudah).

---

## Gap 4: Belum Ada Studi Multi-Dependen dalam Satu Penelitian

### Keadaan Saat Ini
Tesis yang ada menguji **hanya satu** variabel dependen:
- UNDIKSHA (2025): Return saham saja
- ITB (2024): Financial distress (Altman Z-Score) saja
- UNISSULA (2025): Nilai perusahaan saja

Belum ada tesis yang menguji **harga saham, return saham, DAN nilai perusahaan secara simultan** dalam satu studi.

### Mengapa Ini Penting
Rasio fundamental yang signifikan terhadap harga saham belum tentu signifikan terhadap return atau Tobin's Q. Menguji ketiga dependen secara simultan memungkinkan perbandingan **konsistensi** pengaruh rasio fundamental dan memberikan gambaran yang lebih **komprehensif**.

### Kontribusi Penelitian Ini
Menggunakan **3 variabel dependen** (PRICE, RET, TQ) yang diestimasi dalam 9 model regresi terpisah.

---

## Gap 5: Periode Observasi 2019–2025 Belum Tercakup Penuh

### Keadaan Saat Ini
Tesis yang ada hanya mencakup sub-periode:
- UNDIKSHA: 2021–2023
- ITB: 2021Q1–2023Q2
- UNISSULA: 2020–2023

Tidak ada yang mencakup **periode penuh 2019–2025** yang meliputi:
- Pre-COVID (2019)
- Pandemi COVID-19 (2020–2021)
- Recovery (2022)
- Era GenAI (2023–2025)

### Mengapa Ini Penting
Panel data yang lebih panjang memungkinkan:
- Analisis lintas regime (pre/during/post COVID, pre/post GenAI)
- Estimasi yang lebih robust (lebih banyak observasi)
- Deteksi structural break yang lebih akurat

### Kontribusi Penelitian Ini
Menggunakan **periode 2019–2025 (7 tahun)** yang mencakup berbagai regime ekonomi dan teknologi.

---

## Ringkasan Posisi Penelitian

```
Literatur yang ada:
  ✅ Rasio fundamental → outcome perusahaan (banyak studi)
  ✅ Sektor teknologi BEI (3 tesis S2)
  ✅ Panel regression (standar)

Yang BELUM ada (gap):
  ❌ AI disclosure sebagai moderator di sektor teknologi BEI
  ❌ Structural break era GenAI (2023)
  ❌ Multi-dependen (harga + return + Tobin's Q) dalam satu studi
  ❌ Metode kausal (GMM) untuk robustness
  ❌ Periode penuh 2019–2025

Penelitian ini → mengisi SEMUA gap di atas dalam satu studi terpadu.
```

---

## Novelty Statement

> Penelitian ini memberikan kontribusi orisinal dengan menguji **relevansi rasio fundamental di era AI** pada perusahaan sektor teknologi BEI periode 2019–2025, menggunakan **AI Disclosure Index** sebagai variabel moderasi dan mendeteksi **structural break era Generative AI (2023)**. Dengan menggunakan **tiga variabel dependen** (harga saham, return saham, dan Tobin's Q) serta **System GMM** sebagai robustness check, penelitian ini memberikan bukti empiris yang lebih komprehensif dan robust dibandingkan studi-studi sebelumnya.
