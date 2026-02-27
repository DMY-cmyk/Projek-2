$ErrorActionPreference = "Stop"
$ticker = "TLKM.JK"
$period1 = 1546300800
$period2 = 1767225599
$url = "https://query1.finance.yahoo.com/v7/finance/download/${ticker}?period1=${period1}&period2=${period2}&interval=1d&events=history&includeAdjustedClose=true"
Write-Host "URL: $url"
try {
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    $lines = $response.Content -split "`n" | Select-Object -First 5
    foreach ($l in $lines) { Write-Host $l }
} catch {
    Write-Host "Error: $_"
    Write-Host "Trying with headers..."
    try {
        $headers = @{ "User-Agent" = "Mozilla/5.0" }
        $response = Invoke-WebRequest -Uri $url -Headers $headers -UseBasicParsing
        Write-Host "Status: $($response.StatusCode)"
        $lines = $response.Content -split "`n" | Select-Object -First 5
        foreach ($l in $lines) { Write-Host $l }
    } catch {
        Write-Host "Error with headers: $_"
    }
}
