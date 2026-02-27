param(
    [Parameter(Mandatory = $false)]
    [string]$EViewsOutDir = ".\output\eviews",
    [Parameter(Mandatory = $false)]
    [string]$OutCsv = ".\output\hypothesis_results.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutMd = ".\output\hypothesis_decision.md",
    [Parameter(Mandatory = $false)]
    [double]$Alpha = 0.05
)

$ErrorActionPreference = "Stop"

function Parse-EqRow {
    param(
        [string]$Text,
        [string]$Variable
    )
    # Best effort parser for EViews text output rows:
    # VarName  Coef  StdErr  t-Stat  Prob
    $pattern = "^\s*" + [Regex]::Escape($Variable) + "\s+([\-0-9Ee\.\+]+)\s+([\-0-9Ee\.\+]+)\s+([\-0-9Ee\.\+]+)\s+([\-0-9Ee\.\+]+)\s*$"
    foreach ($line in ($Text -split "`r?`n")) {
        if ($line -match $pattern) {
            $coef = [double]$matches[1]
            $tstat = [double]$matches[3]
            $pval = [double]$matches[4]
            return @{
                found = $true
                coef = $coef
                tstat = $tstat
                pval = $pval
            }
        }
    }
    return @{ found = $false; coef = $null; tstat = $null; pval = $null }
}

if (-not (Test-Path $EViewsOutDir)) {
    throw "EViews output directory not found: $EViewsOutDir"
}

$eqFiles = @{
    price = Join-Path $EViewsOutDir "eq_price_base.txt"
    ret = Join-Path $EViewsOutDir "eq_ret_base.txt"
    tq = Join-Path $EViewsOutDir "eq_tq_base.txt"
}

$mapping = @(
    @{ hypothesis="H1a"; variable="roa"; dependent="price"; expected="+" },
    @{ hypothesis="H1b"; variable="roa"; dependent="ret"; expected="+" },
    @{ hypothesis="H1c"; variable="roa"; dependent="tq"; expected="+" },
    @{ hypothesis="H2a"; variable="der"; dependent="price"; expected="-" },
    @{ hypothesis="H2b"; variable="der"; dependent="ret"; expected="-" },
    @{ hypothesis="H2c"; variable="der"; dependent="tq"; expected="-" },
    @{ hypothesis="H3a"; variable="eps"; dependent="price"; expected="+" },
    @{ hypothesis="H3b"; variable="eps"; dependent="ret"; expected="+" },
    @{ hypothesis="H3c"; variable="eps"; dependent="tq"; expected="+" }
)

$rows = @()
foreach ($m in $mapping) {
    $eqPath = $eqFiles[$m.dependent]
    $coef = $null
    $tstat = $null
    $pval = $null
    $decision = "Pending"
    $direction = ""
    $note = ""

    if (Test-Path $eqPath) {
        $txt = Get-Content -Path $eqPath -Raw
        $parsed = Parse-EqRow -Text $txt -Variable $m.variable
        if ($parsed.found) {
            $coef = [Math]::Round($parsed.coef, 6)
            $tstat = [Math]::Round($parsed.tstat, 6)
            $pval = [Math]::Round($parsed.pval, 6)
            $direction = if ($coef -gt 0) { "+" } elseif ($coef -lt 0) { "-" } else { "0" }

            if ($pval -le $Alpha) {
                if ($direction -eq $m.expected) {
                    $decision = "Diterima"
                } else {
                    $decision = "Ditolak (arah berlawanan)"
                }
            } else {
                $decision = "Ditolak (tidak signifikan)"
            }
        } else {
            $note = "Variable row not found in equation output."
        }
    } else {
        $note = "Equation output file not found."
    }

    $rows += [PSCustomObject]@{
        hypothesis = $m.hypothesis
        variable = $m.variable
        dependent = $m.dependent
        expected_sign = $m.expected
        coef = $coef
        t_stat = $tstat
        p_value = $pval
        observed_sign = $direction
        alpha = $Alpha
        decision = $decision
        note = $note
    }
}

$outDir = Split-Path -Parent $OutCsv
if ($outDir) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }
$rows | Export-Csv -Path $OutCsv -NoTypeInformation -Encoding UTF8

$accepted = @($rows | Where-Object { $_.decision -eq "Diterima" }).Count
$rejected = @($rows | Where-Object { $_.decision -like "Ditolak*" }).Count
$pending = @($rows | Where-Object { $_.decision -eq "Pending" }).Count

$md = @()
$md += "# Hypothesis Decision Summary"
$md += ""
$md += "- Alpha: $Alpha"
$md += "- Accepted: $accepted"
$md += "- Rejected: $rejected"
$md += "- Pending: $pending"
$md += ""
$md += "| Hypothesis | Variable | Dependent | Coef | p-value | Decision |"
$md += "|---|---|---|---:|---:|---|"
foreach ($r in $rows) {
    $md += "| $($r.hypothesis) | $($r.variable) | $($r.dependent) | $($r.coef) | $($r.p_value) | $($r.decision) |"
}
$md += ""
$md += "Detailed table: `output/hypothesis_results.csv`."

$mdDir = Split-Path -Parent $OutMd
if ($mdDir) { New-Item -ItemType Directory -Force -Path $mdDir | Out-Null }
$md | Set-Content -Path $OutMd

Write-Host "Wrote hypothesis table: $OutCsv"
Write-Host "Wrote hypothesis summary: $OutMd"
