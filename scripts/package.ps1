param(
  [string]$Runtime = "win-x64",
  [string]$Configuration = "Release",
  [string]$Version = "dev"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) {
  Write-Error "dotnet CLI not found. Please install .NET SDK 8+ and retry."
}

$outDir = Join-Path $PSScriptRoot "artifacts/$Runtime"
$publishDir = Join-Path $outDir "publish"
New-Item -ItemType Directory -Force -Path $publishDir | Out-Null

dotnet publish "$PSScriptRoot/../LiteMonitor.csproj" -c $Configuration -r $Runtime --self-contained false -o $publishDir

$zipName = "LiteMonitor_v$Version-$Runtime.zip"
$zipPath = Join-Path $outDir $zipName
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Compress-Archive -Path (Join-Path $publishDir '*') -DestinationPath $zipPath

Write-Host "Package created: $zipPath"
