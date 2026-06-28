# Agent Notes

## Project

This repository is for `modcsbr`, a Counter-Strike 1.6 / GoldSrc custom mod based on ReGameDLL_CS.

## Ground Rules

- Keep `upstream/ReGameDLL_CS` as third-party source.
- Do not modify upstream code until the original Linux `cs.so` has been built and documented.
- Prefer small, spec-driven changes under `specs/`.
- Use 32-bit x86 for all GameDLL builds. Do not use x64 for Steam CS 1.6 / GoldSrc.

## Important Paths

- Linux setup: `docs/setup/linux.md`
- Build notes: `docs/setup/build-regamedll.md`
- ReGameDLL build script: `scripts/build/regamedll-linux.sh`
- Steam install script: `scripts/install/modcsbr-steam-linux.sh`
- Launch test script: `scripts/test/launch-modcsbr-steam-linux.sh`
