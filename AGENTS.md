# Agent Notes

## Project

This repository is for `modcsbr`, a Counter-Strike 1.6 / GoldSrc-family custom mod targeting Xash3D FWGS with CS16Client and ReGameDLL_CS.

## Ground Rules

- Keep `upstream/ReGameDLL_CS` as the server GameDLL submodule from `https://github.com/WilliamSampaio/ReGameDLL_CS.git`, tracking branch `modcsbr` for mod-specific work.
- Keep `upstream/cs16-client` as the client DLL submodule from `https://github.com/WilliamSampaio/cs16-client.git`, tracking branch `modcsbr` for mod-specific work.
- Treat `rehlds/ReGameDLL_CS` and `Velaron/cs16-client` as original upstream projects, not as the direct working remotes for this repo.
- Keep `runtime/xash3d` as a local, ignored working directory; do not commit downloaded engine/runtime binaries.
- Prefer small, spec-driven changes under `specs/`.
- Use 32-bit x86/Win32 for Windows client, server GameDLL, and Xash3D FWGS runtime compatibility unless all loaded game libraries are intentionally rebuilt for another architecture.
- Initial active runtime target is Windows Xash3D FWGS from `C:\dev\modcsbr`; keep the older Steam `hl.exe` scripts as legacy helpers.
- The initial engine plan uses official Xash3D FWGS binaries under `runtime/xash3d`; build the engine from source only when binaries are insufficient.
- Every repository change must update the relevant project documentation in the same turn: `CHANGELOG.md`, `README.md`, docs under `docs/`, and `AGENTS.md` when agent instructions, paths, workflows, or rules change.

## Important Paths

- Linux setup: `docs/setup/linux.md`
- Windows setup: `docs/setup/windows-11.md`
- Build notes: `docs/setup/build-regamedll.md`
- Xash3D FWGS Windows setup: `docs/setup/xash3d-windows.md`
- CS16Client build notes: `docs/setup/build-cs16-client.md`
- ReGameDLL build script: `scripts/build/regamedll-linux.sh`
- Windows ReGameDLL build script: `scripts/build/regamedll-windows.ps1`
- Windows CS16Client build script: `scripts/build/cs16-client-windows.ps1`
- Steam install script: `scripts/install/modcsbr-steam-linux.sh`
- Windows Steam install script: `scripts/install/modcsbr-steam-windows.ps1`
- Windows Xash3D install script: `scripts/install/modcsbr-xash3d-windows.ps1`
- Linux environment check: `scripts/test/check-linux-environment.sh`
- Windows environment check: `scripts/test/check-windows-environment.ps1`
- Launch test script: `scripts/test/launch-modcsbr-steam-linux.sh`
- Windows launch test script: `scripts/test/launch-modcsbr-steam-windows.ps1`
- Windows Xash3D launch script: `scripts/test/launch-modcsbr-xash3d-windows.ps1`
