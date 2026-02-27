param(
    [Parameter(Mandatory = $false)]
    [string]$PlanPath = ".\Plan.md"
)

$ErrorActionPreference = "Stop"

function Run-Step([string]$Label, [scriptblock]$Block, [System.Collections.Generic.List[object]]$Log) {
    try {
        & $Block
        $Log.Add([PSCustomObject]@{ step = $Label; status = "ok"; message = "" })
    } catch {
        $Log.Add([PSCustomObject]@{ step = $Label; status = "failed"; message = $_.Exception.Message })
    }
}

$log = New-Object 'System.Collections.Generic.List[object]'

Run-Step -Label "update_collection_availability" -Log $log -Block {
    powershell -ExecutionPolicy Bypass -File .\scripts\update_collection_availability.ps1 `
      -MasterCsv .\output\data_collection_master_interim.csv `
      -OutStatusCsv .\output\data_collection_master_status.csv `
      -OutReportMd .\output\data_collection_availability_report.md | Out-Null
}

Run-Step -Label "build_download_queues" -Log $log -Block {
    powershell -ExecutionPolicy Bypass -File .\scripts\build_download_queues.ps1 `
      -StatusCsv .\output\data_collection_master_status.csv `
      -OutFsCsv .\output\download_queue_fs.csv `
      -OutArCsv .\output\download_queue_ar.csv `
      -OutPriceCsv .\output\download_queue_price.csv `
      -OutSummaryMd .\output\download_queue_summary.md | Out-Null
}

Run-Step -Label "sync_sample_from_collection" -Log $log -Block {
    powershell -ExecutionPolicy Bypass -File .\scripts\sync_sample_from_collection.ps1 `
      -SampleTemplate .\output\sample_selection_template.csv `
      -CollectionStatus .\output\data_collection_master_status.csv `
      -OutCsv .\output\sample_selection_result_interim.csv `
      -OutSummaryMd .\output\sample_selection_interim_summary.md | Out-Null
}

Run-Step -Label "build_ai_manual_sheet" -Log $log -Block {
    powershell -ExecutionPolicy Bypass -File .\scripts\build_ai_manual_sheet.ps1 `
      -CollectionStatus .\output\data_collection_master_status.csv `
      -OutCsv .\output\ai_disclosure_manual_sheet_interim.csv `
      -OutMd .\output\ai_disclosure_manual_sheet_note.md | Out-Null
}

Run-Step -Label "build_ai_spotcheck_template" -Log $log -Block {
    powershell -ExecutionPolicy Bypass -File .\scripts\build_ai_spotcheck_template.ps1 `
      -MasterCsv .\output\data_collection_master_status.csv `
      -OutCsv .\output\ai_disclosure_spotcheck_10pct.csv `
      -OutMd .\output\ai_disclosure_spotcheck_note.md | Out-Null
}

Run-Step -Label "build_plan_dashboard" -Log $log -Block {
    powershell -ExecutionPolicy Bypass -File .\scripts\build_plan_dashboard.ps1 `
      -PlanPath $PlanPath `
      -OutMd .\output\plan_progress_dashboard.md | Out-Null
}

Run-Step -Label "build_pending_actions" -Log $log -Block {
    powershell -ExecutionPolicy Bypass -File .\scripts\build_pending_actions.ps1 `
      -PlanPath $PlanPath `
      -OutCsv .\output\pending_actions.csv `
      -OutMd .\output\pending_actions_summary.md | Out-Null
}

Run-Step -Label "build_execution_sprint" -Log $log -Block {
    powershell -ExecutionPolicy Bypass -File .\scripts\build_execution_sprint.ps1 `
      -PendingCsv .\output\pending_actions.csv `
      -OutMd .\output\next_actions_sprint.md | Out-Null
}

Run-Step -Label "record_progress_snapshot" -Log $log -Block {
    powershell -ExecutionPolicy Bypass -File .\scripts\record_progress_snapshot.ps1 `
      -AvailabilityReport .\output\data_collection_availability_report.md `
      -DashboardReport .\output\plan_progress_dashboard.md `
      -PendingSummary .\output\pending_actions_summary.md `
      -OutCsv .\output\progress_history.csv | Out-Null
}

Run-Step -Label "build_daily_standup" -Log $log -Block {
    powershell -ExecutionPolicy Bypass -File .\scripts\build_daily_standup.ps1 `
      -ProgressHistory .\output\progress_history.csv `
      -BlockerReport .\output\critical_blockers_report.md `
      -DailyBatch .\output\daily_collection_batch.md `
      -OutMd .\output\daily_standup.md | Out-Null
}

$summaryPath = ".\output\operational_refresh_summary.md"
$okCount = @($log | Where-Object { $_.status -eq "ok" }).Count
$failCount = @($log | Where-Object { $_.status -eq "failed" }).Count

$md = @()
$md += "# Operational Refresh Summary"
$md += ""
$md += "- Steps OK: $okCount"
$md += "- Steps Failed: $failCount"
$md += ""
$md += "## Step Log"
foreach ($r in $log) {
    if ($r.status -eq "ok") {
        $md += "- [OK] $($r.step)"
    } else {
        $md += "- [FAILED] $($r.step): $($r.message)"
    }
}
$md += ""
$md += "## Refreshed Outputs"
$md += "- output/data_collection_master_status.csv"
$md += "- output/data_collection_availability_report.md"
$md += "- output/download_queue_*.csv and output/download_queue_summary.md"
$md += "- output/sample_selection_result_interim.csv"
$md += "- output/ai_disclosure_manual_sheet_interim.csv"
$md += "- output/ai_disclosure_spotcheck_10pct.csv"
$md += "- output/plan_progress_dashboard.md"
$md += "- output/pending_actions.csv + output/pending_actions_summary.md"
$md += "- output/next_actions_sprint.md"
$md += "- output/progress_history.csv"
$md += "- output/daily_standup.md"

$outDir = Split-Path -Parent $summaryPath
if ($outDir) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }
$md | Set-Content -Path $summaryPath

Write-Host "Wrote operational refresh summary: $summaryPath"
