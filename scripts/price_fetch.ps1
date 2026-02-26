param(
  [Parameter(Mandatory = $true)][string]$Ticker,
  [int]$StartYear = 2019,
  [int]$EndYear = 2025,
  [string]$Out = "data/prices_$Ticker.csv"
)

$ErrorActionPreference = "Stop"

function To-UnixTime([datetime]$dt) {
  [int][double]([DateTimeOffset]$dt).ToUnixTimeSeconds()
}

$start = Get-Date -Date "$StartYear-01-01" -Hour 0 -Minute 0 -Second 0
$end = Get-Date -Date "$EndYear-12-31" -Hour 23 -Minute 59 -Second 59

$period1 = To-UnixTime $start
$period2 = To-UnixTime $end

$base = "https://query1.finance.yahoo.com/v7/finance/download/$Ticker"
$url = "$base?period1=$period1&period2=$period2&interval=1d&events=history&includeAdjustedClose=true"

$csvPath = Join-Path $env:TEMP "yahoo_$Ticker.csv"
Invoke-RestMethod -Uri $url -OutFile $csvPath

$rows = Import-Csv $csvPath | Where-Object { $_.Close -and $_.Close -ne "null" }

$yearGroups = $rows | Group-Object { (Get-Date $_.Date).Year } | Where-Object {
  $_.Name -ge $StartYear -and $_.Name -le $EndYear
}

$outRows = foreach ($g in $yearGroups) {
  $last = $g.Group | Sort-Object { Get-Date $_.Date } | Select-Object -Last 1
  [pscustomobject]@{
    fy = [int]$g.Name
    price = [double]$last.Close
  }
}

$dir = Split-Path -Parent $Out
if ($dir) {
  New-Item -ItemType Directory -Force $dir | Out-Null
}

$outRows | Sort-Object fy | Export-Csv -Path $Out -NoTypeInformation
Write-Host "Saved $Out"
