# Xash3D FWGS Windows Runtime

This is the active initial runtime path for `modcsbr`.

## Goal

Run `modcsbr` on Windows with:

- Xash3D FWGS official Windows binaries as the engine runtime;
- Steam-owned `valve` and `cstrike` assets copied or linked into the Xash3D directory;
- `WilliamSampaio/cs16-client` branch `modcsbr` built as `cl_dlls/client.dll`;
- `WilliamSampaio/ReGameDLL_CS` branch `modcsbr` built as `dlls/mp.dll`.

The first phase uses downloaded Xash3D FWGS binaries. Build the engine from source only if the binary runtime blocks mod development.

## Runtime Layout

Default local runtime:

```text
runtime/xash3d/
  xash3d.exe
  valve/
  cstrike/
  modcsbr/
    liblist.gam
    cl_dlls/client.dll
    dlls/mp.dll
```

`runtime/` is ignored by Git.

If the engine lives elsewhere, set:

```powershell
$env:XASH3D_DIR = "D:\Games\xash3d-fwgs"
```

## Base Game Assets

Xash3D FWGS still needs legal Half-Life/Counter-Strike assets. The installer detects the Windows Steam Half-Life folder from the registry and Steam libraries when possible.

Override detection with:

```powershell
$env:HALF_LIFE_DIR = "D:\SteamLibrary\steamapps\common\Half-Life"
```

The folder must contain:

```text
valve/
cstrike/
```

At minimum, Xash3D must be able to find:

```text
runtime/xash3d/valve/gfx.wad
```

If `valve` already exists because it came with the Xash3D package, the installer merges the Steam `valve` files into it instead of skipping the folder.

By default assets are copied into the Xash3D runtime. To use directory junctions instead:

```powershell
$env:MODCSBR_ASSET_MODE = "link"
```

## Build Server

From Developer PowerShell for VS 2022:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1
```

Expected repository output:

```text
mod/modcsbr/dlls/mp.dll
```

## Build Client

Initialize the client/server submodules:

```powershell
git submodule sync --recursive
git submodule update --init --recursive
```

Build:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -UpdateSubmodules
```

Expected repository output:

```text
mod/modcsbr/cl_dlls/client.dll
```

## Install

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1
```

Reset the installed Xash mod folder:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1 -Reset
```

Suppress optional ReGameDLL extras:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1 -DisableReGameDLLExtras
```

## Launch

Validate without opening a process:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
```

Launch:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

Launch directly into a map:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -AutoMap -Map de_dust2
```

Equivalent command:

```text
xash3d.exe -game modcsbr -console -dev
```

## Notes

- Keep all runtime binaries under `runtime/xash3d` or another ignored directory.
- Keep the Xash3D, CS16Client, and ReGameDLL builds aligned to Win32/x86 unless all loaded game libraries are rebuilt together for another architecture.
- Do not patch `hl.exe` or rely on Steam `-applaunch` for this active path; the Steam scripts remain legacy helpers.

## Troubleshooting

If Xash3D shows `Host_InitCommon: couldn't load gfx.wad`, the runtime is missing Half-Life base assets. Confirm:

```powershell
Test-Path runtime\xash3d\valve\gfx.wad
```

If it returns `False`, set `HALF_LIFE_DIR` to the Steam Half-Life folder and reinstall:

```powershell
$env:HALF_LIFE_DIR = "C:\Program Files (x86)\Steam\steamapps\common\Half-Life"
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1
```
