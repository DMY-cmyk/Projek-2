# ANTISIPASI PERTANYAAN SIDANG (DRAFT JAWABAN)

## 1) Mengapa memilih sektor teknologi?
Sektor teknologi memiliki dinamika pertumbuhan tinggi, volatilitas pasar tinggi, serta intensitas narasi AI/digital yang lebih jelas. Ini membuat sektor teknologi relevan untuk menguji apakah rasio fundamental masih bernilai informatif di era AI.

## 2) Bagaimana mengukur AI disclosure?
AI disclosure diukur dengan content analysis annual report menggunakan kata kunci AI core, digital tech, dan digital transformation. Skor dibuat dalam bentuk `aid_binary` dan `aid_frequency` untuk robustness.

## 3) Mengapa 2023 dijadikan cutoff era GenAI?
Tahun 2023 dipakai sebagai titik perubahan rezim karena adopsi dan atensi pasar terhadap GenAI meningkat tajam setelah peluncuran LLM publik skala besar pada akhir 2022 dan eskalasi adopsi korporasi pada 2023.

## 4) Bagaimana mengatasi sampel kecil?
Pendekatan yang digunakan:
1. Model adaptif (fallback spesifikasi lebih ringkas).
2. Robustness checks (winsorizing, exclude 2020, subsample).
3. Transparansi keterbatasan inferensi jika complete-case rendah.

## 5) Apa perbedaan dengan tesis pembanding?
Perbedaan utama:
1. Multi-dependen (PRICE, RET, TQ) dalam satu desain.
2. Moderasi AI disclosure + structural break post-2023.
3. Pipeline reproducible end-to-end yang terdokumentasi.

## 6) Mengapa robustness checks 4.5.1–4.5.4 dipilih?
Empat robustness checks dipilih untuk menangani ancaman validitas yang berbeda:
1. **Subsample analysis (4.5.1)**: Menguji stabilitas hasil pada sub-kelompok (technology-only, pre/post GenAI, exclude 2020/COVID). Ini memastikan temuan tidak didorong oleh satu sub-kelompok tertentu.
2. **Winsorization persentil 1%/99% (4.5.2)**: Mengurangi pengaruh outlier ekstrem pada estimasi koefisien tanpa menghapus observasi, yang penting mengingat sektor teknologi cenderung memiliki distribusi skewed (Das *et al.*, 2024).
3. **Proksi alternatif PBV (4.5.3)**: Menggantikan Tobin's Q (TQ) dengan Price-to-Book Value (PBV) untuk memastikan temuan terkait valuasi tidak artifak dari satu proksi saja (Chung & Pruitt, 1994).
4. **System GMM (4.5.4)**: Mengatasi potensi endogeneity (reverse causality antara kinerja keuangan dan valuasi pasar) menggunakan instrumen lag variabel (Arellano & Bond, 1991; Blundell & Bond, 1998).
Keempat pendekatan ini saling melengkapi dan memberikan triangulasi yang kuat terhadap temuan utama.

## 7) Apa isi Analisis Komparatif Indonesia vs AS (4.6.6)?
Section 4.6.6 menyajikan perbandingan deskriptif rasio fundamental antara perusahaan teknologi BEI (26 sampel) dan 10 perusahaan teknologi AS (data SEC EDGAR). Poin-poin utama:
1. **Sifat deskriptif, bukan kausal**: Perbandingan ini bertujuan memberikan konteks (*contextual benchmarking*), bukan menguji hubungan kausal lintas negara.
2. **Sumber data AS**: Data diambil dari SEC EDGAR filings menggunakan pipeline otomatis yang mengakses laporan 10-K perusahaan teknologi AS.
3. **Variabel yang dibandingkan**: Statistik deskriptif (mean, median, standar deviasi) untuk rasio fundamental yang sama (ROA, ROE, NPM, CR, DER, TATO, EPS) pada kedua kelompok.
4. **Kontribusi**: Memberikan perspektif apakah pola relevansi fundamental di Indonesia konsisten atau berbeda dengan pasar yang lebih matang. Perbedaan sistematis dapat menunjukkan faktor institusional, regulatori, atau tahapan adopsi teknologi yang berbeda.
5. **Keterbatasan**: Perbedaan standar akuntansi (PSAK vs US GAAP), ukuran pasar, dan komposisi sampel membatasi generalisasi.

