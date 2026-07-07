param(
    [switch] $Reset,

    [string] $ModName = $(if ($env:MOD_NAME) { $env:MOD_NAME } else { "modcsbr" }),

    [string] $XashDir = $(if ($env:XASH3D_DIR) { $env:XASH3D_DIR } else { "" }),

    [string] $HalfLifeDir = $(if ($env:HALF_LIFE_DIR) { $env:HALF_LIFE_DIR } else { "" }),

    [ValidateSet("copy", "link")]
    [string] $AssetMode = $(if ($env:MODCSBR_ASSET_MODE) { $env:MODCSBR_ASSET_MODE } else { "copy" }),

    [string] $ClientInstallDir = $(if ($env:CS16_CLIENT_INSTALL_DIR) { $env:CS16_CLIENT_INSTALL_DIR } else { "" }),

    [switch] $DisableZBot,

    [switch] $DisableHostageAI,

    [switch] $DisableReGameDLLExtras
)

$ErrorActionPreference = "Stop"

$rootDir = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$modSourceDir = Join-Path $rootDir "mod\modcsbr"
$defaultXashDir = Join-Path $rootDir "runtime\xash3d"
$defaultClientInstallDir = Join-Path $rootDir "build\windows\cs16-client-install"

if (-not $XashDir) {
    $XashDir = $defaultXashDir
}
if (-not $ClientInstallDir) {
    $ClientInstallDir = $defaultClientInstallDir
}
if ([string]::IsNullOrWhiteSpace($ModName)) {
    Write-Error "ModName cannot be empty."
}

$enableZBot = -not $DisableZBot -and -not $DisableReGameDLLExtras -and $env:MODCSBR_ENABLE_ZBOT -ne "0"
$enableHostageAI = -not $DisableHostageAI -and -not $DisableReGameDLLExtras -and $env:MODCSBR_ENABLE_HOSTAGE_AI -ne "0"

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

