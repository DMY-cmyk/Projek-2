param(
    [Parameter(Mandatory = $false)]
    [string]$InputCsv = ".\output\sample_selection_template.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutCsv = ".\output\sample_selection_result.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutSummaryMd = ".\output\sample_estimation.md",
    [Parameter(Mandatory = $false)]
    [datetime]$ListingCutoff = [datetime]"2019-01-01",
    [Parameter(Mandatory = $false)]
    [switch]$RelaxListingTo2020
)

$ErrorActionPreference = "Stop"

function Parse-Bool {
    param([object]$v)
    if ($null -eq $v) { return $false }
    $s = $v.ToString().Trim().ToLowerInvariant()
    return @("1","true","yes","y","ok") -contains $s
}

if ($RelaxListingTo2020) {
    $ListingCutoff = [datetime]"2020-01-01"
}

if (-not (Test-Path $InputCsv)) {
    throw "Input CSV not found: $InputCsv"
}

$rows = Import-Csv -Path $InputCsv
$required = @(
    "ticker","company_name","listing_date","active_status","idx_ic_sector",
    "has_fs_2019_2025","has_ar_2019_2025","has_price_data","idr_reporting"
)

if ($rows.Count -gt 0) {
    $cols = @($rows[0].PSObject.Properties.Name | ForEach-Object { $_.ToLowerInvariant() })
    $missing = @()
    foreach ($c in $required) {
        if ($cols -notcontains $c.ToLowerInvariant()) { $missing += $c }
    }
    if ($missing.Count -gt 0) {
        throw "Missing required columns: $($missing -join ', ')"
    }
}

$out = @()
foreach ($r in $rows) {
    $reasons = @()

    $sector = "$($r.idx_ic_sector)".Trim().ToLowerInvariant()
    if ($sector -notmatch "technology|teknologi") {
        $reasons += "non_technology_sector"
    }

    $listingOk = $false
    try {
        $ld = [datetime]$r.listing_date
        if ($ld -le $ListingCutoff) { $listingOk = $true }
    } catch {
        $reasons += "invalid_listing_date"
    }
    if (-not $listingOk -and $reasons -notcontains "invalid_listing_date") {
        $reasons += "listing_after_cutoff"
    }

    $active = "$($r.active_status)".Trim().ToLowerInvariant()
    if ($active -notin @("active","aktif","listed")) {
        $reasons += "inactive_or_delisted"
    }

    if (-not (Parse-Bool $r.has_fs_2019_2025)) { $reasons += "incomplete_financial_statements" }
    if (-not (Parse-Bool $r.has_ar_2019_2025)) { $reasons += "incomplete_annual_reports" }
    if (-not (Parse-Bool $r.has_price_data)) { $reasons += "missing_price_data" }
    if (-not (Parse-Bool $r.idr_reporting)) { $reasons += "non_idr_reporting" }

    $include = if ($reasons.Count -eq 0) { 1 } else { 0 }

    $out += [PSCustomObject]@{
        ticker = $r.ticker
        company_name = $r.company_name
        listing_date = $r.listing_date
        active_status = $r.active_status
        idx_ic_sector = $r.idx_ic_sector
        has_fs_2019_2025 = $r.has_fs_2019_2025
        has_ar_2019_2025 = $r.has_ar_2019_2025
        has_price_data = $r.has_price_data
        idr_reporting = $r.idr_reporting
        include_flag = $include
        exclude_reason = ($reasons -join ";")
    }
}

$outDir = Split-Path -Parent $OutCsv
if ($outDir) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }
if ($out.Count -eq 0) {
    @(
        "ticker,company_name,listing_date,active_status,idx_ic_sector,has_fs_2019_2025,has_ar_2019_2025,has_price_data,idr_reporting,include_flag,exclude_reason"
    ) | Set-Content -Path $OutCsv
} else {
    $out | Export-Csv -Path $OutCsv -NoTypeInformation -Encoding UTF8
}

$total = $out.Count
$included = @($out | Where-Object { $_.include_flag -eq 1 }).Count
$excluded = $total - $included

$reasonStats = @{}
foreach ($row in $out | Where-Object { $_.include_flag -eq 0 }) {
    $parts = "$($row.exclude_reason)".Split(";") | Where-Object { $_ -ne "" }
    foreach ($p in $parts) {
        if (-not $reasonStats.ContainsKey($p)) { $reasonStats[$p] = 0 }
        $reasonStats[$p] += 1
    }
}

$summary = @()
$summary += "# Sample Estimation Summary"
$summary += ""
$summary += "Cutoff listing date: $($ListingCutoff.ToString('yyyy-MM-dd'))"
$summary += ""
$summary += "- Total candidates: $total"
$summary += "- Included: $included"
$summary += "- Excluded: $excluded"
$summary += ""
$summary += "## Exclusion Reasons"
if ($reasonStats.Keys.Count -eq 0) {
    $summary += "- None"
} else {
    foreach ($k in ($reasonStats.Keys | Sort-Object)) {
        $summary += "- ${k}: $($reasonStats[$k])"
    }
}

$outSummaryDir = Split-Path -Parent $OutSummaryMd
if ($outSummaryDir) { New-Item -ItemType Directory -Force -Path $outSummaryDir | Out-Null }
$summary | Set-Content -Path $OutSummaryMd

Write-Host "Wrote: $OutCsv"
Write-Host "Wrote: $OutSummaryMd"
