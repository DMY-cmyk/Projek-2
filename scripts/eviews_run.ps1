param(
    [Parameter(Mandatory = $false)]
    [string]$DatasetPath = ".\output\panel_dataset_template.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutDir = ".\output\eviews",
    [Parameter(Mandatory = $false)]
    [string]$WorkfileName = "panel_2019_2025.wf1",
    [Parameter(Mandatory = $false)]
    [switch]$SmokeMode,
    [Parameter(Mandatory = $false)]
    [switch]$AdaptiveSpec
)

$ErrorActionPreference = "Stop"

function Resolve-FullPath {
    param([string]$PathValue)
    $resolved = Resolve-Path -Path $PathValue -ErrorAction Stop
    return $resolved.Path
}

function Require-Columns {
    param(
        [string]$CsvPath,
        [string[]]$Required
    )

    $sample = Import-Csv -Path $CsvPath | Select-Object -First 1
    if (-not $sample) {
        throw "Dataset is empty: $CsvPath"
    }
    $cols = @($sample.PSObject.Properties.Name | ForEach-Object { $_.Trim().ToLowerInvariant() })
    $missing = @()
    foreach ($c in $Required) {
        if ($cols -notcontains $c.ToLowerInvariant()) {
            $missing += $c
        }
    }
    if ($missing.Count -gt 0) {
        throw "Dataset missing required columns: $($missing -join ', ')"
    }
}

$requiredColumns = @(
    "firm_id","year","price","ret","tq",
    "roa","roe","npm","cr","der","tato","eps",
    "size","growth","age","vol","aid","dgenai"
)

$dataset = Resolve-FullPath -PathValue $DatasetPath
Require-Columns -CsvPath $dataset -Required $requiredColumns

$outDirFull = [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $OutDir))
New-Item -ItemType Directory -Force -Path $outDirFull | Out-Null
$workfile = Join-Path $outDirFull $WorkfileName

Write-Host "Dataset   : $dataset"
Write-Host "Output dir: $outDirFull"

$mgr = New-Object -ComObject "EViews.Manager"
$app = $mgr.GetApplication()
$app.Hide()

function Invoke-EViewsSafe {
    param(
        [object]$App,
        [string]$Cmd,
        [string]$Label,
        [System.Collections.Generic.List[object]]$RunLog
    )
    try {
        $App.Run($Cmd)
        $RunLog.Add([PSCustomObject]@{ step=$Label; status="ok"; command=$Cmd; message="" })
        return $true
    } catch {
        $RunLog.Add([PSCustomObject]@{ step=$Label; status="failed"; command=$Cmd; message=$_.Exception.Message })
        return $false
    }
}

