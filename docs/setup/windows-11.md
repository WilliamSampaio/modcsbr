# Windows 11 C/C++ Development Setup

This project uses Visual Studio's MSVC toolchain for Windows builds and VS Code as the editor.

The active initial runtime is Xash3D FWGS on Windows. Windows builds produce the server `mp.dll` from ReGameDLL_CS and the client `client.dll` from CS16Client.

## Goal

Configure Windows 11 so VS Code can:

- edit C/C++ with IntelliSense;
- find MSVC headers and libraries;
- run `cl.exe`;
- run `msbuild.exe`;
- run `cmake.exe`;
- build ReGameDLL_CS as `Release | Win32`;
- build CS16Client as `Release | Win32`;
- launch `modcsbr` through Xash3D FWGS.

The Windows server build produces `mod/modcsbr/dlls/mp.dll`. The Linux `cs.so` path is retained only for legacy Steam tests.

## 1. Install Git

Install Git for Windows:

```text
https://git-scm.com/download/win
```

Open a new PowerShell and verify:

```powershell
git --version
```

## 2. Install VS Code

Install VS Code:

```text
https://code.visualstudio.com/
```

Verify the `code` command:

```powershell
code --version
```

If this command is not found, open VS Code and run:

```text
Ctrl+Shift+P > Shell Command: Install 'code' command in PATH
```

On Windows this may also be configured by reinstalling VS Code and enabling:

```text
Add to PATH
```

## 3. Install Visual Studio C++ Toolchain

Install Visual Studio 2022 Community or Visual Studio Build Tools:

```text
https://visualstudio.microsoft.com/vs/community/
```

In the installer, select this workload:

```text
Desktop development with C++
```

Make sure these components are selected:

- MSVC v143 C++ build tools;
- Windows 10/11 SDK;
- C++ CMake tools for Windows;
- MSBuild.

## 4. Open Developer PowerShell

Open this from the Start Menu:

```text
Developer PowerShell for VS 2022
```

This shell loads the MSVC environment variables needed by `cl.exe` and `msbuild.exe`.

Verify the compiler:

```powershell
cl
```

Expected result:

```text
Microsoft (R) C/C++ Optimizing Compiler
```

Verify MSBuild:

```powershell
msbuild -version
```

Expected result: a version number.

## 5. Open This Project In VS Code

Still inside `Developer PowerShell for VS 2022`, run:

```powershell
cd C:\dev\modcsbr
code .
```

Opening VS Code this way makes the integrated terminal inherit the MSVC environment.

In VS Code, open a terminal:

```text
Terminal > New Terminal
```

Verify again:

```powershell
cl
msbuild -version
```

## 6. Install Recommended VS Code Extensions

VS Code should detect `.vscode/extensions.json` and suggest the recommended extensions.

Install:

- C/C++ by Microsoft;
- CMake Tools by Microsoft;
- PowerShell by Microsoft;
- GitLens.

If the popup does not appear, open:

```text
Extensions > Filter > Recommended
```

## 7. Check C/C++ IntelliSense

The project already has `.vscode/settings.json` configured for:

```text
C++ standard = C++14
IntelliSense = windows-msvc-x86
```

This matches the ReGameDLL_CS Windows build target.

After `upstream/ReGameDLL_CS` is added, open a `.cpp` file from that folder and confirm:

- syntax highlighting works;
- right-click `Go to Definition` works;
- include errors are not shown for standard/MSVC headers.

## 8. Optional Smoke Test

Use this only to confirm the compiler is working outside ReGameDLL.

Create a temporary file outside the repo or delete it after testing:

```powershell
cd $env:TEMP
notepad hello.cpp
```

Use this content:

```cpp
#include <iostream>

int main()
{
    std::cout << "MSVC is working\n";
    return 0;
}
```

Compile:

```powershell
cl /EHsc hello.cpp
```

Run:

```powershell
.\hello.exe
```

Expected output:

```text
MSVC is working
```

## 9. Build ReGameDLL_CS From VS Code

After `upstream/ReGameDLL_CS` exists, run:

```powershell
git submodule sync --recursive
git submodule update --init --recursive
```

Then run:

```text
Terminal > Run Build Task
```

Select:

```text
ReGameDLL: build Windows Release Win32
```

The task builds:

```text
upstream\ReGameDLL_CS\msvc\ReGameDLL.sln
```

with:

```text
Configuration = Release
Platform = Win32
```

You can run the same build from Developer PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1
```

The wrapper copies the newest `mp.dll` into:

```text
mod\modcsbr\dlls\mp.dll
```

## 10. Build CS16Client From VS Code

Initialize the client submodule from the `WilliamSampaio/cs16-client` fork:

```powershell
git submodule sync --recursive
git submodule update --init --recursive
```

The submodule lives at `upstream\cs16-client` and tracks branch `modcsbr`.

Run:

```text
Terminal > Run Build Task
```

Select:

```text
CS16Client: build Windows Release Win32
```

Or run directly:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -UpdateSubmodules
```

