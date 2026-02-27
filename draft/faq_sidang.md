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
