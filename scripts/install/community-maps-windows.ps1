param(
    [string] $Repository = $(if ($env:MODCSBR_COMMUNITY_MAPS_REPOSITORY) { $env:MODCSBR_COMMUNITY_MAPS_REPOSITORY } else { "modcsbr/community-maps" }),

    [string] $ReleaseTag = $(if ($env:MODCSBR_COMMUNITY_MAPS_RELEASE_TAG) { $env:MODCSBR_COMMUNITY_MAPS_RELEASE_TAG } else { "" }),

    [string] $CommunityMapsDir = $(if ($env:MODCSBR_COMMUNITY_MAPS_DIR) { $env:MODCSBR_COMMUNITY_MAPS_DIR } else { "" }),

    [string] $ModName = $(if ($env:MOD_NAME) { $env:MOD_NAME } else { "modcsbr" }),

    [string] $XashDir = $(if ($env:XASH3D_DIR) { $env:XASH3D_DIR } else { "" }),

    [string[]] $Maps = @(),

    [switch] $All,

    [switch] $FromRelease,

    [switch] $Force,

    [switch] $ValidateOnly,

    [switch] $NoDownload
)

$ErrorActionPreference = "Stop"

$rootDir = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$downloadsDir = Join-Path $rootDir ".downloads\community-maps"

if (-not $XashDir) {
    $XashDir = Join-Path $rootDir "runtime\xash3d"
}

if ([string]::IsNullOrWhiteSpace($ModName)) {
    Write-Error "ModName cannot be empty."
}

if (-not $All -and $Maps.Count -eq 0) {
    Write-Error "Choose at least one map with -Maps or install every allowed map with -All."
}

function Get-FileHashString {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [ValidateSet("SHA256", "MD5")]
        [string] $Algorithm
    )

    return (Get-FileHash -Algorithm $Algorithm -LiteralPath $Path).Hash.ToUpperInvariant()
}

function Assert-PathInside {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Parent,

        [Parameter(Mandatory = $true)]
        [string] $Child
    )

    $parentFull = [System.IO.Path]::GetFullPath($Parent).TrimEnd('\', '/')
    $childFull = [System.IO.Path]::GetFullPath($Child)

    if (-not ($childFull.StartsWith($parentFull + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase) -or
              $childFull.Equals($parentFull, [System.StringComparison]::OrdinalIgnoreCase))) {
        Write-Error "Refusing to access path outside target directory. Parent: $parentFull Child: $childFull"
    }
}

function Read-JsonFile {
    param([Parameter(Mandatory = $true)] [string] $Path)

    return Get-Content -Raw -LiteralPath $Path -Encoding UTF8 | ConvertFrom-Json
}

function Test-RedistributionAllowed {
    param([Parameter(Mandatory = $true)] [string] $Status)

    return $Status -eq "allowed" -or $Status -eq "permission-granted"
}

function Get-GitHubRelease {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Repository,

        [string] $ReleaseTag
    )

    $headers = @{ "User-Agent" = "modcsbr-community-maps-installer" }

    if ($ReleaseTag) {
        $uri = "https://api.github.com/repos/$Repository/releases/tags/$ReleaseTag"
    }
    else {
        $uri = "https://api.github.com/repos/$Repository/releases/latest"
    }

    Write-Host "Reading release metadata from $uri"
    return Invoke-RestMethod -Headers $headers -Uri $uri
}

function Get-AssetByName {
    param(
        [Parameter(Mandatory = $true)]
        $Release,

        [Parameter(Mandatory = $true)]
        [string] $Name
    )

    $asset = $Release.assets | Where-Object { $_.name -eq $Name } | Select-Object -First 1
    if (-not $asset) {
        Write-Error "Release '$($Release.tag_name)' does not contain asset: $Name"
    }

    return $asset
}

function Download-ReleaseAsset {
    param(
        [Parameter(Mandatory = $true)]
        $Release,

        [Parameter(Mandatory = $true)]
        [string] $Name,

        [Parameter(Mandatory = $true)]
        [string] $TargetDir,

        [switch] $NoDownload
    )

    $target = Join-Path $TargetDir $Name
    if ((Test-Path -LiteralPath $target) -and $NoDownload) {
        Write-Host "Using cached asset: $target"
        return $target
    }

    if ($NoDownload) {
        Write-Error "NoDownload is set, but cached asset was not found: $target"
    }

    $asset = Get-AssetByName -Release $Release -Name $Name
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null

    Write-Host "Downloading $Name from release $($Release.tag_name)"
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $target
    return $target
}

function Read-Checksums {
    param([Parameter(Mandatory = $true)] [string] $Path)

    $checksums = @{}
    foreach ($line in Get-Content -LiteralPath $Path) {
        if ($line -match '^\s*([A-Fa-f0-9]{64})\s+\*?(.+?)\s*$') {
            $checksums[$matches[2]] = $matches[1].ToUpperInvariant()
        }
    }

    return $checksums
}

