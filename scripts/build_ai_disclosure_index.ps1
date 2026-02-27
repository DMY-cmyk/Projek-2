param(
    [Parameter(Mandatory = $false)]
    [string]$InputDir = ".\output\annual_reports_txt",
    [Parameter(Mandatory = $false)]
    [string]$OutCsv = ".\output\ai_disclosure_index.csv"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $InputDir)) {
    throw "Input directory not found: $InputDir"
}

$files = Get-ChildItem -Path $InputDir -File -Filter *.txt
if ($files.Count -eq 0) {
    throw "No .txt files found in $InputDir"
}

$keywords = @{
    ai_core = @(
        "artificial intelligence", "kecerdasan buatan", " ai ",
        "machine learning", "deep learning", "neural network"
    )
    digital_tech = @(
        "big data", "cloud computing", "iot", "internet of things",
        "blockchain", "automation", "robotics"
    )
    digital_transformation = @(
        "digital transformation", "transformasi digital",
        "digitalisasi", "digitization"
    )
}

$rows = @()
foreach ($f in $files) {
    # Expected filename: {TICKER}_{YEAR}_AR.txt
    if ($f.BaseName -notmatch "^([A-Za-z0-9]+)_(\d{4})_AR$") {
        continue
    }

    $ticker = $matches[1].ToUpperInvariant()
    $year = [int]$matches[2]
    $text = (Get-Content -Path $f.FullName -Raw).ToLowerInvariant()
    $textPadded = " " + $text + " "
    $totalWords = [Math]::Max(1, ($text -split "\s+").Count)

    $catFlags = @{}
    $catFreq = @{}

    foreach ($cat in $keywords.Keys) {
        $found = 0
        $freq = 0
        foreach ($kw in $keywords[$cat]) {
            $escaped = [Regex]::Escape($kw)
            $count = ([Regex]::Matches($textPadded, $escaped)).Count
            if ($count -gt 0) { $found = 1 }
            $freq += $count
        }
        $catFlags[$cat] = $found
        $catFreq[$cat] = $freq
    }

    $binaryAID = ($catFlags.ai_core + $catFlags.digital_tech + $catFlags.digital_transformation) / 3.0
    $freqTotal = $catFreq.ai_core + $catFreq.digital_tech + $catFreq.digital_transformation
    $freqAID = $freqTotal / $totalWords

    $rows += [PSCustomObject]@{
        ticker = $ticker
        year = $year
        ai_core_flag = $catFlags.ai_core
        digital_tech_flag = $catFlags.digital_tech
        digital_transformation_flag = $catFlags.digital_transformation
        ai_core_freq = $catFreq.ai_core
        digital_tech_freq = $catFreq.digital_tech
        digital_transformation_freq = $catFreq.digital_transformation
        aid_binary = [Math]::Round($binaryAID, 6)
        aid_frequency = [Math]::Round($freqAID, 8)
        total_words = $totalWords
        source_file = $f.Name
    }
}

if ($rows.Count -eq 0) {
    throw "No files matched expected pattern {TICKER}_{YEAR}_AR.txt in $InputDir"
}

$outParent = Split-Path -Parent $OutCsv
if ($outParent) {
    New-Item -ItemType Directory -Force -Path $outParent | Out-Null
}

$rows | Sort-Object ticker, year | Export-Csv -Path $OutCsv -NoTypeInformation -Encoding UTF8
Write-Host "Wrote AI disclosure index: $OutCsv ($($rows.Count) rows)"
