# Agent Notes

## Project

This repository is for a Counter-Strike 1.6 / GoldSrc custom mod based on ReGameDLL_CS.

## Ground Rules

- Keep `upstream/ReGameDLL_CS` as third-party source.
- Do not modify upstream code until the original DLL has been built and documented.
- Prefer small, spec-driven changes under `specs/`.
- Use `Win32` for all GameDLL builds. Do not use `x64`.

## Important Paths

- ReGameDLL solution: `upstream/ReGameDLL_CS/msvc/ReGameDLL.sln`
- Build notes: `docs/setup/build-regamedll.md`
- Windows setup: `docs/setup/windows-11.md`
