param(
    [Parameter(Mandatory = $false)]
    [string]$InputCsv = ".\data\processed\panel_dataset.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutStatsMd = ".\output\descriptive_stats.md",
    [Parameter(Mandatory = $false)]
    [string]$OutCorrCsv = ".\output\correlation_matrix.csv"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $InputCsv)) { throw "Input not found: $InputCsv" }
$rows = Import-Csv $InputCsv
if ($rows.Count -eq 0) { throw "No rows in: $InputCsv" }

function ToN([object]$v) {
    if ($null -eq $v) { return $null }
    $s = $v.ToString().Trim()
    if ($s -eq "") { return $null }
    $x = 0.0
    if ([double]::TryParse($s, [ref]$x)) { return $x }
    return $null
}

function Mean([double[]]$a) { if ($a.Count -eq 0) { return $null }; return ($a | Measure-Object -Average).Average }
function Std([double[]]$a) {
    if ($a.Count -lt 2) { return $null }
    $m = Mean $a
    $sum = 0.0
    foreach ($x in $a) { $sum += [Math]::Pow($x - $m, 2) }
    return [Math]::Sqrt($sum / ($a.Count - 1))
}
function Corr([double[]]$x, [double[]]$y) {
    if ($x.Count -ne $y.Count -or $x.Count -lt 2) { return $null }
    $mx = Mean $x; $my = Mean $y
    $sx = Std $x; $sy = Std $y
    if ($null -eq $sx -or $null -eq $sy -or $sx -eq 0 -or $sy -eq 0) { return $null }
    $cov = 0.0
    for ($i=0; $i -lt $x.Count; $i++) { $cov += (($x[$i]-$mx) * ($y[$i]-$my)) }
    $cov = $cov / ($x.Count - 1)
    return $cov / ($sx * $sy)
}

$vars = @("price","ret","tq","roa","roe","npm","cr","der","tato","eps","size","growth","age","vol","aid","ii")
$stats = @()
foreach ($v in $vars) {
    $a = @($rows | ForEach-Object { ToN $_.$v } | Where-Object { $null -ne $_ })
    if ($a.Count -eq 0) { continue }
    $stats += [PSCustomObject]@{
        variable = $v
        n = $a.Count
        mean = [Math]::Round((Mean $a), 6)
        median = [Math]::Round(($a | Sort-Object | Select-Object -Index ([int][Math]::Floor(($a.Count-1)/2))), 6)
        std_dev = [Math]::Round((Std $a), 6)
        min = [Math]::Round(($a | Measure-Object -Minimum).Minimum, 6)
        max = [Math]::Round(($a | Measure-Object -Maximum).Maximum, 6)
    }
}

$md = @()
$md += "# Descriptive Statistics"
$md += ""
$md += "Source: $InputCsv"
$md += ""
$md += "| Variable | N | Mean | Median | Std Dev | Min | Max |"
$md += "|---|---:|---:|---:|---:|---:|---:|"
foreach ($s in $stats) {
    $md += "| $($s.variable) | $($s.n) | $($s.mean) | $($s.median) | $($s.std_dev) | $($s.min) | $($s.max) |"
}

$outStatsDir = Split-Path -Parent $OutStatsMd
if ($outStatsDir) { New-Item -ItemType Directory -Force -Path $outStatsDir | Out-Null }
$md | Set-Content $OutStatsMd

# Correlation matrix
$corrRows = @()
$header = @("variable") + $vars
$corrRows += ($header -join ",")
foreach ($vx in $vars) {
    $line = @($vx)
    foreach ($vy in $vars) {
        $pairsX = @()
        $pairsY = @()
        foreach ($r in $rows) {
            $x = ToN $r.$vx
            $y = ToN $r.$vy
            if ($null -ne $x -and $null -ne $y) {
                $pairsX += $x
                $pairsY += $y
            }
        }
        $c = Corr $pairsX $pairsY
        if ($null -eq $c) { $line += "" } else { $line += ([Math]::Round($c, 6)) }
    }
    $corrRows += ($line -join ",")
}

$outCorrDir = Split-Path -Parent $OutCorrCsv
if ($outCorrDir) { New-Item -ItemType Directory -Force -Path $outCorrDir | Out-Null }
$corrRows | Set-Content $OutCorrCsv

Write-Host "Wrote descriptive stats: $OutStatsMd"
Write-Host "Wrote correlation matrix: $OutCorrCsv"
