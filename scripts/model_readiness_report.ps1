param(
    [Parameter(Mandatory = $false)]
    [string]$EViewsSummary = ".\output\eviews\eviews_run_summary.md",
    [Parameter(Mandatory = $false)]
    [string]$PanelCsv = ".\data\processed\panel_dataset.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutMd = ".\output/model_readiness_report.md"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $PanelCsv)) { throw "Panel dataset not found: $PanelCsv" }
$rows = Import-Csv $PanelCsv

function ToN([object]$v) {
    if ($null -eq $v) { return $null }
    $s = $v.ToString().Trim()
    if ($s -eq "") { return $null }
    $x = 0.0
    if ([double]::TryParse($s, [ref]$x)) { return $x }
    return $null
}

$nRows = $rows.Count
$nFirm = @($rows | Select-Object -ExpandProperty firm_id -Unique).Count
$nYear = @($rows | Select-Object -ExpandProperty year -Unique).Count

$retNonMissing = @($rows | Where-Object { $null -ne (ToN $_.ret) }).Count
$growthNonMissing = @($rows | Where-Object { $null -ne (ToN $_.growth) }).Count

$summaryLines = @()
if (Test-Path $EViewsSummary) {
    $summaryLines = Get-Content $EViewsSummary
}

$hasInsufficientObs = $false
$failedSteps = 0
$okSteps = 0
foreach ($ln in $summaryLines) {
    if ($ln -match "Insufficient number of observations") { $hasInsufficientObs = $true }
    if ($ln -match "Successful steps:\s+(\d+)") { $okSteps = [int]$matches[1] }
    if ($ln -match "Failed steps:\s+(\d+)") { $failedSteps = [int]$matches[1] }
}

$ready = $true
$reasons = @()
if ($nRows -lt 30) { $ready = $false; $reasons += "Total panel rows too low ($nRows)." }
if ($nFirm -lt 10) { $ready = $false; $reasons += "Firm count too low ($nFirm)." }
if ($nYear -lt 4) { $ready = $false; $reasons += "Year coverage too low ($nYear)." }
if ($retNonMissing -lt 10) { $ready = $false; $reasons += "RET non-missing observations too low ($retNonMissing)." }
if ($growthNonMissing -lt 10) { $ready = $false; $reasons += "GROWTH non-missing observations too low ($growthNonMissing)." }
if ($hasInsufficientObs) { $ready = $false; $reasons += "EViews summary shows insufficient observations." }

$md = @()
$md += "# Model Readiness Report"
$md += ""
$md += "- Panel dataset: $PanelCsv"
$md += "- EViews summary: $EViewsSummary"
$md += "- Panel rows: $nRows"
$md += "- Unique firms: $nFirm"
$md += "- Unique years: $nYear"
$md += "- RET non-missing rows: $retNonMissing"
$md += "- GROWTH non-missing rows: $growthNonMissing"
$md += "- EViews successful steps: $okSteps"
$md += "- EViews failed steps: $failedSteps"
$md += ""
$md += "## Readiness Verdict"
$md += "- Ready for full 9-model estimation: $ready"
if ($reasons.Count -gt 0) {
    $md += ""
    $md += "## Blocking Reasons"
    foreach ($r in $reasons) { $md += "- $r" }
}
$md += ""
$md += "## Required Next Actions"
$md += "- Complete manual data collection and fill financial/price/annual-report availability flags."
$md += "- Rebuild `data/processed/panel_dataset.csv` after master sheets are complete."
$md += "- Re-run EViews model pipeline and hypothesis extraction."

$outDir = Split-Path -Parent $OutMd
if ($outDir) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }
$md | Set-Content -Path $OutMd

Write-Host "Wrote model readiness report: $OutMd"
