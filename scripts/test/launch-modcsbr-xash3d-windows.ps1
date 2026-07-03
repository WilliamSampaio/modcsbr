param(
    [switch] $Reset,

    [string] $ModName = $(if ($env:MOD_NAME) { $env:MOD_NAME } else { "modcsbr" }),

    [string] $XashDir = $(if ($env:XASH3D_DIR) { $env:XASH3D_DIR } else { "" }),

    [ValidateSet("copy", "link")]
    [string] $AssetMode = $(if ($env:MODCSBR_ASSET_MODE) { $env:MODCSBR_ASSET_MODE } else { "copy" }),

    [switch] $DisableZBot,

    [switch] $DisableHostageAI,

    [switch] $DisableReGameDLLExtras,

    [switch] $AutoMap,

    [switch] $NoLaunch,

    [string] $Map = $(if ($env:MAP) { $env:MAP } else { "de_dust2" }),

    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]] $LaunchArgs
)

$ErrorActionPreference = "Stop"

$rootDir = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$installScript = Join-Path $rootDir "scripts\install\modcsbr-xash3d-windows.ps1"

if (-not $XashDir) {
    $XashDir = Join-Path $rootDir "runtime\xash3d"
}

$installParams = @{
    ModName = $ModName
    XashDir = $XashDir
    AssetMode = $AssetMode
}

if ($Reset) {
    $installParams.Reset = $true
}
if ($DisableZBot) {
    $installParams.DisableZBot = $true
}
if ($DisableHostageAI) {
    $installParams.DisableHostageAI = $true
}
if ($DisableReGameDLLExtras) {
    $installParams.DisableReGameDLLExtras = $true
}

& $installScript @installParams

$xashDirResolved = (Resolve-Path $XashDir).Path
$xashExe = Join-Path $xashDirResolved "xash3d.exe"

if (-not (Test-Path $xashExe)) {
    Write-Error "xash3d.exe was not found at: $xashExe. Put official Xash3D FWGS Windows binaries there or set XASH3D_DIR."
}

$args = @("-game", $ModName, "-console", "-dev")

if ($AutoMap -or $env:MODCSBR_AUTO_MAP -eq "1") {
    $args += @("+map", $Map)
}

if ($LaunchArgs) {
    $args += $LaunchArgs
}

Write-Host "Launching $ModName with Xash3D FWGS."
if ($NoLaunch) {
    Write-Host "NoLaunch: $xashExe $($args -join ' ')"
    return
}

Start-Process -FilePath $xashExe -ArgumentList $args -WorkingDirectory $xashDirResolved
