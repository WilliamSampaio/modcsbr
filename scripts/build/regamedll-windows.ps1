param(
    [ValidateSet("Debug", "Release", "Tests")]
    [string] $Configuration = "Release",

    [ValidateSet("Win32")]
    [string] $Platform = "Win32",

    [string] $VisualStudioVersion = "17.0",

    [string] $PlatformToolset = "auto"
)

$ErrorActionPreference = "Stop"

$rootDir = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$upstreamDir = Join-Path $rootDir "upstream\ReGameDLL_CS"
$solutionPath = Join-Path $upstreamDir "msvc\ReGameDLL.sln"
$modDllDir = Join-Path $rootDir "mod\modcsbr\dlls"

if (-not (Test-Path $solutionPath)) {
    Write-Error "Missing upstream solution: $solutionPath. Run: git submodule update --init --recursive"
}

if (-not (Get-Command msbuild -ErrorAction SilentlyContinue)) {
    Write-Error "msbuild was not found. Open Developer PowerShell for VS 2022 and run this script again."
}

function Resolve-PlatformToolset {
    param(
        [string] $RequestedToolset,
        [string] $RequestedPlatform
    )

    if ($RequestedToolset -ne "auto") {
        return $RequestedToolset
    }

    $vsRoot = Join-Path ${env:ProgramFiles(x86)} "Microsoft Visual Studio"
    $toolsetDirs = Get-ChildItem -Path $vsRoot -Recurse -Directory -Filter "PlatformToolsets" -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -like "*\Platforms\$RequestedPlatform\PlatformToolsets" }

    $installedToolsets = $toolsetDirs |
        ForEach-Object { Get-ChildItem -Path $_.FullName -Directory -ErrorAction SilentlyContinue } |
        Select-Object -ExpandProperty Name -Unique

    if (-not $installedToolsets) {
        Write-Error "No MSVC platform toolsets were found for $RequestedPlatform. Install Visual Studio C++ build tools."
    }

    $preferredToolsets = @("v145", "v143", "v142", "v141", "v140", "v120")
    foreach ($toolset in $preferredToolsets) {
        if ($installedToolsets -contains $toolset) {
            return $toolset
        }
    }

    return ($installedToolsets | Sort-Object -Descending | Select-Object -First 1)
}

$resolvedPlatformToolset = Resolve-PlatformToolset -RequestedToolset $PlatformToolset -RequestedPlatform $Platform

Write-Host "Building ReGameDLL_CS with MSBuild..."
Write-Host "Solution: $solutionPath"
Write-Host "Configuration: $Configuration"
Write-Host "Platform: $Platform"
Write-Host "VisualStudioVersion: $VisualStudioVersion"
Write-Host "PlatformToolset: $resolvedPlatformToolset"

& msbuild $solutionPath `
    /m `
    /p:Configuration=$Configuration `
    /p:Platform=$Platform `
    /p:VisualStudioVersion=$VisualStudioVersion `
    /p:PlatformToolset=$resolvedPlatformToolset

if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

$artifact = Get-ChildItem -Path $upstreamDir -Recurse -File -Filter "mp.dll" |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

if ($artifact) {
    Write-Host "Built: $($artifact.FullName)"
    New-Item -ItemType Directory -Path $modDllDir -Force | Out-Null
    Copy-Item -LiteralPath $artifact.FullName -Destination (Join-Path $modDllDir "mp.dll") -Force
    Write-Host "Copied: $(Join-Path $modDllDir 'mp.dll')"
}
else {
    Write-Warning "Build finished, but mp.dll was not found under $upstreamDir."
}

Write-Host "Windows Xash3D FWGS runtime uses mod/modcsbr/dlls/mp.dll. Linux Steam legacy tests still use mod/modcsbr/dlls/cs.so."
