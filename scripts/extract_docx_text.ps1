param(
    [string]$DocxPath = ".\Skripsi_31998_DZAKI.docx",
    [string]$OutPath = ".\temp_skripsi_text.txt"
)

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$doc = $word.Documents.Open((Resolve-Path $DocxPath).Path)
$text = $doc.Content.Text
$doc.Close($false)
$word.Quit()
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($word) | Out-Null
$text | Out-File -FilePath $OutPath -Encoding UTF8
Write-Host "Extracted $($text.Length) chars to $OutPath"
