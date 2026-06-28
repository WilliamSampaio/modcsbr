# Architecture Overview

The project separates original third-party code from custom mod files.

## Upstream

`upstream/ReGameDLL_CS` contains the original ReGameDLL_CS project as a Git submodule. This keeps the external source history separate and makes future upstream updates easier to review.

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
