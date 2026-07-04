# modcsbr

## Idiomas

- [English](README.md)
- Portugues (Brasil): [README.pt-BR.md](README.pt-BR.md)
- Espanol: este archivo

`modcsbr` es un mod personalizado de la familia Counter-Strike 1.6 / GoldSrc para Xash3D FWGS en Windows.

El proyecto usa Xash3D FWGS como motor, CS16Client como `client.dll` y `menu.dll`, ReGameDLL_CS como GameDLL del servidor, y archivos locales legalmente adquiridos de Half-Life / Counter-Strike 1.6 en Steam como base de assets.

El flujo antiguo de lanzamiento con Steam/GoldSrc no esta soportado. La ruta de runtime soportada es:

```text
runtime/xash3d/xash3d.exe -game modcsbr
```

No uses `runtime/xash3d/xash3d.exe -game cstrike` como smoke test del proyecto. La carpeta generada `runtime/xash3d/cstrike` existe como base de assets copiada desde Steam; su `cl_dlls/client.dll` original puede fallar por estado de Steam GameUI cuando Xash3D lo carga directamente.

## Estado

Este repositorio se esta preparando para colaboracion publica. El foco actual es mantener una base Windows Xash3D limpia antes de ampliar cambios de gameplay y assets.

## Assets Legales

Este repositorio no incluye binarios ni assets de Valve, Half-Life, Counter-Strike, Steam o Xash3D.

Los colaboradores necesitan una instalacion legal propia de Half-Life / Counter-Strike 1.6 en Steam. El instalador copia los assets locales necesarios a carpetas ignoradas en `runtime/`:

```text
runtime/xash3d/valve
runtime/xash3d/cstrike
runtime/xash3d/modcsbr
runtime/xash3d/steam_api.dll
```

No hagas commit de archivos generados de runtime, binarios del motor ni assets Valve/Counter-Strike.

## Requisitos

- Windows 11.
- Git for Windows.
- VS Code.
- Visual Studio Build Tools / Visual Studio Installer con el workload `Desktop development with C++`.
- CMake instalado por el workload C++ de Visual Studio.
- Python 3 disponible como `python` en PATH o mediante `py -3`.
- Binarios oficiales Windows de Xash3D FWGS extraidos en `runtime/xash3d`.
- Half-Life / Counter-Strike 1.6 instalado localmente por Steam.

Componentes de Visual Studio Installer usados por el proyecto:

- Workload: `Desktop development with C++`.
- Herramientas MSBuild.
- Herramientas MSVC x64/x86.
- Windows 11 SDK `10.0.26100.8249` o mas nuevo.
- C++ CMake tools for Windows.
- C++ test tools core features.
- MSVC AddressSanitizer.
- vcpkg package manager.

Consulta la guia de setup de Windows en los idiomas enlazados abajo.

## Inicio Rapido

Clona e inicializa submodulos:

```powershell
git submodule sync --recursive
git submodule update --init --recursive
```

Antes de editar los submodulos principales, colocalos en sus branches `modcsbr`:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/dev/switch-modcsbr-branches.ps1
```

Si Half-Life de Steam no esta en la ubicacion predeterminada:

```powershell
$env:HALF_LIFE_DIR = "D:\SteamLibrary\steamapps\common\Half-Life"
```

Compila la GameDLL del servidor:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1
```

Compila el cliente y el menu:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -UpdateSubmodules
```

Instala el runtime local de Xash3D:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1 -Reset
```

Valida y lanza:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

En el menu principal, usa `New Game` para crear una partida local, elegir mapa, maximo de jugadores y cantidad de bots.

## Documentacion

- Setup de Windows:
  [English](docs/setup/windows-11.md) |
  [Portugues](docs/setup/windows-11.pt-BR.md) |
  [Espanol](docs/setup/windows-11.es.md)
- Runtime Xash3D FWGS:
  [English](docs/setup/xash3d-windows.md) |
  [Portugues](docs/setup/xash3d-windows.pt-BR.md) |
  [Espanol](docs/setup/xash3d-windows.es.md)
- Build ReGameDLL_CS:
  [English](docs/setup/build-regamedll.md) |
  [Portugues](docs/setup/build-regamedll.pt-BR.md) |
  [Espanol](docs/setup/build-regamedll.es.md)
- Build CS16Client:
  [English](docs/setup/build-cs16-client.md) |
  [Portugues](docs/setup/build-cs16-client.pt-BR.md) |
  [Espanol](docs/setup/build-cs16-client.es.md)
- Vista de arquitectura:
  [English](docs/architecture/overview.md) |
  [Portugues](docs/architecture/overview.pt-BR.md) |
  [Espanol](docs/architecture/overview.es.md)
- [Spec aprobada del runtime](specs/approved/xash3d-fwgs-windows-runtime.md)

## Contribuir

Mantén los cambios pequenos y documenta comportamiento en `specs/` antes de grandes features. No hagas commit de archivos generados de runtime ni assets propietarios de terceros.

Antes de abrir un pull request, ejecuta:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/check-windows-environment.ps1
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
```

Al cambiar build, instalacion, launch, rutas o workflow, actualiza la documentacion relevante en el mismo change.
