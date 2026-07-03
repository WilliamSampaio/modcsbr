# Build ReGameDLL_CS

This document records the server GameDLL build path for the original, unmodified ReGameDLL_CS.

The active initial runtime is Windows Xash3D FWGS, which uses `mp.dll`. The Linux `cs.so` baseline remains documented below as a legacy Steam/GoldSrc validation path.

## Windows Xash3D FWGS Build

### Required Environment

- Operating system: Windows 11
- Toolchain: Visual Studio 2022 or Build Tools
- Build system: MSBuild
- Platform: Win32/x86
- Output: `mp.dll`

### Build Steps

Open Developer PowerShell for VS 2022 and run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1
```

Expected repository output:

```text
mod/modcsbr/dlls/mp.dll
```

The Xash3D installer copies that file into:

```text
runtime/xash3d/modcsbr/dlls/mp.dll
```

### Validation

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
```

Then launch:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

## Linux Legacy Build

### Required Environment

- Operating system: Ubuntu 24.04
- Toolchain: GCC/G++ with multilib
- Build system: CMake + Make
- Platform: Linux 32-bit x86
- Output: `cs.so`

Do not use x64 for Steam CS 1.6 / GoldSrc.

### Build Steps

1. Install dependencies:

   ```bash
   scripts/install/linux-build-deps-ubuntu.sh --install
   ```

2. Initialize the submodule:

   ```bash
   git submodule sync --recursive
   git submodule update --init --recursive
   ```

   The submodule is sourced from `https://github.com/WilliamSampaio/ReGameDLL_CS.git` and tracks branch `modcsbr`. Keep the recorded baseline revision documented before making mod-specific ReGameDLL changes.

3. Build:

   ```bash
   scripts/build/regamedll-linux.sh
   ```

4. Install into the Steam CS 1.6 folder:

   ```bash
   scripts/install/modcsbr-steam-linux.sh
   ```

5. Launch:

   ```bash
   scripts/test/launch-modcsbr-steam-linux.sh
   ```

### Validation Log

- ReGameDLL_CS revision: `781a68ae1c6fb652cf4fbc894970b4fb4dde19f9`
- Submodule source: `https://github.com/WilliamSampaio/ReGameDLL_CS.git`
- Original upstream project: `https://github.com/rehlds/ReGameDLL_CS.git`
- Future mod branch: `modcsbr`
- Build status: successful on Linux
- Generated library: `upstream/ReGameDLL_CS/build/regamedll/cs.so`
- Repository copy: `mod/modcsbr/dlls/cs.so`
- Steam install copy: `~/.steam/debian-installation/steamapps/common/Half-Life/modcsbr/dlls/cs.so`
- Binary check: `ELF 32-bit LSB shared object, Intel 80386`
- Build time: about 64 seconds on the first local build
- Problems encountered:
  - GCC 13.3 emits upstream warnings such as `-Woverloaded-virtual` and `-Wmaybe-uninitialized`.
  - Linker emits a `DT_TEXTREL` warning.
  - No build-stopping errors encountered.
- Launch notes:
  - Direct `hl_linux` launch needed explicit library paths for `libsteam_api.so`, `hw.so`, and Steam Runtime i386 `libopenal.so.1`.
  - Direct `hl_linux` still crashed in this WSLg environment, and the same crash reproduced with stock `cstrike`.
  - The project launcher now defaults to `steam -applaunch 70 -game modcsbr`.
  - Steam launch worked without forcing `-soft`; use `-soft` only as a manual fallback argument.
  - AppID `70` is required to validate that Steam respected `-game modcsbr`; AppID `10` can open the Counter-Strike context instead of the custom mod folder.
  - Starting a map from the CS `New Game` menu initializes the HUD correctly; direct `+map` launch is optional via `MODCSBR_AUTO_MAP=1`.

Next validation step: launch Steam Half-Life with `-game modcsbr`, confirm `modcsbr: client autoexec.cfg loaded`, start a map through `New Game`, and look for `modcsbr: ReGameDLL game_init.cfg loaded` in the console.

If the GameDLL is already built and only the HUD is missing, do not rebuild first. Reset the installed mod with copied assets:

```bash
MODCSBR_ASSET_MODE=copy scripts/install/modcsbr-steam-linux.sh --reset
```

Installers enable ReGameDLL_CS optional extras by default:

- zBot for CS 1.6;
- CS:CZ hostage AI for CS 1.6.

Use `--no-regamedll-extras` on Linux or `-DisableReGameDLLExtras` on Windows to suppress both during install/launch.
