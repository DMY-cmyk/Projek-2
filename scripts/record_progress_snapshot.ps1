param(
    [Parameter(Mandatory = $false)]
    [string]$AvailabilityReport = ".\output\data_collection_availability_report.md",
    [Parameter(Mandatory = $false)]
    [string]$DashboardReport = ".\output\plan_progress_dashboard.md",
    [Parameter(Mandatory = $false)]
    [string]$PendingSummary = ".\output\pending_actions_summary.md",
    [Parameter(Mandatory = $false)]
    [string]$OutCsv = ".\output\progress_history.csv"
)

$ErrorActionPreference = "Stop"

function Read-Lines([string]$p) {
    if (Test-Path $p) { return Get-Content $p }
    return @()
}

function Extract-Int([string[]]$lines, [string]$pattern) {
    foreach ($ln in $lines) {
        if ($ln -match $pattern) { return [int]$matches[1] }
    }
    return 0
}

function Extract-Double([string[]]$lines, [string]$pattern) {
    foreach ($ln in $lines) {
        if ($ln -match $pattern) { return [double]$matches[1] }
    }
    return 0.0
}

$avail = Read-Lines $AvailabilityReport
$dash = Read-Lines $DashboardReport
$pend = Read-Lines $PendingSummary

$fsAvail = Extract-Int $avail "Financial statement PDFs available:\s+(\d+)\s*/"
$arAvail = Extract-Int $avail "Annual report PDFs available:\s+(\d+)\s*/"
$pxAvail = Extract-Int $avail "Price CSV files available:\s+(\d+)\s*/"
$fullAvail = Extract-Int $avail "Fully complete rows \(FS \+ AR \+ Price\):\s+(\d+)\s*/"
$totalRows = Extract-Int $avail "Total firm-year rows:\s+(\d+)"

$doneCount = Extract-Int $dash "Completed:\s+(\d+)"
$pendingCount = Extract-Int $dash "Pending:\s+(\d+)"
$completionRate = Extract-Double $dash "Completion rate:\s+([0-9]+(?:\.[0-9]+)?)%"
$pendingActions = Extract-Int $pend "Total pending actions:\s+(\d+)"

$timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

$row = [PSCustomObject]@{
    timestamp = $timestamp
    total_firm_year_rows = $totalRows
    fs_available = $fsAvail
    ar_available = $arAvail
    price_available = $pxAvail
    fully_complete_rows = $fullAvail
    plan_done = $doneCount
    plan_pending = $pendingCount
    plan_completion_rate_pct = $completionRate
    pending_actions = $pendingActions
}

$outDir = Split-Path -Parent $OutCsv
if ($outDir) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }

if (Test-Path $OutCsv) {
    $existing = Import-Csv $OutCsv
    $combined = @($existing) + @($row)
    $combined | Export-Csv -Path $OutCsv -NoTypeInformation -Encoding UTF8
} else {
    @($row) | Export-Csv -Path $OutCsv -NoTypeInformation -Encoding UTF8
}

Write-Host "Appended progress snapshot to: $OutCsv"
