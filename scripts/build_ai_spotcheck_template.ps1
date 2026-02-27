param(
    [Parameter(Mandatory = $false)]
    [string]$MasterCsv = ".\output\data_collection_master_status.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutCsv = ".\output\ai_disclosure_spotcheck_10pct.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutMd = ".\output\ai_disclosure_spotcheck_note.md"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $MasterCsv)) { throw "Master status CSV not found: $MasterCsv" }
$rows = Import-Csv $MasterCsv
if ($rows.Count -eq 0) { throw "Master status CSV empty: $MasterCsv" }

# Build deterministic 10% sample from master rows.
$target = [Math]::Ceiling($rows.Count * 0.10)
$pick = @()
if ($target -gt 0) {
    for ($i = 0; $i -lt $rows.Count; $i += 10) {
        $pick += $rows[$i]
    }
    if ($pick.Count -lt $target) {
        $need = $target - $pick.Count
        $pick += ($rows | Select-Object -Last $need)
    }
}

$out = @()
foreach ($r in $pick) {
    $ticker = $r.ticker
    $year = $r.year
    $txtPath = ".\output\annual_reports_txt\${ticker}_${year}_AR.txt"
    $out += [PSCustomObject]@{
        ticker = $ticker
        year = $year
        ar_pdf_path = $r.ar_pdf_path
        ar_txt_path = $txtPath
        ar_downloaded = $r.ar_downloaded
        ai_keyword_hits_auto = ""
        ai_keyword_hits_manual = ""
        match_flag = ""
        reviewer_note = ""
    }
}

$outDir = Split-Path -Parent $OutCsv
if ($outDir) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }
if ($out.Count -gt 0) {
    $out | Export-Csv -Path $OutCsv -NoTypeInformation -Encoding UTF8
} else {
    "ticker,year,ar_pdf_path,ar_txt_path,ar_downloaded,ai_keyword_hits_auto,ai_keyword_hits_manual,match_flag,reviewer_note" | Set-Content -Path $OutCsv
}

$md = @()
$md += "# AI Disclosure Spot-Check Note (10%)"
$md += ""
$md += "- Source status file: $MasterCsv"
$arReadyCount = @($rows | Where-Object { $_.ar_downloaded -eq "1" }).Count
$md += "- Total master rows: $($rows.Count)"
$md += "- AR-ready rows (current): $arReadyCount"
$md += "- Spot-check rows generated (10%): $($out.Count)"
$md += "- Spot-check file: $OutCsv"
$md += ""
$md += "## Usage"
$md += '- Fill `ai_keyword_hits_auto` from text-mining output.'
$md += '- Fill `ai_keyword_hits_manual` from manual read.'
$md += '- Set `match_flag` to 1 if aligned, else 0.'
$md += '- Record discrepancy in `reviewer_note`.'

$outMdDir = Split-Path -Parent $OutMd
if ($outMdDir) { New-Item -ItemType Directory -Force -Path $outMdDir | Out-Null }
$md | Set-Content -Path $OutMd

Write-Host "Wrote spot-check CSV: $OutCsv"
Write-Host "Wrote spot-check note: $OutMd"
