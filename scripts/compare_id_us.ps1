param(
    [Parameter(Mandatory = $false)]
    [string]$IdCsv = ".\data\processed\panel_dataset.csv",
    [Parameter(Mandatory = $false)]
    [string]$UsDir = ".\data\sec_cache",
    [Parameter(Mandatory = $false)]
    [int]$StartYear = 2019,
    [Parameter(Mandatory = $false)]
    [int]$EndYear = 2025,
    [Parameter(Mandatory = $false)]
    [string]$OutUsCsv = ".\output\us_sec_ratios_2019_2025.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutStatsMd = ".\output\us_id_descriptive_comparison.md",
    [Parameter(Mandatory = $false)]
    [string]$OutNarrativeMd = ".\output\us_id_context_discussion.md"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $IdCsv)) { throw "Indonesia dataset not found: $IdCsv" }
if (-not (Test-Path $UsDir)) { throw "US SEC cache directory not found: $UsDir" }

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

function Median([double[]]$a) {
    if ($a.Count -eq 0) { return $null }
    $s = @($a | Sort-Object)
    $mid = [int][Math]::Floor(($s.Count - 1) / 2)
    return $s[$mid]
}

function Std([double[]]$a) {
    if ($a.Count -lt 2) { return $null }
    $m = Mean $a
    $sum = 0.0
    foreach ($x in $a) { $sum += [Math]::Pow($x - $m, 2) }
    return [Math]::Sqrt($sum / ($a.Count - 1))
}

function Describe([object[]]$rows, [string]$col) {
    $vals = @($rows | ForEach-Object { ToN $_.$col } | Where-Object { $null -ne $_ })
    if ($vals.Count -eq 0) {
        return [PSCustomObject]@{
            n = 0; mean = $null; median = $null; std = $null; min = $null; max = $null
        }
    }
    return [PSCustomObject]@{
        n = $vals.Count
        mean = [Math]::Round((Mean $vals), 6)
        median = [Math]::Round((Median $vals), 6)
        std = [Math]::Round((Std $vals), 6)
        min = [Math]::Round(($vals | Measure-Object -Minimum).Minimum, 6)
        max = [Math]::Round(($vals | Measure-Object -Maximum).Maximum, 6)
    }
}

# Indonesia rows
$idRowsRaw = Import-Csv $IdCsv
$idRows = @($idRowsRaw | Where-Object {
    $y = ToN $_.year
    $null -ne $y -and $y -ge $StartYear -and $y -le $EndYear
})

# US rows from SEC cache ratios
$targetTickers = @("AAPL","MSFT","GOOGL","META","NVDA","AMZN","TSLA","CRM","ADBE","ORCL")
$usAll = @()
foreach ($t in $targetTickers) {
    $p = Join-Path $UsDir ("{0}_ratios.csv" -f $t)
    if (-not (Test-Path $p)) { continue }
    $tmp = Import-Csv $p | Where-Object {
        $fy = ToN $_.fy
        $null -ne $fy -and $fy -ge $StartYear -and $fy -le $EndYear
    } | ForEach-Object {
        [PSCustomObject]@{
            ticker = $t
            fy = ToN $_.fy
            roa = ToN $_.roa
            roe = ToN $_.roe
            npm = ToN $_.net_margin
            der = ToN $_.der
            eps = ToN $_.eps
            pbv = ToN $_.pbv
        }
    }
    $usAll += $tmp
}

$outUsDir = Split-Path -Parent $OutUsCsv
if ($outUsDir) { New-Item -ItemType Directory -Force -Path $outUsDir | Out-Null }
$usAll | Sort-Object ticker, fy | Export-Csv -Path $OutUsCsv -NoTypeInformation -Encoding UTF8

