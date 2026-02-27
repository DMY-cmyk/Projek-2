param(
    [Parameter(Mandatory = $false)]
    [string]$StatusCsv = ".\output\data_collection_master_status.csv",
    [Parameter(Mandatory = $false)]
    [int]$BatchSize = 5,
    [Parameter(Mandatory = $false)]
    [string]$OutMd = ".\output\daily_collection_batch.md"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $StatusCsv)) { throw "Status CSV not found: $StatusCsv" }
$rows = Import-Csv $StatusCsv
if ($rows.Count -eq 0) { throw "Status CSV is empty: $StatusCsv" }

# Score each ticker by remaining missing rows (FS/AR/Price).
$byTicker = @{}
foreach ($r in $rows) {
    $t = $r.ticker.ToUpperInvariant()
    if (-not $byTicker.ContainsKey($t)) {
        $byTicker[$t] = [PSCustomObject]@{
            ticker = $t
            company_name = $r.company_name
            missing_fs = 0
            missing_ar = 0
            missing_price = 0
            total_rows = 0
        }
    }
    $o = $byTicker[$t]
    if ($r.fs_downloaded -ne "1") { $o.missing_fs++ }
    if ($r.ar_downloaded -ne "1") { $o.missing_ar++ }
    if ($r.price_downloaded -ne "1") { $o.missing_price++ }
    $o.total_rows++
}

$ranked = @($byTicker.Values | Sort-Object -Property @{Expression={ $_.missing_fs + $_.missing_ar + $_.missing_price };Descending=$true}, ticker)
$batch = @($ranked | Select-Object -First $BatchSize)

$md = @()
$md += "# Daily Collection Batch"
$md += ""
$md += "- Source: $StatusCsv"
$md += "- Batch size: $($batch.Count)"
$md += ""
$md += "| Ticker | Company | Missing FS | Missing AR | Missing Price |"
$md += "|---|---|---:|---:|---:|"
foreach ($b in $batch) {
    $md += "| $($b.ticker) | $($b.company_name) | $($b.missing_fs) | $($b.missing_ar) | $($b.missing_price) |"
}
$md += ""
$md += "## Execution Checklist (Today)"
$md += "1. Download FS PDFs for selected tickers (2019-2025) to `data/raw/`."
$md += "2. Download AR PDFs for selected tickers (2019-2025) to `data/annual_reports/`."
$md += "3. Download/prepare price CSV for selected tickers in `data/prices/`."
$md += "4. Run `scripts/refresh_operational_dashboard.ps1`."
$md += "5. Confirm queue shrink in `output/download_queue_summary.md`."

$outDir = Split-Path -Parent $OutMd
if ($outDir) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }
$md | Set-Content -Path $OutMd

Write-Host "Wrote daily batch: $OutMd"
