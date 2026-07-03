# Windows Development Environment

## Goal

Configure Windows 11 as the development, build, install, and launch environment for `modcsbr`.

The supported runtime is Xash3D FWGS under `runtime/xash3d`. The old Steam/GoldSrc install and launch workflow has been removed.

## Developer-Facing Behavior

A developer on Windows can:

- read `docs/setup/windows-11.md` as the setup guide;
- run `powershell -ExecutionPolicy Bypass -File scripts/test/check-windows-environment.ps1`;
- run `powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1`;
- run `powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -UpdateSubmodules`;
- run `powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1`;
- run `powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1`;
- use VS Code tasks for the same Windows check/build/install/launch actions.

## Technical Notes

- Use MSVC x86 / Win32 for all loaded game libraries.
- Build ReGameDLL_CS as `mod/modcsbr/dlls/mp.dll`.
- Build CS16Client as `mod/modcsbr/cl_dlls/client.dll` and `mod/modcsbr/cl_dlls/menu.dll`.
- Generate `runtime/xash3d/modcsbr` from the Steam `cstrike` base, then overlay repository mod files and compiled DLLs.
- Keep Steam-owned assets and runtime binaries under ignored `runtime/`; do not commit them.

## Test Plan

1. Check the Windows environment:

   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts/test/check-windows-environment.ps1
   ```

2. Build server:

   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1
   ```

3. Build client:

   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -UpdateSubmodules
   ```

4. Install Xash3D runtime:

   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1
   ```

5. Validate launch command:

   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
   ```

6. Launch:

   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
   ```
