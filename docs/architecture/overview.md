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

The current teams, free type composition, maximum one-player difference between active teams, and team-specific player-type alias proposal is documented in [`specs/backlog/teams-player-types-and-predefined-kits.md`](../../specs/backlog/teams-player-types-and-predefined-kits.md). The server is intended to validate team availability for joins, switches, and reconnections; reconnecting does not reserve the previous team slot. The current ReGameDLL_CS and CS16Client code uses a 32-client maximum, while an individual server may configure fewer. The proposal remains unapproved and does not describe implemented gameplay.

Backward compatibility with CS 1.6 maps and game modes is an initial product pillar. Future gameplay work should preserve legacy spawn/objective entity handling and should not require recompiling legacy maps merely to load and complete a round. Internal legacy side identifiers may remain as a compatibility layer even when the player-facing teams use different names.

The current product direction removes money and buying: the server grants a predefined kit at spawn. Community-authored teams may map themed weapons and presentation onto global type contracts. Damage remains fixed by the global weapon profile. Magazine capacity may be configured from 1 through the slot's ammo ceiling; recoil and fire rate may vary within server-validated ranges and valid combinations. The server must validate the complete package before accepting it. Loading a legacy map does not restore the classic economy.

Extreme magazine capacities are valid thematic choices, such as a one-shot crossbow, but the declared value remains independent from the visual asset and must stay within the slot ceiling. Models, animations, sounds, and HUD should communicate the accepted behavior consistently.
