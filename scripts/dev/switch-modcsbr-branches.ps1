param(
    [string] $Branch = "modcsbr",

    [switch] $IncludeMainUI,

    [switch] $NoFetch
)

$ErrorActionPreference = "Stop"

$rootDir = Resolve-Path (Join-Path $PSScriptRoot "..\..")

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "git was not found. Install Git for Windows before using this script."
}

$submodules = @(
    @{
        Path = "upstream\ReGameDLL_CS"
        Name = "ReGameDLL_CS server GameDLL"
    },
    @{
        Path = "upstream\cs16-client"
        Name = "CS16Client client/menu DLL"
    }
)

if ($IncludeMainUI) {
    $submodules += @{
        Path = "upstream\cs16-client\3rdparty\mainui_cpp"
        Name = "CS16Client nested MainUI"
    }
}

function Invoke-Git {
    param(
        [Parameter(Mandatory = $true)]
        [string] $RepoPath,

        [Parameter(Mandatory = $true)]
        [string[]] $Arguments
    )

    & git -C $RepoPath @Arguments
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}

function Test-GitSuccess {
    param(
        [Parameter(Mandatory = $true)]
        [string] $RepoPath,

        [Parameter(Mandatory = $true)]
        [string[]] $Arguments
    )

    & git -C $RepoPath @Arguments *> $null
    return $LASTEXITCODE -eq 0
}

foreach ($submodule in $submodules) {
    $relativePath = $submodule.Path
    $repoPath = Join-Path $rootDir $relativePath

    if (-not (Test-Path $repoPath)) {
        Write-Error "Missing submodule path: $relativePath. Run: git submodule update --init --recursive"
    }

    if (-not (Test-GitSuccess -RepoPath $repoPath -Arguments @("rev-parse", "--is-inside-work-tree"))) {
        Write-Error "Path is not a Git checkout: $relativePath"
    }

    Write-Host ""
    Write-Host "==> $($submodule.Name)"
    Write-Host "Path: $relativePath"

    if (-not $NoFetch) {
        Write-Host "Fetching origin..."
        Invoke-Git -RepoPath $repoPath -Arguments @("fetch", "origin", "--prune")
    }

    $hasLocalBranch = Test-GitSuccess -RepoPath $repoPath -Arguments @("show-ref", "--verify", "--quiet", "refs/heads/$Branch")
    $hasRemoteBranch = Test-GitSuccess -RepoPath $repoPath -Arguments @("show-ref", "--verify", "--quiet", "refs/remotes/origin/$Branch")

    if ($hasLocalBranch) {
        Write-Host "Switching to local branch '$Branch'..."
        Invoke-Git -RepoPath $repoPath -Arguments @("switch", $Branch)
    }
    elseif ($hasRemoteBranch) {
        Write-Host "Creating local branch '$Branch' tracking 'origin/$Branch'..."
        Invoke-Git -RepoPath $repoPath -Arguments @("switch", "--track", "-c", $Branch, "origin/$Branch")
    }
    else {
        Write-Error "Branch '$Branch' was not found locally or at origin for $relativePath. Create/push the branch in that fork first, or rerun with another -Branch value."
    }

    $currentBranch = (& git -C $repoPath branch --show-current)
    $currentCommit = (& git -C $repoPath rev-parse --short HEAD)
    Write-Host "Now on $currentBranch at $currentCommit"
}

Write-Host ""
Write-Host "Done. Run 'git status' in the repository root to see whether any submodule pointers changed."
