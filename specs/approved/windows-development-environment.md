# Windows Development Environment

## Goal

Configure Windows 11 as a development and editor environment for `modcsbr` while keeping the canonical GameDLL build on Linux.

Windows should support:

- VS Code editing and navigation for the ReGameDLL_CS codebase;
- MSVC x86 IntelliSense;
- `cl.exe` and `msbuild.exe` smoke checks;
- optional upstream ReGameDLL_CS `Release | Win32` builds for local diagnostics.

Linux remains the required path for producing the project baseline `cs.so` used by Steam CS 1.6 / GoldSrc on Linux.

## Developer-Facing Behavior

A developer on Windows can:

- read `docs/setup/windows-11.md` as the setup guide;
- run `powershell -ExecutionPolicy Bypass -File scripts/test/check-windows-environment.ps1` from PowerShell to verify Git, VS Code, MSVC, MSBuild, and the upstream solution;
- run `powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1` from Developer PowerShell for VS 2022 to build the upstream MSVC solution as `Release | Win32`;
- run `powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-steam-windows.ps1` to install the mod into the Windows Steam Half-Life folder;
- run `powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-steam-windows.ps1` to launch Half-Life through Steam with `-game modcsbr`;
- use VS Code tasks for Windows check/build actions.

The Windows build produces the upstream Windows GameDLL artifact, normally `mp.dll`. It does not replace the Linux `cs.so` baseline and should not be copied into `mod/modcsbr/dlls`.

The Windows installer may copy that `mp.dll` into the installed Steam `Half-Life\modcsbr\dlls\mp.dll` path because `liblist.gam` points Windows GoldSrc to `dlls\mp.dll`.

By default, the installer also extracts and enables ReGameDLL_CS optional extras:

- zBot for CS 1.6, enabled with `bot_enable 1`;
- CS:CZ hostage AI for CS 1.6, enabled with `hostage_ai_enable 1`.

Users can suppress both with `-DisableReGameDLLExtras`, or suppress one with `-DisableZBot` / `-DisableHostageAI`.

## Technical Notes

- Keep `upstream/ReGameDLL_CS` third-party. Do not patch upstream project files for Windows setup.
- Use MSVC x86 / Win32. Do not use x64 for GoldSrc GameDLL work.
- The repository may be opened from `C:\dev\modcsbr` for Windows editor work.
- C/C++ builds that produce the Linux `cs.so` must still be performed from the Linux ext4 checkout, expected at `/home/william/modcsbr` on `/dev/sdd`.
- VS Code IntelliSense should use `windows-msvc-x86` when working from Windows.

## Test Plan

1. From Windows PowerShell:

   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts/test/check-windows-environment.ps1
   ```

2. From Developer PowerShell for VS 2022:

   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1
   ```

3. Confirm the script reports a Win32 build artifact under `upstream/ReGameDLL_CS`.
4. Install into Windows Steam:

   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-steam-windows.ps1
   ```

5. Launch through Windows Steam:

   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-steam-windows.ps1
   ```

6. Confirm Linux baseline remains documented and built with:

   ```bash
   scripts/build/regamedll-linux.sh
   ```
