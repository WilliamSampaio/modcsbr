# Changelog

All notable project changes will be documented here.

## Unreleased

- Switched the active initial runtime plan from Steam `hl.exe` to Windows Xash3D FWGS.
- Restored the ReGameDLL_CS submodule metadata to the `WilliamSampaio/ReGameDLL_CS` fork and branch `modcsbr`.
- Added `WilliamSampaio/cs16-client` as an `upstream/cs16-client` submodule on branch `modcsbr`.
- Added Windows CS16Client build support with `scripts/build/cs16-client-windows.ps1`.
- Added CS16Client nested submodule checks and `-UpdateSubmodules` support for `3rdparty` dependencies.
- Added Windows Xash3D FWGS install and launch scripts for `runtime/xash3d`.
- Fixed Xash3D asset installation to merge Steam `valve`/`cstrike` assets into existing runtime folders and validate `valve/gfx.wad`.
- Added Xash3D FWGS and CS16Client setup docs plus an approved runtime spec.
- Updated Windows environment checks and VS Code tasks for client, server, and Xash3D runtime workflows.
- Created base project structure.
- Added ReGameDLL_CS as an upstream submodule entry.
- Switched the active setup path to Linux.
- Added Linux build, Steam install, and launch scripts for `modcsbr`.
- Added Linux storage/environment check for `/dev/sdd`.
- Validated the first Linux ReGameDLL_CS build and Steam `modcsbr` install.
- Fixed the Linux launcher environment for Steam `libsteam_api.so` and `hw.so` loading.
- Changed the launcher default to Steam `-applaunch`, keeping direct `hl_linux` as a debug mode.
- Removed the forced `-soft` renderer flag after Steam launch worked without it.
- Changed Steam launch AppID back to Half-Life `70` so `-game modcsbr` loads the custom mod folder correctly.
- Documented WSL/llvmpipe performance limits and added runtime graphics warnings to the Linux environment check.
- Restored CS `settings.scr`/`user.scr` installation so the `Create Server` game options appear in `modcsbr`.
- Added `game_init.cfg` marker output for ReGameDLL validation from the Steam client console.
- Added clean reinstall support for the Steam `modcsbr` folder with copied CS client/HUD assets.
- Changed the launcher to open the CS menu by default because `New Game` initializes the HUD correctly.
- Added a client `autoexec.cfg` marker to confirm the Steam client launched the `modcsbr` folder.
- Pointed the ReGameDLL_CS submodule at the `WilliamSampaio/ReGameDLL_CS` fork for future mod-specific branches.
- Documented the fork's `modcsbr` branch as the destination for future ReGameDLL_CS changes.
- Reapplied the built GameDLL after full local mod copies in Linux and Windows Steam installs.
- Changed launch-script resets to preserve local mod assets by default, with explicit no-full-copy opt-outs.
- Added a Windows local GameUI.dll patch during install so CS Multiplayer crosshair controls recognize the `modcsbr` game directory.
