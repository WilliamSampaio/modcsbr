# modcsbr

## Languages

- English: this file
- Portugues (Brasil): [README.pt-BR.md](README.pt-BR.md)
- Espanol: [README.es.md](README.es.md)

`modcsbr` is a Counter-Strike 1.6 / GoldSrc-family custom mod targeting Xash3D FWGS on Windows.

The project uses:

- Xash3D FWGS as the runtime engine;
- CS16Client as the client DLL and MainUI DLL;
- ReGameDLL_CS as the server GameDLL;
- legally owned Half-Life / Counter-Strike 1.6 Steam files as a local asset base.

The old Steam/GoldSrc launch workflow is not supported. The only supported runtime path is:

```text
runtime/xash3d/xash3d.exe -game modcsbr
```

Do not use `runtime/xash3d/xash3d.exe -game cstrike` as a project smoke test. The generated `runtime/xash3d/cstrike` folder is an asset base copied from Steam; its stock `cl_dlls/client.dll` can assert on Steam GameUI state when loaded directly by Xash3D.

## Status

This repository is being prepared for public collaboration. The current focus is getting a clean Windows Xash3D baseline before gameplay and asset changes grow.

Gameplay discovery has started with a non-approved backlog exploration of teams, free type composition, predefined kits without money or buying, and community-authored themed teams constrained by symmetric type contracts. The MVP uses four fixed initial types—Assault, Support, Marksman, and Breacher—without making four a permanent catalog limit. Weapon damage remains fixed; community content may choose magazine capacity up to the slot's ammo ceiling and may vary recoil and fire rate within server-validated ranges. Magazine capacity, total ammunition, reload behavior, reload timing, and animation remain separate parameters. For the MVP, reload timing is fixed by weapon category, based on CS 1.6 references, and enforced by the server; community assets must adapt to it rather than define it. Pump-action and semi-automatic shotguns follow the M3 and XM1014 shell-by-shell baselines, while fully automatic shotguns are out of scope. Team counts may differ by at most one active player, and reconnections obey current availability without reserving a previous slot. Backward compatibility with CS 1.6 maps and game modes is an initial product pillar, but legacy maps do not reactivate the economy. The current codebase supports up to 32 connected clients, while servers may configure fewer. This is a proposal for playtesting, not current game behavior.

Assault chooses one mutually exclusive Rifle or SMG variant, both with pistol, knife, one fragmentation grenade, and two flashbangs. Knife mechanics are global even when teams replace its presentation, and weapon damage always follows the server-validated category. A survivor may carry a collected weapon into the next round as a replacement for the same slot; it receives complete magazines only up to its own category ceiling, and changing type or variant restores the selected predefined kit.

Support uses one MVP kit: machine gun with a 250-round ceiling, pistol with a 45-round ceiling, knife, one flashbang, and one smoke. Its initial damage/reload baseline follows the M249, including a 4.7-second reload, and suppression remains emergent rather than an artificial opponent penalty.

Marksman chooses one mutually exclusive Bolt-action or Semi-auto variant. Bolt-action has a 50-round total ceiling; Semi-auto has a 90-round total ceiling and trades lower fixed damage for a higher fire rate. The initial global baselines are 75 damage and a 2.0-second reload for Bolt-action, and 70 damage and a 3.35-second reload for Semi-auto, using the Scout and SG-550 only as mechanical references rather than required weapon identities. Both ceilings include the inserted magazine, and both variants receive a pistol with a 45-round ceiling, knife, one flashbang, and one smoke. AWP-equivalent profiles and automatic target information remain out of scope.

Breacher chooses one mutually exclusive pump-action/M3 or semi-automatic/XM1014 variant. Both receive exactly 40 shells, a pistol with a 45-round ceiling, knife, two flashbangs, and one smoke; neither receives fragmentation grenades, an SMG, a breaching tool, or passive bonuses.

The first gameplay phase reuses CS 1.6 device/defusal modes, round lifecycle, legacy maps, classic reload, exact aggregate-ammo HUD, flashlight/night-vision systems, ground weapons, team-stacking checks, and bot objective logic. On reversible scenarios, the server swaps operational sides at halftime without changing team identity. Initial balance uses `mp_limitteams 1` with `mp_autoteambalance 0`. Individual magazines remain a second experimental phase. Community content may declare a normal or suppressed pistol only for Marksman, but the scenario applies the same mechanical profile to both teams. Every community-authored themed weapon must reference an approved global mechanical profile; compensated asymmetry may use different profiles within the same allowlist and power budget. The server's global profile allowlist applies uniformly to every supported legacy map and mode; scenarios cannot filter it or introduce new game modes.

## Legal Assets

This repository does not include Valve, Half-Life, Counter-Strike, Steam, or Xash3D runtime binaries/assets.

Contributors need their own legal Steam installation of Half-Life / Counter-Strike 1.6. The installer copies required local assets into ignored `runtime/` folders:

```text
runtime/xash3d/valve
runtime/xash3d/cstrike
runtime/xash3d/modcsbr
runtime/xash3d/steam_api.dll
```

Do not commit generated runtime files, engine binaries, or Valve/Counter-Strike assets.
Do not commit Windows metadata files such as `Thumbs.db`; they are local Explorer caches, not mod assets.

## Requirements

- Windows 11.
- Git for Windows.
- VS Code.
- Visual Studio Build Tools / Visual Studio Installer with the `Desktop development with C++` workload.
- CMake from the Visual Studio C++ workload.
- Python 3 available as `python` in PATH, or through the Python launcher as `py -3`.
- Official Xash3D FWGS Windows binaries extracted into `runtime/xash3d`.
- Steam Half-Life / Counter-Strike 1.6 installed locally.

