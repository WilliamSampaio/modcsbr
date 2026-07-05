# modcsbr

## Idiomas

- English: [README.md](README.md)
- Portugues (Brasil): [README.pt-BR.md](README.pt-BR.md)
- Espanol: este archivo

`modcsbr` es un mod personalizado de la familia Counter-Strike 1.6 / GoldSrc para Xash3D FWGS en Windows.

El proyecto usa:

- Xash3D FWGS como motor de runtime;
- CS16Client como DLL cliente y DLL MainUI;
- ReGameDLL_CS como GameDLL del servidor;
- archivos Steam legalmente adquiridos de Half-Life / Counter-Strike 1.6 como base local de assets.

El flujo antiguo de lanzamiento con Steam/GoldSrc no esta soportado. La unica ruta de runtime soportada es:

```text
runtime/xash3d/xash3d.exe -game modcsbr
```

No uses `runtime/xash3d/xash3d.exe -game cstrike` como smoke test del proyecto. La carpeta generada `runtime/xash3d/cstrike` es una base de assets copiada desde Steam; su `cl_dlls/client.dll` stock puede generar un assert de estado Steam GameUI cuando Xash3D lo carga directamente.

## Estado

Este repositorio se esta preparando para colaboracion publica. El foco actual es obtener una base Windows Xash3D limpia antes de ampliar cambios de gameplay y assets.

## Assets Legales

Este repositorio no incluye binarios/assets de Valve, Half-Life, Counter-Strike, Steam o runtime Xash3D.

Los colaboradores necesitan su propia instalacion Steam legal de Half-Life / Counter-Strike 1.6. El instalador copia los assets locales necesarios a carpetas ignoradas en `runtime/`:

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
- CMake del workload C++ de Visual Studio.
- Python 3 disponible como `python` en PATH, o mediante el Python launcher como `py -3`.
- Binarios oficiales Windows de Xash3D FWGS extraidos en `runtime/xash3d`.
- Half-Life / Counter-Strike 1.6 instalado localmente por Steam.

Componentes de Visual Studio Installer usados por este proyecto:

- Workload: `Desktop development with C++`.
- Herramientas MSBuild.
- Herramientas MSVC para x64/x86.
- Windows 11 SDK `10.0.26100.8249` o mas nuevo.
- C++ CMake tools for Windows.
- C++ test tools core features.
- MSVC AddressSanitizer.
- vcpkg package manager.

Consulta [docs/setup/windows-11.es.md](docs/setup/windows-11.es.md) para detalles del instalador y comandos de verificacion.

## Inicio Rapido

Clona e inicializa submodulos:

```powershell
git submodule sync --recursive
git submodule update --init --recursive
```

Coloca los submodulos principales de desarrollo en sus branches `modcsbr` antes de editarlos:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/dev/switch-modcsbr-branches.ps1
```

Usa tambien `-IncludeMainUI` despues de que el submodulo anidado `mainui_cpp` sea forkado y tenga una branch `modcsbr`.

Si Half-Life de Steam no esta en la ubicacion predeterminada, apunta los scripts a la carpeta que contiene `valve`, `cstrike` y `steam_api.dll`:

```powershell
$env:HALF_LIFE_DIR = "D:\SteamLibrary\steamapps\common\Half-Life"
```

Compila la GameDLL del servidor:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1
```

Compila las DLLs cliente y menu:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -UpdateSubmodules
```

Instala el runtime Xash3D local:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1 -Reset
```

Valida el comando de lanzamiento:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
```

Lanza:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

En el menu principal, usa `New Game` para crear una partida local. Esa pantalla permite elegir mapa, definir maximo de jugadores y definir la cantidad de bots.

## Layout del Runtime

El instalador genera un runtime local ignorado:

```text
runtime/xash3d/
  xash3d.exe
  valve/
  cstrike/
  steam_api.dll
  modcsbr/
    base copiada de cstrike
    archivos superpuestos desde mod/modcsbr
    resource/mainui_english.txt
    resource/modcsbr_english.txt
    cl_dlls/client.dll
    cl_dlls/menu.dll
    dlls/mp.dll
```

`menu.dll` debe quedarse junto a `client.dll`; Xash3D FWGS MainUI espera ese layout para `MenuFactory`.
Los archivos de localizacion propios del mod son diccionarios placeholder intencionalmente pequenos. Silencian avisos de archivos faltantes de CS16Client/MainUI sin commitear recursos de texto propiedad de Valve.

## Layout del Repositorio

```text
mod/modcsbr/                  overlay fuente del mod
runtime/xash3d/               runtime local ignorado
scripts/build/                wrappers de build Windows
scripts/install/              instalador del runtime Xash3D
scripts/test/                 chequeos de ambiente y launch
upstream/ReGameDLL_CS/        submodulo de la GameDLL del servidor
upstream/cs16-client/         submodulo de la DLL cliente con dependencias 3rdparty anidadas
docs/                         notas de setup y arquitectura
specs/                        planificacion orientada por specs
```

El checkout anidado `upstream/cs16-client/3rdparty/ReGameDLL_CS` pertenece al build de CS16Client. El trabajo de GameDLL del servidor para `modcsbr` debe quedarse en el submodulo superior `upstream/ReGameDLL_CS`.

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

Manten los cambios pequenos y documenta comportamiento en `specs/` antes de grandes features. No hagas commit de archivos generados de runtime ni assets propietarios de terceros.

Antes de abrir un pull request, ejecuta:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/check-windows-environment.ps1
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
```

Al tocar build, instalacion, launch, rutas o comportamiento de workflow, actualiza la documentacion relevante en el mismo cambio.

## Troubleshooting

Si Xash3D no puede encontrar `gfx.wad`, define `HALF_LIFE_DIR` y reinstala el runtime.

Si Xash3D informa que `MenuFactory` no esta disponible, recompila CS16Client y confirma:

```powershell
Test-Path runtime\xash3d\modcsbr\cl_dlls\menu.dll
```

Si ejecutar `runtime\xash3d\xash3d.exe -game cstrike` abre una ventana de assert Microsoft Visual C++ para `g_hGameUIModule`, vuelve a la ruta de lanzamiento soportada del mod:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

Si `cl`, `msbuild` o `cmake` faltan, reabre el proyecto desde Developer PowerShell y confirma que los componentes de Visual Studio Installer listados arriba estan instalados.

Si el build de CS16Client informa que falta Python, instala Python 3 con `Add python.exe to PATH` o con el Python launcher habilitado. Si `python --version` apunta a `WindowsApps\python.exe` o abre Microsoft Store, deshabilita los aliases de ejecucion de app de Windows para `python.exe` y `python3.exe`.
