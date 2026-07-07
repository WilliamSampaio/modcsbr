# Build ReGameDLL_CS en Windows

Este documento registra la ruta de build de la GameDLL del servidor para `modcsbr`.

El runtime soportado es Windows Xash3D FWGS, que carga `dlls/mp.dll` desde la carpeta generada `runtime/xash3d/modcsbr`.

## Ambiente Necesario

- Sistema operativo: Windows 11
- Toolchain: Visual Studio Build Tools / Visual Studio Installer con herramientas C++
- Sistema de build: MSBuild
- Plataforma: Win32/x86
- Salida: `mp.dll`

## Pasos de Build

Abre Developer PowerShell for Visual Studio y ejecuta:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1
```

Para cambios de codigo, manten el submodulo en la branch de desarrollo en vez de detached `HEAD`:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/dev/switch-modcsbr-branches.ps1
```

Salida esperada en el repositorio:

```text
mod/modcsbr/dlls/mp.dll
```

El instalador de Xash3D copia ese archivo a:

```text
runtime/xash3d/modcsbr/dlls/mp.dll
```

## Validacion

Valida el comando de launch sin abrir el juego:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
```

Luego lanza:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

## Notas

- Manten el build en Win32/x86, salvo que todas las bibliotecas cargadas por Xash3D se reconstruyan juntas para otra arquitectura.
- Manten los cambios personalizados de ReGameDLL_CS en `upstream/ReGameDLL_CS` en la branch `modcsbr`.
- Los flujos antiguos de Steam/GoldSrc y validacion de biblioteca Linux fueron removidos de este proyecto.
