# Build CS16Client en Windows

Este documento registra la ruta de build en Windows para el fork `WilliamSampaio/cs16-client`.

## Ambiente Necesario

- Sistema operativo: Windows 11
- Toolchain: Visual Studio Build Tools / Visual Studio Installer con soporte C++
- Sistema de build: CMake
- Dependencia de script: Python 3 como `python` en PATH o por el launcher `py -3`
- Plataforma: Win32/x86
- Salida: `client.dll` y `menu.dll`

## Layout del Codigo

Inicializa el submodulo:

```powershell
git submodule sync --recursive
git submodule update --init --recursive
```

El submodulo vive en:

```text
upstream/cs16-client
```

Apunta a `https://github.com/WilliamSampaio/cs16-client.git` y sigue la branch `modcsbr`. El upstream original es `https://github.com/Velaron/cs16-client`.

Despues de inicializarlo, cambia el checkout editable de detached `HEAD` a la branch de desarrollo:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/dev/switch-modcsbr-branches.ps1
```

## Pasos de Build

Abre Developer PowerShell for Visual Studio en `C:\dev\modcsbr` y ejecuta:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -UpdateSubmodules
```

`-UpdateSubmodules` inicializa las dependencias anidadas en `upstream\cs16-client\3rdparty`, incluyendo YaPB, ReGameDLL_CS, MainUI y MiniUTL.

El checkout `upstream\cs16-client\3rdparty\ReGameDLL_CS` es parte del grafo de build de CS16Client. No es la GameDLL de servidor autoritativa de `modcsbr`; el trabajo de servidor debe quedar en el submodulo superior `upstream\ReGameDLL_CS`.

El wrapper ejecuta CMake, compila en Release y copia los `client.dll` y `menu.dll` mas nuevos a:

```text
mod/modcsbr/cl_dlls/client.dll
mod/modcsbr/cl_dlls/menu.dll
```

## Rutas Personalizadas

Usa rutas explicitas para probar otro checkout o carpeta de salida:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 `
  -SourceDir D:\src\cs16-client `
  -BuildDir build\windows\cs16-client-test `
  -InstallDir build\windows\cs16-client-test-install
```

Omite la copia al layout del mod:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -NoInstallToMod
```

## Validacion

Despues del build, instala y lanza el runtime Xash3D:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

Ruta esperada en el runtime instalado:

```text
runtime/xash3d/modcsbr/cl_dlls/client.dll
runtime/xash3d/modcsbr/cl_dlls/menu.dll
```

Si Xash3D muestra `Error: native object "MenuFactory" is unavailable`, reconstruye CS16Client y reinstala el runtime. Normalmente significa que falta `menu.dll` junto a `client.dll`.

Si CMake dice que falta Python, instala Python 3 y verifica:

```powershell
python --version
py -3 --version
```
