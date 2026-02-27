param(
    [Parameter(Mandatory = $false)]
    [string]$InputCsv = ".\output\panel_dataset_built.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutDir = ".\output\robustness",
    [Parameter(Mandatory = $false)]
    [string]$OutReport = ".\output\robustness_checks.md"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $InputCsv)) {
    throw "Input panel dataset not found: $InputCsv"
}

$rows = Import-Csv $InputCsv
if ($rows.Count -eq 0) {
    throw "Input panel dataset has no rows: $InputCsv"
}

function ToN([object]$v) {
    if ($null -eq $v) { return $null }
    $s = $v.ToString().Trim()
    if ($s -eq "") { return $null }
    $x = 0.0
    if ([double]::TryParse($s, [ref]$x)) { return $x }
    return $null
}

function Percentile-Bounds {
    param(
        [double[]]$arr,
        [double]$pLow,
        [double]$pHigh
    )
    if ($arr.Count -lt 5) { return @{ low = $null; high = $null } }
    $s = $arr | Sort-Object
    $iLow = [Math]::Floor(($s.Count - 1) * $pLow)
    $iHigh = [Math]::Floor(($s.Count - 1) * $pHigh)
    return @{ low = $s[$iLow]; high = $s[$iHigh] }
}

function Apply-Winsor {
    param(
        [object[]]$InputRows,
        [string[]]$NumericCols,
        [double]$pLow,
        [double]$pHigh
    )
    $cloned = @()
    foreach ($r in $InputRows) {
        $h = @{}
        foreach ($p in $r.PSObject.Properties) { $h[$p.Name] = $p.Value }
        $cloned += [PSCustomObject]$h
    }

    foreach ($col in $NumericCols) {
        $vals = @($cloned | ForEach-Object { ToN $_.$col } | Where-Object { $null -ne $_ })
        $b = Percentile-Bounds -arr $vals -pLow $pLow -pHigh $pHigh
        if ($null -eq $b.low -or $null -eq $b.high) { continue }
        foreach ($row in $cloned) {
            $v = ToN $row.$col
            if ($null -eq $v) { continue }
            if ($v -lt $b.low) { $row.$col = $b.low }
            if ($v -gt $b.high) { $row.$col = $b.high }
        }
    }

    return ,$cloned
}

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$years = @($rows | ForEach-Object { [int]$_.year } | Sort-Object -Unique)
$pre = @($rows | Where-Object { [int]$_.year -ge 2019 -and [int]$_.year -le 2022 })
$post = @($rows | Where-Object { [int]$_.year -ge 2023 -and [int]$_.year -le 2025 })
$exCovid = @($rows | Where-Object { [int]$_.year -ne 2020 })

$numericCols = @("price","ret","tq","roa","roe","npm","cr","der","tato","eps","size","growth","age","vol","aid","ii")
$w1 = Apply-Winsor -InputRows $rows -NumericCols $numericCols -pLow 0.01 -pHigh 0.99
$w5 = Apply-Winsor -InputRows $rows -NumericCols $numericCols -pLow 0.05 -pHigh 0.95

$prePath = Join-Path $OutDir "panel_pre_2019_2022.csv"
$postPath = Join-Path $OutDir "panel_post_2023_2025.csv"
$exCovidPath = Join-Path $OutDir "panel_exclude_2020.csv"
$w1Path = Join-Path $OutDir "panel_winsor_1_99.csv"
$w5Path = Join-Path $OutDir "panel_winsor_5_95.csv"
$pbvAltPath = Join-Path $OutDir "panel_alt_proxy_pbv.csv"

$pre | Export-Csv -Path $prePath -NoTypeInformation -Encoding UTF8
$post | Export-Csv -Path $postPath -NoTypeInformation -Encoding UTF8
$exCovid | Export-Csv -Path $exCovidPath -NoTypeInformation -Encoding UTF8
$w1 | Export-Csv -Path $w1Path -NoTypeInformation -Encoding UTF8
$w5 | Export-Csv -Path $w5Path -NoTypeInformation -Encoding UTF8

# Alternate proxy dataset: if pbv exists keep it; else create empty pbv column as placeholder.
$alt = @()
foreach ($r in $rows) {
    $h = @{}
    foreach ($p in $r.PSObject.Properties) { $h[$p.Name] = $p.Value }
    if (-not $h.ContainsKey("pbv")) {
        $h["pbv"] = ""
    }
    $alt += [PSCustomObject]$h
}
$alt | Export-Csv -Path $pbvAltPath -NoTypeInformation -Encoding UTF8

$report = @()
$report += "# Robustness Checks Report"
$report += ""
$report += "- Source dataset: $InputCsv"
$report += "- Available years: $($years -join ', ')"
$report += "- Total rows: $($rows.Count)"
$report += ""
$report += "## Generated Robustness Datasets"
$report += "- Subsample pre (2019-2022): $prePath (rows: $($pre.Count))"
$report += "- Subsample post (2023-2025): $postPath (rows: $($post.Count))"
$report += "- Exclude 2020: $exCovidPath (rows: $($exCovid.Count))"
$report += "- Winsor 1/99: $w1Path (rows: $($w1.Count))"
$report += "- Winsor 5/95: $w5Path (rows: $($w5.Count))"
$report += "- Alt proxy PBV dataset: $pbvAltPath (rows: $($alt.Count))"
$report += ""
$report += "## Notes"
$report += "- This step prepares datasets for robustness reruns."
$report += "- Estimation reruns can be executed with `scripts/eviews_run.ps1` per dataset."
$report += "- System GMM remains pending and should be executed in dedicated software workflow."

$report | Set-Content -Path $OutReport

Write-Host "Wrote robustness report: $OutReport"
Write-Host "Generated datasets in: $OutDir"
