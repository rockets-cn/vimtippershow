$ErrorActionPreference = 'Stop'

$Source = Split-Path -Parent $MyInvocation.MyCommand.Path
$Destination = 'C:\Program Files\Vim\vim91\pack\vimtipper\start\vimtipper'

New-Item -ItemType Directory -Force -Path $Destination | Out-Null

Copy-Item -Path `
  (Join-Path $Source 'autoload'), `
  (Join-Path $Source 'plugin'), `
  (Join-Path $Source 'tests'), `
  (Join-Path $Source 'README.md') `
  -Destination $Destination `
  -Recurse `
  -Force

Write-Host "VimTipper installed to $Destination"
