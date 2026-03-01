$raw = Get-Content ".\temp_skripsi_text.txt" -Raw
$lines = $raw -split "`r" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
$lines | Set-Content ".\temp_skripsi_lines.txt" -Encoding UTF8
Write-Host "Split into $($lines.Count) lines"
