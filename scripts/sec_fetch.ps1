param(
  [string]$Cik,
  [string]$Ticker,
  [Parameter(Mandatory = $true)][string]$UserAgent,
  [string]$Out = "sec_companyfacts.csv",
  [string]$RatiosOut = "sec_ratios.csv",
  [string]$CacheDir = "data/sec_cache",
  [string]$TickersPath = "data/sec_cache/company_tickers.json",
  [string]$PriceCsv,
  [string]$PriceTicker,
  [int]$PriceStartYear = 2019,
  [int]$PriceEndYear = 2025,
  [switch]$NoFyOnly
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($Cik) -and [string]::IsNullOrWhiteSpace($Ticker)) {
  throw "Provide either -Cik or -Ticker"
}

$exe = "cargo"
$argList = @(
  "run",
  "-p",
  "projek-2",
  "--",
  "sec-fetch"
)

if (-not [string]::IsNullOrWhiteSpace($Cik)) {
  $argList += @("--cik", $Cik)
} else {
  $argList += @("--cik", "0")
}

if (-not [string]::IsNullOrWhiteSpace($Ticker)) {
  $argList += @("--ticker", $Ticker)
}

$argList += @(
  "--user-agent", $UserAgent,
  "--out", $Out,
  "--ratios-out", $RatiosOut,
  "--cache-dir", $CacheDir,
  "--tickers-path", $TickersPath,
  "--price-start-year", $PriceStartYear,
  "--price-end-year", $PriceEndYear
)

if (-not [string]::IsNullOrWhiteSpace($PriceCsv)) {
  $argList += @("--price-csv", $PriceCsv)
}

if (-not [string]::IsNullOrWhiteSpace($PriceTicker)) {
  $argList += @("--price-ticker", $PriceTicker)
}

if ($NoFyOnly) {
  $argList += @("--fy-only", "false")
}

& $exe @argList
