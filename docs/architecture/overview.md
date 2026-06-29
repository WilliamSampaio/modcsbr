# Architecture Overview

The project separates original third-party code from custom mod files.

## Upstream

`upstream/ReGameDLL_CS` contains the ReGameDLL_CS project as a Git submodule. The submodule URL points to the `WilliamSampaio/ReGameDLL_CS` fork so future mod-specific GameDLL work can happen on the fork's `modcsbr` branch while keeping the external source history separate.

The validated baseline is still the original unmodified ReGameDLL_CS revision recorded in `docs/setup/build-regamedll.md`. Keep custom edits out of the submodule until that baseline has been built, installed, and documented.

## Mod Files

`mod/modcsbr` is reserved for the local mod layout used during testing:

- `dlls/` - compiled GameDLL output copied for tests.
- `models/` - model assets.
- `sound/` - sound assets.
- `sprites/` - sprite assets.
- `resource/` - UI/resource files.
- `maps/` - map files.

The Steam test install lives outside the repository under the Half-Life folder:

```text
~/.steam/debian-installation/steamapps/common/Half-Life/modcsbr
```

The installed mod uses `modcsbr/liblist.gam`, loads `dlls/cs.so`, and falls back to the stock `cstrike` assets.

## Specs

Gameplay and feature changes should start as specs. Move specs through:

- `specs/backlog`
- `specs/approved`
- `specs/implementing`
- `specs/completed`
