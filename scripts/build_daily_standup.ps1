param(
    [Parameter(Mandatory = $false)]
    [string]$ProgressHistory = ".\output\progress_history.csv",
    [Parameter(Mandatory = $false)]
    [string]$BlockerReport = ".\output\critical_blockers_report.md",
    [Parameter(Mandatory = $false)]
    [string]$DailyBatch = ".\output\daily_collection_batch.md",
    [Parameter(Mandatory = $false)]
    [string]$OutMd = ".\output\daily_standup.md"
)

$ErrorActionPreference = "Stop"

$history = @()
if (Test-Path $ProgressHistory) { $history = @(Import-Csv $ProgressHistory) }
$last = $null
$prev = $null
if ($history.Count -gt 0) {
    $last = $history[-1]
}
if ($history.Count -gt 1) {
    $prev = $history[-2]
}

function Delta([object]$a, [object]$b) {
    if ($null -eq $a -or $null -eq $b) { return "" }
    return ([double]$a - [double]$b)
}

$md = @()
$md += "# Daily Standup"
$md += ""
$md += "- Generated at: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$md += ""
$md += "## Progress Snapshot"
if ($null -eq $last) {
    $md += "- No progress history yet. Run `scripts/record_progress_snapshot.ps1` first."
} else {
    $md += "- Latest timestamp: $($last.timestamp)"
    $md += "- FS available: $($last.fs_available) / $($last.total_firm_year_rows)"
    $md += "- AR available: $($last.ar_available) / $($last.total_firm_year_rows)"
    $md += "- Price available: $($last.price_available) / $($last.total_firm_year_rows)"
    $md += "- Fully complete rows: $($last.fully_complete_rows) / $($last.total_firm_year_rows)"
    $md += "- Plan completion: $($last.plan_completion_rate_pct)% ($($last.plan_done) done, $($last.plan_pending) pending)"
    $md += "- Pending actions: $($last.pending_actions)"
    if ($null -ne $prev) {
        $md += ""
        $md += "### Delta vs Previous Snapshot"
        $md += "- FS delta: $(Delta $last.fs_available $prev.fs_available)"
        $md += "- AR delta: $(Delta $last.ar_available $prev.ar_available)"
        $md += "- Price delta: $(Delta $last.price_available $prev.price_available)"
        $md += "- Fully complete delta: $(Delta $last.fully_complete_rows $prev.fully_complete_rows)"
        $md += "- Plan completion delta (%): $(Delta $last.plan_completion_rate_pct $prev.plan_completion_rate_pct)"
        $md += "- Pending actions delta: $(Delta $last.pending_actions $prev.pending_actions)"
    }
}

$md += ""
$md += "## Today Focus"
if (Test-Path $DailyBatch) {
    $batchLines = Get-Content $DailyBatch | Select-Object -First 14
    $md += $batchLines
} else {
    $md += "- Daily batch file not found: $DailyBatch"
}

$md += ""
$md += "## Critical Blockers"
if (Test-Path $BlockerReport) {
    $blockerLines = Get-Content $BlockerReport | Select-Object -First 20
    $md += $blockerLines
} else {
    $md += "- Blocker report not found: $BlockerReport"
}

$outDir = Split-Path -Parent $OutMd
if ($outDir) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }
$md | Set-Content -Path $OutMd

Write-Host "Wrote daily standup: $OutMd"
