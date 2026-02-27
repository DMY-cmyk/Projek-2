param(
    [Parameter(Mandatory = $false)]
    [string]$PanelCsv = ".\data\processed\panel_dataset.csv",
    [Parameter(Mandatory = $false)]
    [string]$FinancialCsv = ".\data\processed\financial_master.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutMd = ".\output\data_validation_interim.md"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $PanelCsv)) { throw "Panel dataset not found: $PanelCsv" }
$panel = Import-Csv $PanelCsv
if ($panel.Count -eq 0) { throw "Panel dataset empty: $PanelCsv" }

function ToN([object]$v) {
    if ($null -eq $v) { return $null }
    $s = $v.ToString().Trim()
    if ($s -eq "") { return $null }
    $x = 0.0
    if ([double]::TryParse($s, [ref]$x)) { return $x }
    return $null
}

function Mean([double[]]$a) {
    if ($a.Count -eq 0) { return $null }
    return ($a | Measure-Object -Average).Average
}

function Std([double[]]$a) {
    if ($a.Count -lt 2) { return $null }
    $m = Mean $a
    $sum = 0.0
    foreach ($x in $a) { $sum += [Math]::Pow($x - $m, 2) }
    return [Math]::Sqrt($sum / ($a.Count - 1))
}

$numCols = @("price","ret","tq","roa","roe","npm","cr","der","tato","eps","size","growth","age","vol","aid","ii")

# Missing counts
$missing = @{}
foreach ($c in $numCols) {
    $missing[$c] = @($panel | Where-Object { $null -eq (ToN $_.$c) }).Count
}

# Outlier count (> 3 SD)
$outlierCounts = @{}
foreach ($c in $numCols) {
    $vals = @($panel | ForEach-Object { ToN $_.$c } | Where-Object { $null -ne $_ })
    if ($vals.Count -lt 3) {
        $outlierCounts[$c] = 0
        continue
    }
    $m = Mean $vals
    $s = Std $vals
    if ($null -eq $s -or $s -eq 0) {
        $outlierCounts[$c] = 0
        continue
    }
    $cnt = 0
    foreach ($v in $vals) {
        if ([Math]::Abs($v - $m) -gt (3 * $s)) { $cnt++ }
    }
    $outlierCounts[$c] = $cnt
}

# Negative checks for variables expected non-negative
$nonNegativeCols = @("cr","der","tato","eps","size","age","vol","aid","ii","price")
$negCounts = @{}
foreach ($c in $nonNegativeCols) {
    $negCounts[$c] = @($panel | Where-Object {
        $v = ToN $_.$c
        $null -ne $v -and $v -lt 0
    }).Count
}

# Accounting identity check from financial csv if available
$identityChecked = $false
$identityPass = 0
$identityFail = 0
$identityIncomplete = 0
if (Test-Path $FinancialCsv) {
    $fin = Import-Csv $FinancialCsv
    if ($fin.Count -gt 0) {
        $identityChecked = $true
        foreach ($r in $fin) {
            $a = ToN $r.total_assets
            $l = ToN $r.total_liabilities
            $e = ToN $r.total_equity
            if ($null -eq $a -or $null -eq $l -or $null -eq $e) {
                $identityIncomplete++
                continue
            }
            $delta = [Math]::Abs($a - ($l + $e))
            if ($delta -le 1e-6) { $identityPass++ } else { $identityFail++ }
        }
    }
}

$md = @()
$md += "# Data Validation Interim Report"
$md += ""
$md += "- Panel source: $PanelCsv"
$md += "- Financial source: $FinancialCsv"
$md += "- Panel rows: $($panel.Count)"
$md += "- Status: interim/pilot validation"
$md += ""
$md += "## Missing Values"
foreach ($c in $numCols) { $md += "- ${c}: $($missing[$c])" }
$md += ""
$md += "## Outlier Screening (> 3 SD)"
foreach ($c in $numCols) { $md += "- ${c}: $($outlierCounts[$c])" }
$md += ""
$md += "## Non-Negative Checks"
foreach ($c in $nonNegativeCols) { $md += "- ${c}: negative_count = $($negCounts[$c])" }
$md += ""
$md += "## Accounting Identity (Assets = Liabilities + Equity)"
if ($identityChecked) {
    $md += "- Rows passing identity: $identityPass"
    $md += "- Rows failing identity: $identityFail"
    $md += "- Rows not comparable (missing assets/liabilities/equity): $identityIncomplete"
} else {
    $md += "- Not checked (financial source not available)."
}
$md += ""
$md += "## Notes"
$md += "- This report is generated from current repository data and does not replace manual source-document cross-check."
$md += "- Final validation must be rerun after full data collection is completed."

$outDir = Split-Path -Parent $OutMd
if ($outDir) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }
$md | Set-Content -Path $OutMd

Write-Host "Wrote interim validation report: $OutMd"
