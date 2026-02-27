param(
    [Parameter(Mandatory = $false)]
    [string]$OutModelDecision = ".\output\model_selection_decision_template.md",
    [Parameter(Mandatory = $false)]
    [string]$OutRegressionCsv = ".\output\regression_reporting_template.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutInteractionMd = ".\output\interaction_interpretation_template.md",
    [Parameter(Mandatory = $false)]
    [string]$OutGmmMd = ".\output\system_gmm_preparation_note.md"
)

$ErrorActionPreference = "Stop"

# 1) Model selection decision template
$md1 = @()
$md1 += "# Model Selection Decision Template"
$md1 += ""
$md1 += "## Inputs"
$md1 += "- Chow/F-test result:"
$md1 += "- Hausman test result:"
$md1 += "- LM/Breusch-Pagan random effect test (optional):"
$md1 += ""
$md1 += "## Decision Matrix"
$md1 += "| Test | H0 | p-value | Decision Rule | Result |"
$md1 += "|---|---|---:|---|---|"
$md1 += "| Chow/F-test | Pooled OLS adequate |  | p<0.05 -> FE preferred |  |"
$md1 += "| Hausman | RE consistent |  | p<0.05 -> FE preferred; else RE |  |"
$md1 += "| LM test (optional) | Pooled adequate |  | p<0.05 -> RE/FE over pooled |  |"
$md1 += ""
$md1 += "## Final Model Choice"
$md1 += "- Chosen model for baseline:"
$md1 += "- Entity fixed effects used (Yes/No):"
$md1 += "- Time fixed effects used (Yes/No):"
$md1 += "- Justification:"

$dir1 = Split-Path -Parent $OutModelDecision
if ($dir1) { New-Item -ItemType Directory -Force -Path $dir1 | Out-Null }
$md1 | Set-Content -Path $OutModelDecision

# 2) 9-regression reporting template
$models = @(
    "Model 1a PRICE Baseline",
    "Model 1b RET Baseline",
    "Model 1c TQ Baseline",
    "Model 2a PRICE Moderasi AID",
    "Model 2b RET Moderasi AID",
    "Model 2c TQ Moderasi AID",
    "Model 3a PRICE Structural Break",
    "Model 3b RET Structural Break",
    "Model 3c TQ Structural Break"
)

$regRows = @()
foreach ($m in $models) {
    $regRows += [PSCustomObject]@{
        model = $m
        dependent = ""
        key_variables = ""
        coef_summary = ""
        t_or_z_stat = ""
        p_value = ""
        r_squared = ""
        adjusted_r_squared = ""
        f_stat = ""
        n_obs = ""
        interpretation = ""
    }
}

$dir2 = Split-Path -Parent $OutRegressionCsv
if ($dir2) { New-Item -ItemType Directory -Force -Path $dir2 | Out-Null }
$regRows | Export-Csv -Path $OutRegressionCsv -NoTypeInformation -Encoding UTF8

# 3) Interaction interpretation template
$md3 = @()
$md3 += "# Interaction Interpretation Template"
$md3 += ""
$md3 += "## AID Interaction (X x AID)"
$md3 += "| Model | Interaction Term | Coef | p-value | Direction | Interpretation |"
$md3 += "|---|---|---:|---:|---|---|"
$md3 += "| 2a |  |  |  |  |  |"
$md3 += "| 2b |  |  |  |  |  |"
$md3 += "| 2c |  |  |  |  |  |"
$md3 += ""
$md3 += "## DGENAI Interaction (X x DGENAI)"
$md3 += "| Model | Interaction Term | Coef | p-value | Direction | Interpretation |"
$md3 += "|---|---|---:|---:|---|---|"
$md3 += "| 3a |  |  |  |  |  |"
$md3 += "| 3b |  |  |  |  |  |"
$md3 += "| 3c |  |  |  |  |  |"
$md3 += ""
$md3 += "## Overfitting Check Notes"
$md3 += "- Apakah perlu reduksi interaksi ke 2-3 rasio utama?"
$md3 += "- Kriteria reduksi: multikolinearitas, stabilitas koefisien, dan teori."

$dir3 = Split-Path -Parent $OutInteractionMd
if ($dir3) { New-Item -ItemType Directory -Force -Path $dir3 | Out-Null }
$md3 | Set-Content -Path $OutInteractionMd

# 4) System GMM preparation note
$md4 = @()
$md4 += "# System GMM Preparation Note"
$md4 += ""
$md4 += "## Minimum Data Readiness"
$md4 += "- Panel dimensions memadai (N dan T cukup)."
$md4 += "- Variabel dependen dan lag tersedia tanpa missing berat."
$md4 += "- Definisi instrumen internal (lag dependent/endogenous regressors) disepakati."
$md4 += ""
$md4 += "## Diagnostic Targets"
$md4 += "- AR(1): diharapkan signifikan."
$md4 += "- AR(2): diharapkan tidak signifikan."
$md4 += "- Hansen/Sargan: validitas instrumen memadai."
$md4 += ""
$md4 += "## Execution Plan"
$md4 += "1. Jalankan baseline FE/RE final terlebih dahulu."
$md4 += "2. Tetapkan variabel endogen/predetermined."
$md4 += "3. Estimasi System GMM dan dokumentasikan diagnostics."
$md4 += "4. Bandingkan arah/signifikansi dengan model utama."

$dir4 = Split-Path -Parent $OutGmmMd
if ($dir4) { New-Item -ItemType Directory -Force -Path $dir4 | Out-Null }
$md4 | Set-Content -Path $OutGmmMd

Write-Host "Wrote model decision template: $OutModelDecision"
Write-Host "Wrote regression reporting template: $OutRegressionCsv"
Write-Host "Wrote interaction interpretation template: $OutInteractionMd"
Write-Host "Wrote System GMM preparation note: $OutGmmMd"
