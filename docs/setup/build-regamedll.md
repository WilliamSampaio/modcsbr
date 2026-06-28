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
- Build status: blocked until Linux build dependencies are installed
- Generated library: pending
- Build time: pending
- Problems encountered:
  - `cmake`, `gcc`, `g++`, and `make` are not currently available in PATH.
  - `scripts/install/linux-build-deps-ubuntu.sh --install` requires an interactive `sudo` password outside this Codex session.

Update this section after building and record the exact `cs.so` path produced by CMake.
