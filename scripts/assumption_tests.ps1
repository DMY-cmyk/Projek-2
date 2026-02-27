param(
    [Parameter(Mandatory = $false)]
    [string]$InputCsv = ".\data\processed\panel_dataset.csv",
    [Parameter(Mandatory = $false)]
    [string]$Dependent = "price",
    [Parameter(Mandatory = $false)]
    [string[]]$Predictors = @("roa","roe","npm","cr","der","tato","eps","size","growth","age","vol","aid","ii","dgenai"),
    [Parameter(Mandatory = $false)]
    [string]$OutMd = ".\output\assumption_tests.md",
    [Parameter(Mandatory = $false)]
    [string]$OutVifCsv = ".\output\vif_table.csv"
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

function Mean([double[]]$a) {
    if ($a.Count -eq 0) { return $null }
    return ($a | Measure-Object -Average).Average
}

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

function Matrix-Transpose([object[]]$m) {
    $r = $m.Count
    $c = $m[0].Count
    $t = @()
    for ($j=0; $j -lt $c; $j++) {
        $row = New-Object double[] $r
        for ($i=0; $i -lt $r; $i++) { $row[$i] = [double]$m[$i][$j] }
        $t += ,$row
    }
    return ,$t
}

function Matrix-Mul([object[]]$a, [object[]]$b) {
    $ar = $a.Count; $ac = $a[0].Count
    $br = $b.Count; $bc = $b[0].Count
    if ($ac -ne $br) { throw "Matrix size mismatch" }
    $m = @()
    for ($i=0; $i -lt $ar; $i++) {
        $row = New-Object double[] $bc
        for ($j=0; $j -lt $bc; $j++) {
            $s = 0.0
            for ($k=0; $k -lt $ac; $k++) { $s += [double]$a[$i][$k] * [double]$b[$k][$j] }
            $row[$j] = $s
        }
        $m += ,$row
    }
    return ,$m
}

function Matrix-Inverse([object[]]$m) {
    $n = $m.Count
    if ($n -ne $m[0].Count) { throw "Inverse requires square matrix" }
    $aug = @()
    for ($i=0; $i -lt $n; $i++) {
        $row = New-Object double[] ($n*2)
        for ($j=0; $j -lt $n; $j++) { $row[$j] = [double]$m[$i][$j] }
        for ($j=0; $j -lt $n; $j++) { $row[$n+$j] = if ($i -eq $j) { 1.0 } else { 0.0 } }
        $aug += ,$row
    }
    for ($i=0; $i -lt $n; $i++) {
        $pivot = $i
        $maxVal = [Math]::Abs($aug[$i][$i])
        for ($r=$i+1; $r -lt $n; $r++) {
            $v = [Math]::Abs($aug[$r][$i])
            if ($v -gt $maxVal) { $maxVal = $v; $pivot = $r }
        }
        if ($maxVal -lt 1e-12) { throw "Singular matrix" }
        if ($pivot -ne $i) {
            $tmp = $aug[$i]; $aug[$i] = $aug[$pivot]; $aug[$pivot] = $tmp
        }
        $pv = $aug[$i][$i]
        for ($j=0; $j -lt $n*2; $j++) { $aug[$i][$j] = $aug[$i][$j] / $pv }
        for ($r=0; $r -lt $n; $r++) {
            if ($r -eq $i) { continue }
            $f = $aug[$r][$i]
            for ($j=0; $j -lt $n*2; $j++) {
                $aug[$r][$j] = $aug[$r][$j] - $f * $aug[$i][$j]
            }
        }
    }
    $inv = @()
    for ($i=0; $i -lt $n; $i++) {
        $row = New-Object double[] $n
        for ($j=0; $j -lt $n; $j++) { $row[$j] = $aug[$i][$n+$j] }
        $inv += ,$row
    }
    return ,$inv
}

function OLS([object[]]$X, [double[]]$y) {
    # y as Nx1 matrix
    $Y = @()
    foreach ($v in $y) { $Y += ,([double[]]@($v)) }
    $Xt = Matrix-Transpose $X
    $XtX = Matrix-Mul $Xt $X
    $XtXInv = Matrix-Inverse $XtX
    $XtY = Matrix-Mul $Xt $Y
    $B = Matrix-Mul $XtXInv $XtY
    $beta = @()
    for ($i=0; $i -lt $B.Count; $i++) { $beta += $B[$i][0] }

    $n = $X.Count
    $k = $X[0].Count
    $res = New-Object double[] $n
    $yhat = New-Object double[] $n
    for ($i=0; $i -lt $n; $i++) {
        $yh = 0.0
        for ($j=0; $j -lt $k; $j++) { $yh += $X[$i][$j] * $beta[$j] }
        $yhat[$i] = $yh
        $res[$i] = $y[$i] - $yh
    }
    $ym = Mean $y
    $sst = 0.0; $sse = 0.0
    for ($i=0; $i -lt $n; $i++) {
        $sst += [Math]::Pow(($y[$i]-$ym),2)
        $sse += [Math]::Pow(($res[$i]),2)
    }
    $r2 = if ($sst -eq 0) { $null } else { 1.0 - ($sse / $sst) }
    return @{
        beta = $beta
        residuals = $res
        yhat = $yhat
        r2 = $r2
        n = $n
        k = $k
    }
}

# Build complete-case matrix with adaptive predictor count for small samples.
$effectivePredictors = @($Predictors)

function Build-CleanRows([string[]]$Preds) {
    $tmp = @()
    foreach ($r in $rows) {
        $y = ToN $r.$Dependent
        if ($null -eq $y) { continue }
        $xvals = @()
        $ok = $true
        foreach ($p in $Preds) {
            $v = ToN $r.$p
            if ($null -eq $v) { $ok = $false; break }
            $xvals += $v
        }
        if (-not $ok) { continue }
        $firm = if ($r.firm_id) { $r.firm_id } else { "" }
        $year = ToN $r.year
        $tmp += [PSCustomObject]@{ y=$y; x=$xvals; firm_id=$firm; year=$year }
    }
    return ,$tmp
}

$clean = Build-CleanRows -Preds $effectivePredictors
if ($clean.Count -lt 10) { Write-Warning "Low complete-case sample for assumption tests: $($clean.Count)" }

$maxPredictors = [Math]::Max(1, $clean.Count - 2) # keep room for intercept
if ($effectivePredictors.Count -gt $maxPredictors) {
    $priority = @("roa","der","eps","size","growth","age","vol","aid","ii","dgenai","roe","npm","cr","tato")
    $ordered = @()
    foreach ($p in $priority) { if ($effectivePredictors -contains $p) { $ordered += $p } }
    foreach ($p in $effectivePredictors) { if ($ordered -notcontains $p) { $ordered += $p } }
    $effectivePredictors = @($ordered | Select-Object -First $maxPredictors)
    $clean = Build-CleanRows -Preds $effectivePredictors
}

$X = @()
$Y = New-Object double[] $clean.Count
for ($i=0; $i -lt $clean.Count; $i++) {
    $row = New-Object double[] (1 + $effectivePredictors.Count)
    $row[0] = 1.0
    for ($j=0; $j -lt $effectivePredictors.Count; $j++) { $row[$j+1] = [double]$clean[$i].x[$j] }
    $X += ,$row
    $Y[$i] = [double]$clean[$i].y
}

$ols = $null
try {
    $ols = OLS $X $Y
} catch {
    $vifTable = @()
    foreach ($p in $effectivePredictors) {
        $vifTable += [PSCustomObject]@{ variable = $p; vif = ""; high_vif = "" }
    }
    $outVifDir = Split-Path -Parent $OutVifCsv
    if ($outVifDir) { New-Item -ItemType Directory -Force -Path $outVifDir | Out-Null }
    $vifTable | Export-Csv -Path $OutVifCsv -NoTypeInformation -Encoding UTF8

    $md = @()
    $md += "# Assumption Tests (Automation)"
    $md += ""
    $md += "- Source: $InputCsv"
    $md += "- Dependent: $Dependent"
    $md += "- Complete-case N: $($clean.Count)"
    $md += "- Effective predictors: $($effectivePredictors -join ', ')"
    $md += "- Status: failed to estimate OLS base model (likely insufficient sample or singular matrix)."
    $md += "- Action: add more observations or reduce predictors and rerun."
    $outMdDir = Split-Path -Parent $OutMd
    if ($outMdDir) { New-Item -ItemType Directory -Force -Path $outMdDir | Out-Null }
    $md | Set-Content $OutMd
    Write-Host "Wrote assumption report (fallback): $OutMd"
    Write-Host "Wrote VIF table (fallback): $OutVifCsv"
    exit 0
}

# VIF from inverse correlation matrix of predictors
$k = $effectivePredictors.Count
$corrM = @()
for ($i=0; $i -lt $k; $i++) {
    $row = New-Object double[] $k
    for ($j=0; $j -lt $k; $j++) {
        $xi = New-Object double[] $clean.Count
        $xj = New-Object double[] $clean.Count
        for ($t=0; $t -lt $clean.Count; $t++) {
            $xi[$t] = [double]$clean[$t].x[$i]
            $xj[$t] = [double]$clean[$t].x[$j]
        }
        $c = Corr $xi $xj
        if ($null -eq $c) { $c = 0.0 }
        if ($i -eq $j) { $c = 1.0 }
        $row[$j] = $c
    }
    $corrM += ,$row
}

$vifTable = @()
try {
    $invCorr = Matrix-Inverse $corrM
    for ($i=0; $i -lt $k; $i++) {
        $vif = $invCorr[$i][$i]
        $vifTable += [PSCustomObject]@{
            variable = $effectivePredictors[$i]
            vif = [Math]::Round($vif, 6)
            high_vif = if ($vif -gt 10) { 1 } else { 0 }
        }
    }
} catch {
    for ($i=0; $i -lt $k; $i++) {
        $vifTable += [PSCustomObject]@{
            variable = $effectivePredictors[$i]
            vif = ""
            high_vif = ""
        }
    }
}

$outVifDir = Split-Path -Parent $OutVifCsv
if ($outVifDir) { New-Item -ItemType Directory -Force -Path $outVifDir | Out-Null }
$vifTable | Export-Csv -Path $OutVifCsv -NoTypeInformation -Encoding UTF8

# Breusch-Pagan LM: regress e^2 on predictors + intercept
$e2 = New-Object double[] $ols.n
for ($i=0; $i -lt $ols.n; $i++) { $e2[$i] = $ols.residuals[$i] * $ols.residuals[$i] }
$bp = OLS $X $e2
$bpLm = if ($null -eq $bp.r2) { $null } else { $ols.n * $bp.r2 }
$bpDf = $effectivePredictors.Count

# Durbin-Watson (within firm order by year)
$sorted = $clean | Sort-Object firm_id, year
$num = 0.0; $den = 0.0
$lastFirm = ""; $lastRes = $null
for ($i=0; $i -lt $sorted.Count; $i++) {
    $res = $ols.residuals[$i]
    $den += $res * $res
    if ($sorted[$i].firm_id -eq $lastFirm -and $null -ne $lastRes) {
        $num += [Math]::Pow(($res - $lastRes), 2)
    }
    $lastFirm = $sorted[$i].firm_id
    $lastRes = $res
}
$dw = if ($den -eq 0) { $null } else { $num / $den }

# High pairwise correlations among independents
$highCorr = @()
for ($i=0; $i -lt $k; $i++) {
    for ($j=$i+1; $j -lt $k; $j++) {
        $xi = New-Object double[] $clean.Count
        $xj = New-Object double[] $clean.Count
        for ($t=0; $t -lt $clean.Count; $t++) {
            $xi[$t] = [double]$clean[$t].x[$i]
            $xj[$t] = [double]$clean[$t].x[$j]
        }
        $c = Corr $xi $xj
        if ($null -ne $c -and [Math]::Abs($c) -gt 0.8) {
            $highCorr += [PSCustomObject]@{
                var_1 = $effectivePredictors[$i]
                var_2 = $effectivePredictors[$j]
                corr = [Math]::Round($c, 6)
            }
        }
    }
}

$md = @()
$md += "# Assumption Tests (Automation)"
$md += ""
$md += "- Source: $InputCsv"
$md += "- Dependent: $Dependent"
$md += "- Complete-case N: $($clean.Count)"
$md += "- Effective predictors: $($effectivePredictors -join ', ')"
$md += ""
$md += "## Multicollinearity (VIF)"
$md += "Saved table: $OutVifCsv"
$highVifCount = @($vifTable | Where-Object { $_.high_vif -eq 1 }).Count
$md += "- Variables with VIF > 10: $highVifCount"
$md += ""
$md += "## Heteroskedasticity (Breusch-Pagan LM)"
$md += "- LM statistic: $([Math]::Round($bpLm, 6))"
$md += "- df: $bpDf"
$md += "- Note: compare LM against chi-square critical value for formal decision."
$md += ""
$md += "## Autocorrelation (Durbin-Watson, within-firm residual ordering)"
$md += "- DW statistic: $([Math]::Round($dw, 6))"
$md += "- Rule of thumb: around 2 indicates weak first-order autocorrelation."
$md += ""
$md += "## High Pairwise Correlation Among Predictors (|r| > 0.8)"
if ($highCorr.Count -eq 0) {
    $md += "- None"
} else {
    foreach ($r in $highCorr) {
        $md += "- $($r.var_1) vs $($r.var_2): $($r.corr)"
    }
}

$outMdDir = Split-Path -Parent $OutMd
if ($outMdDir) { New-Item -ItemType Directory -Force -Path $outMdDir | Out-Null }
$md | Set-Content $OutMd

Write-Host "Wrote assumption report: $OutMd"
Write-Host "Wrote VIF table: $OutVifCsv"