Visual Studio Installer components used for this project:

- Workload: `Desktop development with C++`.
- MSBuild tools.
- MSVC build tools for x64/x86.
- Windows 11 SDK `10.0.26100.8249` or newer.
- C++ CMake tools for Windows.
- C++ test tools core features.
- MSVC AddressSanitizer.
- vcpkg package manager.

See [docs/setup/windows-11.md](docs/setup/windows-11.md) for installer details and verification commands.

## Quick Start

Clone and initialize submodules:

```powershell
git submodule sync --recursive
git submodule update --init --recursive
```

Put the primary development submodules on their `modcsbr` branches before editing them:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/dev/switch-modcsbr-branches.ps1
```

Use `-IncludeMainUI` as well after the nested `mainui_cpp` submodule is forked and has a `modcsbr` branch.

If Steam Half-Life is not in the default location, point the scripts at the folder that contains `valve`, `cstrike`, and `steam_api.dll`:

```powershell
$env:HALF_LIFE_DIR = "D:\SteamLibrary\steamapps\common\Half-Life"
```

Build the server GameDLL:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1
```

Build the client and menu DLLs:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -UpdateSubmodules
```

Install the local Xash3D runtime:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1 -Reset
```

Validate the launch command:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
```

Launch:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

In the main menu, use `New Game` to create a local match. That screen lets you select a map, set max players, and set the bot count.
The mod ReGameDLL default plus startup and server configs enable `mp_flashlight`, so the normal flashlight command (`impulse 100`, usually bound to `F`) works in local matches.

## Runtime Layout

The installer generates a local ignored runtime:

```text
runtime/xash3d/
  xash3d.exe
  valve/
  cstrike/
  steam_api.dll
  modcsbr/
    base copied from cstrike
    files overlaid from mod/modcsbr
    resource/mainui_english.txt
    resource/modcsbr_english.txt
    cl_dlls/client.dll
    cl_dlls/menu.dll
    dlls/mp.dll
```

`menu.dll` must stay beside `client.dll`; Xash3D FWGS MainUI expects that layout for `MenuFactory`.
The mod-owned localization files are intentionally small placeholder dictionaries. They silence CS16Client/MainUI missing-file warnings without committing Valve-owned text resources.

## Repository Layout

```text
mod/modcsbr/                  source mod overlay
runtime/xash3d/               local ignored runtime
scripts/build/                Windows build wrappers
scripts/install/              Xash3D runtime installer
scripts/test/                 environment and launch checks
upstream/ReGameDLL_CS/        server GameDLL submodule
upstream/cs16-client/         client DLL submodule with nested 3rdparty build dependencies
docs/                         setup and architecture notes
specs/                        spec-driven planning
```

The nested `upstream/cs16-client/3rdparty/ReGameDLL_CS` checkout belongs to the CS16Client build. Server GameDLL work for `modcsbr` should stay in the top-level `upstream/ReGameDLL_CS` submodule.

## Documentation

- Windows setup:
  [English](docs/setup/windows-11.md) |
  [Portugues](docs/setup/windows-11.pt-BR.md) |
  [Espanol](docs/setup/windows-11.es.md)
- Xash3D FWGS runtime:
  [English](docs/setup/xash3d-windows.md) |
  [Portugues](docs/setup/xash3d-windows.pt-BR.md) |
  [Espanol](docs/setup/xash3d-windows.es.md)
- Build ReGameDLL_CS:
  [English](docs/setup/build-regamedll.md) |
  [Portugues](docs/setup/build-regamedll.pt-BR.md) |
  [Espanol](docs/setup/build-regamedll.es.md)
- Build CS16Client:
  [English](docs/setup/build-cs16-client.md) |
  [Portugues](docs/setup/build-cs16-client.pt-BR.md) |
  [Espanol](docs/setup/build-cs16-client.es.md)
- Architecture overview:
  [English](docs/architecture/overview.md) |
  [Portugues](docs/architecture/overview.pt-BR.md) |
  [Espanol](docs/architecture/overview.es.md)
- Product direction (Portuguese):
  [Vision](docs/product/product-vision.md) |
  [Design pillars](docs/product/design-pillars.md)
- [Backlog gameplay exploration: teams, player types, and predefined kits](specs/backlog/teams-player-types-and-predefined-kits.md) (Portuguese; not approved)
- [Approved runtime spec](specs/approved/xash3d-fwgs-windows-runtime.md)

## Contributing

Keep changes small and document behavior in `specs/` before large feature work. Do not commit generated runtime files or third-party proprietary assets.

Before opening a pull request, run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/check-windows-environment.ps1
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
```

When touching build, install, launch, paths, or workflow behavior, update the relevant docs in the same change.

## Troubleshooting

If Xash3D cannot find `gfx.wad`, set `HALF_LIFE_DIR` and reinstall the runtime.

If Xash3D reports `MenuFactory` is unavailable, rebuild CS16Client and confirm:

```powershell
Test-Path runtime\xash3d\modcsbr\cl_dlls\menu.dll
```

If launching `runtime\xash3d\xash3d.exe -game cstrike` opens a Microsoft Visual C++ assertion dialog for `g_hGameUIModule`, switch back to the supported mod launch path:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

If `cl`, `msbuild`, or `cmake` are missing, reopen the project from Developer PowerShell and confirm the Visual Studio Installer components listed above are installed.

If the CS16Client build reports that Python is missing, install Python 3 with `Add python.exe to PATH` or the Python launcher enabled. If `python --version` points at `WindowsApps\python.exe` or opens the Microsoft Store, disable the Windows app execution aliases for `python.exe` and `python3.exe`.
