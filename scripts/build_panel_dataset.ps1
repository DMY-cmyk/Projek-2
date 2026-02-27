param(
    [Parameter(Mandatory = $false)]
    [string]$FinancialCsv = ".\data\processed\financial_master.csv",
    [Parameter(Mandatory = $false)]
    [string]$PriceCsv = ".\data\processed\price_master.csv",
    [Parameter(Mandatory = $false)]
    [string]$AidCsv = ".\output\ai_disclosure_index.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutCsv = ".\data\processed\panel_dataset.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutCleaningLog = ".\output\data_cleaning_log.md",
    [Parameter(Mandatory = $false)]
    [switch]$Winsorize
)

$ErrorActionPreference = "Stop"

function To-DoubleOrNull {
    param([object]$v)
    if ($null -eq $v) { return $null }
    $s = $v.ToString().Trim()
    if ($s -eq "") { return $null }
    $x = 0.0
    if ([double]::TryParse($s, [ref]$x)) { return $x }
    return $null
}

function Safe-Div {
    param([double]$a, [double]$b)
    if ($null -eq $a -or $null -eq $b -or $b -eq 0) { return $null }
    return $a / $b
}

function Pct-Growth {
    param([double]$cur, [double]$prev)
    if ($null -eq $cur -or $null -eq $prev -or $prev -eq 0) { return $null }
    return ($cur - $prev) / $prev
}

function Winsorize-Array {
    param([double[]]$arr, [double]$pLow = 0.01, [double]$pHigh = 0.99)
    if ($arr.Count -lt 5) { return @{ low = $null; high = $null } }
    $s = $arr | Sort-Object
    $iLow = [Math]::Floor(($s.Count - 1) * $pLow)
    $iHigh = [Math]::Floor(($s.Count - 1) * $pHigh)
    return @{ low = $s[$iLow]; high = $s[$iHigh] }
}

foreach ($p in @($FinancialCsv, $PriceCsv, $AidCsv)) {
    if (-not (Test-Path $p)) { throw "Required input not found: $p" }
}

$fin = Import-Csv $FinancialCsv
$prx = Import-Csv $PriceCsv
$aid = Import-Csv $AidCsv

# Build lookup maps
$priceMap = @{}
foreach ($r in $prx) {
    $k = ("{0}|{1}" -f $r.firm_id, $r.year)
    $priceMap[$k] = $r
}

$aidMap = @{}
foreach ($r in $aid) {
    $firm = if ($r.firm_id) { $r.firm_id } else { $r.ticker }
    $k = ("{0}|{1}" -f $firm, $r.year)
    $aidMap[$k] = $r
}

# Keep yearly net income/revenue/price history for growth and return
$incomeByFirmYear = @{}
$revenueByFirmYear = @{}
$priceByFirmYear = @{}
foreach ($r in $fin) {
    $k = ("{0}|{1}" -f $r.firm_id, $r.year)
    $incomeByFirmYear[$k] = To-DoubleOrNull $r.net_income
    $revenueByFirmYear[$k] = To-DoubleOrNull $r.revenue
}
foreach ($r in $prx) {
    $k = ("{0}|{1}" -f $r.firm_id, $r.year)
    $priceByFirmYear[$k] = To-DoubleOrNull $r.price
}

