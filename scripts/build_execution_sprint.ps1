param(
    [Parameter(Mandatory = $false)]
    [string]$PendingCsv = ".\output\pending_actions.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutMd = ".\output\next_actions_sprint.md"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $PendingCsv)) { throw "Pending CSV not found: $PendingCsv" }
$rows = Import-Csv $PendingCsv
if ($rows.Count -eq 0) { throw "Pending CSV is empty: $PendingCsv" }

function Score-Task([string]$phase, [string]$task) {
    $score = 0
    # Prioritize data-collection blockers first.
    if ($phase -like "3:*") { $score += 50 }
    if ($phase -like "2:*") { $score += 35 }
    if ($phase -like "4:*") { $score += 30 }
    if ($phase -like "6:*") { $score += 20 }
    if ($phase -like "0:*") { $score += 10 }

    if ($task -match "download|Download|annual report|laporan keuangan|harga saham|content analysis|AID|sampel final") { $score += 40 }
    if ($task -match "model|regresi|hipotesis|GMM|interaksi") { $score += 25 }
    if ($task -match "Submit|Revisi|Upload|Latihan presentasi") { $score += 15 }
    return $score
}

$ranked = @()
foreach ($r in $rows) {
    $ranked += [PSCustomObject]@{
        id = $r.id
        phase = $r.phase
        step = $r.step
        task = $r.task
        owner_hint = $r.owner_hint
        score = Score-Task -phase $r.phase -task $r.task
    }
}
$ranked = $ranked | Sort-Object -Property @{Expression="score";Descending=$true}, @{Expression="id";Descending=$false}

$top = @($ranked | Select-Object -First 20)

$md = @()
$md += "# Next Actions Sprint (Priority Queue)"
$md += ""
$md += "- Source queue: $PendingCsv"
$md += "- Total pending: $($rows.Count)"
$md += "- Sprint size (top priority): $($top.Count)"
$md += ""
$md += "## Top Priority Tasks"
$md += "| Priority | Phase | Step | Owner Hint | Task |"
$md += "|---:|---|---|---|---|"
$i = 0
foreach ($t in $top) {
    $i++
    $md += "| $i | $($t.phase) | $($t.step) | $($t.owner_hint) | $($t.task) |"
}
$md += ""
$md += "## Suggested Execution Order"
$md += "1. Selesaikan seluruh item data collection (FS/AR/Price) sampai availability >= 80%."
$md += "2. Finalisasi sampel berdasarkan availability nyata, lalu rebuild panel dataset."
$md += "3. Jalankan ulang model panel + hypothesis extraction pada dataset final."
$md += "4. Tutup sisa item finalisasi administratif (konsultasi pembimbing dan sidang)."

$outDir = Split-Path -Parent $OutMd
if ($outDir) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }
$md | Set-Content -Path $OutMd

Write-Host "Wrote sprint queue: $OutMd"
