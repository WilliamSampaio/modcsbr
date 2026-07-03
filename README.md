# modcsbr

`modcsbr` is a Counter-Strike 1.6 / GoldSrc-family custom mod targeting Xash3D FWGS on Windows.

The project uses:

- Xash3D FWGS as the runtime engine;
- CS16Client as the client DLL and MainUI DLL;
- ReGameDLL_CS as the server GameDLL;
- legally owned Half-Life / Counter-Strike 1.6 Steam files as a local asset base.

The old Steam/GoldSrc launch workflow is not supported. The only supported runtime path is:

```text
runtime/xash3d/xash3d.exe -game modcsbr
```

## Status

This repository is being prepared for public collaboration. The current focus is getting a clean Windows Xash3D baseline before gameplay and asset changes grow.

## Legal Assets

This repository does not include Valve, Half-Life, Counter-Strike, Steam, or Xash3D runtime binaries/assets.

Contributors need their own legal Steam installation of Half-Life / Counter-Strike 1.6. The installer copies required local assets into ignored `runtime/` folders:

```text
runtime/xash3d/valve
runtime/xash3d/cstrike
runtime/xash3d/modcsbr
runtime/xash3d/steam_api.dll
```

Do not commit generated runtime files, engine binaries, or Valve/Counter-Strike assets.

## Requirements

- Windows 11.
- Git for Windows.
- VS Code.
- Visual Studio Build Tools / Visual Studio Installer with the `Desktop development with C++` workload.
- CMake from the Visual Studio C++ workload.
- Python 3 available as `python` in PATH, or through the Python launcher as `py -3`.
- Official Xash3D FWGS Windows binaries extracted into `runtime/xash3d`.
- Steam Half-Life / Counter-Strike 1.6 installed locally.

Visual Studio Installer components used for this project:

- Workload: `Desktop development with C++`.
- MSBuild tools.
- MSVC build tools for x64/x86.
- Windows 11 SDK `10.0.26100.8249` or newer.
- C++ CMake tools for Windows.
- C++ test tools core features.
- MSVC AddressSanitizer.
- vcpkg package manager.

See [docs/setup/windows-11.md](docs/setup/windows-11.md) for installer details and verification commands.

## Quick Start

Clone and initialize submodules:

```powershell
git submodule sync --recursive
git submodule update --init --recursive
```

If Steam Half-Life is not in the default location, point the scripts at the folder that contains `valve`, `cstrike`, and `steam_api.dll`:

```powershell
$env:HALF_LIFE_DIR = "D:\SteamLibrary\steamapps\common\Half-Life"
```

Build the server GameDLL:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1
```

Build the client and menu DLLs:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -UpdateSubmodules
```

Install the local Xash3D runtime:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1 -Reset
```

Validate the launch command:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
```

Launch:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

In the main menu, use `New Game` to create a local match. That screen lets you select a map, set max players, and set the bot count.

## Runtime Layout

The installer generates a local ignored runtime:

```text
runtime/xash3d/
  xash3d.exe
  valve/
  cstrike/
  steam_api.dll
  modcsbr/
    base copied from cstrike
    files overlaid from mod/modcsbr
    resource/mainui_english.txt
    resource/modcsbr_english.txt
    cl_dlls/client.dll
    cl_dlls/menu.dll
    dlls/mp.dll
```

`menu.dll` must stay beside `client.dll`; Xash3D FWGS MainUI expects that layout for `MenuFactory`.
The mod-owned localization files are intentionally small placeholder dictionaries. They silence CS16Client/MainUI missing-file warnings without committing Valve-owned text resources.

## Repository Layout

```text
mod/modcsbr/                  source mod overlay
runtime/xash3d/               local ignored runtime
scripts/build/                Windows build wrappers
scripts/install/              Xash3D runtime installer
scripts/test/                 environment and launch checks
upstream/ReGameDLL_CS/        server GameDLL submodule
upstream/cs16-client/         client DLL submodule
docs/                         setup and architecture notes
specs/                        spec-driven planning
```

## Documentation

- [Windows setup](docs/setup/windows-11.md)
- [Xash3D FWGS runtime](docs/setup/xash3d-windows.md)
- [Build ReGameDLL_CS](docs/setup/build-regamedll.md)
- [Build CS16Client](docs/setup/build-cs16-client.md)
- [Architecture overview](docs/architecture/overview.md)
- [Approved runtime spec](specs/approved/xash3d-fwgs-windows-runtime.md)

## Contributing

Keep changes small and document behavior in `specs/` before large feature work. Do not commit generated runtime files or third-party proprietary assets.

Before opening a pull request, run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/check-windows-environment.ps1
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
```

When touching build, install, launch, paths, or workflow behavior, update the relevant docs in the same change.

## Troubleshooting

If Xash3D cannot find `gfx.wad`, set `HALF_LIFE_DIR` and reinstall the runtime.

If Xash3D reports `MenuFactory` is unavailable, rebuild CS16Client and confirm:

```powershell
Test-Path runtime\xash3d\modcsbr\cl_dlls\menu.dll
```

If `cl`, `msbuild`, or `cmake` are missing, reopen the project from Developer PowerShell and confirm the Visual Studio Installer components listed above are installed.

If the CS16Client build reports that Python is missing, install Python 3 with `Add python.exe to PATH` or the Python launcher enabled. If `python --version` points at `WindowsApps\python.exe` or opens the Microsoft Store, disable the Windows app execution aliases for `python.exe` and `python3.exe`.
