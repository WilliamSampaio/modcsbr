# Agent Notes

## Project

This repository is for `modcsbr`, a Counter-Strike 1.6 / GoldSrc custom mod based on ReGameDLL_CS.

## Ground Rules

- Keep `upstream/ReGameDLL_CS` as third-party source.
- Do not modify upstream code until the original Linux `cs.so` has been built and documented.
- The `upstream/ReGameDLL_CS` submodule points to `https://github.com/WilliamSampaio/ReGameDLL_CS.git`; future mod-specific ReGameDLL changes should be committed to the `modcsbr` branch in that fork.
- Prefer small, spec-driven changes under `specs/`.
- Use 32-bit x86 for all GameDLL builds. Do not use x64 for Steam CS 1.6 / GoldSrc.
- Keep builds on the Linux ext4 filesystem. This machine's repo is expected at `/home/william/modcsbr` on `/dev/sdd`; avoid `/mnt/c` for C/C++ builds.
- Windows is supported as an editor/MSVC diagnostic environment from `C:\dev\modcsbr`; do not treat Windows `mp.dll` builds as the canonical Linux `cs.so` baseline.
- Every repository change must update the relevant project documentation in the same turn: `CHANGELOG.md`, `README.md`, docs under `docs/`, and `AGENTS.md` when agent instructions, paths, workflows, or rules change.

## Important Paths

- Linux setup: `docs/setup/linux.md`
- Windows setup: `docs/setup/windows-11.md`
- Build notes: `docs/setup/build-regamedll.md`
- ReGameDLL build script: `scripts/build/regamedll-linux.sh`
- Windows diagnostic build script: `scripts/build/regamedll-windows.ps1`
- Steam install script: `scripts/install/modcsbr-steam-linux.sh`
- Windows Steam install script: `scripts/install/modcsbr-steam-windows.ps1`
- Linux environment check: `scripts/test/check-linux-environment.sh`
- Windows environment check: `scripts/test/check-windows-environment.ps1`
- Launch test script: `scripts/test/launch-modcsbr-steam-linux.sh`
- Windows launch test script: `scripts/test/launch-modcsbr-steam-windows.ps1`
