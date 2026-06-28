param(
    [switch] $Reset,

    [string] $ModName = $(if ($env:MOD_NAME) { $env:MOD_NAME } else { "modcsbr" }),

    [string] $SteamAppId = $(if ($env:MODCSBR_STEAM_APP_ID) { $env:MODCSBR_STEAM_APP_ID } else { "70" }),

    [ValidateSet("copy", "link")]
    [string] $AssetMode = $(if ($env:MODCSBR_ASSET_MODE) { $env:MODCSBR_ASSET_MODE } else { "copy" }),

    [switch] $AutoMap,

    [switch] $NoLaunch,

    [string] $Map = $(if ($env:MAP) { $env:MAP } else { "de_dust2" }),

    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]] $LaunchArgs
)

$ErrorActionPreference = "Stop"

$rootDir = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$installScript = Join-Path $rootDir "scripts\install\modcsbr-steam-windows.ps1"

function Get-SteamRootCandidates {
    $candidates = @()

    if ($env:STEAM_DIR) {
        $candidates += $env:STEAM_DIR
    }

    foreach ($registryPath in @("HKCU:\Software\Valve\Steam", "HKLM:\SOFTWARE\WOW6432Node\Valve\Steam", "HKLM:\SOFTWARE\Valve\Steam")) {
        try {
            $steamPath = (Get-ItemProperty -Path $registryPath -ErrorAction Stop).SteamPath
            if ($steamPath) {
                $candidates += $steamPath
            }
        }
        catch {
        }
    }

    $candidates += Join-Path ${env:ProgramFiles(x86)} "Steam"
    $candidates += Join-Path $env:ProgramFiles "Steam"

    $candidates |
        Where-Object { $_ -and (Test-Path $_) } |
        ForEach-Object { (Resolve-Path $_).Path } |
        Select-Object -Unique
}

function Find-SteamExe {
    foreach ($steamRoot in Get-SteamRootCandidates) {
        $candidate = Join-Path $steamRoot "steam.exe"
        if (Test-Path $candidate) {
            return (Resolve-Path $candidate).Path
        }
    }

    Write-Error "Could not find steam.exe. Set STEAM_DIR to your Steam installation folder."
}

$installParams = @{
    ModName = $ModName
    AssetMode = $AssetMode
}

if ($Reset) {
    $installParams.Reset = $true
}

& $installScript @installParams

$steamExe = Find-SteamExe
$args = @("-applaunch", $SteamAppId, "-game", $ModName, "-console", "-dev")

if ($AutoMap -or $env:MODCSBR_AUTO_MAP -eq "1") {
    $args += @("+map", $Map)
}

if ($LaunchArgs) {
    $args += $LaunchArgs
}

Write-Host "Launching $ModName through Steam AppID $SteamAppId."
if ($NoLaunch) {
    Write-Host "NoLaunch: $steamExe $($args -join ' ')"
    return
}

Start-Process -FilePath $steamExe -ArgumentList $args
