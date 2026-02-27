# Data Validation Interim Report

- Panel source: .\data\processed\panel_dataset.csv
- Financial source: .\data\processed\financial_master.csv
- Panel rows: 4
- Status: interim/pilot validation

## Missing Values
- price: 0
- ret: 2
- tq: 0
- roa: 0
- roe: 0
- npm: 0
- cr: 0
- der: 0
- tato: 0
- eps: 0
- size: 0
- growth: 2
- age: 0
- vol: 0
- aid: 0
- ii: 0

## Outlier Screening (> 3 SD)
- price: 0
- ret: 0
- tq: 0
- roa: 0
- roe: 0
- npm: 0
- cr: 0
- der: 0
- tato: 0
- eps: 0
- size: 0
- growth: 0
- age: 0
- vol: 0
- aid: 0
- ii: 0

## Non-Negative Checks
- cr: negative_count = 0
- der: negative_count = 0
- tato: negative_count = 0
- eps: negative_count = 0
- size: negative_count = 0
- age: negative_count = 0
- vol: negative_count = 0
- aid: negative_count = 0
- ii: negative_count = 0
- price: negative_count = 0

## Accounting Identity (Assets = Liabilities + Equity)
- Rows passing identity: 0
- Rows failing identity: 0
- Rows not comparable (missing assets/liabilities/equity): 189

## Notes
- This report is generated from current repository data and does not replace manual source-document cross-check.
- Final validation must be rerun after full data collection is completed.
