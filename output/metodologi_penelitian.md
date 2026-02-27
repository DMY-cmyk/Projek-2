# Metodologi Penelitian (Implementasi Step 2.x)

## 1) Desain Penelitian
- Jenis: kuantitatif, asosiatif (panel data).
- Pendekatan: deduktif (teori -> hipotesis -> pengujian).
- Data: sekunder (laporan keuangan, annual report, harga saham).

## 2) Populasi dan Sampel
- Populasi: seluruh emiten sektor Teknologi BEI (IDX-IC).
- Periode observasi: 2019-2025.
- Sampling: purposive sampling dengan kriteria di `Plan.md`.
- Implementasi teknis:
  - Gunakan template inventaris sampel: `output/sample_selection_template.csv`.
  - Isi variabel status inklusi per emiten (`include_flag`).

## 3) Definisi Operasional Variabel
Kolom final dataset panel (minimum):
- Identitas: `firm_id`, `year`
- Dependen: `price`, `ret`, `tq`
- Independen: `roa`, `roe`, `npm`, `cr`, `der`, `tato`, `eps`
- Moderasi: `aid`, `ii`, `dgenai`
- Kontrol: `size`, `growth`, `age`, `vol`

Formula mengacu ke `analysis_output.md` bagian metodologi appendix.

## 4) Metode Pengumpulan Data
- Laporan keuangan: IDX -> Financial Statements.
- Annual report: IDX / website emiten.
- Harga saham: IDX / Yahoo Finance (closing tahunan + bulanan).
- Checklist implementasi ada di: `output/data_collection_checklist.md`.

## 5) Konstruksi AI Disclosure Index
- Input: file teks annual report (`output/annual_reports_txt/{TICKER}_{YEAR}_AR.txt`).
- Skrip: `scripts/build_ai_disclosure_index.ps1`.
- Output: `output/ai_disclosure_index.csv`.
- Metode:
  - `aid_binary`: skor kategori biner (0-1).
  - `aid_frequency`: frekuensi kata kunci terhadap total kata.

## 6) Analisis Data dan Otomasi EViews
- Skrip utama EViews: `scripts/eviews_run.ps1`.
- Template program EViews: `scripts/eviews/panel_analysis_template.prg`.
- Output EViews:
  - Workfile: `output/eviews/panel_2019_2025.wf1`
  - Hasil persamaan: `output/eviews/*.txt`

Catatan:
- Versi saat ini otomatis menjalankan baseline, moderasi AID, dan structural break dengan pooled LS.
- Upgrade FE/RE/Hausman/robust diagnostics dapat ditambahkan setelah dataset final stabil.
