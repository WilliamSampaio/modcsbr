param(
    [switch] $Reset,

    [string] $ModName = $(if ($env:MOD_NAME) { $env:MOD_NAME } else { "modcsbr" }),

    [ValidateSet("copy", "link")]
    [string] $AssetMode = $(if ($env:MODCSBR_ASSET_MODE) { $env:MODCSBR_ASSET_MODE } else { "copy" }),

    [switch] $FullModCopy = $(if ($env:MODCSBR_FULL_MOD_COPY -eq "1") { $true } else { $false }),

    [switch] $DisableZBot,

    [switch] $DisableHostageAI,

    [switch] $DisableReGameDLLExtras
)

$ErrorActionPreference = "Stop"

$rootDir = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$modSourceDir = Join-Path $rootDir "mod\modcsbr"
$localDllPath = Join-Path $modSourceDir "dlls\mp.dll"
$upstreamDllPath = Join-Path $rootDir "upstream\ReGameDLL_CS\msvc\Release\mp.dll"

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
    if ($env:HALF_LIFE_DIR) {
        if ((Test-Path (Join-Path $env:HALF_LIFE_DIR "hl.exe")) -and (Test-Path (Join-Path $env:HALF_LIFE_DIR "cstrike"))) {
            return (Resolve-Path $env:HALF_LIFE_DIR).Path
        }

        Write-Error "HALF_LIFE_DIR is set, but hl.exe and cstrike were not found under: $env:HALF_LIFE_DIR"
    }

    foreach ($steamRoot in Get-SteamRootCandidates) {
        foreach ($library in Get-SteamLibraryPaths -SteamRoot $steamRoot) {
            $candidate = Join-Path $library "steamapps\common\Half-Life"
            if ((Test-Path (Join-Path $candidate "hl.exe")) -and (Test-Path (Join-Path $candidate "cstrike"))) {
                return (Resolve-Path $candidate).Path
            }
        }
    }

    Write-Error "Could not find Half-Life Steam install. Set HALF_LIFE_DIR to the folder that contains hl.exe and cstrike."
}

function Install-EntryIfExists {
    param(
        [string] $Source,
        [string] $Target
    )

    if ((Test-Path $Target) -or (Get-Item $Target -ErrorAction SilentlyContinue)) {
        return
    }

    if (-not (Test-Path $Source)) {
        return
    }

    if ($AssetMode -eq "link") {
        $item = Get-Item $Source
        if ($item.PSIsContainer) {
            New-Item -ItemType Junction -Path $Target -Target $Source | Out-Null
        }
        else {
            New-Item -ItemType HardLink -Path $Target -Target $Source | Out-Null
        }
    }
    else {
        Copy-Item -Path $Source -Destination $Target -Recurse -Force
    }
}

function Install-SettingsScriptIfNeeded {
    param(
        [string] $Source,
        [string] $Target
    )

    if (-not (Test-Path $Source)) {
        return
    }

    if ((-not (Test-Path $Target)) -or ((Get-Content -Raw $Target) -notmatch '"mp_roundtime"')) {
        Copy-Item -Path $Source -Destination $Target -Force
    }
}

function Copy-FullLocalModIfEnabled {
    if (-not $FullModCopy) {
        return
    }

    foreach ($item in Get-ChildItem -Force $modSourceDir) {
        $target = Join-Path $destDir $item.Name

        if ((Test-Path $target) -or (Get-Item $target -ErrorAction SilentlyContinue)) {
            Remove-Item -LiteralPath $target -Recurse -Force
        }

        Copy-Item -LiteralPath $item.FullName -Destination $target -Recurse -Force
    }
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
            Copy-Item -Path (Join-Path $cstrikeExtractDir "*") -Destination $destDir -Recurse -Force
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

    $config = Join-Path $destDir "game_init.cfg"
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
        $filteredLines.Add("// bot_enable 1 disabled by MODCSBR_ENABLE_ZBOT=0")
    }

    if ($EnableHostageAI) {
        $filteredLines.Add("hostage_ai_enable 1")
    }
    else {
        $filteredLines.Add("// hostage_ai_enable 1 disabled by MODCSBR_ENABLE_HOSTAGE_AI=0")
    }
    $filteredLines.Add("// END modcsbr ReGameDLL extras")

    Set-Content -Path $config -Value $filteredLines -Encoding ASCII
}

$halfLifeDir = Find-HalfLifeDir
$cstrikeDir = Join-Path $halfLifeDir "cstrike"
$destDir = Join-Path $halfLifeDir $ModName

if ($Reset) {
    $expectedDest = Join-Path $halfLifeDir $ModName
    if ($destDir -ne $expectedDest) {
        Write-Error "Refusing to reset unexpected mod path: $destDir"
    }

    if (Test-Path $destDir) {
        Remove-Item -LiteralPath $destDir -Recurse -Force
    }
}

New-Item -ItemType Directory -Path (Join-Path $destDir "dlls") -Force | Out-Null
Copy-Item -Path (Join-Path $modSourceDir "liblist.gam") -Destination (Join-Path $destDir "liblist.gam") -Force

foreach ($file in @("autoexec.cfg", "game_init.cfg")) {
    $source = Join-Path $modSourceDir $file
    if (Test-Path $source) {
        Copy-Item -Path $source -Destination (Join-Path $destDir $file) -Force
    }
}

$dllSource = $null
if (Test-Path $localDllPath) {
    $dllSource = $localDllPath
}
elseif (Test-Path $upstreamDllPath) {
    $dllSource = $upstreamDllPath
}

if ($dllSource) {
    Copy-Item -Path $dllSource -Destination (Join-Path $destDir "dlls\mp.dll") -Force
}
else {
    Write-Warning "mp.dll does not exist yet. Build first with: powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1"
}

foreach ($entry in @("cl_dlls", "events", "gfx", "maps", "media", "models", "overviews", "resource", "sound", "sprites")) {
    Install-EntryIfExists -Source (Join-Path $cstrikeDir $entry) -Target (Join-Path $destDir $entry)
}

foreach ($file in @("commandmenu.txt", "game_init.cfg", "server.cfg", "titles.txt", "user.scr")) {
    Install-EntryIfExists -Source (Join-Path $cstrikeDir $file) -Target (Join-Path $destDir $file)
}

Install-SettingsScriptIfNeeded -Source (Join-Path $cstrikeDir "settings.scr") -Target (Join-Path $destDir "settings.scr")
Copy-FullLocalModIfEnabled

Install-ReGameDLLExtraIfEnabled -Enabled $enableZBot -Archive (Join-Path $rootDir "upstream\ReGameDLL_CS\regamedll\extra\zBot\bot_profiles.zip") -Label "zBot for CS 1.6"
Install-ReGameDLLExtraIfEnabled -Enabled $enableHostageAI -Archive (Join-Path $rootDir "upstream\ReGameDLL_CS\regamedll\extra\HostageImprov\host_improv.zip") -Label "CS:CZ hostage AI for CS 1.6"
Set-ReGameDLLExtraConfig -EnableZBot $enableZBot -EnableHostageAI $enableHostageAI

Write-Host "Installed $ModName mod skeleton at: $destDir"
Write-Host "Game DLL path: $(Join-Path $destDir 'dlls\mp.dll')"
Write-Host "Asset mode: $AssetMode"
Write-Host "Full local mod copy: $FullModCopy"
Write-Host "zBot enabled: $enableZBot"
Write-Host "Hostage AI enabled: $enableHostageAI"
