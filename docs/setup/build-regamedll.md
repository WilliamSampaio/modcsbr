# Build ReGameDLL_CS On Windows

This document records the server GameDLL build path for `modcsbr`.

The supported runtime is Windows Xash3D FWGS, which loads `dlls/mp.dll` from the generated `runtime/xash3d/modcsbr` folder.

## Required Environment

- Operating system: Windows 11
- Toolchain: Visual Studio Build Tools / Visual Studio Installer with C++ tools
- Build system: MSBuild
- Platform: Win32/x86
- Output: `mp.dll`

## Build Steps

Open Developer PowerShell for Visual Studio and run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1
```

For source changes, keep the submodule checkout on the development branch instead of detached `HEAD`:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/dev/switch-modcsbr-branches.ps1
```

Expected repository output:

```text
mod/modcsbr/dlls/mp.dll
```

The Xash3D installer copies that file into:

```text
runtime/xash3d/modcsbr/dlls/mp.dll
```

## Validation

Validate the launch command without opening the game:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
```

Then launch:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

## Notes

- Keep the build Win32/x86 unless all loaded Xash3D game libraries are rebuilt together for another architecture.
- Keep custom ReGameDLL_CS changes in `upstream/ReGameDLL_CS` on the `modcsbr` branch.
- The old Steam/GoldSrc and Linux server-library validation paths have been removed from this project.
