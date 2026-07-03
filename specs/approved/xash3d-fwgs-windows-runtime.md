# Xash3D FWGS Windows Runtime

## Goal

Run `modcsbr` on Xash3D FWGS on Windows, with separate client and server builds.

## Player-Facing Behavior

Launching the project should open `modcsbr` through Xash3D FWGS:

```text
xash3d.exe -game modcsbr -console -dev
```

The runtime should load:

- CS16Client as the client DLL and menu DLL;
- ReGameDLL_CS as the server GameDLL;
- Steam-owned CS 1.6 assets from `valve` and `cstrike`.

## Technical Notes

- Use official Xash3D FWGS binaries first, placed under `runtime/xash3d` or a directory pointed to by `XASH3D_DIR`.
- Generate `runtime/xash3d/modcsbr` from the Steam `cstrike` asset base, then overlay repository mod files and compiled DLLs.
- Keep `upstream/cs16-client` as a client DLL submodule pointed at `https://github.com/WilliamSampaio/cs16-client.git`, tracking branch `modcsbr`.
- Keep `upstream/ReGameDLL_CS` as a server GameDLL submodule pointed at `https://github.com/WilliamSampaio/ReGameDLL_CS.git`, tracking branch `modcsbr`.
- Build Windows artifacts as Win32/x86:
  - `mod/modcsbr/cl_dlls/client.dll`;
  - `mod/modcsbr/cl_dlls/menu.dll`;
  - `mod/modcsbr/dlls/mp.dll`.
- Do not reintroduce Steam/GoldSrc install or launch workflows.

## Test Plan

1. Run `scripts/test/check-windows-environment.ps1`.
2. Build server with `scripts/build/regamedll-windows.ps1`.
3. Build client with `scripts/build/cs16-client-windows.ps1 -UpdateSubmodules`.
4. Install runtime with `scripts/install/modcsbr-xash3d-windows.ps1`.
5. Validate launch command with `scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch`.
6. Launch Xash3D FWGS with `scripts/test/launch-modcsbr-xash3d-windows.ps1`.
