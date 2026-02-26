param(
  [Parameter(Mandatory = $true)][string]$UserAgent,
  [string]$Out = "data/sec_cache/company_tickers.json"
)

$ErrorActionPreference = "Stop"

$exe = "cargo"
$argList = @(
  "run",
  "-p",
  "projek-2",
  "--",
  "sec-tickers",
  "--user-agent", $UserAgent,
  "--out", $Out
)

& $exe @argList
