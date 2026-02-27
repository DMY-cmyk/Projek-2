param(
    [Parameter(Mandatory = $false)]
    [string]$DatasetPath = ".\output\panel_dataset_template.csv",
    [Parameter(Mandatory = $false)]
    [string]$OutDir = ".\output\eviews",
    [Parameter(Mandatory = $false)]
    [string]$WorkfileName = "panel_2019_2025.wf1",
    [Parameter(Mandatory = $false)]
    [switch]$SmokeMode
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

    if ($SmokeMode) {
        # Reduced specs for quick verification with tiny sample files.
        $app.Run("equation eq_price_base.ls price c roa der")
        $app.Run("equation eq_ret_base.ls ret c roa der")
        $app.Run("equation eq_tq_base.ls tq c roa der")

        $app.Run("equation eq_price_aid.ls price c roa der aid roa_aid der_aid")
        $app.Run("equation eq_ret_aid.ls ret c roa der aid roa_aid der_aid")
        $app.Run("equation eq_tq_aid.ls tq c roa der aid roa_aid der_aid")

        $app.Run("equation eq_price_break.ls price c roa der dgenai roa_dgenai der_dgenai")
        $app.Run("equation eq_ret_break.ls ret c roa der dgenai roa_dgenai der_dgenai")
        $app.Run("equation eq_tq_break.ls tq c roa der dgenai roa_dgenai der_dgenai")
    } else {
        # Full specs for the final thesis dataset.
        $app.Run("equation eq_price_base.ls price c roa roe npm cr der tato eps size growth age vol")
        $app.Run("equation eq_ret_base.ls ret c roa roe npm cr der tato eps size growth age vol")
        $app.Run("equation eq_tq_base.ls tq c roa roe npm cr der tato eps size growth age vol")

        $app.Run("equation eq_price_aid.ls price c roa der eps aid roa_aid der_aid eps_aid size growth age vol")
        $app.Run("equation eq_ret_aid.ls ret c roa der eps aid roa_aid der_aid eps_aid size growth age vol")
        $app.Run("equation eq_tq_aid.ls tq c roa der eps aid roa_aid der_aid eps_aid size growth age vol")

        $app.Run("equation eq_price_break.ls price c roa der eps dgenai roa_dgenai der_dgenai eps_dgenai size growth age vol")
        $app.Run("equation eq_ret_break.ls ret c roa der eps dgenai roa_dgenai der_dgenai eps_dgenai size growth age vol")
        $app.Run("equation eq_tq_break.ls tq c roa der eps dgenai roa_dgenai der_dgenai eps_dgenai size growth age vol")
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
        $app.Run("freeze($tab) $eq.output")
        $app.Run("$tab.save(t=txt) `"$outFile`"")
    }

    $app.Run("save `"$escapedWf`"")
    Write-Host "EViews run finished. Workfile: $workfile"
    Write-Host "Equation outputs saved in: $outDirFull"
}
finally {
    try { $app.Run("close @all") } catch {}
}
