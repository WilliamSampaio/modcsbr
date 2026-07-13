# Architecture Overview

The project separates original third-party code, ignored local runtime trees, and custom mod files.

## Upstream

`upstream/ReGameDLL_CS` contains the ReGameDLL_CS project as a Git submodule. The submodule URL points to `WilliamSampaio/ReGameDLL_CS` and tracks branch `modcsbr`, where mod-specific server GameDLL work should live.

Keep custom edits in this submodule on the `modcsbr` branch after the Windows Xash3D FWGS baseline has been built, installed, and documented.

`upstream/cs16-client` contains the CS16Client project as a Git submodule. The submodule URL points to `WilliamSampaio/cs16-client` and tracks branch `modcsbr`, where mod-specific client DLL work should live.

CS16Client has its own nested dependencies under `upstream/cs16-client/3rdparty`, including a nested `ReGameDLL_CS` checkout. That nested checkout exists for CS16Client's build graph and shared interfaces. It is not the authoritative server GameDLL tree for this repository; use the top-level `upstream/ReGameDLL_CS` submodule for `mp.dll` work.

`runtime/xash3d` is an ignored local runtime containing official Xash3D FWGS binaries, Steam-owned base assets, and the installed `modcsbr` folder. The installed `modcsbr` folder is generated from a local copy of Steam `cstrike` assets with repository mod files and compiled DLLs applied on top.

## Mod Files

`mod/modcsbr` is reserved for the source mod layout copied into the Xash3D runtime:

- `cl_dlls/` - compiled CS16Client output copied as `client.dll` and `menu.dll`.
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

The Xash3D install uses `modcsbr/liblist.gam`, loads `cl_dlls/client.dll`, `cl_dlls/menu.dll`, and `dlls/mp.dll`, and carries a complete local `cstrike` asset base inside the ignored runtime mod folder.

## Specs

Gameplay and feature changes should start as specs. Move specs through:

- `specs/backlog`
- `specs/approved`
- `specs/implementing`
- `specs/completed`

The current factions, tactical roles, predefined kits, economy, and magazine proposal is documented in [`specs/backlog/factions-roles-and-predefined-kits.md`](../../specs/backlog/factions-roles-and-predefined-kits.md). It is product discovery only, remains unapproved, and does not describe implemented architecture.
