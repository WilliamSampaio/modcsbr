# Build ReGameDLL_CS On Linux

This document records the baseline build of the original, unmodified ReGameDLL_CS.

## Required Environment

- Operating system: Ubuntu 24.04
- Toolchain: GCC/G++ with multilib
- Build system: CMake + Make
- Platform: Linux 32-bit x86
- Output: `cs.so`

Do not use x64 for Steam CS 1.6 / GoldSrc.

## Build Steps

1. Install dependencies:

   ```bash
   scripts/install/linux-build-deps-ubuntu.sh --install
   ```

2. Initialize the submodule:

   ```bash
   git submodule update --init --recursive
   ```

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

## Validation Log

- ReGameDLL_CS revision: `781a68ae1c6fb652cf4fbc894970b4fb4dde19f9`
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

Next validation step: launch Steam CS 1.6 with `modcsbr` and run `game version` in the console.
