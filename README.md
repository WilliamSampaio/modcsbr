# modcsbr

Custom Counter-Strike 1.6 / GoldSrc mod project based on ReGameDLL_CS.

## Goals

- Keep the original ReGameDLL_CS source isolated under `upstream/`.
- Build the unmodified GameDLL first, validating the development environment before custom changes.
- Track custom gameplay changes through specs before implementation.

## Repository Layout

- `.github/workflows/` - future CI automation.
- `.vscode/` - local editor tasks and recommendations.
- `docs/` - setup, architecture, and research notes.
- `mod/mycs/` - mod assets and test layout.
- `scripts/` - build, install, and test helpers.
- `specs/` - feature specs grouped by status.
- `upstream/ReGameDLL_CS/` - ReGameDLL_CS submodule.

## Build Target

Use Visual Studio 2022 with MSVC v143:

- Configuration: `Release`
- Platform: `Win32`

Counter-Strike 1.6 / GoldSrc is a 32-bit ecosystem, so do not build the GameDLL as x64.
