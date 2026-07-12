# Agent Notes

## Project

This repository is for `modcsbr`, a Counter-Strike 1.6 / GoldSrc-family custom mod targeting Xash3D FWGS with CS16Client and ReGameDLL_CS.

## Ground Rules

- Keep `upstream/ReGameDLL_CS` as the server GameDLL submodule from `https://github.com/WilliamSampaio/ReGameDLL_CS.git`, tracking branch `modcsbr` for mod-specific work.
- Keep `upstream/cs16-client` as the client DLL submodule from `https://github.com/WilliamSampaio/cs16-client.git`, tracking branch `modcsbr` for mod-specific work.
- Use `scripts/dev/switch-modcsbr-branches.ps1` to move editable submodule working trees from detached `HEAD` onto their `modcsbr` branches before committing.
- Treat `upstream/cs16-client/3rdparty/ReGameDLL_CS` as a nested CS16Client build dependency, not as the authoritative server GameDLL working tree for this repo.
- Treat `rehlds/ReGameDLL_CS` and `Velaron/cs16-client` as original upstream projects, not as the direct working remotes for this repo.
- Keep `runtime/xash3d` as a local, ignored working directory; do not commit downloaded engine/runtime binaries.
- Keep Steam-owned `valve`/`cstrike` assets and the generated full `runtime/xash3d/modcsbr` copy local and ignored; do not commit Valve/Counter-Strike assets.
- Prefer small, spec-driven changes under `specs/`.
- Use 32-bit x86/Win32 for Windows client, CS16Client menu DLL, server GameDLL, and Xash3D FWGS runtime compatibility unless all loaded game libraries are intentionally rebuilt for another architecture.
- Windows build docs should mention the Visual Studio Installer `Desktop development with C++` workload plus MSBuild, latest MSVC x64/x86 build tools, Windows 11 SDK, CMake tools, C++ test tools, MSVC AddressSanitizer, and vcpkg.
- Windows CS16Client build docs should also mention Python 3 as `python` in PATH or `py -3` because its CMake configure step requires a Python interpreter.
- Active runtime target is Windows Xash3D FWGS from `C:\dev\modcsbr`; do not reintroduce Steam/GoldSrc install or launch workflows.
- Do not use stock `-game cstrike` as a supported Xash3D smoke test; the copied Steam CS client DLL can assert on Steam GameUI state under Xash3D.
- The initial engine plan uses official Xash3D FWGS binaries under `runtime/xash3d`; build the engine from source only when binaries are insufficient.
- Keep CS16Client's `menu.dll` installed beside `client.dll` in `cl_dlls`; Xash3D FWGS MainUI expects that layout for `MenuFactory`.
- Generate the Xash3D `modcsbr` runtime folder by copying the Steam `cstrike` base first, then overlaying repository mod files and compiled DLLs.
- Ignore Windows Explorer metadata such as `Thumbs.db`; do not commit shell cache files as mod assets.
- Keep user-facing README/setup/architecture documentation available in English, Portuguese (Brazil), and Spanish, and keep the language links in `README.md` up to date.
- Every repository change must update the relevant project documentation in the same turn: `CHANGELOG.md`, `README.md`, docs under `docs/`, and `AGENTS.md` when agent instructions, paths, workflows, or rules change.

## Important Paths

- Windows setup: `docs/setup/windows-11.md`
- Windows setup, Portuguese: `docs/setup/windows-11.pt-BR.md`
- Windows setup, Spanish: `docs/setup/windows-11.es.md`
- Build notes: `docs/setup/build-regamedll.md`
- Xash3D FWGS Windows setup: `docs/setup/xash3d-windows.md`
- CS16Client build notes: `docs/setup/build-cs16-client.md`
- Windows ReGameDLL build script: `scripts/build/regamedll-windows.ps1`
- Windows CS16Client build script: `scripts/build/cs16-client-windows.ps1`
- Development submodule branch script: `scripts/dev/switch-modcsbr-branches.ps1`
- Windows Xash3D install script: `scripts/install/modcsbr-xash3d-windows.ps1`
- Windows environment check: `scripts/test/check-windows-environment.ps1`
- Windows Xash3D launch script: `scripts/test/launch-modcsbr-xash3d-windows.ps1`

## Gameplay Product Workflow

- For requests involving gameplay mechanics, game rules, characters,
  loadouts, weapons, economy, objectives, balance, player experience,
  or product identity, load the `game-product-designer` skill before
  proposing implementation.
- Product and gameplay changes must begin as a spec under `specs/backlog`.
- Do not move a gameplay spec to `specs/approved` without an explicit
  product decision.
- Treat `docs/product/product-vision.md` and
  `docs/product/design-pillars.md` as authoritative product guidance
  when those files exist.
