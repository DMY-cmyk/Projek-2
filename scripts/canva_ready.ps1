param(
    [Parameter(Mandatory = $false)]
    [string]$TemplateDocx = ".\Skripsi_31998_DZAKI.docx"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $TemplateDocx)) {
    throw "Template docx not found: $TemplateDocx"
}

$edge = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if (-not (Test-Path $edge)) {
    throw "Edge not found at expected path: $edge"
}

New-Item -ItemType Directory -Force -Path ".\draft" | Out-Null

Write-Host "Building Canva-ready slide decks..."
pandoc .\draft\defense_slides.md -t pptx -o .\draft\defense_slides.pptx
pandoc .\draft\defense_slides_v2.md -t pptx -o .\draft\defense_slides_v2.pptx

Write-Host "Building one-page summary DOCX..."
pandoc .\draft\one_page_summary_penguji.md --reference-doc="$TemplateDocx" -o .\draft\one_page_summary_penguji.docx

Write-Host "Building one-page summary PDF..."
pandoc .\draft\one_page_summary_penguji.md -s -o .\draft\one_page_summary_penguji.html
& $edge --headless --disable-gpu --print-to-pdf="D:\VsCode\Projek-2\draft\one_page_summary_penguji.pdf" "file:///D:/VsCode/Projek-2/draft/one_page_summary_penguji.html" | Out-Null

Write-Host "Writing build manifest..."
$manifest = @()
$manifest += "# Canva Ready Build Manifest"
$manifest += ""
$manifest += "- Template: $TemplateDocx"
$manifest += "- Generated at: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$manifest += ""
$manifest += "## Assets"
$manifest += "- draft/defense_slides.pptx"
$manifest += "- draft/defense_slides_v2.pptx"
$manifest += "- draft/one_page_summary_penguji.docx"
$manifest += "- draft/one_page_summary_penguji.pdf"
$manifest += "- draft/one_page_summary_penguji.html"
$manifest | Set-Content .\output\canva_ready_manifest.md

Write-Host "Canva-ready assets generated successfully."
