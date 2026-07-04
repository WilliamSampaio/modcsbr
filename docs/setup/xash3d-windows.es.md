# Runtime Xash3D FWGS en Windows

Esta es la ruta de runtime soportada para `modcsbr`.

## Objetivo

Ejecutar `modcsbr` en Windows con:

- binarios oficiales Windows de Xash3D FWGS como runtime del motor;
- assets Steam `valve` y `cstrike` copiados o enlazados en el directorio Xash3D;
- branch `modcsbr` de `WilliamSampaio/cs16-client` compilada como `cl_dlls/client.dll` y `cl_dlls/menu.dll`;
- branch `modcsbr` de `WilliamSampaio/ReGameDLL_CS` compilada como `dlls/mp.dll`.

La primera fase usa binarios descargados de Xash3D FWGS. Compila el motor desde fuente solo si el runtime binario bloquea el desarrollo del mod.

## Layout del Runtime

Runtime local predeterminado:

```text
runtime/xash3d/
  xash3d.exe
  valve/
  cstrike/
  modcsbr/
    assets stock de cstrike copiados localmente
    liblist.gam
    resource/mainui_english.txt
    resource/modcsbr_english.txt
    cl_dlls/client.dll
    cl_dlls/menu.dll
    dlls/mp.dll
```

`runtime/` es ignorado por Git.

Si el motor esta en otro lugar:

```powershell
$env:XASH3D_DIR = "D:\Games\xash3d-fwgs"
```

## Assets Base

Xash3D FWGS todavia necesita assets legales de Half-Life/Counter-Strike. El instalador intenta detectar la carpeta Half-Life de Steam desde el registro y las bibliotecas Steam.

Para sobrescribir la deteccion:

```powershell
$env:HALF_LIFE_DIR = "D:\SteamLibrary\steamapps\common\Half-Life"
```

La carpeta debe contener:

```text
valve/
cstrike/
steam_api.dll
```

Como minimo, Xash3D debe encontrar:

```text
runtime/xash3d/valve/gfx.wad
```

El instalador tambien copia `steam_api.dll` a la raiz del runtime Xash3D por compatibilidad con assets Steam copiados. Esto no convierte `-game cstrike` en un objetivo soportado.

La carpeta instalada `modcsbr` se crea primero desde `cstrike` de Steam y luego recibe los archivos del repositorio y DLLs compiladas. Asi el runtime local tiene un mod completo derivado de Counter-Strike sin commitear assets Steam en Git.

Por defecto los assets se copian. Para usar junctions:

```powershell
$env:MODCSBR_ASSET_MODE = "link"
```

## Build

En Developer PowerShell for Visual Studio:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -UpdateSubmodules
```

Salidas esperadas:

```text
mod/modcsbr/dlls/mp.dll
mod/modcsbr/cl_dlls/client.dll
mod/modcsbr/cl_dlls/menu.dll
```

## Instalacion

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1
```

Recrea la carpeta generada del mod:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1 -Reset
```

Usa `-Reset` despues de cambiar assets base de Steam o cuando quieras una carpeta generada limpia.

## Launch

Valida sin abrir proceso:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
```

Lanza:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

Usa `New Game` en el menu principal para crear una partida local, elegir mapa y definir cantidad de bots.

Launch directo a un mapa:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -AutoMap -Map de_dust2
```

Comando equivalente:

```text
xash3d.exe -game modcsbr -console -dev
```

No uses `xash3d.exe -game cstrike` como smoke test del proyecto.

## Troubleshooting

Si Xash3D muestra `Host_InitCommon: couldn't load gfx.wad`, confirma:

```powershell
Test-Path runtime\xash3d\valve\gfx.wad
```

Si retorna `False`, define `HALF_LIFE_DIR` con la carpeta Half-Life de Steam y reinstala.

Si Xash3D muestra `Error: native object "MenuFactory" is unavailable`, confirma:

```powershell
Test-Path runtime\xash3d\modcsbr\cl_dlls\menu.dll
```

Si retorna `False`, reconstruye CS16Client y reinstala el runtime.
