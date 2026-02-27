# Preliminary Analysis Note (Template Dataset)

- Dataset used: `data/processed/panel_dataset.csv`
- Observation count: 4 firm-year rows (2 firms x 2 years)
- Purpose: pipeline validation and early diagnostic write-up, not final inferential result

## Descriptive Interpretation

- `PRICE` ranges from 850 to 1120, with mean 970 and moderate dispersion (std. dev. 117.47).
- `TQ` ranges from 850.47 to 1018.57, indicating similar directional movement with `PRICE` in the template data.
- Profitability ratios (`ROA`, `ROE`, `NPM`) are all positive across all observations.
- `AID` spans 0.00 to 0.66, showing variation in AI disclosure score across firm-year observations.
- `RET` and `GROWTH` each have only 2 non-missing observations, so any inference for these variables is highly unstable.

## Correlation Screening (|r| > 0.8)

- Pairwise correlations are very high for many variable pairs (including near-perfect values), indicating severe multicollinearity risk.
- This pattern is expected with very small sample size and mechanically related accounting variables.
- Action for final dataset stage: reduce overlapping predictors (e.g., avoid including highly collinear profitability ratios together) or run model variants.

## Model/Assumption Implication

- Assumption test automation reports failure for full inferential testing due to insufficient effective sample and singularity risk.
- Therefore, model-selection decisions (Pooled vs FE vs RE) remain pending until the full real dataset is collected.