$map = @(
    @{ label = "ROA"; idCol = "roa"; usCol = "roa" },
    @{ label = "ROE"; idCol = "roe"; usCol = "roe" },
    @{ label = "NPM"; idCol = "npm"; usCol = "npm" },
    @{ label = "DER"; idCol = "der"; usCol = "der" },
    @{ label = "EPS"; idCol = "eps"; usCol = "eps" },
    @{ label = "PBV"; idCol = ""; usCol = "pbv" }
)

$md = @()
$md += "# US vs Indonesia Descriptive Comparison"
$md += ""
$md += "- Indonesia dataset: $IdCsv"
$md += "- US SEC cache directory: $UsDir"
$md += "- Period: $StartYear-$EndYear"
$md += "- US merged rows: $($usAll.Count)"
$md += "- Indonesia rows in period: $($idRows.Count)"
$md += ""
$md += "| Variable | Indonesia N | Indonesia Mean | Indonesia Median | US N | US Mean | US Median | Notes |"
$md += "|---|---:|---:|---:|---:|---:|---:|---|"

foreach ($m in $map) {
    $idDesc = if ([string]::IsNullOrWhiteSpace($m.idCol)) {
        [PSCustomObject]@{ n = 0; mean = $null; median = $null }
    } else {
        Describe -rows $idRows -col $m.idCol
    }
    $usDesc = Describe -rows $usAll -col $m.usCol

    $idMean = if ($null -eq $idDesc.mean) { "" } else { $idDesc.mean }
    $idMed = if ($null -eq $idDesc.median) { "" } else { $idDesc.median }
    $usMean = if ($null -eq $usDesc.mean) { "" } else { $usDesc.mean }
    $usMed = if ($null -eq $usDesc.median) { "" } else { $usDesc.median }
    $note = if ($m.label -eq "PBV") { "Indonesia PBV not in current panel template; US PBV mostly missing without price-enriched run." } else { "" }

    $md += "| $($m.label) | $($idDesc.n) | $idMean | $idMed | $($usDesc.n) | $usMean | $usMed | $note |"
}

$statsDir = Split-Path -Parent $OutStatsMd
if ($statsDir) { New-Item -ItemType Directory -Force -Path $statsDir | Out-Null }
$md | Set-Content -Path $OutStatsMd

$narr = @()
$narr += "# Indonesia vs US Context Discussion (Supplementary)"
$narr += ""
$narr += "## Scope"
$narr += "- This is supplementary analysis from existing SEC cache and current Indonesia panel file."
$narr += "- It is descriptive, not causal inference."
$narr += ""
$narr += "## Market Maturity"
$narr += "- US sample (large-cap tech) shows mature scale and generally stronger profitability consistency."
$narr += "- Indonesia tech sample is still early-stage with fewer long-listed issuers and higher listing recency."
$narr += ""
$narr += "## Regulation and Reporting Context"
$narr += "- US firms report under SEC regime with long disclosure history and broader analyst coverage."
$narr += "- Indonesia firms operate under BEI/OJK disclosure environment with heterogeneous annual-report depth for AI topics."
$narr += ""
$narr += "## AI Adoption Context"
$narr += "- US mega-cap firms adopted AI investments earlier and at larger capex/intangible scale."
$narr += "- Indonesia ICT issuers are in mixed adoption stages; AI disclosure intensity likely varies by sub-sector."
$narr += ""
$narr += "## Interpretation Guardrails"
$narr += "- Current Indonesia dataset in repo is still pilot-sized, so significance comparison between markets is not statistically reliable yet."
$narr += "- Final comparative inference should be rerun after full Indonesia panel dataset is completed."

$narrDir = Split-Path -Parent $OutNarrativeMd
if ($narrDir) { New-Item -ItemType Directory -Force -Path $narrDir | Out-Null }
$narr | Set-Content -Path $OutNarrativeMd

Write-Host "Wrote US merged ratios: $OutUsCsv"
Write-Host "Wrote descriptive comparison: $OutStatsMd"
Write-Host "Wrote context discussion: $OutNarrativeMd"
