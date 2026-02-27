param(
    [Parameter(Mandatory = $false)]
    [string]$CollectionStatus = ".\output\data_collection_master_status.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutCsv = ".\output\ai_disclosure_manual_sheet_interim.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutMd = ".\output\ai_disclosure_manual_sheet_note.md"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $CollectionStatus)) { throw "Collection status not found: $CollectionStatus" }
$rows = Import-Csv $CollectionStatus
if ($rows.Count -eq 0) { throw "Collection status empty: $CollectionStatus" }

$out = @()
foreach ($r in $rows) {
    $ticker = $r.ticker
    $year = $r.year
    $out += [PSCustomObject]@{
        ticker = $ticker
        year = $year
        ar_downloaded = $r.ar_downloaded
        ar_pdf_path = $r.ar_pdf_path
        ar_txt_path = ".\output\annual_reports_txt\${ticker}_${year}_AR.txt"
        k1_ai_core = ""
        k2_digital_tech = ""
        k3_digital_transformation = ""
        aid_binary = ""
        total_words = ""
        ai_keyword_hits = ""
        aid_frequency = ""
        coder = ""
        review_date = ""
        notes = ""
    }
}

$outDir = Split-Path -Parent $OutCsv
if ($outDir) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }
$out | Export-Csv -Path $OutCsv -NoTypeInformation -Encoding UTF8

$arReady = @($rows | Where-Object { $_.ar_downloaded -eq "1" }).Count

$md = @()
$md += "# AI Disclosure Manual Sheet Note (Interim)"
$md += ""
$md += "- Source collection status: $CollectionStatus"
$md += "- Total firm-year rows: $($rows.Count)"
$md += "- AR-ready rows currently: $arReady"
$md += "- Manual sheet output: $OutCsv"
$md += ""
$md += "## Field Guide"
$md += '- `k1_ai_core`, `k2_digital_tech`, `k3_digital_transformation`: isi 1 jika kategori terdeteksi, selain itu 0.'
$md += '- `aid_binary`: (k1+k2+k3)/3.'
$md += '- `ai_keyword_hits`: total kemunculan keyword AI dari text mining/manual count.'
$md += '- `aid_frequency`: ai_keyword_hits/total_words.'
$md += '- `coder`, `review_date`, `notes`: untuk jejak audit coding.'

$outMdDir = Split-Path -Parent $OutMd
if ($outMdDir) { New-Item -ItemType Directory -Force -Path $outMdDir | Out-Null }
$md | Set-Content -Path $OutMd

Write-Host "Wrote manual AI sheet: $OutCsv"
Write-Host "Wrote note: $OutMd"
