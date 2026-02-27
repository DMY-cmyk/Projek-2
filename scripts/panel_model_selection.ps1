param(
    [Parameter(Mandatory = $false)]
    [string]$DatasetPath = ".\output\panel_dataset_template.csv",
    [Parameter(Mandatory = $false)]
    [string]$Dependent = "price",
    [Parameter(Mandatory = $false)]
    [string]$Regressors = "roa der eps size growth age vol aid ii dgenai",
    [Parameter(Mandatory = $false)]
    [string]$OutDir = ".\output\eviews_model_selection",
    [Parameter(Mandatory = $false)]
    [string]$OutReportMd = ".\output\panel_model_selection.md"
)

$ErrorActionPreference = "Stop"

function Resolve-FullPath {
    param([string]$PathValue)
    $resolved = Resolve-Path -Path $PathValue -ErrorAction Stop
    return $resolved.Path
}

function Invoke-EViewsCmd {
    param(
        [object]$App,
        [string]$Command,
        [string]$Label,
        [System.Collections.Generic.List[object]]$Log
    )
    try {
        $App.Run($Command)
        $Log.Add([PSCustomObject]@{
            step = $Label
            status = "ok"
            command = $Command
            message = ""
        })
        return $true
    } catch {
        $Log.Add([PSCustomObject]@{
            step = $Label
            status = "failed"
            command = $Command
            message = $_.Exception.Message
        })
        return $false
    }
}

$dataset = Resolve-FullPath -PathValue $DatasetPath
$outDirFull = [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $OutDir))
New-Item -ItemType Directory -Force -Path $outDirFull | Out-Null

$log = New-Object 'System.Collections.Generic.List[object]'
$mgr = New-Object -ComObject "EViews.Manager"
$app = $mgr.GetApplication()
$app.Hide()

try {
    $escapedDataset = $dataset.Replace("\", "\\")
    $escapedOut = $outDirFull.Replace("\", "\\")

    Invoke-EViewsCmd -App $app -Label "load_dataset" -Log $log -Command "wfload(page=raw) `"$escapedDataset`"" | Out-Null
    Invoke-EViewsCmd -App $app -Label "pagestruct" -Log $log -Command "pagestruct firm_id year" | Out-Null
    Invoke-EViewsCmd -App $app -Label "smpl_all" -Log $log -Command "smpl @all" | Out-Null

    $baseSpec = "$Dependent c $Regressors"

    # Pooled OLS
    $okPooled = Invoke-EViewsCmd -App $app -Label "pooled_ls" -Log $log -Command "equation eq_pool.ls $baseSpec"
    if ($okPooled) {
        Invoke-EViewsCmd -App $app -Label "export_pooled" -Log $log -Command "freeze(tab_pool) eq_pool.output" | Out-Null
        Invoke-EViewsCmd -App $app -Label "save_pooled" -Log $log -Command "tab_pool.save(t=txt) `"$escapedOut\\eq_pool.txt`"" | Out-Null
    }

    # Fixed effects (entity)
    $okFe = Invoke-EViewsCmd -App $app -Label "fixed_effects" -Log $log -Command "equation eq_fe.ls(panel=fixed) $baseSpec"
    if ($okFe) {
        Invoke-EViewsCmd -App $app -Label "export_fe" -Log $log -Command "freeze(tab_fe) eq_fe.output" | Out-Null
        Invoke-EViewsCmd -App $app -Label "save_fe" -Log $log -Command "tab_fe.save(t=txt) `"$escapedOut\\eq_fe.txt`"" | Out-Null
    }

    # Random effects
    $okRe = Invoke-EViewsCmd -App $app -Label "random_effects" -Log $log -Command "equation eq_re.ls(panel=random) $baseSpec"
    if ($okRe) {
        Invoke-EViewsCmd -App $app -Label "export_re" -Log $log -Command "freeze(tab_re) eq_re.output" | Out-Null
        Invoke-EViewsCmd -App $app -Label "save_re" -Log $log -Command "tab_re.save(t=txt) `"$escapedOut\\eq_re.txt`"" | Out-Null
    }

    # Attempt common model-selection tests.
    $chowOk = Invoke-EViewsCmd -App $app -Label "chow_test_attempt" -Log $log -Command "freeze(tab_chow) eq_fe.redtest" 
    if ($chowOk) {
        Invoke-EViewsCmd -App $app -Label "save_chow" -Log $log -Command "tab_chow.save(t=txt) `"$escapedOut\\chow_test.txt`"" | Out-Null
    }

    $hausmanOk = Invoke-EViewsCmd -App $app -Label "hausman_test_attempt" -Log $log -Command "freeze(tab_hausman) eq_re.hausman eq_fe"
    if ($hausmanOk) {
        Invoke-EViewsCmd -App $app -Label "save_hausman" -Log $log -Command "tab_hausman.save(t=txt) `"$escapedOut\\hausman_test.txt`"" | Out-Null
    }
}
finally {
    try { $app.Run("close @all") } catch {}
}

$okCount = @($log | Where-Object { $_.status -eq "ok" }).Count
$failCount = @($log | Where-Object { $_.status -eq "failed" }).Count

$report = @()
$report += "# Panel Model Selection Report"
$report += ""
$report += "- Dataset: $dataset"
$report += "- Dependent: $Dependent"
$report += "- Regressors: $Regressors"
$report += "- Success steps: $okCount"
$report += "- Failed steps: $failCount"
$report += ""
$report += "## Execution Log"
foreach ($row in $log) {
    if ($row.status -eq "ok") {
        $report += "- [OK] $($row.step)"
    } else {
        $report += "- [FAILED] $($row.step): $($row.message)"
    }
}
$report += ""
$report += "## Decision Guidance"
$report += "1. If `eq_pool`, `eq_fe`, and `eq_re` all succeed, compare test outputs (Chow/Hausman) in output folder."
$report += "2. If test attempts fail, run corresponding tests manually in EViews GUI on the generated equations."
$report += "3. Record final model choice in `Plan.md` after real dataset run."

$outReportDir = Split-Path -Parent $OutReportMd
if ($outReportDir) { New-Item -ItemType Directory -Force -Path $outReportDir | Out-Null }
$report | Set-Content -Path $OutReportMd

Write-Host "Wrote report: $OutReportMd"
Write-Host "Wrote EViews outputs to: $outDirFull"
