param(
    [ValidateSet("Debug", "Release", "RelWithDebInfo", "MinSizeRel")]
    [string] $Configuration = "Release",

    [ValidateSet("Win32")]
    [string] $Platform = "Win32",

    [string] $SourceDir,

    [string] $BuildDir,

    [string] $InstallDir,

    [switch] $NoInstallToMod,

    [switch] $UpdateSubmodules
)

$ErrorActionPreference = "Stop"

$rootDir = Resolve-Path (Join-Path $PSScriptRoot "..\..")

if (-not $SourceDir) {
    $SourceDir = Join-Path $rootDir "upstream\cs16-client"
}
if (-not $BuildDir) {
    $BuildDir = Join-Path $rootDir "build\windows\cs16-client"
}
if (-not $InstallDir) {
    $InstallDir = Join-Path $rootDir "build\windows\cs16-client-install"
}

if (-not (Test-Path $SourceDir)) {
    Write-Error "Missing cs16-client source at: $SourceDir. Run: git submodule sync --recursive; git submodule update --init --recursive"
}

if ($UpdateSubmodules) {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Error "git was not found. Install Git for Windows before using -UpdateSubmodules."
    }

    Write-Host "Updating nested CS16Client submodules..."
    & git -C $SourceDir submodule sync --recursive
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }

    & git -C $SourceDir submodule update --init --recursive
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}

$requiredNestedFiles = @(
    "3rdparty\yapb\CMakeLists.txt",
    "3rdparty\ReGameDLL_CS\CMakeLists.txt",
    "3rdparty\mainui_cpp\CMakeLists.txt"
)

$missingNestedFiles = @()
foreach ($relativePath in $requiredNestedFiles) {
    $candidate = Join-Path $SourceDir $relativePath
    if (-not (Test-Path $candidate)) {
        $missingNestedFiles += $relativePath
    }
}

if ($missingNestedFiles.Count -gt 0) {
    Write-Host "Missing nested CS16Client submodule files:"
    foreach ($relativePath in $missingNestedFiles) {
        Write-Host "  - $relativePath"
    }
    Write-Error "Initialize nested submodules with: git -C upstream\cs16-client submodule update --init --recursive. Or rerun this script with -UpdateSubmodules."
}

if (-not (Get-Command cmake -ErrorAction SilentlyContinue)) {
    Write-Error "cmake was not found. Install Visual Studio C++ tools with CMake support, then open Developer PowerShell for Visual Studio."
}

function Resolve-PythonExecutable {
    $pythonCmd = Get-Command python -ErrorAction SilentlyContinue
    if ($pythonCmd -and $pythonCmd.Source -notlike "*\WindowsApps\python.exe") {
        try {
            $version = & $pythonCmd.Source --version 2>&1
            if ($LASTEXITCODE -eq 0 -and $version -match "^Python 3\.") {
                return $pythonCmd.Source
            }
        }
        catch {
        }
    }

    $pyCmd = Get-Command py -ErrorAction SilentlyContinue
    if ($pyCmd) {
        try {
            $candidate = & py -3 -c "import sys; print(sys.executable)" 2>$null | Select-Object -First 1
            if ($LASTEXITCODE -eq 0 -and $candidate -and (Test-Path $candidate)) {
                return $candidate
            }
        }
        catch {
        }
    }

    return $null
}

$pythonExecutable = Resolve-PythonExecutable
if (-not $pythonExecutable) {
    Write-Error "Python 3 was not found. Install Python 3 with 'Add python.exe to PATH' enabled, or install the Python launcher so 'py -3' works. If python resolves to WindowsApps, disable the python.exe/python3.exe app execution aliases."
}

$pythonVersion = & $pythonExecutable --version 2>&1

Write-Host "Configuring CS16Client..."
Write-Host "Source: $SourceDir"
Write-Host "Build: $BuildDir"
Write-Host "Install: $InstallDir"
Write-Host "Configuration: $Configuration"
Write-Host "Platform: $Platform"
Write-Host "Python: $pythonExecutable ($pythonVersion)"

& cmake -A $Platform -S $SourceDir -B $BuildDir "-DPython_EXECUTABLE:FILEPATH=$pythonExecutable"
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

& cmake --build $BuildDir --config $Configuration
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

& cmake --install $BuildDir --config $Configuration --prefix $InstallDir
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

$clientArtifacts = @(
    @{ Name = "client.dll"; Label = "client DLL" },
    @{ Name = "menu.dll"; Label = "menu DLL" }
)

foreach ($artifact in $clientArtifacts) {
    $foundArtifact = Get-ChildItem -Path $InstallDir, $BuildDir -Recurse -File -Filter $artifact.Name -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if ($foundArtifact) {
        Write-Host "Built $($artifact.Label): $($foundArtifact.FullName)"

        if (-not $NoInstallToMod) {
            $targetDir = Join-Path $rootDir "mod\modcsbr\cl_dlls"
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
            Copy-Item -LiteralPath $foundArtifact.FullName -Destination (Join-Path $targetDir $artifact.Name) -Force
            Write-Host "Copied $($artifact.Label) to: $(Join-Path $targetDir $artifact.Name)"
        }
    }
    else {
        Write-Warning "Build finished, but $($artifact.Name) was not found under $InstallDir or $BuildDir."
    }
}
