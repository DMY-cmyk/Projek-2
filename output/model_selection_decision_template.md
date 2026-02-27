# Model Selection Decision Template

## Inputs
- Chow/F-test result:
- Hausman test result:
- LM/Breusch-Pagan random effect test (optional):

## Decision Matrix
| Test | H0 | p-value | Decision Rule | Result |
|---|---|---:|---|---|
| Chow/F-test | Pooled OLS adequate |  | p<0.05 -> FE preferred |  |
| Hausman | RE consistent |  | p<0.05 -> FE preferred; else RE |  |
| LM test (optional) | Pooled adequate |  | p<0.05 -> RE/FE over pooled |  |

## Final Model Choice
- Chosen model for baseline:
- Entity fixed effects used (Yes/No):
- Time fixed effects used (Yes/No):
- Justification:
