param(
    [Parameter(Mandatory = $false)]
    [string]$AvailabilityReport = ".\output\data_collection_availability_report.md",
    [Parameter(Mandatory = $false)]
    [string]$ModelReadiness = ".\output\model_readiness_report.md",
    [Parameter(Mandatory = $false)]
    [string]$PendingSummary = ".\output\pending_actions_summary.md",
    [Parameter(Mandatory = $false)]
    [string]$OutMd = ".\output\critical_blockers_report.md"
)

$ErrorActionPreference = "Stop"

function TryRead([string]$p) {
    if (Test-Path $p) { return Get-Content $p }
    return @("File not found: $p")
}

$avail = TryRead $AvailabilityReport
$model = TryRead $ModelReadiness
$pending = TryRead $PendingSummary

function ExtractNum([string[]]$lines, [string]$pattern) {
    foreach ($ln in $lines) {
        if ($ln -match $pattern) { return [int]$matches[1] }
    }
    return $null
}

$fsAvail = ExtractNum $avail "Financial statement PDFs available:\s+(\d+)\s*/"
$arAvail = ExtractNum $avail "Annual report PDFs available:\s+(\d+)\s*/"
$pxAvail = ExtractNum $avail "Price CSV files available:\s+(\d+)\s*/"
$pendingTotal = ExtractNum $pending "Total pending actions:\s+(\d+)"
$modelReady = $false
foreach ($ln in $model) {
    if ($ln -match "Ready for full 9-model estimation:\s+True") { $modelReady = $true }
}

$md = @()
$md += "# Critical Blockers Report"
$md += ""
$md += "- Source availability: $AvailabilityReport"
$md += "- Source model readiness: $ModelReadiness"
$md += "- Source pending summary: $PendingSummary"
$md += ""
$md += "## Current Blockers"
$md += "- FS availability: $fsAvail"
$md += "- AR availability: $arAvail"
$md += "- Price availability: $pxAvail"
$md += "- Model ready for full estimation: $modelReady"
$md += "- Total pending actions: $pendingTotal"
$md += ""
$md += "## Immediate Resolution Path"
$md += "1. Raise FS/AR/Price availability via daily collection batches."
$md += "2. Rebuild panel dataset after sufficient availability."
$md += "3. Re-run EViews pipeline and hypothesis extraction."
$md += "4. Finalize model choice + interpretation templates."

$outDir = Split-Path -Parent $OutMd
if ($outDir) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }
$md | Set-Content -Path $OutMd

Write-Host "Wrote blocker report: $OutMd"