`-UpdateSubmodules` fills the nested `upstream\cs16-client\3rdparty` dependencies required by CMake.

The wrapper copies the newest `client.dll` into:

```text
mod\modcsbr\cl_dlls\client.dll
```

For a quick environment check:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/check-windows-environment.ps1
```

If PowerShell says the `.ps1` file is not digitally signed, keep using the commands above with `-ExecutionPolicy Bypass -File`. This bypass applies only to that process and does not change the machine-wide execution policy.

## 11. Install And Launch With Xash3D FWGS

Put official Xash3D FWGS Windows binaries in:

```text
runtime\xash3d
```

The folder should contain:

```text
xash3d.exe
```

Install:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1
```

Validate the launch command without opening the game:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
```

Launch:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

Use a custom Xash3D path with:

```powershell
$env:XASH3D_DIR = "D:\Games\xash3d-fwgs"
```

Use a custom Steam Half-Life asset path with:

```powershell
$env:HALF_LIFE_DIR = "D:\SteamLibrary\steamapps\common\Half-Life"
```

See:

```text
docs/setup/xash3d-windows.md
docs/setup/build-cs16-client.md
```

## 12. Legacy Steam Install And Launch

After the Windows server build produces `mp.dll`, install the mod into the Steam Half-Life folder:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-steam-windows.ps1
```

By default, the installer also enables the ReGameDLL_CS optional extras documented upstream:

- zBot for CS 1.6;
- CS:CZ hostage AI for CS 1.6.

It extracts:

```text
upstream\ReGameDLL_CS\regamedll\extra\zBot\bot_profiles.zip
upstream\ReGameDLL_CS\regamedll\extra\HostageImprov\host_improv.zip
```

and adds this managed block to the installed `modcsbr\game_init.cfg`:

```text
bot_enable 1
hostage_ai_enable 1
```

Suppress both extras with:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-steam-windows.ps1 -DisableReGameDLLExtras
```

Suppress only one extra with `-DisableZBot` or `-DisableHostageAI`.

To copy every local file from `mod\modcsbr` into the installed Steam mod folder, run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-steam-windows.ps1 -FullModCopy
```

Use this when local mod assets under directories such as `models`, `resource`, `sound`, or `sprites` must replace the installed files. Directory copies are merged so base CS UI resources, including `resource\OptionsSubMultiplayer.res` for the Multiplayer crosshair selector, stay available.

The Windows installer also creates a local `modcsbr\cl_dlls\GameUI.dll` copy from `valve\cl_dlls\GameUI.dll` and patches its internal `cstrike` game-directory marker to `modcsbr`. This keeps the Multiplayer crosshair controls populated under `-game modcsbr` without modifying the original Valve file.

The installer detects Steam from the Windows registry and Steam library folders. It expects the Half-Life folder to contain:

```text
hl.exe
cstrike\
```

Launch through Steam:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-steam-windows.ps1
```

Validate the install and launch command without opening Steam:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-steam-windows.ps1 -NoLaunch
```

Reset, reinstall, and launch while preserving local `mod\modcsbr` assets:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-steam-windows.ps1 -Reset
```

Use `-Reset -NoFullModCopy` only when you want a clean install without local mod asset overlays.

Launch without installing the optional extras:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-steam-windows.ps1 -DisableReGameDLLExtras
```

Use a custom Half-Life path with:

```powershell
$env:HALF_LIFE_DIR = "D:\SteamLibrary\steamapps\common\Half-Life"
```

## Troubleshooting

If `cl` is not found:

- close VS Code;
- open `Developer PowerShell for VS 2022`;
- run `code .` from `C:\dev\modcsbr`.

If `msbuild` is not found:

- confirm Visual Studio C++ tools are installed;
- confirm MSBuild was selected in the Visual Studio Installer;
- reopen VS Code from `Developer PowerShell for VS 2022`.

If IntelliSense uses the wrong architecture:

- confirm `.vscode/settings.json` has `windows-msvc-x86`;
- reload VS Code with `Developer: Reload Window`.

If PowerShell blocks a script because it is not digitally signed:

- run it with `powershell -ExecutionPolicy Bypass -File <script-path>`;
- do not change the global execution policy just for this project.

If MSBuild reports `MSB8020` and asks for the Visual Studio 2010 `v100` toolset:

- use `scripts/build/regamedll-windows.ps1` instead of calling `msbuild` directly;
- the wrapper forces `VisualStudioVersion=17.0` and auto-detects an installed Win32 platform toolset such as `v145` or `v143` without changing upstream project files.

If MSBuild reports `MSB8020` for `v143` on Visual Studio Build Tools 18:

- keep using the wrapper; it should auto-detect `v145`;
- run `scripts/test/check-windows-environment.ps1` to confirm the toolchain path if the error persists.

If `cmake` is not found:

- install the Visual Studio "C++ CMake tools for Windows" component;
- reopen Developer PowerShell for VS 2022.

If `xash3d.exe` is not found:

- extract official Xash3D FWGS Windows binaries into `runtime\xash3d`;
- or set `XASH3D_DIR` to the engine directory.
