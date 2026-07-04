# Setup de Desarrollo C/C++ en Windows 11

Este proyecto usa la toolchain MSVC de Visual Studio para builds Windows y VS Code como editor.

El runtime soportado es Xash3D FWGS en Windows. Los builds Windows producen `mp.dll` desde ReGameDLL_CS y `client.dll`/`menu.dll` desde CS16Client.

## Objetivo

Configurar Windows 11 para que VS Code pueda:

- editar C/C++ con IntelliSense;
- encontrar headers y bibliotecas MSVC;
- ejecutar `cl.exe`;
- ejecutar `msbuild.exe`;
- ejecutar `cmake.exe`;
- ejecutar `python.exe`;
- compilar ReGameDLL_CS como `Release | Win32`;
- compilar CS16Client como `Release | Win32`;
- ejecutar `modcsbr` por Xash3D FWGS.

## 1. Instala Git

Instala Git for Windows:

```text
https://git-scm.com/download/win
```

Verifica:

```powershell
git --version
```

## 2. Instala VS Code

Instala VS Code:

```text
https://code.visualstudio.com/
```

Verifica:

```powershell
code --version
```

Si el comando no existe, reinstala marcando `Add to PATH` o usa en VS Code:

```text
Ctrl+Shift+P > Shell Command: Install 'code' command in PATH
```

## 3. Instala la Toolchain C++ de Visual Studio

Instala Visual Studio Build Tools o Visual Studio Community:

```text
https://visualstudio.microsoft.com/vs/community/
```

Este proyecto fue validado con Visual Studio Installer / Build Tools 18.x. Visual Studio 2022 Build Tools tambien deberia funcionar con los mismos componentes C++.

En el instalador, selecciona el workload:

```text
Desktop development with C++
```

En `Installation details`, confirma los componentes opcionales:

- MSVC build tools para x64/x86, version mas nueva disponible;
- Windows 11 SDK `10.0.26100.8249` o mas nuevo;
- C++ CMake tools for Windows;
- C++ test tools core features;
- MSVC AddressSanitizer;
- vcpkg package manager.

ATL, MFC, C++/CLI, Clang y toolsets MSVC antiguos no son necesarios salvo que una dependencia futura los exija.

## 4. Instala Python 3

El configure de CS16Client por CMake necesita un interprete Python.

Instala Python 3:

```text
https://www.python.org/downloads/windows/
```

Durante la instalacion, habilita:

```text
Add python.exe to PATH
py launcher
```

Verifica en un nuevo PowerShell:

```powershell
python --version
py -3 --version
```

Si Windows abre Microsoft Store o resuelve `python` a `WindowsApps\python.exe`, desactiva los aliases:

```text
Settings > Apps > Advanced app settings > App execution aliases
```

Desactiva `python.exe` y `python3.exe`.

## 5. Abre Developer PowerShell

Abre desde el menu inicio:

```text
Developer PowerShell for VS
Developer PowerShell for VS 2022
Developer PowerShell for VS 2026
```

Ese shell carga variables MSVC necesarias para `cl.exe` y `msbuild.exe`.

Verifica:

```powershell
cl
msbuild -version
python --version
```

## 6. Abre el Proyecto en VS Code

Todavia en Developer PowerShell:

```powershell
cd C:\dev\modcsbr
code .
```

Abrir VS Code asi hace que el terminal integrado herede el ambiente MSVC.

En el terminal de VS Code, verifica de nuevo:

```powershell
cl
msbuild -version
python --version
```

## 7. Instala Extensiones Recomendadas

VS Code deberia detectar `.vscode/extensions.json`.

Instala:

- C/C++ by Microsoft;
- CMake Tools by Microsoft;
- PowerShell by Microsoft;
- GitLens.

## 8. Inicializa Submodulos

```powershell
git submodule sync --recursive
git submodule update --init --recursive
```

Antes de editar submodulos principales, cambialos a las branches `modcsbr`:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/dev/switch-modcsbr-branches.ps1
```

## 9. Build ReGameDLL_CS

Desde VS Code, usa:

```text
Terminal > Run Build Task
```

Selecciona:

```text
ReGameDLL: build Windows Release Win32
```

O ejecuta directamente:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1
```

Salida:

```text
mod\modcsbr\dlls\mp.dll
```

## 10. Build CS16Client

Desde VS Code, selecciona:

```text
CS16Client: build Windows Release Win32
```

O ejecuta directamente:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -UpdateSubmodules
```

Salidas:

```text
mod\modcsbr\cl_dlls\client.dll
mod\modcsbr\cl_dlls\menu.dll
```

## 11. Instala y Ejecuta con Xash3D FWGS

Coloca los binarios oficiales Windows de Xash3D FWGS en:

```text
runtime\xash3d
```

La carpeta debe contener:

```text
xash3d.exe
```

Instala:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1
```

Recrea la carpeta generada del mod:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1 -Reset
```

Valida sin abrir el juego:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
```

Lanza:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

Usa rutas personalizadas si hace falta:

```powershell
$env:XASH3D_DIR = "D:\Games\xash3d-fwgs"
$env:HALF_LIFE_DIR = "D:\SteamLibrary\steamapps\common\Half-Life"
```

## Troubleshooting

Si `cl` no se encuentra, cierra VS Code, abre Developer PowerShell for Visual Studio y ejecuta `code .` desde `C:\dev\modcsbr`.

Si `msbuild` no se encuentra, confirma que las herramientas C++ y MSBuild fueron seleccionadas en Visual Studio Installer.

Si `cmake` no se encuentra, instala el componente `C++ CMake tools for Windows`.

Si CS16Client dice que falta Python, instala Python 3, reabre Developer PowerShell y verifica `python --version` o `py -3 --version`.

Si `xash3d.exe` no se encuentra, extrae los binarios oficiales de Xash3D FWGS en `runtime\xash3d` o define `XASH3D_DIR`.

Si `runtime\xash3d\xash3d.exe -game cstrike` muestra una asercion Microsoft Visual C++ para `g_hGameUIModule`, usa el launcher soportado de `modcsbr`. La asercion viene de la DLL cliente stock de Steam CS; `modcsbr` usa `client.dll` y `menu.dll` de CS16Client.
