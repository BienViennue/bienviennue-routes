# --- generate-index.ps1 ---
# Bouwt index.html op basis van alle GPX / PDF / PNG-bestanden in de huidige map

$routes = Get-ChildItem -File | Where-Object { $_.Extension -in '.gpx', '.pdf', '.png' }
$groups = $routes | Group-Object { $_.BaseName }

$head = @'
<!DOCTYPE html>
<html lang="nl">
<head>
  <meta charset="UTF-8">
  <title>BienViennue – Routes overzicht</title>
  <style>
    body{
      font-family:Arial, sans-serif;
      margin:2rem;
      background:#f9f9f9;
      color:#333
    }
    h1{color:#5BA9C2}
    .route{
      margin-bottom:1.2rem;
      padding:1rem;
      background:#fff;
      border-radius:8px;
      box-shadow:0 2px 5px rgba(0,0,0,.1)
    }
    .name{
      font-weight:700;
      margin:0 0 .6rem 0
    }
    .buttons a{
      display:inline-block;
      margin-right:10px;
      padding:6px 12px;
      border-radius:6px;
      text-decoration:none;
      color:#fff;
      font-weight:700
    }
    .gpx{background:#5BA9C2}
    .pdf{background:#d9534f}
    .png{background:#5cb85c}
  </style>
</head>
<body>
  <h1>BienViennue – Routes overzicht</h1>
'@

$body = New-Object System.Text.StringBuilder

foreach ($g in $groups | Sort-Object Name) {

  $name = $g.Name

  $gpx = $g.Group | Where-Object { $_.Extension -ieq '.gpx' } | Select-Object -First 1
  $pdf = $g.Group | Where-Object { $_.Extension -ieq '.pdf' } | Select-Object -First 1
  $png = $g.Group | Where-Object { $_.Extension -ieq '.png' } | Select-Object -First 1

  $gpxHref = if ($gpx) { [uri]::EscapeDataString($gpx.Name) } else { $null }
  $pdfHref = if ($pdf) { [uri]::EscapeDataString($pdf.Name) } else { $null }
  $pngHref = if ($png) { [uri]::EscapeDataString($png.Name) } else { $null }

  $null = $body.AppendLine('  <div class="route">')
  $null = $body.AppendLine("    <p class=""name"">$name</p>")
  $null = $body.AppendLine('    <div class="buttons">')

  if ($gpxHref) {
    $null = $body.AppendLine("      <a class=""gpx"" href=""$gpxHref"" download>Download GPX</a>")
  }
  if ($pdfHref) {
    $null = $body.AppendLine("      <a class=""pdf"" href=""$pdfHref"" download>Download PDF</a>")
  }
  if ($pngHref) {
    $null = $body.AppendLine("      <a class=""png"" href=""$pngHref"" download>Download PNG</a>")
  }

  $null = $body.AppendLine('    </div>')
  $null = $body.AppendLine('  </div>')
}

$tail = @'
</body>
</html>
'@

$head + $body.ToString() + $tail | Set-Content -Encoding UTF8 -Path ".\index.html"

Write-Host "index.html gegenereerd met $($groups.Count) routes."
