param(
    [Parameter(Mandatory = $false)]
    [string]$MasterCsv = ".\output\data_collection_master_interim.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutStatusCsv = ".\output\data_collection_master_status.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutReportMd = ".\output\data_collection_availability_report.md"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $MasterCsv)) { throw "Master CSV not found: $MasterCsv" }
$rows = Import-Csv $MasterCsv
if ($rows.Count -eq 0) { throw "Master CSV is empty: $MasterCsv" }

function Resolve-RelPath([string]$p) {
    if ([string]::IsNullOrWhiteSpace($p)) { return $null }
    $trim = $p.Trim()
    if ($trim.StartsWith(".\")) {
        $trim = $trim.Substring(2)
    }
    return (Join-Path (Get-Location) $trim)
}

$updated = @()
foreach ($r in $rows) {
    $fs = Resolve-RelPath $r.fs_pdf_path
    $ar = Resolve-RelPath $r.ar_pdf_path
    $px = Resolve-RelPath $r.price_csv_path

    $fsOk = if ($fs -and (Test-Path $fs)) { "1" } else { "0" }
    $arOk = if ($ar -and (Test-Path $ar)) { "1" } else { "0" }
    $pxOk = if ($px -and (Test-Path $px)) { "1" } else { "0" }

    $updated += [PSCustomObject]@{
        firm_id = $r.firm_id
        ticker = $r.ticker
        company_name = $r.company_name
        year = $r.year
        fs_pdf_path = $r.fs_pdf_path
        ar_pdf_path = $r.ar_pdf_path
        price_csv_path = $r.price_csv_path
        fs_downloaded = $fsOk
        ar_downloaded = $arOk
        price_downloaded = $pxOk
        extraction_done = if ($r.extraction_done) { $r.extraction_done } else { "" }
        notes = if ($r.notes) { $r.notes } else { "" }
    }
}

$outStatusDir = Split-Path -Parent $OutStatusCsv
if ($outStatusDir) { New-Item -ItemType Directory -Force -Path $outStatusDir | Out-Null }
$updated | Export-Csv -Path $OutStatusCsv -NoTypeInformation -Encoding UTF8

$total = $updated.Count
$fsCount = @($updated | Where-Object { $_.fs_downloaded -eq "1" }).Count
$arCount = @($updated | Where-Object { $_.ar_downloaded -eq "1" }).Count
$pxCount = @($updated | Where-Object { $_.price_downloaded -eq "1" }).Count
$fullCount = @($updated | Where-Object {
    $_.fs_downloaded -eq "1" -and $_.ar_downloaded -eq "1" -and $_.price_downloaded -eq "1"
}).Count

$missingFs = @($updated | Where-Object { $_.fs_downloaded -eq "0" })
$missingAr = @($updated | Where-Object { $_.ar_downloaded -eq "0" })
$missingPx = @($updated | Where-Object { $_.price_downloaded -eq "0" })

$md = @()
$md += "# Data Collection Availability Report (Interim)"
$md += ""
$md += "- Master source: $MasterCsv"
$md += "- Status output: $OutStatusCsv"
$md += "- Total firm-year rows: $total"
$md += ""
$md += "## Completion Summary"
$md += "- Financial statement PDFs available: $fsCount / $total"
$md += "- Annual report PDFs available: $arCount / $total"
$md += "- Price CSV files available: $pxCount / $total"
$md += "- Fully complete rows (FS + AR + Price): $fullCount / $total"
$md += ""
$md += "## Missing File Counters"
$md += "- Missing FS rows: $($missingFs.Count)"
$md += "- Missing AR rows: $($missingAr.Count)"
$md += "- Missing Price rows: $($missingPx.Count)"
$md += ""
$md += "## Next Action"
$md += "- Prioritize file collection and rerun this script to refresh status."

$outReportDir = Split-Path -Parent $OutReportMd
if ($outReportDir) { New-Item -ItemType Directory -Force -Path $outReportDir | Out-Null }
$md | Set-Content -Path $OutReportMd

Write-Host "Wrote status CSV: $OutStatusCsv"
Write-Host "Wrote availability report: $OutReportMd"