try {
    $escapedDataset = $dataset.Replace("\", "\\")
    $escapedOut = $outDirFull.Replace("\", "\\")
    $escapedWf = $workfile.Replace("\", "\\")

    $app.Run("wfload(page=raw) `"$escapedDataset`"")
    $app.Run("pagestruct firm_id year")
    $app.Run("smpl @all")

    # Build interaction terms used by moderation and structural-break models.
    $app.Run("series roa_aid = roa*aid")
    $app.Run("series der_aid = der*aid")
    $app.Run("series eps_aid = eps*aid")
    $app.Run("series roa_dgenai = roa*dgenai")
    $app.Run("series der_dgenai = der*dgenai")
    $app.Run("series eps_dgenai = eps*dgenai")

    $runLog = New-Object 'System.Collections.Generic.List[object]'

    if ($SmokeMode) {
        # Reduced specs for quick verification with tiny sample files.
        Invoke-EViewsSafe -App $app -Label "eq_price_base_smoke" -RunLog $runLog -Cmd "equation eq_price_base.ls price c roa der" | Out-Null
        Invoke-EViewsSafe -App $app -Label "eq_ret_base_smoke" -RunLog $runLog -Cmd "equation eq_ret_base.ls ret c roa der" | Out-Null
        Invoke-EViewsSafe -App $app -Label "eq_tq_base_smoke" -RunLog $runLog -Cmd "equation eq_tq_base.ls tq c roa der" | Out-Null

        Invoke-EViewsSafe -App $app -Label "eq_price_aid_smoke" -RunLog $runLog -Cmd "equation eq_price_aid.ls price c roa der aid roa_aid der_aid" | Out-Null
        Invoke-EViewsSafe -App $app -Label "eq_ret_aid_smoke" -RunLog $runLog -Cmd "equation eq_ret_aid.ls ret c roa der aid roa_aid der_aid" | Out-Null
        Invoke-EViewsSafe -App $app -Label "eq_tq_aid_smoke" -RunLog $runLog -Cmd "equation eq_tq_aid.ls tq c roa der aid roa_aid der_aid" | Out-Null

        Invoke-EViewsSafe -App $app -Label "eq_price_break_smoke" -RunLog $runLog -Cmd "equation eq_price_break.ls price c roa der dgenai roa_dgenai der_dgenai" | Out-Null
        Invoke-EViewsSafe -App $app -Label "eq_ret_break_smoke" -RunLog $runLog -Cmd "equation eq_ret_break.ls ret c roa der dgenai roa_dgenai der_dgenai" | Out-Null
        Invoke-EViewsSafe -App $app -Label "eq_tq_break_smoke" -RunLog $runLog -Cmd "equation eq_tq_break.ls tq c roa der dgenai roa_dgenai der_dgenai" | Out-Null
    } else {
        # Full specs for the final thesis dataset, with optional adaptive fallback.
        $fullSpecs = @(
            @{ eq="eq_price_base"; cmd="equation eq_price_base.ls price c roa roe npm cr der tato eps size growth age vol" },
            @{ eq="eq_ret_base"; cmd="equation eq_ret_base.ls ret c roa roe npm cr der tato eps size growth age vol" },
            @{ eq="eq_tq_base"; cmd="equation eq_tq_base.ls tq c roa roe npm cr der tato eps size growth age vol" },
            @{ eq="eq_price_aid"; cmd="equation eq_price_aid.ls price c roa der eps aid roa_aid der_aid eps_aid size growth age vol" },
            @{ eq="eq_ret_aid"; cmd="equation eq_ret_aid.ls ret c roa der eps aid roa_aid der_aid eps_aid size growth age vol" },
            @{ eq="eq_tq_aid"; cmd="equation eq_tq_aid.ls tq c roa der eps aid roa_aid der_aid eps_aid size growth age vol" },
            @{ eq="eq_price_break"; cmd="equation eq_price_break.ls price c roa der eps dgenai roa_dgenai der_dgenai eps_dgenai size growth age vol" },
            @{ eq="eq_ret_break"; cmd="equation eq_ret_break.ls ret c roa der eps dgenai roa_dgenai der_dgenai eps_dgenai size growth age vol" },
            @{ eq="eq_tq_break"; cmd="equation eq_tq_break.ls tq c roa der eps dgenai roa_dgenai der_dgenai eps_dgenai size growth age vol" }
        )
        $fallbackSpecs = @(
            @{ eq="eq_price_base"; cmd="equation eq_price_base.ls price c roa der eps size aid" },
            @{ eq="eq_ret_base"; cmd="equation eq_ret_base.ls ret c roa der eps size aid" },
            @{ eq="eq_tq_base"; cmd="equation eq_tq_base.ls tq c roa der eps size aid" },
            @{ eq="eq_price_aid"; cmd="equation eq_price_aid.ls price c roa der aid roa_aid der_aid size" },
            @{ eq="eq_ret_aid"; cmd="equation eq_ret_aid.ls ret c roa der aid roa_aid der_aid size" },
            @{ eq="eq_tq_aid"; cmd="equation eq_tq_aid.ls tq c roa der aid roa_aid der_aid size" },
            @{ eq="eq_price_break"; cmd="equation eq_price_break.ls price c roa der dgenai roa_dgenai der_dgenai size" },
            @{ eq="eq_ret_break"; cmd="equation eq_ret_break.ls ret c roa der dgenai roa_dgenai der_dgenai size" },
            @{ eq="eq_tq_break"; cmd="equation eq_tq_break.ls tq c roa der dgenai roa_dgenai der_dgenai size" }
        )

        for ($i=0; $i -lt $fullSpecs.Count; $i++) {
            $ok = Invoke-EViewsSafe -App $app -Label ("run_" + $fullSpecs[$i].eq + "_full") -RunLog $runLog -Cmd $fullSpecs[$i].cmd
            if (-not $ok -and $AdaptiveSpec) {
                Invoke-EViewsSafe -App $app -Label ("run_" + $fallbackSpecs[$i].eq + "_fallback") -RunLog $runLog -Cmd $fallbackSpecs[$i].cmd | Out-Null
            }
        }
    }

    # Export equation outputs as text tables.
    $equations = @(
        "eq_price_base","eq_ret_base","eq_tq_base",
        "eq_price_aid","eq_ret_aid","eq_tq_aid",
        "eq_price_break","eq_ret_break","eq_tq_break"
    )
    foreach ($eq in $equations) {
        $tab = "tab_" + $eq
        $outFile = Join-Path $escapedOut ($eq + ".txt")
        $frozen = Invoke-EViewsSafe -App $app -Label ("freeze_" + $eq) -RunLog $runLog -Cmd "freeze($tab) $eq.output"
        if ($frozen) {
            Invoke-EViewsSafe -App $app -Label ("save_" + $eq) -RunLog $runLog -Cmd "$tab.save(t=txt) `"$outFile`"" | Out-Null
        }
    }

    Invoke-EViewsSafe -App $app -Label "save_workfile" -RunLog $runLog -Cmd "save `"$escapedWf`"" | Out-Null

    $summaryPath = Join-Path $outDirFull "eviews_run_summary.md"
    $okCount = @($runLog | Where-Object { $_.status -eq "ok" }).Count
    $failCount = @($runLog | Where-Object { $_.status -eq "failed" }).Count
    $summary = @()
    $summary += "# EViews Run Summary"
    $summary += ""
    $summary += "- Dataset: $dataset"
    $summary += "- SmokeMode: $($SmokeMode.IsPresent)"
    $summary += "- AdaptiveSpec: $($AdaptiveSpec.IsPresent)"
    $summary += "- Successful steps: $okCount"
    $summary += "- Failed steps: $failCount"
    $summary += ""
    $summary += "## Log"
    foreach ($r in $runLog) {
        if ($r.status -eq "ok") {
            $summary += "- [OK] $($r.step)"
        } else {
            $summary += "- [FAILED] $($r.step): $($r.message)"
        }
    }
    $summary | Set-Content -Path $summaryPath

    Write-Host "EViews run finished. Workfile: $workfile"
    Write-Host "Equation outputs saved in: $outDirFull"
    Write-Host "Run summary: $summaryPath"
}
finally {
    try { $app.Run("close @all") } catch {}
}
