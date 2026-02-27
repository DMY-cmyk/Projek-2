param(
    [Parameter(Mandatory = $false)]
    [string]$StatusCsv = ".\output\data_collection_master_status.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutFsCsv = ".\output\download_queue_fs.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutArCsv = ".\output\download_queue_ar.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutPriceCsv = ".\output\download_queue_price.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutSummaryMd = ".\output\download_queue_summary.md"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $StatusCsv)) { throw "Status CSV not found: $StatusCsv" }
$rows = Import-Csv $StatusCsv
if ($rows.Count -eq 0) { throw "Status CSV is empty: $StatusCsv" }

$fsQueue = @($rows | Where-Object { $_.fs_downloaded -ne "1" } | ForEach-Object {
    [PSCustomObject]@{
        ticker = $_.ticker
        year = $_.year
        company_name = $_.company_name
        expected_fs_pdf = $_.fs_pdf_path
        source_hint = "IDX Listed Companies > Financial Statements"
    }
})

$arQueue = @($rows | Where-Object { $_.ar_downloaded -ne "1" } | ForEach-Object {
    [PSCustomObject]@{
        ticker = $_.ticker
        year = $_.year
        company_name = $_.company_name
        expected_ar_pdf = $_.ar_pdf_path
        source_hint = "IDX / Company website > Annual Report"
    }
})

$priceQueue = @($rows | Where-Object { $_.price_downloaded -ne "1" } | ForEach-Object {
    [PSCustomObject]@{
        ticker = $_.ticker
        year = $_.year
        company_name = $_.company_name
        expected_price_csv = $_.price_csv_path
        yahoo_symbol = "$($_.ticker).JK"
        source_hint = "Yahoo Finance / IDX price history"
    }
})

$outDir = Split-Path -Parent $OutFsCsv
if ($outDir) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }

$fsQueue | Export-Csv -Path $OutFsCsv -NoTypeInformation -Encoding UTF8
$arQueue | Export-Csv -Path $OutArCsv -NoTypeInformation -Encoding UTF8
$priceQueue | Export-Csv -Path $OutPriceCsv -NoTypeInformation -Encoding UTF8

$md = @()
$md += "# Download Queue Summary"
$md += ""
$md += "- Source status CSV: $StatusCsv"
$md += "- FS queue rows: $($fsQueue.Count)"
$md += "- AR queue rows: $($arQueue.Count)"
$md += "- Price queue rows: $($priceQueue.Count)"
$md += ""
$md += "## Queue Files"
$md += "- FS queue: $OutFsCsv"
$md += "- AR queue: $OutArCsv"
$md += "- Price queue: $OutPriceCsv"
$md += ""
$md += "## Usage"
$md += "- Mark completion by placing files in expected paths and rerun availability script."
$md += "- Then rerun this queue script to shrink pending rows."

$summaryDir = Split-Path -Parent $OutSummaryMd
if ($summaryDir) { New-Item -ItemType Directory -Force -Path $summaryDir | Out-Null }
$md | Set-Content -Path $OutSummaryMd

Write-Host "Wrote FS queue: $OutFsCsv"
Write-Host "Wrote AR queue: $OutArCsv"
Write-Host "Wrote Price queue: $OutPriceCsv"
Write-Host "Wrote summary: $OutSummaryMd"
