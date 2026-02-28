param(
    [string]$MasterCsv = ".\output\data_collection_master_interim.csv"
)

$ErrorActionPreference = "Stop"
$rows = Import-Csv $MasterCsv

$updated = @()
foreach ($r in $rows) {
    $pricePath = $r.price_csv_path
    # Fix: prices_TICKER.JK.csv -> prices_TICKER.csv
    if ($pricePath -match 'prices_(\w+)\.JK\.csv$') {
        $ticker = $Matches[1]
        $pricePath = ".\data\prices\prices_${ticker}.csv"
    }
    $updated += [PSCustomObject]@{
        firm_id        = $r.firm_id
        ticker         = $r.ticker
        company_name   = $r.company_name
        year           = $r.year
        fs_pdf_path    = $r.fs_pdf_path
        ar_pdf_path    = $r.ar_pdf_path
        price_csv_path = $pricePath
        fs_downloaded  = $r.fs_downloaded
        ar_downloaded  = $r.ar_downloaded
        price_downloaded = $r.price_downloaded
        extraction_done = $r.extraction_done
        notes          = $r.notes
    }
}

$updated | Export-Csv -Path $MasterCsv -NoTypeInformation -Encoding UTF8
Write-Host "Updated $($updated.Count) rows in $MasterCsv"
