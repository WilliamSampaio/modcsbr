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

## WSL Performance

WSL is good for building `cs.so`, installing the mod, and confirming that Steam loads `modcsbr`.

It is not a good performance target for CS 1.6 gameplay. If the game console prints:

```text
GL_RENDERER: llvmpipe
```

the game is using Mesa software rendering on the CPU. Expect very low FPS, bad frame pacing, input lag, and unstable mouse behavior.

Use WSL only for smoke validation:

```text
modcsbr: client autoexec.cfg loaded
modcsbr: ReGameDLL game_init.cfg loaded
```

For real gameplay testing, use native Linux with GPU acceleration or Windows Steam.

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
steam -applaunch 70 -game modcsbr -console -dev
```

Use AppID `70` to validate the custom mod folder. It opens Half-Life while respecting `-game modcsbr`.

AppID `10` opens Counter-Strike 1.6 directly. In that mode Steam can load the `cstrike` context instead of the `modcsbr` folder, so it is not the main validation path for this project.

The script also sets `LD_LIBRARY_PATH` to the Half-Life folder and Steam Runtime i386 libraries so `hl_linux` can load `libsteam_api.so`, `hw.so`, and `libopenal.so.1`.

The launcher does not force a renderer. To test software rendering manually, pass `-soft`:

```bash
scripts/test/launch-modcsbr-steam-linux.sh -soft
```

The default launch method is through Steam. To debug the raw `hl_linux` binary:

```bash
MODCSBR_LAUNCH_METHOD=direct scripts/test/launch-modcsbr-steam-linux.sh
```

By default, the launcher opens the CS menu. Start a map through `New Game`; this initializes the CS client HUD correctly.

To start directly on a map:

```bash
MODCSBR_AUTO_MAP=1 MAP=de_inferno scripts/test/launch-modcsbr-steam-linux.sh
```

If the HUD is missing when using direct `+map`, use the menu `New Game` flow.

## Validation

When the game opens, the client console should show:

```text
modcsbr: client autoexec.cfg loaded
```

This confirms the game launched with the `modcsbr` folder.

If the console only says `execing autoexec.cfg` and does not show this marker, it probably executed another folder's `autoexec.cfg`. Check that the launcher is using AppID `70`.

Then start a map through `New Game`, open the console, and look for:

```text
modcsbr: ReGameDLL game_init.cfg loaded
```

Expected result: the line appears after the local server starts. This confirms that ReGameDLL executed `modcsbr/game_init.cfg`.

`game version` is a server command and `game_version` is a server cvar. In the Steam client console they may print `Unknown command`.
