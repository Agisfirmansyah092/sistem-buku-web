param([string]$RepositoryName = 'sistem-buku-web')
$ErrorActionPreference = 'Stop'
if ($RepositoryName -notmatch '^[A-Za-z0-9_.-]+$') {
    throw 'Nama repository tidak valid.'
}
$projectRoot = Split-Path -Parent $PSScriptRoot
Push-Location $projectRoot
try {
    $portableGit = Join-Path $projectRoot '.local-tools/git/cmd'
    if (Test-Path (Join-Path $portableGit 'git.exe')) {
        $env:Path = "$portableGit;$env:Path"
    }
    & flutter pub get
    if ($LASTEXITCODE -ne 0) { throw 'flutter pub get gagal.' }
    & flutter build web --release "--base-href=/$RepositoryName/"
    if ($LASTEXITCODE -ne 0) { throw 'Build website gagal.' }
    New-Item -ItemType File -Force 'build/web/.nojekyll' | Out-Null
    New-Item -ItemType Directory -Force 'release' | Out-Null
    $zip = Join-Path $projectRoot "release/$RepositoryName.zip"
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    if (Test-Path -LiteralPath $zip) {
        $zip = Join-Path $projectRoot "release/$RepositoryName-$(Get-Date -Format 'yyyyMMdd-HHmmss').zip"
    }
    [IO.Compression.ZipFile]::CreateFromDirectory(
        (Join-Path $projectRoot 'build/web'), $zip
    )
    Write-Output "Build siap: $zip"
    Write-Output 'Unggah isi ZIP yang sudah diekstrak, bukan file ZIP-nya, ke root repository Pages.'
} finally {
    Pop-Location
}
