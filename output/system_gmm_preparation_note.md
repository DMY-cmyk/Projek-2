# System GMM Preparation Note

## Minimum Data Readiness
- Panel dimensions memadai (N dan T cukup).
- Variabel dependen dan lag tersedia tanpa missing berat.
- Definisi instrumen internal (lag dependent/endogenous regressors) disepakati.

## Diagnostic Targets
- AR(1): diharapkan signifikan.
- AR(2): diharapkan tidak signifikan.
- Hansen/Sargan: validitas instrumen memadai.

## Execution Plan
1. Jalankan baseline FE/RE final terlebih dahulu.
2. Tetapkan variabel endogen/predetermined.
3. Estimasi System GMM dan dokumentasikan diagnostics.
4. Bandingkan arah/signifikansi dengan model utama.
