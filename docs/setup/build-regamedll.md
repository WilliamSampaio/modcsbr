# Build ReGameDLL_CS

This document records the baseline build of the original, unmodified ReGameDLL_CS.

## Required Environment

- Operating system: Windows 11
- IDE/toolchain: Visual Studio 2022
- MSVC toolset: v143
- Platform: Win32 / x86
- Configuration: Release
- Solution: `upstream\ReGameDLL_CS\msvc\ReGameDLL.sln`

Do not use x64. Counter-Strike 1.6, HLDS, and the GoldSrc GameDLL are 32-bit.

## Build Steps

1. Initialize the submodule:

   ```powershell
   git submodule update --init --recursive
   ```

2. Open the solution:

   ```text
   upstream\ReGameDLL_CS\msvc\ReGameDLL.sln
   ```

3. Select:

   ```text
   Configuration: Release
   Platform: Win32
   ```

4. Run:

   ```text
   Build > Build Solution
   ```

## Validation Log

- ReGameDLL_CS revision: `781a68ae1c6fb652cf4fbc894970b4fb4dde19f9`
- Build status: pending local Windows validation
- Generated DLL: pending
- Build time: pending
- Problems encountered: pending

Update this section after building on Windows and record the exact `mp.dll` path produced by Visual Studio.
