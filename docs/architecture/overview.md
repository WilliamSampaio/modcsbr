# Architecture Overview

The project separates original third-party code, ignored local runtime trees, and custom mod files.

## Upstream

`upstream/ReGameDLL_CS` contains the ReGameDLL_CS project as a Git submodule. The submodule URL points to `WilliamSampaio/ReGameDLL_CS` and tracks branch `modcsbr`, where mod-specific server GameDLL work should live.

The historical Linux baseline is recorded in `docs/setup/build-regamedll.md`. Keep custom edits out of the submodule until the Windows Xash3D FWGS baseline has been built, installed, and documented.

`upstream/cs16-client` contains the CS16Client project as a Git submodule. The submodule URL points to `WilliamSampaio/cs16-client` and tracks branch `modcsbr`, where mod-specific client DLL work should live.

`runtime/xash3d` is an ignored local runtime containing official Xash3D FWGS binaries, Steam-owned base assets, and the installed `modcsbr` folder.

## Mod Files

`mod/modcsbr` is reserved for the source mod layout copied into the Xash3D runtime:

- `cl_dlls/` - compiled CS16Client output copied as `client.dll`.
- `dlls/` - compiled GameDLL output copied for tests.
- `models/` - model assets.
- `sound/` - sound assets.
- `sprites/` - sprite assets.
- `resource/` - UI/resource files.
- `maps/` - map files.

The active Windows runtime install lives under:

```text
runtime/xash3d/modcsbr
```

The legacy Steam test install lives outside the repository under the Half-Life folder:

```text
~/.steam/debian-installation/steamapps/common/Half-Life/modcsbr
```

The Xash3D install uses `modcsbr/liblist.gam`, loads `cl_dlls/client.dll` and `dlls/mp.dll`, and falls back to the stock `cstrike` assets.

## Specs

Gameplay and feature changes should start as specs. Move specs through:

- `specs/backlog`
- `specs/approved`
- `specs/implementing`
- `specs/completed`
