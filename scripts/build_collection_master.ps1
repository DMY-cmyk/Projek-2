param(
    [Parameter(Mandatory = $false)]
    [string]$SampleTemplate = ".\output\sample_selection_template.csv",
    [Parameter(Mandatory = $false)]
    [int]$StartYear = 2019,
    [Parameter(Mandatory = $false)]
    [int]$EndYear = 2025,
    [Parameter(Mandatory = $false)]
    [string]$OutMasterCsv = ".\output\data_collection_master_interim.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutCrosscheckCsv = ".\output\manual_crosscheck_10pct.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutManifestMd = ".\output\data_collection_manifest_interim.md"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $SampleTemplate)) { throw "Sample template not found: $SampleTemplate" }
$sample = Import-Csv $SampleTemplate
if ($sample.Count -eq 0) { throw "Sample template is empty: $SampleTemplate" }

# Scenario C recommended tickers (Technology + Telecommunication, strict cutoff pre-2019)
$tickers = @(
    "MTDL","LMAS","PTSN","SKYB","MLPT","ATIC","KIOS","MCAS","NFCX","DIVA","LUCK",
    "ISAT","TLKM","KBLV","CENT","EXCL","BTEL","TOWR","TBIG","SUPR","IBST","BALI","LINK","OASA","LCKM","GHON"
)

$lookup = @{}
foreach ($r in $sample) {
    if ($r.ticker) { $lookup[$r.ticker.ToUpperInvariant()] = $r }
}

$rows = @()
foreach ($t in $tickers) {
    $meta = $null
    if ($lookup.ContainsKey($t)) { $meta = $lookup[$t] }

    for ($y = $StartYear; $y -le $EndYear; $y++) {
        $rows += [PSCustomObject]@{
            firm_id = $t
            ticker = $t
            company_name = if ($null -ne $meta) { $meta.company_name } else { "" }
            year = $y
            fs_pdf_path = ".\data\raw\${t}_${y}_FS.pdf"
            ar_pdf_path = ".\data\annual_reports\${t}_${y}_AR.pdf"
            price_csv_path = ".\data\prices\prices_${t}.JK.csv"
            fs_downloaded = ""
            ar_downloaded = ""
            price_downloaded = ""
            extraction_done = ""
            notes = ""
        }
    }
}

$outDir = Split-Path -Parent $OutMasterCsv
if ($outDir) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }
$rows | Export-Csv -Path $OutMasterCsv -NoTypeInformation -Encoding UTF8

# Deterministic 10% manual cross-check sample
$total = $rows.Count
$target = [Math]::Ceiling($total * 0.10)
$cross = @()
for ($i = 0; $i -lt $rows.Count; $i += 10) {
    $cross += $rows[$i]
}
if ($cross.Count -lt $target) {
    $needed = $target - $cross.Count
    $extra = $rows | Select-Object -Last $needed
    $cross += $extra
}
$seen = @{}
$crossUnique = @()
foreach ($r in $cross) {
    $k = "{0}|{1}" -f $r.firm_id, $r.year
    if (-not $seen.ContainsKey($k)) {
        $seen[$k] = $true
        $crossUnique += $r
    }
}
$cross = $crossUnique
$cross | Export-Csv -Path $OutCrosscheckCsv -NoTypeInformation -Encoding UTF8

$md = @()
$md += "# Data Collection Manifest (Interim)"
$md += ""
$md += "- Scenario: Technology + Telecommunication (strict cutoff pre-2019)"
$md += "- Firms: $($tickers.Count)"
$md += "- Period: $StartYear-$EndYear"
$md += "- Expected firm-year rows: $($rows.Count)"
$md += "- Manual cross-check target (10%): $target"
$md += "- Manual cross-check rows generated: $($cross.Count)"
$md += ""
$md += "## Output Files"
$md += "- Master collection sheet: $OutMasterCsv"
$md += "- Cross-check 10% sheet: $OutCrosscheckCsv"
$md += ""
$md += "## Notes"
$md += '- Fill `fs_downloaded`, `ar_downloaded`, `price_downloaded`, and `extraction_done` with 1/0.'
$md += "- Update notes for missing documents, ticker changes, or reporting-currency issues."

$manifestDir = Split-Path -Parent $OutManifestMd
if ($manifestDir) { New-Item -ItemType Directory -Force -Path $manifestDir | Out-Null }
$md | Set-Content -Path $OutManifestMd

Write-Host "Wrote master sheet: $OutMasterCsv"
Write-Host "Wrote cross-check sample: $OutCrosscheckCsv"
Write-Host "Wrote manifest: $OutManifestMd"
