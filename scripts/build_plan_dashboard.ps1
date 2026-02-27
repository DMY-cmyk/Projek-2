param(
    [Parameter(Mandatory = $false)]
    [string]$PlanPath = ".\Plan.md",
    [Parameter(Mandatory = $false)]
    [string]$OutMd = ".\output\plan_progress_dashboard.md"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $PlanPath)) { throw "Plan file not found: $PlanPath" }
$lines = Get-Content $PlanPath

$currentPhase = "UNKNOWN"
$phaseStats = @{}
$manualCount = 0
$pendingCount = 0
$doneCount = 0

foreach ($ln in $lines) {
    if ($ln -match "^##\s+FASE\s+(.+)$") {
        $currentPhase = $matches[1].Trim()
        if (-not $phaseStats.ContainsKey($currentPhase)) {
            $phaseStats[$currentPhase] = [PSCustomObject]@{ done = 0; pending = 0 }
        }
        continue
    }

    if ($ln -match "^\s*-\s+\[(x| )\]\s+(.+)$") {
        $isDone = ($matches[1] -eq "x")
        $text = $matches[2]
        if (-not $phaseStats.ContainsKey($currentPhase)) {
            $phaseStats[$currentPhase] = [PSCustomObject]@{ done = 0; pending = 0 }
        }
        if ($isDone) {
            $phaseStats[$currentPhase].done++
            $doneCount++
        } else {
            $phaseStats[$currentPhase].pending++
            $pendingCount++
            if ($text -match "BUTUH AKSI MANUSIA") { $manualCount++ }
        }
    }
}

$total = $doneCount + $pendingCount
$pct = if ($total -gt 0) { [Math]::Round(($doneCount * 100.0) / $total, 2) } else { 0 }

$md = @()
$md += "# Plan Progress Dashboard"
$md += ""
$md += "- Source: $PlanPath"
$md += "- Total checklist items: $total"
$md += "- Completed: $doneCount"
$md += "- Pending: $pendingCount"
$md += "- Pending marked manual (`BUTUH AKSI MANUSIA`): $manualCount"
$md += "- Completion rate: $pct%"
$md += ""
$md += "## By Phase"
$md += "| Phase | Done | Pending |"
$md += "|---|---:|---:|"
foreach ($k in ($phaseStats.Keys | Sort-Object)) {
    $md += "| $k | $($phaseStats[$k].done) | $($phaseStats[$k].pending) |"
}
$md += ""
$md += "## Notes"
$md += "- Dashboard is progress metadata, not a substitute for quality review."
$md += "- Rerun after each major update to keep execution status current."

$outDir = Split-Path -Parent $OutMd
if ($outDir) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }
$md | Set-Content -Path $OutMd

Write-Host "Wrote dashboard: $OutMd"
