# Changelog

All notable project changes will be documented here.

## Unreleased

- Removed the legacy Steam/GoldSrc install, launch, Linux environment, and Linux server-library helper scripts.
- Made Windows Xash3D FWGS the only supported runtime path.
- Added `WilliamSampaio/cs16-client` as an `upstream/cs16-client` submodule on branch `modcsbr`.
- Added Windows CS16Client build support with nested submodule checks and `-UpdateSubmodules`.
- Added Windows Xash3D FWGS install and launch scripts for `runtime/xash3d`.
- Fixed Windows CS16Client build/install flow to copy `menu.dll` beside `client.dll` for Xash3D FWGS MainUI loading.
- Fixed Xash3D asset installation to merge Steam `valve`/`cstrike` assets into existing runtime folders and validate `valve/gfx.wad`.
- Fixed Xash3D stock `-game cstrike` smoke tests by copying Steam `steam_api.dll` into the local runtime root.
- Changed the Xash3D install flow to seed `runtime/xash3d/modcsbr` from a full local Steam `cstrike` copy before overlaying mod files and compiled DLLs.
- Restored the ReGameDLL_CS submodule metadata to the `WilliamSampaio/ReGameDLL_CS` fork and branch `modcsbr`.
- Updated Windows environment checks, VS Code tasks, setup docs, architecture docs, specs, and agent notes for the Xash3D-only workflow.
- Documented the Visual Studio Installer workload/components used for Windows builds.
- Optimized the README for public GitHub contributors with a shorter quick start, legal asset notice, and contribution guidance.
- Updated CS16Client MainUI so `New Game` opens local match creation with map selection and bot count for `modcsbr`.
- Documented the CS16Client Python 3 build dependency and added earlier Windows environment/build checks for `python` or `py -3`.
- Added mod-owned `mainui_english.txt` and `modcsbr_english.txt` localization placeholders so CS16Client/MainUI stop warning about missing language dictionaries at launch.