## 8) Bagaimana dengan kesenjangan AI disclosure vs adopsi aktual?
Ini merupakan Limitasi 6 yang secara eksplisit diakui dalam BAB V:
1. **Content analysis menangkap pengungkapan, bukan adopsi**: AI Disclosure Index (AID) diukur melalui kata kunci di annual report. Perusahaan yang mengadopsi AI tetapi tidak mengungkapkannya akan mendapat skor rendah, dan sebaliknya (*greenwashing* atau *AI-washing*).
2. **Implikasi metodologis**: AID mengukur *intention to signal* (Signaling Theory), bukan *actual capability* (RBV). Keduanya valid secara teoretis tetapi mengukur konstruk yang berbeda.
3. **Mitigasi dalam penelitian ini**: Penggunaan dua varian skor (`aid_binary` dan `aid_frequency`) serta validasi inter-coder reliability (Cohen's Kappa) untuk memastikan konsistensi pengukuran.
4. **Saran untuk penelitian masa depan**: Pengembangan AID berbasis NLP/text mining yang lebih canggih untuk membedakan pengungkapan substantif vs simbolik, sebagaimana diusulkan dalam Saran 7.

## 9) Apa perbedaan Model 1 (baseline), Model 2 (moderasi), dan Model 3 (structural break)?
Tiga kelompok model didesain untuk menjawab rumusan masalah yang berbeda:
1. **Model 1 — Baseline (H1–H7)**: Menguji pengaruh langsung 7 rasio fundamental (ROA, ROE, NPM, CR, DER, TATO, EPS) terhadap masing-masing variabel dependen (PRICE, RET, TQ) dengan variabel kontrol. Menjawab RM1: "Apakah rasio fundamental berpengaruh signifikan?"
2. **Model 2 — Moderasi AID (H8–H9)**: Menambahkan interaksi X×AID pada Model 1 untuk menguji apakah AI Disclosure Index memperkuat atau memperlemah hubungan rasio fundamental dengan indikator pasar. Menjawab RM2: "Apakah AID memoderasi hubungan tersebut?"
3. **Model 3 — Structural Break (H10–H11)**: Menambahkan interaksi X×DGENAI pada Model 1 untuk menguji apakah relevansi rasio fundamental berubah secara signifikan setelah era GenAI (post-2023). Menjawab RM3: "Apakah terjadi perubahan struktural?"
Setiap kelompok diestimasi untuk 3 variabel dependen, sehingga total 9 persamaan regresi. Pemilihan model panel (CEM/FEM/REM) dilakukan secara independen untuk masing-masing persamaan melalui Uji Chow, Hausman, dan BP-LM.

## 10) Bagaimana saran perbandingan lintas negara (Saran 5)?
Saran 5 dalam BAB V merekomendasikan pengembangan studi komparatif lintas negara dengan desain yang lebih rigorous:
1. **Data awal sudah tersedia**: 10 perusahaan teknologi AS telah diambil datanya dari SEC EDGAR (lihat Section 4.6.6 dan Lampiran 12), sehingga peneliti selanjutnya tidak perlu memulai dari nol.
2. **Rekomendasi metode**: Penggunaan Difference-in-Differences (DID) atau propensity score matching untuk mengisolasi pengaruh faktor institusional, bukan sekadar perbandingan deskriptif.
3. **Variabel tambahan**: Menambahkan variabel konteks negara seperti indeks tata kelola perusahaan, tingkat penetrasi internet, belanja R&D nasional, dan regulasi pengungkapan AI.
4. **Perluasan sampel**: Memperluas ke negara ASEAN (SGX, SET) atau emerging markets lainnya untuk meningkatkan generalisabilitas.
5. **Kontribusi potensial**: Studi lintas negara akan menjawab pertanyaan apakah relevansi fundamental di era AI bersifat universal atau tergantung konteks institusional — sebuah pertanyaan yang belum terjawab dalam literatur saat ini.
