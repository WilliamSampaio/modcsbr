# modcsbr

Custom Counter-Strike 1.6 / GoldSrc mod project based on ReGameDLL_CS.

## Goals

- Keep the original ReGameDLL_CS source isolated under `upstream/`.
- Build the unmodified Linux GameDLL first, validating the development environment before custom changes.
- Test through the Steam CS 1.6 installation on this Linux machine.
- Track custom gameplay changes through specs before implementation.

## Repository Layout

- `.github/workflows/` - future CI automation.
- `.vscode/` - local editor tasks and recommendations.
- `docs/` - setup, architecture, and research notes.
- `mod/modcsbr/` - mod assets and test layout.
- `scripts/` - build, install, and test helpers.
- `specs/` - feature specs grouped by status.
- `upstream/ReGameDLL_CS/` - ReGameDLL_CS submodule.

## Build Target

Primary target:

- OS: Linux
- Compiler: GCC
- Architecture: 32-bit x86
- Output: `cs.so`

Counter-Strike 1.6 / GoldSrc is a 32-bit ecosystem, so do not build the GameDLL as x64.

## Linux Quick Start

```bash
scripts/install/linux-build-deps-ubuntu.sh --install
scripts/build/regamedll-linux.sh
scripts/install/modcsbr-steam-linux.sh
scripts/test/launch-modcsbr-steam-linux.sh
```

See `docs/setup/linux.md` for the full workflow.
