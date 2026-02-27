param(
    [Parameter(Mandatory = $false)]
    [string]$InputCsv = ".\output\idx_population_template.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutPopulationCsv = ".\output\idx_population_normalized.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutSampleTemplateCsv = ".\output\sample_selection_template.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutSummaryMd = ".\output\idx_population_summary.md",
    [Parameter(Mandatory = $false)]
    [datetime]$ListingCutoff = [datetime]"2019-01-01"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $InputCsv)) {
    throw "Input CSV not found: $InputCsv"
}

$rows = Import-Csv -Path $InputCsv
if ($rows.Count -eq 0) {
    throw "Input CSV has no data rows: $InputCsv"
}

$colMap = @{
    ticker = @("ticker","code","symbol","kode","kode_saham")
    company_name = @("company_name","name","nama_perusahaan","emiten")
    listing_date = @("listing_date","ipo_date","tanggal_pencatatan","listing")
    active_status = @("active_status","status","status_pencatatan")
    idx_ic_sector = @("idx_ic_sector","sector","sektor","idx_sector","sector_idxic")
}

function Resolve-ColumnName {
    param([string[]]$Candidates, [string[]]$Available)
    foreach ($c in $Candidates) {
        foreach ($a in $Available) {
            if ($a.ToLowerInvariant() -eq $c.ToLowerInvariant()) { return $a }
        }
    }
    return $null
}

$available = @($rows[0].PSObject.Properties.Name)
$resolved = @{}
foreach ($k in $colMap.Keys) {
    $resolved[$k] = Resolve-ColumnName -Candidates $colMap[$k] -Available $available
}

foreach ($must in @("ticker","company_name","listing_date","active_status","idx_ic_sector")) {
    if (-not $resolved[$must]) {
        throw "Missing required column for '$must'. Accepted aliases: $($colMap[$must] -join ', ')"
    }
}

$normalized = @()
foreach ($r in $rows) {
    $ticker = "$($r.$($resolved.ticker))".Trim().ToUpperInvariant()
    $name = "$($r.$($resolved.company_name))".Trim()
    $listingRaw = "$($r.$($resolved.listing_date))".Trim()
    $status = "$($r.$($resolved.active_status))".Trim()
    $sector = "$($r.$($resolved.idx_ic_sector))".Trim()

    $listingDate = $null
    $listingYear = $null
    $listingOk = $false
    try {
        $listingDate = [datetime]$listingRaw
        $listingYear = $listingDate.Year
        $listingOk = ($listingDate -le $ListingCutoff)
    } catch {}

    $normalized += [PSCustomObject]@{
        ticker = $ticker
        company_name = $name
        listing_date = if ($listingDate) { $listingDate.ToString("yyyy-MM-dd") } else { $listingRaw }
        listing_year = $listingYear
        active_status = $status
        idx_ic_sector = $sector
        listing_before_cutoff = if ($listingDate) { if ($listingOk) { 1 } else { 0 } } else { 0 }
    }
}

$outPopDir = Split-Path -Parent $OutPopulationCsv
if ($outPopDir) { New-Item -ItemType Directory -Force -Path $outPopDir | Out-Null }
$normalized | Sort-Object ticker | Export-Csv -Path $OutPopulationCsv -NoTypeInformation -Encoding UTF8

# Build sample template prefilled from population.
$sample = foreach ($r in $normalized) {
    [PSCustomObject]@{
        ticker = $r.ticker
        company_name = $r.company_name
        listing_date = $r.listing_date
        active_status = $r.active_status
        idx_ic_sector = $r.idx_ic_sector
        has_fs_2019_2025 = ""
        has_ar_2019_2025 = ""
        has_price_data = ""
        idr_reporting = ""
        include_flag = ""
        exclude_reason = ""
    }
}

$outTemplateDir = Split-Path -Parent $OutSampleTemplateCsv
if ($outTemplateDir) { New-Item -ItemType Directory -Force -Path $outTemplateDir | Out-Null }
$sample | Sort-Object ticker | Export-Csv -Path $OutSampleTemplateCsv -NoTypeInformation -Encoding UTF8

$total = $normalized.Count
$tech = @($normalized | Where-Object { $_.idx_ic_sector.ToLowerInvariant() -match "technology|teknologi" }).Count
$listedBefore = @($normalized | Where-Object { $_.listing_before_cutoff -eq 1 }).Count
$active = @($normalized | Where-Object {
    $s = $_.active_status.ToLowerInvariant()
    $s -in @("active","aktif","listed")
}).Count

$summary = @()
$summary += "# IDX Population Summary"
$summary += ""
$summary += "- Source file: $InputCsv"
$summary += "- Cutoff listing date: $($ListingCutoff.ToString('yyyy-MM-dd'))"
$summary += "- Total rows: $total"
$summary += "- Technology sector rows: $tech"
$summary += "- Listed before cutoff: $listedBefore"
$summary += "- Active/listed status rows: $active"
$summary += ""
$summary += "## Output Files"
$summary += "- $OutPopulationCsv"
$summary += "- $OutSampleTemplateCsv"

$outSummaryDir = Split-Path -Parent $OutSummaryMd
if ($outSummaryDir) { New-Item -ItemType Directory -Force -Path $outSummaryDir | Out-Null }
$summary | Set-Content -Path $OutSummaryMd

Write-Host "Wrote normalized population: $OutPopulationCsv"
Write-Host "Wrote sample template: $OutSampleTemplateCsv"
Write-Host "Wrote summary: $OutSummaryMd"