function Get-SteamLibraryPaths {
    param([string] $SteamRoot)

    $libraries = @($SteamRoot)
    $libraryFile = Join-Path $SteamRoot "steamapps\libraryfolders.vdf"

    if (Test-Path $libraryFile) {
        foreach ($line in Get-Content $libraryFile) {
            if ($line -match '^\s*"[0-9]+"\s+"([^"]+)"') {
                $libraries += ($matches[1] -replace "\\\\", "\")
            }
            elseif ($line -match '^\s*"path"\s+"([^"]+)"') {
                $libraries += ($matches[1] -replace "\\\\", "\")
            }
        }
    }

    $libraries |
        Where-Object { $_ -and (Test-Path $_) } |
        ForEach-Object { (Resolve-Path $_).Path } |
        Select-Object -Unique
}

function Find-HalfLifeDir {
    if ($HalfLifeDir) {
        if ((Test-Path (Join-Path $HalfLifeDir "cstrike")) -and (Test-Path (Join-Path $HalfLifeDir "valve"))) {
            return (Resolve-Path $HalfLifeDir).Path
        }

        Write-Error "HalfLifeDir is set, but cstrike and valve were not found under: $HalfLifeDir"
    }

    foreach ($steamRoot in Get-SteamRootCandidates) {
        foreach ($library in Get-SteamLibraryPaths -SteamRoot $steamRoot) {
            $candidate = Join-Path $library "steamapps\common\Half-Life"
            if ((Test-Path (Join-Path $candidate "cstrike")) -and (Test-Path (Join-Path $candidate "valve"))) {
                return (Resolve-Path $candidate).Path
            }
        }
    }

    return $null
}

function Copy-DirectoryContents {
    param(
        [string] $Source,
        [string] $Target
    )

    New-Item -ItemType Directory -Path $Target -Force | Out-Null

    foreach ($item in Get-ChildItem -LiteralPath $Source -Force) {
        $itemTarget = Join-Path $Target $item.Name
        if ($item.PSIsContainer) {
            Copy-DirectoryContents -Source $item.FullName -Target $itemTarget
        }
        else {
            Copy-Item -LiteralPath $item.FullName -Destination $itemTarget -Force
        }
    }
}

function Install-BaseDirectory {
    param(
        [string] $Source,
        [string] $Target
    )

    if (-not (Test-Path $Source -PathType Container)) {
        Write-Warning "Missing base asset directory: $Source"
        return
    }

    if ($AssetMode -eq "link" -and -not (Test-Path $Target)) {
        New-Item -ItemType Junction -Path $Target -Target $Source | Out-Null
        return
    }

    Copy-DirectoryContents -Source $Source -Target $Target
}

function Assert-XashBaseAssets {
    param(
        [string] $RuntimeDir
    )

    $requiredFiles = @(
        "valve\gfx.wad"
    )

    $missingFiles = @()
    foreach ($relativePath in $requiredFiles) {
        $candidate = Join-Path $RuntimeDir $relativePath
        if (-not (Test-Path $candidate)) {
            $missingFiles += $relativePath
        }
    }

    if ($missingFiles.Count -gt 0) {
        Write-Host "Missing required Xash3D base assets:"
        foreach ($relativePath in $missingFiles) {
            Write-Host "  - $relativePath"
        }
        Write-Error "Xash3D needs Half-Life base assets. Set HALF_LIFE_DIR to the Steam Half-Life folder and rerun this script."
    }
}

function Install-HalfLifeRuntimeSupportFiles {
    param(
        [string] $SourceRoot,
        [string] $TargetRoot
    )

    foreach ($fileName in @("steam_api.dll")) {
        $sourceFile = Join-Path $SourceRoot $fileName
        if (Test-Path $sourceFile) {
            Copy-Item -LiteralPath $sourceFile -Destination (Join-Path $TargetRoot $fileName) -Force
        }
        else {
            Write-Warning "Missing Half-Life runtime support file: $sourceFile"
        }
    }
}

function Install-ModBaseAssets {
    param(
        [string] $SourceRoot,
        [string] $TargetRoot
    )

    if (-not (Test-Path $SourceRoot -PathType Container)) {
        Write-Warning "Missing Counter-Strike base directory for mod copy: $SourceRoot"
        return
    }

    Copy-DirectoryContents -Source $SourceRoot -Target $TargetRoot
}

function Find-FirstFile {
    param(
        [string[]] $Roots,
        [string] $Filter
    )

    foreach ($root in $Roots) {
        if (-not (Test-Path $root)) {
            continue
        }

        $found = Get-ChildItem -Path $root -Recurse -File -Filter $Filter -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending |
            Select-Object -First 1
        if ($found) {
            return $found.FullName
        }
    }

    return $null
}

function Install-ReGameDLLExtraIfEnabled {
    param(
        [bool] $Enabled,
        [string] $Archive,
        [string] $Label
    )

    if (-not $Enabled) {
        Write-Host "Skipped $Label extra."
        return
    }
    if (-not (Test-Path $Archive)) {
        Write-Warning "Missing $Label archive: $Archive"
        return
    }

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("modcsbr-extra-" + [System.Guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

    try {
        [System.IO.Compression.ZipFile]::ExtractToDirectory($Archive, $tempDir)
        $cstrikeExtractDir = Join-Path $tempDir "cstrike"
        if (Test-Path $cstrikeExtractDir) {
            Copy-DirectoryContents -Source $cstrikeExtractDir -Target $modDir
        }
        else {
            Write-Warning "$Label archive did not contain a cstrike folder."
        }
    }
    finally {
        if (Test-Path $tempDir) {
            Remove-Item -LiteralPath $tempDir -Recurse -Force
        }
    }

    Write-Host "Installed $Label extra."
}

function Set-ReGameDLLExtraConfig {
    param(
        [bool] $EnableZBot,
        [bool] $EnableHostageAI
    )

    $config = Join-Path $modDir "game_init.cfg"
    if (-not (Test-Path $config)) {
        New-Item -ItemType File -Path $config -Force | Out-Null
    }

    $lines = Get-Content -Path $config
    $filteredLines = New-Object System.Collections.Generic.List[string]
    $skip = $false

    foreach ($line in $lines) {
        if ($line -eq "// BEGIN modcsbr ReGameDLL extras") {
            $skip = $true
            continue
        }
        if ($line -eq "// END modcsbr ReGameDLL extras") {
            $skip = $false
            continue
        }
        if (-not $skip) {
            $filteredLines.Add($line)
        }
    }

    $filteredLines.Add("")
    $filteredLines.Add("// BEGIN modcsbr ReGameDLL extras")
    if ($EnableZBot) {
        $filteredLines.Add("bot_enable 1")
    }
    else {
        $filteredLines.Add("// bot_enable 1 disabled")
    }

    if ($EnableHostageAI) {
        $filteredLines.Add("hostage_ai_enable 1")
    }
    else {
        $filteredLines.Add("// hostage_ai_enable 1 disabled")
    }
    $filteredLines.Add("// END modcsbr ReGameDLL extras")

    Set-Content -Path $config -Value $filteredLines -Encoding ASCII
}

New-Item -ItemType Directory -Path $XashDir -Force | Out-Null
$xashDirResolved = (Resolve-Path $XashDir).Path
$modDir = Join-Path $xashDirResolved $ModName

$xashExe = Join-Path $xashDirResolved "xash3d.exe"
if (-not (Test-Path $xashExe)) {
    Write-Warning "xash3d.exe was not found at: $xashExe. Put official Xash3D FWGS Windows binaries in $xashDirResolved before launching."
}

$detectedHalfLifeDir = Find-HalfLifeDir
if ($detectedHalfLifeDir) {
    Install-BaseDirectory -Source (Join-Path $detectedHalfLifeDir "valve") -Target (Join-Path $xashDirResolved "valve")
    Install-BaseDirectory -Source (Join-Path $detectedHalfLifeDir "cstrike") -Target (Join-Path $xashDirResolved "cstrike")
    Install-HalfLifeRuntimeSupportFiles -SourceRoot $detectedHalfLifeDir -TargetRoot $xashDirResolved
}
elseif ((-not (Test-Path (Join-Path $xashDirResolved "valve"))) -or (-not (Test-Path (Join-Path $xashDirResolved "cstrike")))) {
    Write-Warning "Could not find Steam Half-Life assets. Xash3D needs valve and cstrike under $xashDirResolved."
}

Assert-XashBaseAssets -RuntimeDir $xashDirResolved

if ($Reset -and (Test-Path $modDir)) {
    Remove-Item -LiteralPath $modDir -Recurse -Force
}

$modBaseSourceDir = $null
if ($detectedHalfLifeDir) {
    $modBaseSourceDir = Join-Path $detectedHalfLifeDir "cstrike"
}
elseif (Test-Path (Join-Path $xashDirResolved "cstrike")) {
    $modBaseSourceDir = Join-Path $xashDirResolved "cstrike"
}

if ($modBaseSourceDir) {
    Install-ModBaseAssets -SourceRoot $modBaseSourceDir -TargetRoot $modDir
}
else {
    Write-Warning "Could not find cstrike assets to seed $ModName. The installed mod may be missing stock CS assets."
}

Copy-DirectoryContents -Source $modSourceDir -Target $modDir

$serverDll = Find-FirstFile -Roots @(
    (Join-Path $modSourceDir "dlls"),
    (Join-Path $rootDir "upstream\ReGameDLL_CS\msvc")
) -Filter "mp.dll"

if ($serverDll) {
    $serverTargetDir = Join-Path $modDir "dlls"
    New-Item -ItemType Directory -Path $serverTargetDir -Force | Out-Null
    Copy-Item -LiteralPath $serverDll -Destination (Join-Path $serverTargetDir "mp.dll") -Force
}
else {
    Write-Warning "mp.dll does not exist yet. Build it with: powershell -ExecutionPolicy Bypass -File scripts\build\regamedll-windows.ps1"
}

$clientDll = Find-FirstFile -Roots @(
    (Join-Path $modSourceDir "cl_dlls"),
    $ClientInstallDir,
    (Join-Path $rootDir "build\windows\cs16-client")
) -Filter "client.dll"
$menuDll = Find-FirstFile -Roots @(
    (Join-Path $modSourceDir "cl_dlls"),
    $ClientInstallDir,
    (Join-Path $rootDir "build\windows\cs16-client")
) -Filter "menu.dll"

if ($clientDll) {
    $clientTargetDir = Join-Path $modDir "cl_dlls"
    New-Item -ItemType Directory -Path $clientTargetDir -Force | Out-Null
    Copy-Item -LiteralPath $clientDll -Destination (Join-Path $clientTargetDir "client.dll") -Force
}
else {
    Write-Warning "client.dll does not exist yet. Build it with: powershell -ExecutionPolicy Bypass -File scripts\build\cs16-client-windows.ps1"
}

if ($menuDll) {
    $clientTargetDir = Join-Path $modDir "cl_dlls"
    New-Item -ItemType Directory -Path $clientTargetDir -Force | Out-Null
    Copy-Item -LiteralPath $menuDll -Destination (Join-Path $clientTargetDir "menu.dll") -Force
}
else {
    Write-Warning "menu.dll does not exist yet. Build it with: powershell -ExecutionPolicy Bypass -File scripts\build\cs16-client-windows.ps1"
}

Install-ReGameDLLExtraIfEnabled -Enabled $enableZBot -Archive (Join-Path $rootDir "upstream\ReGameDLL_CS\regamedll\extra\zBot\bot_profiles.zip") -Label "zBot for CS 1.6"
Install-ReGameDLLExtraIfEnabled -Enabled $enableHostageAI -Archive (Join-Path $rootDir "upstream\ReGameDLL_CS\regamedll\extra\HostageImprov\host_improv.zip") -Label "CS:CZ hostage AI for CS 1.6"
Set-ReGameDLLExtraConfig -EnableZBot $enableZBot -EnableHostageAI $enableHostageAI

Write-Host "Installed $ModName for Xash3D FWGS at: $modDir"
Write-Host "Xash3D directory: $xashDirResolved"
Write-Host "Asset mode: $AssetMode"
Write-Host "Server DLL: $(Join-Path $modDir 'dlls\mp.dll')"
Write-Host "Client DLL: $(Join-Path $modDir 'cl_dlls\client.dll')"
Write-Host "Menu DLL: $(Join-Path $modDir 'cl_dlls\menu.dll')"
