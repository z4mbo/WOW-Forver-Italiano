param(
    [string]$Version = '0.2.0-beta'
)

$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$addonDirectory = Join-Path $projectRoot 'Addon'
$toc = Join-Path $addonDirectory 'WOWForverItaliano.toc'
$zipDirectory = Join-Path $projectRoot 'dist'
$zipFile = Join-Path $zipDirectory "WOWForverItaliano-$Version.zip"

if (-not (Test-Path -LiteralPath $toc)) { throw "Missing addon manifest: $toc" }

Get-Content -LiteralPath $toc | ForEach-Object {
    $entry = $_.Trim()
    if ($entry -and -not $entry.StartsWith('##') -and -not $entry.StartsWith('#')) {
        $file = Join-Path $addonDirectory $entry
        if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
            throw "Manifest references missing file: $entry"
        }
    }
}

New-Item -ItemType Directory -Path $zipDirectory -Force | Out-Null
if (Test-Path -LiteralPath $zipFile) { Remove-Item -LiteralPath $zipFile -Force }
Add-Type -AssemblyName System.IO.Compression.FileSystem
$archive = [System.IO.Compression.ZipFile]::Open($zipFile, [System.IO.Compression.ZipArchiveMode]::Create)
try {
    Get-ChildItem -LiteralPath $addonDirectory -Recurse -File | ForEach-Object {
        $relative = [System.IO.Path]::GetRelativePath($addonDirectory, $_.FullName).Replace('\', '/')
        $entryName = "WOWForverItaliano/$relative"
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
            $archive, $_.FullName, $entryName,
            [System.IO.Compression.CompressionLevel]::Optimal
        ) | Out-Null
    }
}
finally {
    $archive.Dispose()
}
Write-Output $zipFile
