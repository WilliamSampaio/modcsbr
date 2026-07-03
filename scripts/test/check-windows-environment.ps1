$ErrorActionPreference = "Stop"

$rootDir = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$upstreamDir = Join-Path $rootDir "upstream\ReGameDLL_CS"
$cs16ClientDir = Join-Path $rootDir "upstream\cs16-client"
$xashDir = if ($env:XASH3D_DIR) { $env:XASH3D_DIR } else { Join-Path $rootDir "runtime\xash3d" }
$solutionPath = Join-Path $upstreamDir "msvc\ReGameDLL.sln"
$settingsPath = Join-Path $rootDir ".vscode\settings.json"

$hasError = $false

function Write-Ok {
    param([string] $Message)
    Write-Host "OK: $Message"
}

function Write-Warn {
    param([string] $Message)
    Write-Host "WARN: $Message"
}

function Write-Fail {
    param([string] $Message)
    Write-Host "FAIL: $Message"
    $script:hasError = $true
}

function Test-Command {
    param(
        [string] $Name,
        [string] $Hint
    )

    $cmd = Get-Command $Name -ErrorAction SilentlyContinue
    if ($cmd) {
        Write-Ok "found $Name at $($cmd.Source)"
        return $true
    }

    Write-Fail "$Name was not found. $Hint"
    return $false
}

if ($IsWindows -or $env:OS -eq "Windows_NT") {
    Write-Ok "running on Windows"
}
else {
    Write-Fail "this script is intended for Windows PowerShell or PowerShell on Windows"
}

if (Test-Path $upstreamDir) {
    Write-Ok "found upstream ReGameDLL_CS"
}
else {
    Write-Fail "missing upstream/ReGameDLL_CS. Run: git submodule update --init --recursive"
}

if (Test-Path $solutionPath) {
    Write-Ok "found upstream MSVC solution"
}
else {
    Write-Fail "missing $solutionPath"
}

$null = Test-Command "git" "Install Git for Windows."
$null = Test-Command "code" "Install VS Code and enable the code command in PATH."
$null = Test-Command "cmake" "Install Visual Studio C++ tools with CMake support."
$hasCl = Test-Command "cl" "Open Developer PowerShell for Visual Studio, then run this script again."
$hasMsbuild = Test-Command "msbuild" "Install Visual Studio C++ tools with MSBuild, then open Developer PowerShell for Visual Studio."

if ($hasCl) {
    $clPath = (Get-Command cl).Source
    if ($clPath -match "\\x86\\cl\.exe$" -or $env:VSCMD_ARG_TGT_ARCH -eq "x86" -or $env:Platform -eq "Win32") {
        Write-Ok "MSVC environment appears to target x86/Win32"
    }
    else {
        Write-Warn "cl is available, but the shell does not clearly report x86. Prefer Developer PowerShell for Visual Studio with Win32/x86 tools."
    }
}

if ($hasMsbuild) {
    $msbuildVersion = & msbuild -version -nologo 2>$null | Select-Object -First 1
    if ($msbuildVersion) {
        Write-Ok "msbuild version $msbuildVersion"
    }

    $vsRoot = Join-Path ${env:ProgramFiles(x86)} "Microsoft Visual Studio"
    $toolsets = Get-ChildItem -Path $vsRoot -Recurse -Directory -Filter "PlatformToolsets" -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -like "*\Platforms\Win32\PlatformToolsets" } |
        ForEach-Object { Get-ChildItem -Path $_.FullName -Directory -ErrorAction SilentlyContinue } |
        Select-Object -ExpandProperty Name -Unique

    if ($toolsets) {
        Write-Ok "found Win32 platform toolsets: $($toolsets -join ', ')"
    }
    else {
        Write-Fail "no Win32 MSVC platform toolsets were found. Install Visual Studio C++ build tools with Win32 support."
    }
}

if (Test-Path $settingsPath) {
    $settings = Get-Content -Raw $settingsPath
    if ($settings -match '"C_Cpp\.default\.intelliSenseMode"\s*:\s*"windows-msvc-x86"') {
        Write-Ok "VS Code IntelliSense is set to windows-msvc-x86"
    }
    else {
        Write-Warn "VS Code IntelliSense is not set to windows-msvc-x86 in .vscode/settings.json"
    }
}
else {
    Write-Warn "missing .vscode/settings.json"
}

Write-Host ""
if (Test-Path $cs16ClientDir) {
    Write-Ok "found external cs16-client source"
}
else {
    Write-Warn "missing upstream\cs16-client. Run: git submodule sync --recursive; git submodule update --init --recursive"
}

if (Test-Path (Join-Path $xashDir "xash3d.exe")) {
    Write-Ok "found Xash3D FWGS executable at $(Join-Path $xashDir 'xash3d.exe')"
}
else {
    Write-Warn "missing xash3d.exe. Put official Xash3D FWGS Windows binaries in $xashDir or set XASH3D_DIR."
}

Write-Host ""
Write-Host "Note: Windows Xash3D FWGS is the active runtime path. Build server with scripts/build/regamedll-windows.ps1, build client with scripts/build/cs16-client-windows.ps1, then launch with scripts/test/launch-modcsbr-xash3d-windows.ps1."

if ($hasError) {
    exit 1
}
