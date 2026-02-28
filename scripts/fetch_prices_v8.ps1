param(
    [int]$StartYear = 2019,
    [int]$EndYear = 2025,
    [string]$OutDir = "data/prices"
)

$ErrorActionPreference = "Continue"

$tickers = @(
    "ATIC.JK","BALI.JK","BTEL.JK","CENT.JK","DIVA.JK",
    "EXCL.JK","GHON.JK","IBST.JK","ISAT.JK",
    "KBLV.JK","KIOS.JK","LCKM.JK","LINK.JK","LMAS.JK",
    "LUCK.JK","MCAS.JK","MLPT.JK","MTDL.JK","NFCX.JK",
    "OASA.JK","PTSN.JK","SKYB.JK","SUPR.JK","TBIG.JK",
    "TLKM.JK","TOWR.JK"
)

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$success = @()
$failed = @()

foreach ($t in $tickers) {
    $shortTicker = $t -replace '\.JK$', ''
    $outFile = Join-Path $OutDir "prices_${shortTicker}.csv"
    Write-Host "Fetching $t via v8 chart API..."
    try {
        $url = "https://query1.finance.yahoo.com/v8/finance/chart/${t}?range=10y&interval=1mo&includeAdjustedClose=true"
        $headers = @{ "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" }
        $resp = Invoke-RestMethod -Uri $url -Headers $headers -UseBasicParsing

        $timestamps = $resp.chart.result[0].timestamp
        $closes = $resp.chart.result[0].indicators.quote[0].close

        if (-not $timestamps -or $timestamps.Count -eq 0) {
            throw "No data returned"
        }

        # Group by year, pick last available close per year
        $yearData = @{}
        for ($i = 0; $i -lt $timestamps.Count; $i++) {
            $ts = $timestamps[$i]
            $close = $closes[$i]
            if ($null -eq $close) { continue }
            $dt = [DateTimeOffset]::FromUnixTimeSeconds($ts).DateTime
            $yr = $dt.Year
            if ($yr -lt $StartYear -or $yr -gt $EndYear) { continue }
            if (-not $yearData.ContainsKey($yr) -or $dt -gt $yearData[$yr].Date) {
                $yearData[$yr] = [pscustomobject]@{ Date = $dt; Close = $close }
            }
        }

        $outRows = foreach ($yr in ($yearData.Keys | Sort-Object)) {
            [pscustomobject]@{
                fy = $yr
                price = [math]::Round($yearData[$yr].Close, 2)
            }
        }

        $outRows | Export-Csv -Path $outFile -NoTypeInformation
        $success += $t
        Write-Host "  OK: $outFile ($($outRows.Count) years)"
    } catch {
        $failed += $t
        Write-Host "  FAILED: $t - $_"
    }
    Start-Sleep -Milliseconds 500
}

Write-Host ""
Write-Host "=== SUMMARY ==="
Write-Host "Success: $($success.Count) / $($tickers.Count)"
Write-Host "Failed: $($failed.Count)"
if ($failed.Count -gt 0) {
    Write-Host "Failed tickers: $($failed -join ', ')"
}
