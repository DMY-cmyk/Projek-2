param(
    [Parameter(Mandatory = $false)]
    [string]$SampleTemplate = ".\output\sample_selection_template.csv",
    [Parameter(Mandatory = $false)]
    [string]$CollectionStatus = ".\output\data_collection_master_status.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutCsv = ".\output\sample_selection_result_interim.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutSummaryMd = ".\output\sample_selection_interim_summary.md"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $SampleTemplate)) { throw "Sample template not found: $SampleTemplate" }
if (-not (Test-Path $CollectionStatus)) { throw "Collection status not found: $CollectionStatus" }

$sample = Import-Csv $SampleTemplate
$status = Import-Csv $CollectionStatus

# Aggregate availability by ticker over all years.
$agg = @{}
foreach ($r in $status) {
    $t = $r.ticker.ToUpperInvariant()
    if (-not $agg.ContainsKey($t)) {
        $agg[$t] = [PSCustomObject]@{
            ticker = $t
            fs_ok = $true
            ar_ok = $true
            px_ok = $true
            years = 0
        }
    }
    $obj = $agg[$t]
    if ($r.fs_downloaded -ne "1") { $obj.fs_ok = $false }
    if ($r.ar_downloaded -ne "1") { $obj.ar_ok = $false }
    if ($r.price_downloaded -ne "1") { $obj.px_ok = $false }
    $obj.years++
}

$rows = @()
foreach ($r in $sample) {
    $t = $r.ticker.ToUpperInvariant()
    $hasFs = "0"
    $hasAr = "0"
    $hasPx = "0"
    if ($agg.ContainsKey($t)) {
        $hasFs = if ($agg[$t].fs_ok) { "1" } else { "0" }
        $hasAr = if ($agg[$t].ar_ok) { "1" } else { "0" }
        $hasPx = if ($agg[$t].px_ok) { "1" } else { "0" }
    }

    $isIdr = if ($r.idr_reporting -eq "1") { "1" } else { "0" }
    if ([string]::IsNullOrWhiteSpace($r.idr_reporting)) { $isIdr = "0" }

    $listingOk = $false
    try {
        $d = [datetime]::Parse($r.listing_date)
        $listingOk = ($d -lt [datetime]"2019-01-01")
    } catch {}

    $sectorOk = ($r.idx_ic_sector -eq "Technology")

    $reasons = @()
    if (-not $sectorOk) { $reasons += "non_technology_sector" }
    if (-not $listingOk) { $reasons += "listing_after_cutoff" }
    if ($hasFs -ne "1") { $reasons += "incomplete_financial_statements" }
    if ($hasAr -ne "1") { $reasons += "incomplete_annual_reports" }
    if ($hasPx -ne "1") { $reasons += "missing_price_data" }
    if ($isIdr -ne "1") { $reasons += "non_idr_reporting" }

    $include = if ($reasons.Count -eq 0) { "1" } else { "0" }

    $rows += [PSCustomObject]@{
        ticker = $r.ticker
        company_name = $r.company_name
        listing_date = $r.listing_date
        active_status = $r.active_status
        idx_ic_sector = $r.idx_ic_sector
        has_fs_2019_2025 = $hasFs
        has_ar_2019_2025 = $hasAr
        has_price_data = $hasPx
        idr_reporting = $isIdr
        include_flag = $include
        exclude_reason = ($reasons -join ";")
    }
}

$outDir = Split-Path -Parent $OutCsv
if ($outDir) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }
$rows | Export-Csv -Path $OutCsv -NoTypeInformation -Encoding UTF8

$included = @($rows | Where-Object { $_.include_flag -eq "1" }).Count
$excluded = @($rows | Where-Object { $_.include_flag -eq "0" }).Count

$reasonMap = @{}
foreach ($r in $rows) {
    if ([string]::IsNullOrWhiteSpace($r.exclude_reason)) { continue }
    foreach ($reason in ($r.exclude_reason -split ";")) {
        if ([string]::IsNullOrWhiteSpace($reason)) { continue }
        if (-not $reasonMap.ContainsKey($reason)) { $reasonMap[$reason] = 0 }
        $reasonMap[$reason]++
    }
}

$md = @()
$md += "# Sample Selection Interim Summary"
$md += ""
$md += "- Source sample template: $SampleTemplate"
$md += "- Source collection status: $CollectionStatus"
$md += "- Output sample result: $OutCsv"
$md += ""
$md += "## Counts"
$md += "- Total candidates: $($rows.Count)"
$md += "- Included: $included"
$md += "- Excluded: $excluded"
$md += ""
$md += "## Exclusion Reasons"
foreach ($k in ($reasonMap.Keys | Sort-Object)) {
    $md += "- ${k}: $($reasonMap[$k])"
}

$outSummaryDir = Split-Path -Parent $OutSummaryMd
if ($outSummaryDir) { New-Item -ItemType Directory -Force -Path $outSummaryDir | Out-Null }
$md | Set-Content -Path $OutSummaryMd

Write-Host "Wrote sample result: $OutCsv"
Write-Host "Wrote summary: $OutSummaryMd"
