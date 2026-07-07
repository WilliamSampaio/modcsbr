# Windows 11 C/C++ Development Setup

This project uses Visual Studio's MSVC toolchain for Windows builds and VS Code as the editor.

The supported runtime is Xash3D FWGS on Windows. Windows builds produce the server `mp.dll` from ReGameDLL_CS and the client `client.dll` from CS16Client.

## Goal

Configure Windows 11 so VS Code can:

- edit C/C++ with IntelliSense;
- find MSVC headers and libraries;
- run `cl.exe`;
- run `msbuild.exe`;
- run `cmake.exe`;
- run `python.exe`;
- build ReGameDLL_CS as `Release | Win32`;
- build CS16Client as `Release | Win32`;
- launch `modcsbr` through Xash3D FWGS.

The Windows server build produces `mod/modcsbr/dlls/mp.dll`.

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

Install Visual Studio Build Tools or Visual Studio Community with the Visual Studio Installer:

```text
https://visualstudio.microsoft.com/vs/community/
```

This project has been validated with Visual Studio Installer / Build Tools 18.x. Visual Studio 2022 Build Tools should also work when the same C++ components are installed.

In the installer, open `Workloads` and select:

```text
Desktop development with C++
```

The installer includes these baseline items with the workload:

- MSBuild tools;
- Visual Studio C++ redistributable update;
- core C++ desktop build resources.

In `Installation details`, make sure these optional components are selected:

- MSVC build tools for x64/x86, latest available version;
- Windows 11 SDK `10.0.26100.8249` or newer;
- C++ CMake tools for Windows;
- C++ test tools core features;
- MSVC AddressSanitizer;
- vcpkg package manager.

You do not need ATL, MFC, C++/CLI, Clang, or older MSVC toolsets unless a future upstream dependency explicitly requires them.

## 4. Install Python 3

CS16Client's CMake configure step requires a Python interpreter.

Install Python 3 from:

```text
https://www.python.org/downloads/windows/
```

During installation, enable:

```text
Add python.exe to PATH
py launcher
```

Open a new PowerShell and verify:

```powershell
python --version
```

Expected result:

```text
Python 3.x.x
```

This is also valid:

```powershell
py -3 --version
```

If Windows opens the Microsoft Store or resolves `python` to `WindowsApps\python.exe`, disable the Windows app execution aliases:

```text
Settings > Apps > Advanced app settings > App execution aliases
```

Turn off the aliases for:

```text
python.exe
python3.exe
```

## 5. Open Developer PowerShell

Open the Visual Studio developer shell from the Start Menu. Depending on the installed version it may be named like:

```text
Developer PowerShell for VS
Developer PowerShell for VS 2022
Developer PowerShell for VS 2026
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

Verify Python:

```powershell
python --version
```

Expected result: `Python 3.x.x`. If you installed only the Python launcher, verify `py -3 --version` instead.

## 6. Open This Project In VS Code

Still inside Developer PowerShell for Visual Studio, run:

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
python --version
```

## 7. Install Recommended VS Code Extensions

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

## 8. Check C/C++ IntelliSense

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

## 9. Optional Smoke Test

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

## 10. Build ReGameDLL_CS From VS Code

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

## 11. Build CS16Client From VS Code

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

The wrapper copies the newest `client.dll` and `menu.dll` into:

```text
mod\modcsbr\cl_dlls\client.dll
mod\modcsbr\cl_dlls\menu.dll
```

For a quick environment check:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/check-windows-environment.ps1
```

If PowerShell says the `.ps1` file is not digitally signed, keep using the commands above with `-ExecutionPolicy Bypass -File`. This bypass applies only to that process and does not change the machine-wide execution policy.

## 12. Install And Launch With Xash3D FWGS

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

The installer creates a local ignored runtime under `runtime\xash3d`. It copies Steam `valve` and `cstrike` assets, copies `steam_api.dll` to the runtime root, seeds `runtime\xash3d\modcsbr` from the full Steam `cstrike` folder, then overlays repository mod files and compiled DLLs.

The copied `runtime\xash3d\cstrike` folder is an asset base, not a supported launch target. Use `-game modcsbr`; stock `-game cstrike` can load the Steam CS client DLL directly and assert on missing Steam GameUI state under Xash3D.

Recreate the generated mod folder from scratch:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1 -Reset
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

## Troubleshooting

If `cl` is not found:

- close VS Code;
- open Developer PowerShell for Visual Studio;
- run `code .` from `C:\dev\modcsbr`.

If `msbuild` is not found:

- confirm Visual Studio C++ tools are installed;
- confirm MSBuild was selected in the Visual Studio Installer;
- reopen VS Code from Developer PowerShell for Visual Studio.

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
- reopen Developer PowerShell for Visual Studio.

If the CS16Client build reports that Python is missing:

- install Python 3 with `Add python.exe to PATH` or the Python launcher enabled;
- reopen Developer PowerShell for Visual Studio;
- verify `python --version` or `py -3 --version` prints `Python 3.x.x`;
- disable the Windows app execution aliases for `python.exe` and `python3.exe` if `python` resolves to `WindowsApps\python.exe`.

If `xash3d.exe` is not found:

- extract official Xash3D FWGS Windows binaries into `runtime\xash3d`;
- or set `XASH3D_DIR` to the engine directory.

If `runtime\xash3d\xash3d.exe -game cstrike` shows a Microsoft Visual C++ assertion for `g_hGameUIModule`, use the supported `modcsbr` launcher instead. The assertion comes from the stock Steam CS client DLL, while `modcsbr` uses CS16Client's `client.dll` and `menu.dll`.
