param(
    [string]$PriceDir = "data/prices",
    [string]$OutFile = "data/prices/price_master.csv",
    [string]$VolOutFile = "data/prices/volatility_master.csv"
)

$ErrorActionPreference = "Stop"

# ---- Part 1: Consolidate year-end prices ----
$tickers = @(
    "ATIC","BALI","BTEL","CENT","DIVA",
    "EXCL","GHON","IBST","ISAT",
    "KBLV","KIOS","LCKM","LINK","LMAS",
    "LUCK","MCAS","MLPT","MTDL","NFCX",
    "OASA","PTSN","SKYB","SUPR","TBIG",
    "TLKM","TOWR"
)

$allRows = @()
foreach ($t in $tickers) {
    $f = Join-Path $PriceDir "prices_${t}.csv"
    if (Test-Path $f) {
        $rows = Import-Csv $f
        foreach ($r in $rows) {
            $allRows += [pscustomobject]@{
                ticker = $t
                fy     = $r.fy
                price  = $r.price
            }
        }
    }
}
$allRows | Export-Csv -Path $OutFile -NoTypeInformation
Write-Host "Price master: $OutFile ($($allRows.Count) rows)"

# ---- Part 2: Compute annual volatility from monthly returns ----
$volRows = @()
foreach ($t in $tickers) {
    $f = Join-Path $PriceDir "monthly_${t}.csv"
    if (-not (Test-Path $f)) { continue }
    $monthly = Import-Csv $f | Sort-Object { [int]$_.year * 100 + [int]$_.month }

    # Compute monthly returns
    $returns = @()
    for ($i = 1; $i -lt $monthly.Count; $i++) {
        $prev = [double]$monthly[$i-1].close
        $curr = [double]$monthly[$i].close
        if ($prev -le 0) { continue }
        $ret = ($curr - $prev) / $prev
        $returns += [pscustomobject]@{
            year = [int]$monthly[$i].year
            ret  = $ret
        }
    }

    # Group by year, compute std dev
    $byYear = $returns | Group-Object year
    foreach ($g in $byYear) {
        $yr = [int]$g.Name
        $rets = $g.Group | ForEach-Object { $_.ret }
        if ($rets.Count -lt 2) { continue }
        $mean = ($rets | Measure-Object -Sum).Sum / $rets.Count
        $sumSqDev = 0
        foreach ($r in $rets) { $sumSqDev += ($r - $mean) * ($r - $mean) }
        $stddev = [math]::Sqrt($sumSqDev / ($rets.Count - 1))
        $volRows += [pscustomobject]@{
            ticker     = $t
            fy         = $yr
            vol_monthly = [math]::Round($stddev, 6)
            n_months   = $rets.Count
        }
    }
}
$volRows | Export-Csv -Path $VolOutFile -NoTypeInformation
Write-Host "Volatility master: $VolOutFile ($($volRows.Count) rows)"
