# Xash3D FWGS Windows Runtime

This is the supported runtime path for `modcsbr`.

## Goal

Run `modcsbr` on Windows with:

- Xash3D FWGS official Windows binaries as the engine runtime;
- Steam-owned `valve` and `cstrike` assets copied or linked into the Xash3D directory;
- `WilliamSampaio/cs16-client` branch `modcsbr` built as `cl_dlls/client.dll` and `cl_dlls/menu.dll`;
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
    stock cstrike assets copied locally
    liblist.gam
    resource/mainui_english.txt
    resource/modcsbr_english.txt
    cl_dlls/client.dll
    cl_dlls/menu.dll
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
steam_api.dll
```

At minimum, Xash3D must be able to find:

```text
runtime/xash3d/valve/gfx.wad
```

If `valve` already exists because it came with the Xash3D package, the installer merges the Steam `valve` files into it instead of skipping the folder.

The installer also copies `steam_api.dll` from the Steam Half-Life folder into the Xash3D root for compatibility with copied Steam assets. This does not make stock `-game cstrike` a supported launch target.

The installed `modcsbr` folder is also seeded from the Steam `cstrike` folder before repository mod files and compiled DLLs are applied. This gives the local Xash runtime a complete Counter-Strike-derived mod folder while keeping Steam-owned assets under ignored `runtime/` instead of committing them to Git.

The repository overlay includes minimal `resource/mainui_english.txt` and `resource/modcsbr_english.txt` dictionaries. CS16Client and MainUI probe those mod-owned files during startup; keeping valid empty dictionaries in the overlay avoids missing-localization warnings while still relying on the copied legal Steam assets for stock Counter-Strike text.

When adding or reviewing overlay assets under `mod/modcsbr`, ignore Windows Explorer metadata such as `Thumbs.db`. Those files are local caches and should not be versioned as part of the mod.

By default assets are copied into the Xash3D runtime. To use directory junctions instead:

```powershell
$env:MODCSBR_ASSET_MODE = "link"
```

## Build Server

From Developer PowerShell for Visual Studio:

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

For development work, switch the primary submodules to their `modcsbr` branches:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/dev/switch-modcsbr-branches.ps1
```

Build:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -UpdateSubmodules
```

Expected repository output:

```text
mod/modcsbr/cl_dlls/client.dll
mod/modcsbr/cl_dlls/menu.dll
```

## Install

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1
```

Reset the installed Xash mod folder:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1 -Reset
```

Use `-Reset` after changing the base Steam assets or when you want a clean generated mod folder. The normal install merges updated files into the existing runtime folder.

The mod ReGameDLL default and the repository overlay's `game_init.cfg`, `server.cfg`, and `listenserver.cfg` set `mp_flashlight "1"`, which lets ReGameDLL accept the standard flashlight command (`impulse 100`) in local matches.

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

Use `New Game` in the main menu to create a local match, choose a map, and set the bot count. The same creation screen is also available from `Multiplayer > Create game`.

Launch directly into a map:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -AutoMap -Map de_dust2
```

Equivalent command:

```text
xash3d.exe -game modcsbr -console -dev
```

Do not use `xash3d.exe -game cstrike` as a project smoke test. The copied Steam `cstrike` folder is present so `modcsbr` can inherit legal base assets; its stock `cl_dlls/client.dll` can assert on missing Steam GameUI state when loaded directly under Xash3D.

## Notes

- Keep all runtime binaries under `runtime/xash3d` or another ignored directory.
- Keep the Xash3D, CS16Client, and ReGameDLL builds aligned to Win32/x86 unless all loaded game libraries are rebuilt together for another architecture.
- Do not rely on Steam/GoldSrc launch workflows; Xash3D FWGS is the only supported runtime path.

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

If Xash3D shows `Error: native object "MenuFactory" is unavailable`, confirm that the CS16Client menu DLL is installed beside the client DLL:

```powershell
Test-Path runtime\xash3d\modcsbr\cl_dlls\menu.dll
```

If it returns `False`, rebuild CS16Client and reinstall the runtime:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -UpdateSubmodules
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1
```

If stock Counter-Strike launched with `-game cstrike` opens a Microsoft Visual C++ assertion dialog for `g_hGameUIModule`, close it and use the supported mod launch path instead:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

That assertion comes from the copied Steam `cstrike\cl_dlls\client.dll`, not from CS16Client or the `modcsbr` runtime.
