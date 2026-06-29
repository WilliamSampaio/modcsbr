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
- Preserved base CS `resource` UI files during local mod asset copies so the Multiplayer crosshair selector stays populated.
- Changed launch-script resets to preserve local mod assets by default, with explicit no-full-copy opt-outs.
