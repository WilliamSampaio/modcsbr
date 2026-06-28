# Changelog

All notable project changes will be documented here.

## Unreleased

- Created base project structure.
- Added ReGameDLL_CS as an upstream submodule entry.
- Switched the active setup path to Linux.
- Added Linux build, Steam install, and launch scripts for `modcsbr`.
- Added Linux storage/environment check for `/dev/sdd`.
- Validated the first Linux ReGameDLL_CS build and Steam `modcsbr` install.
- Fixed the Linux launcher environment for Steam `libsteam_api.so` and `hw.so` loading.
- Changed the launcher default to Steam `-applaunch`, keeping direct `hl_linux` as a debug mode.
- Removed the forced `-soft` renderer flag after Steam launch worked without it.
- Changed Steam launch AppID from Half-Life `70` to Counter-Strike `10` so the CS HUD/client loads correctly.
- Corrected ReGameDLL validation docs to use the `game_version` cvar in the client console.
- Added clean reinstall support for the Steam `modcsbr` folder with copied CS client/HUD assets.
