# Linux Setup

This is the primary setup path for `modcsbr`.

## Host

Current target machine:

- Distribution: Ubuntu 24.04
- Linux storage device: `/dev/sdd`
- Repository path: `/home/william/modcsbr`
- Steam path detected: `~/.steam/debian-installation`
- Half-Life / CS 1.6 path detected: `~/.steam/debian-installation/steamapps/common/Half-Life`
- Base CS folder: `cstrike`
- Mod folder: `modcsbr`

Keep the repository on the Linux `ext4` filesystem. Do not build from `/mnt/c`.

Check the environment with:

```bash
scripts/test/check-linux-environment.sh
```

The expected healthy result is:

```text
OK: repo is on the Linux filesystem.
OK: repo filesystem is on /dev/sdd.
OK: found hl_linux and cstrike.
```

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

Current machine status: dependencies are installed and the first Linux build succeeded, producing a 32-bit `cs.so`.

Rebuild is only needed after changing the GameDLL C++ code or when you want a fresh `cs.so`. HUD/crosshair/health/ammo issues are client-side and should be checked with a clean mod reinstall first.

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

## Reset And Reinstall The Mod

Close CS 1.6 first, then run:

```bash
MODCSBR_ASSET_MODE=copy scripts/install/modcsbr-steam-linux.sh --reset
```

This deletes the installed `modcsbr` folder and recreates it, copying client HUD files from `cstrike` instead of linking them.

You can also reset and launch in one command:

```bash
MODCSBR_ASSET_MODE=copy scripts/test/launch-modcsbr-steam-linux.sh --reset
```

## Launch Test

```bash
scripts/test/launch-modcsbr-steam-linux.sh
```

The script starts:

```text
steam -applaunch 10 -game modcsbr -console -dev +map de_dust2
```

Use AppID `10` for Counter-Strike 1.6. AppID `70` is Half-Life and can launch without the CS HUD/client context.

The script also sets `LD_LIBRARY_PATH` to the Half-Life folder and Steam Runtime i386 libraries so `hl_linux` can load `libsteam_api.so`, `hw.so`, and `libopenal.so.1`.

The launcher does not force a renderer. To test software rendering manually, pass `-soft`:

```bash
scripts/test/launch-modcsbr-steam-linux.sh -soft
```

The default launch method is through Steam. To debug the raw `hl_linux` binary:

```bash
MODCSBR_LAUNCH_METHOD=direct scripts/test/launch-modcsbr-steam-linux.sh
```

Change the map with:

```bash
MAP=de_inferno scripts/test/launch-modcsbr-steam-linux.sh
```

## Validation

In the game console, run:

```text
game_version
```

Expected result: the console prints the ReGameDLL_CS version, confirming that `modcsbr/dlls/cs.so` is loaded.

`game version` is a server command. In the Steam client console it may print `Unknown command: game`.