function Assert-ExpectedSha256 {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [string] $ExpectedSha256
    )

    $actual = Get-FileHashString -Path $Path -Algorithm SHA256
    if ($actual -ne $ExpectedSha256.ToUpperInvariant()) {
        Write-Error "SHA256 mismatch for $Path. Expected $ExpectedSha256, got $actual."
    }
}

function Assert-ManifestFiles {
    param(
        [Parameter(Mandatory = $true)]
        [string] $MapDir
    )

    $manifestPath = Join-Path $MapDir "manifest.json"
    if (-not (Test-Path -LiteralPath $manifestPath)) {
        Write-Error "Missing manifest: $manifestPath"
    }

    $manifest = Read-JsonFile -Path $manifestPath

    if (-not (Test-RedistributionAllowed -Status $manifest.redistribution)) {
        Write-Error "Map '$($manifest.id)' cannot be installed because redistribution is '$($manifest.redistribution)'."
    }

    foreach ($file in $manifest.files) {
        if (-not $file.hosted) {
            continue
        }

        $filePath = Join-Path $MapDir ($file.path -replace '/', '\')
        Assert-PathInside -Parent $MapDir -Child $filePath

        if (-not (Test-Path -LiteralPath $filePath -PathType Leaf)) {
            Write-Error "Missing hosted file for map '$($manifest.id)': $($file.path)"
        }

        $actualSize = (Get-Item -LiteralPath $filePath).Length
        if ($actualSize -ne [int64] $file.size_bytes) {
            Write-Error "Size mismatch for $filePath. Expected $($file.size_bytes), got $actualSize."
        }

        Assert-ExpectedSha256 -Path $filePath -ExpectedSha256 $file.sha256

        $actualMd5 = Get-FileHashString -Path $filePath -Algorithm MD5
        if ($actualMd5 -ne $file.md5.ToUpperInvariant()) {
            Write-Error "MD5 mismatch for $filePath. Expected $($file.md5), got $actualMd5."
        }
    }

    return $manifest
}

function Copy-MapFilesToRuntime {
    param(
        [Parameter(Mandatory = $true)]
        [string] $MapDir,

        [Parameter(Mandatory = $true)]
        [string] $RuntimeModDir,

        [switch] $Force
    )

    $filesDir = Join-Path $MapDir "files"
    if (-not (Test-Path -LiteralPath $filesDir -PathType Container)) {
        Write-Error "Missing files directory: $filesDir"
    }

    New-Item -ItemType Directory -Path $RuntimeModDir -Force | Out-Null

    foreach ($source in Get-ChildItem -Recurse -File -LiteralPath $filesDir) {
        $relative = $source.FullName.Substring($filesDir.Length).TrimStart('\', '/')
        $target = Join-Path $RuntimeModDir $relative
        Assert-PathInside -Parent $RuntimeModDir -Child $target

        if (Test-Path -LiteralPath $target -PathType Leaf) {
            $sourceHash = Get-FileHashString -Path $source.FullName -Algorithm SHA256
            $targetHash = Get-FileHashString -Path $target -Algorithm SHA256

            if ($sourceHash -eq $targetHash) {
                Write-Host "Unchanged: $relative"
                continue
            }

            if (-not $Force) {
                Write-Error "Destination exists with different content: $target. Use -Force to overwrite."
            }

            Write-Host "Overwriting: $relative"
        }
        else {
            Write-Host "Installing: $relative"
        }

        New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force | Out-Null
        Copy-Item -LiteralPath $source.FullName -Destination $target -Force
    }
}

function Get-MapDirectoriesFromRoot {
    param(
        [Parameter(Mandatory = $true)]
        [string] $CatalogueRoot,

        [string[]] $Maps,

        [switch] $All
    )

    $mapsRoot = Join-Path $CatalogueRoot "maps"
    if (-not (Test-Path -LiteralPath $mapsRoot -PathType Container)) {
        $manifest = Get-ChildItem -Recurse -Filter "manifest.json" -LiteralPath $CatalogueRoot |
            Where-Object { $_.FullName -match '[\\/]maps[\\/][^\\/]+[\\/]manifest\.json$' } |
            Select-Object -First 1

        if (-not $manifest) {
            Write-Error "Missing maps directory in catalogue: $mapsRoot"
        }

        $mapsRoot = Split-Path -Parent (Split-Path -Parent $manifest.FullName)
        Write-Warning "Catalogue maps directory was nested; using: $mapsRoot"
    }

    if ($All) {
        return @(Get-ChildItem -Directory -LiteralPath $mapsRoot | Sort-Object Name)
    }

    return @(
        foreach ($map in $Maps) {
            $mapDir = Join-Path $mapsRoot $map
            if (-not (Test-Path -LiteralPath $mapDir -PathType Container)) {
                Write-Error "Map '$map' was not found under: $mapsRoot"
            }
            Get-Item -LiteralPath $mapDir
        }
    )
}

function Install-FromCatalogueRoot {
    param(
        [Parameter(Mandatory = $true)]
        [string] $CatalogueRoot,

        [Parameter(Mandatory = $true)]
        [string] $RuntimeModDir,

        [string[]] $Maps,

        [switch] $All,

        [switch] $Force,

        [switch] $ValidateOnly
    )

    $mapDirs = Get-MapDirectoriesFromRoot -CatalogueRoot $CatalogueRoot -Maps $Maps -All:$All
    if ($mapDirs.Count -eq 0) {
        Write-Error "No maps selected."
    }

    foreach ($mapDir in $mapDirs) {
        $manifest = Assert-ManifestFiles -MapDir $mapDir.FullName
        Write-Host "Validated map: $($manifest.id)"

        if (-not $ValidateOnly) {
            Copy-MapFilesToRuntime -MapDir $mapDir.FullName -RuntimeModDir $RuntimeModDir -Force:$Force
        }
    }
}

function Install-FromRelease {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Repository,

        [string] $ReleaseTag,

        [Parameter(Mandatory = $true)]
        [string] $RuntimeModDir,

        [string[]] $Maps,

        [switch] $All,

        [switch] $Force,

        [switch] $ValidateOnly,

        [switch] $NoDownload
    )

    $release = Get-GitHubRelease -Repository $Repository -ReleaseTag $ReleaseTag
    $tag = $release.tag_name
    if (-not $tag) {
        Write-Error "Could not determine release tag."
    }

    Write-Host "Using community maps release: $tag"

    $releaseDir = Join-Path $downloadsDir $tag
    $assetDir = Join-Path $releaseDir "assets"
    $extractDir = Join-Path $releaseDir "extracted"
    New-Item -ItemType Directory -Path $assetDir -Force | Out-Null
    New-Item -ItemType Directory -Path $extractDir -Force | Out-Null

    $indexPath = Download-ReleaseAsset -Release $release -Name "manifest-index.json" -TargetDir $assetDir -NoDownload:$NoDownload
    $checksumsPath = Download-ReleaseAsset -Release $release -Name "checksums.sha256" -TargetDir $assetDir -NoDownload:$NoDownload

    $checksums = Read-Checksums -Path $checksumsPath
    if ($checksums.ContainsKey("manifest-index.json")) {
        Assert-ExpectedSha256 -Path $indexPath -ExpectedSha256 $checksums["manifest-index.json"]
    }

    $index = Read-JsonFile -Path $indexPath

    $assetsToInstall = @()
    if ($All) {
        $assetsToInstall += $index.full_pack.asset
    }
    else {
        foreach ($map in $Maps) {
            $pack = $index.packs | Where-Object { $_.id -eq $map } | Select-Object -First 1
            if (-not $pack) {
                Write-Error "Release index does not contain map: $map"
            }
            $assetsToInstall += $pack.asset
        }
    }

    foreach ($assetName in ($assetsToInstall | Select-Object -Unique)) {
        $zipPath = Download-ReleaseAsset -Release $release -Name $assetName -TargetDir $assetDir -NoDownload:$NoDownload

        $expected = $null
        if ($checksums.ContainsKey($assetName)) {
            $expected = $checksums[$assetName]
        }
        elseif ($assetName -eq $index.full_pack.asset) {
            $expected = $index.full_pack.sha256
        }
        else {
            $pack = $index.packs | Where-Object { $_.asset -eq $assetName } | Select-Object -First 1
            if ($pack) {
                $expected = $pack.sha256
            }
        }

        if (-not $expected) {
            Write-Error "Could not find expected SHA256 for release asset: $assetName"
        }

        Assert-ExpectedSha256 -Path $zipPath -ExpectedSha256 $expected

        Write-Host "Extracting $assetName"
        Expand-Archive -LiteralPath $zipPath -DestinationPath $extractDir -Force
    }

    Install-FromCatalogueRoot -CatalogueRoot $extractDir -RuntimeModDir $RuntimeModDir -Maps $Maps -All:$All -Force:$Force -ValidateOnly:$ValidateOnly
}

$runtimeModDir = Join-Path $XashDir $ModName

if ($CommunityMapsDir) {
    $catalogueRoot = (Resolve-Path $CommunityMapsDir).Path
    Write-Host "Installing community maps from local catalogue: $catalogueRoot"
    Install-FromCatalogueRoot -CatalogueRoot $catalogueRoot -RuntimeModDir $runtimeModDir -Maps $Maps -All:$All -Force:$Force -ValidateOnly:$ValidateOnly
    return
}

if (-not $FromRelease) {
    Write-Host "No CommunityMapsDir was provided; using GitHub Release source."
}

Install-FromRelease -Repository $Repository -ReleaseTag $ReleaseTag -RuntimeModDir $runtimeModDir -Maps $Maps -All:$All -Force:$Force -ValidateOnly:$ValidateOnly -NoDownload:$NoDownload
