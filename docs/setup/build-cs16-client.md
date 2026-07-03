# Build CS16Client On Windows

This document records the planned Windows build path for the `WilliamSampaio/cs16-client` fork.

## Required Environment

- Operating system: Windows 11
- Toolchain: Visual Studio 2022 or Build Tools with C++ support
- Build system: CMake
- Platform: Win32/x86
- Output: `client.dll`

## Source Layout

Initialize the submodule:

```powershell
git submodule sync --recursive
git submodule update --init --recursive
```

The submodule lives at:

```text
upstream/cs16-client
```

It points to:

```text
https://github.com/WilliamSampaio/cs16-client.git
```

and tracks branch `modcsbr`. The original upstream project is `https://github.com/Velaron/cs16-client`.

## Build Steps

Open Developer PowerShell for VS 2022 from `C:\dev\modcsbr` and run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -UpdateSubmodules
```

`-UpdateSubmodules` initializes the nested CS16Client dependencies under `upstream\cs16-client\3rdparty`, including YaPB, ReGameDLL_CS, MainUI, and MiniUTL.

If you prefer to update them manually:

```powershell
git -C upstream\cs16-client submodule update --init --recursive
```

The wrapper runs the equivalent of:

```powershell
cmake -A Win32 -S upstream\cs16-client -B build\windows\cs16-client
cmake --build build\windows\cs16-client --config Release
cmake --install build\windows\cs16-client --config Release --prefix build\windows\cs16-client-install
```

Then it copies the newest `client.dll` to:

```text
mod/modcsbr/cl_dlls/client.dll
```

## Custom Paths

Use explicit paths when testing another checkout or output folder:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 `
  -SourceDir D:\src\cs16-client `
  -BuildDir build\windows\cs16-client-test `
  -InstallDir build\windows\cs16-client-test-install
```

Skip copying into the mod source layout:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -NoInstallToMod
```

## Validation

After build, install and launch the Xash3D runtime:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

Expected installed runtime path:

```text
runtime/xash3d/modcsbr/cl_dlls/client.dll
```
