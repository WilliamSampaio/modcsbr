# Linux Setup

This is the primary setup path for `modcsbr`.

## Host

Current target machine:

- Distribution: Ubuntu 24.04
- Steam path detected: `~/.steam/debian-installation`
- Half-Life / CS 1.6 path detected: `~/.steam/debian-installation/steamapps/common/Half-Life`
- Base CS folder: `cstrike`
- Mod folder: `modcsbr`

## Install Build Dependencies

Preview the required packages:

```bash
scripts/install/linux-build-deps-ubuntu.sh
```

Install them:

```bash
scripts/install/linux-build-deps-ubuntu.sh --install
```

The important part is 32-bit compilation support:

- `gcc-multilib`
- `g++-multilib`
- `libc6-dev-i386`

ReGameDLL_CS builds a 32-bit Linux GameDLL for GoldSrc.

## Build ReGameDLL_CS

```bash
scripts/build/regamedll-linux.sh
```

The script runs the upstream build and copies the resulting library to:

```text
mod/modcsbr/dlls/cs.so
```

Current machine note: the build cannot run until `cmake`, `gcc`, `g++`, `make`, and 32-bit multilib packages are installed. The dependency script is ready, but it needs an interactive `sudo` password.

## Install The Mod Into Steam CS 1.6

```bash
scripts/install/modcsbr-steam-linux.sh
```

By default, the script installs to:

```text
~/.steam/debian-installation/steamapps/common/Half-Life/modcsbr
```

Set a custom install location with:

```bash
HALF_LIFE_DIR="/path/to/Half-Life" scripts/install/modcsbr-steam-linux.sh
```

## Launch Test

```bash
scripts/test/launch-modcsbr-steam-linux.sh
```

The script starts:

```text
./hl_linux -steam -game modcsbr -console -dev +map de_dust2
```

Change the map with:

```bash
MAP=de_inferno scripts/test/launch-modcsbr-steam-linux.sh
```

## Validation

In the game console, run:

```text
game version
```

Expected result: the console prints the ReGameDLL_CS version, confirming that `modcsbr/dlls/cs.so` is loaded.