$rows = @()
foreach ($r in $fin) {
    $firm = $r.firm_id
    $year = [int]$r.year
    $k = ("{0}|{1}" -f $firm, $year)
    $kPrev = ("{0}|{1}" -f $firm, ($year - 1))

    $assets = To-DoubleOrNull $r.total_assets
    $liab = To-DoubleOrNull $r.total_liabilities
    $equity = To-DoubleOrNull $r.total_equity
    $ca = To-DoubleOrNull $r.current_assets
    $cl = To-DoubleOrNull $r.current_liabilities
    $ni = To-DoubleOrNull $r.net_income
    $rev = To-DoubleOrNull $r.revenue
    $intan = To-DoubleOrNull $r.intangible_assets
    $shares = To-DoubleOrNull $r.shares_outstanding

    $price = $null
    $vol = $null
    if ($priceMap.ContainsKey($k)) {
        $price = To-DoubleOrNull $priceMap[$k].price
        $vol = To-DoubleOrNull $priceMap[$k].vol
    }
    $pricePrev = if ($priceByFirmYear.ContainsKey($kPrev)) { $priceByFirmYear[$kPrev] } else { $null }

    $aidVal = 0.0
    if ($aidMap.ContainsKey($k)) {
        if ($aidMap[$k].aid_binary) { $aidVal = To-DoubleOrNull $aidMap[$k].aid_binary }
        elseif ($aidMap[$k].aid) { $aidVal = To-DoubleOrNull $aidMap[$k].aid }
    }

    $roa = Safe-Div $ni $assets
    $roe = Safe-Div $ni $equity
    $npm = Safe-Div $ni $rev
    $cr = Safe-Div $ca $cl
    $der = Safe-Div $liab $equity
    $tato = Safe-Div $rev $assets
    $eps = Safe-Div $ni $shares
    $ii = Safe-Div $intan $assets
    $size = if ($null -ne $assets -and $assets -gt 0) { [Math]::Log($assets) } else { $null }
    $growth = if ($revenueByFirmYear.ContainsKey($kPrev)) { Pct-Growth $rev $revenueByFirmYear[$kPrev] } else { $null }
    $ret = Pct-Growth $price $pricePrev
    $marketCap = if ($null -ne $price -and $null -ne $shares) { $price * $shares } else { $null }
    $tq = if ($null -ne $marketCap -and $null -ne $liab -and $null -ne $assets -and $assets -ne 0) { ($marketCap + $liab) / $assets } else { $null }
    $dgenai = if ($year -ge 2023) { 1 } else { 0 }

    $listingYear = $null
    if ($r.listing_year -and $r.listing_year.ToString().Trim() -ne "") {
        $listingYear = [int]$r.listing_year
    }
    $age = if ($null -ne $listingYear) { $year - $listingYear } else { $null }

    $rows += [PSCustomObject]@{
        firm_id = $firm
        year = $year
        price = $price
        ret = $ret
        tq = $tq
        roa = $roa
        roe = $roe
        npm = $npm
        cr = $cr
        der = $der
        tato = $tato
        eps = $eps
        size = $size
        growth = $growth
        age = $age
        vol = $vol
        aid = $aidVal
        ii = $ii
        dgenai = $dgenai
    }
}

if ($Winsorize -and $rows.Count -gt 0) {
    $numericCols = @("price","ret","tq","roa","roe","npm","cr","der","tato","eps","size","growth","age","vol","aid","ii")
    foreach ($col in $numericCols) {
        $vals = @($rows | ForEach-Object { To-DoubleOrNull $_.$col } | Where-Object { $null -ne $_ })
        $bound = Winsorize-Array -arr $vals
        if ($null -eq $bound.low -or $null -eq $bound.high) { continue }
        foreach ($row in $rows) {
            $v = To-DoubleOrNull $row.$col
            if ($null -eq $v) { continue }
            if ($v -lt $bound.low) { $row.$col = $bound.low }
            if ($v -gt $bound.high) { $row.$col = $bound.high }
        }
    }
}

$outDir = Split-Path -Parent $OutCsv
if ($outDir) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }
$rows | Sort-Object firm_id, year | Export-Csv -Path $OutCsv -NoTypeInformation -Encoding UTF8

$miss = @{}
$fields = @("price","ret","tq","roa","roe","npm","cr","der","tato","eps","size","growth","age","vol","aid","ii")
foreach ($f in $fields) {
    $miss[$f] = @($rows | Where-Object { $null -eq (To-DoubleOrNull $_.$f) }).Count
}

$log = @()
$log += "# Data Cleaning Log"
$log += ""
$log += "- Input financial rows: $($fin.Count)"
$log += "- Input price rows: $($prx.Count)"
$log += "- Input AID rows: $($aid.Count)"
$log += "- Output panel rows: $($rows.Count)"
$log += "- Winsorize applied: $($Winsorize.IsPresent)"
$log += ""
$log += "## Missing Values by Field"
foreach ($f in $fields) {
    $log += "- ${f}: $($miss[$f])"
}

$logDir = Split-Path -Parent $OutCleaningLog
if ($logDir) { New-Item -ItemType Directory -Force -Path $logDir | Out-Null }
$log | Set-Content -Path $OutCleaningLog

Write-Host "Wrote panel dataset: $OutCsv"
Write-Host "Wrote cleaning log: $OutCleaningLog"
