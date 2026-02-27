param(
    [Parameter(Mandatory = $false)]
    [string]$PlanPath = ".\Plan.md",
    [Parameter(Mandatory = $false)]
    [string]$OutCsv = ".\output\pending_actions.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutMd = ".\output\pending_actions_summary.md"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $PlanPath)) { throw "Plan file not found: $PlanPath" }
$lines = Get-Content $PlanPath

$phase = "UNKNOWN"
$step = ""
$items = @()
$idx = 0

foreach ($ln in $lines) {
    if ($ln -match "^##\s+FASE\s+(.+)$") {
        $phase = $matches[1].Trim()
        continue
    }
    if ($ln -match "^###\s+Step\s+(.+)$") {
        $step = $matches[1].Trim()
        continue
    }
    if ($ln -match "^\s*-\s+\[\s\]\s+(.+)$") {
        $task = $matches[1].Trim()
        $idx++
        $isManual = $false
        if ($task -match "BUTUH AKSI MANUSIA|Submit|Revisi|Upload|Latihan presentasi|download|Download|manual") {
            $isManual = $true
        }

        $items += [PSCustomObject]@{
            id = $idx
            phase = $phase
            step = $step
            task = $task
            owner_hint = if ($isManual) { "manual" } else { "mixed" }
            status = "pending"
        }
    }
}

$outDir = Split-Path -Parent $OutCsv
if ($outDir) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }
$items | Export-Csv -Path $OutCsv -NoTypeInformation -Encoding UTF8

$manual = @($items | Where-Object { $_.owner_hint -eq "manual" }).Count
$mixed = @($items | Where-Object { $_.owner_hint -eq "mixed" }).Count

$phaseMap = @{}
foreach ($it in $items) {
    if (-not $phaseMap.ContainsKey($it.phase)) { $phaseMap[$it.phase] = 0 }
    $phaseMap[$it.phase]++
}

$md = @()
$md += "# Pending Actions Summary"
$md += ""
$md += "- Source plan: $PlanPath"
$md += "- Total pending actions: $($items.Count)"
$md += "- Owner hint manual: $manual"
$md += "- Owner hint mixed: $mixed"
$md += "- Detailed list: $OutCsv"
$md += ""
$md += "## Pending by Phase"
$md += "| Phase | Pending Count |"
$md += "|---|---:|"
foreach ($k in ($phaseMap.Keys | Sort-Object)) {
    $md += "| $k | $($phaseMap[$k]) |"
}
$md += ""
$md += "## Usage"
$md += "- Use this file as daily execution queue."
$md += "- Update `Plan.md` first, then regenerate this summary."

$mdDir = Split-Path -Parent $OutMd
if ($mdDir) { New-Item -ItemType Directory -Force -Path $mdDir | Out-Null }
$md | Set-Content -Path $OutMd

Write-Host "Wrote pending actions CSV: $OutCsv"
Write-Host "Wrote pending actions summary: $OutMd"
