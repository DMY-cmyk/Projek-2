param(
    [int]$StartYear = 2019,
    [int]$EndYear = 2025,
    [string]$OutDir = "data/prices"
)

$ErrorActionPreference = "Continue"

$tickers = @(
    "MTDL.JK","LMAS.JK","PTSN.JK","SKYB.JK","MLPT.JK","ATIC.JK",
    "KIOS.JK","MCAS.JK","NFCX.JK","DIVA.JK","LUCK.JK",
    "ISAT.JK","TLKM.JK","KBLV.JK","CENT.JK","EXCL.JK",
    "BTEL.JK","TOWR.JK","TBIG.JK","SUPR.JK",
    "IBST.JK","BALI.JK","LINK.JK","OASA.JK","LCKM.JK","GHON.JK"
)

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$success = @()
$failed = @()

foreach ($t in $tickers) {
    $outFile = Join-Path $OutDir "prices_$t.csv"
    Write-Host "Fetching $t ..."
    try {
        & "$PSScriptRoot\price_fetch.ps1" -Ticker $t -StartYear $StartYear -EndYear $EndYear -Out $outFile
        $success += $t
        Write-Host "  OK: $outFile"
    } catch {
        $failed += $t
        Write-Host "  FAILED: $t - $_"
    }
    Start-Sleep -Seconds 1
}

Write-Host ""
Write-Host "=== SUMMARY ==="
Write-Host "Success: $($success.Count) / $($tickers.Count)"
Write-Host "Failed: $($failed.Count)"
if ($failed.Count -gt 0) {
    Write-Host "Failed tickers: $($failed -join ', ')"
}
