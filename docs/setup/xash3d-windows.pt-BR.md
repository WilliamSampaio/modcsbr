# Runtime Xash3D FWGS no Windows

Este e o caminho de runtime suportado para `modcsbr`.

## Objetivo

Rodar `modcsbr` no Windows com:

- binarios oficiais Windows do Xash3D FWGS como runtime da engine;
- assets Steam `valve` e `cstrike` copiados ou linkados para o diretorio Xash3D;
- branch `modcsbr` de `WilliamSampaio/cs16-client` compilada como `cl_dlls/client.dll` e `cl_dlls/menu.dll`;
- branch `modcsbr` de `WilliamSampaio/ReGameDLL_CS` compilada como `dlls/mp.dll`.

A primeira fase usa binarios baixados do Xash3D FWGS. Compile a engine a partir do codigo-fonte apenas se o runtime binario bloquear o desenvolvimento do mod.

## Layout do Runtime

Runtime local padrao:

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

`runtime/` e ignorado pelo Git.

Se a engine estiver em outro lugar:

```powershell
$env:XASH3D_DIR = "D:\Games\xash3d-fwgs"
```

## Assets Base

Xash3D FWGS ainda precisa de assets legais do Half-Life/Counter-Strike. O instalador tenta detectar a pasta Half-Life da Steam pelo registro e pelas bibliotecas Steam.

Para sobrescrever a deteccao:

```powershell
$env:HALF_LIFE_DIR = "D:\SteamLibrary\steamapps\common\Half-Life"
```

A pasta deve conter:

```text
valve/
cstrike/
steam_api.dll
```

No minimo, Xash3D precisa encontrar:

```text
runtime/xash3d/valve/gfx.wad
```

O instalador tambem copia `steam_api.dll` para a raiz do runtime Xash3D por compatibilidade com assets Steam copiados. Isso nao torna `-game cstrike` um alvo suportado.

A pasta instalada `modcsbr` e semeada a partir do `cstrike` da Steam antes de aplicar os arquivos do repositorio e DLLs compiladas. Assim o runtime local tem um mod derivado de Counter-Strike completo sem commitar assets Steam no Git.

Por padrao os assets sao copiados. Para usar junctions:

```powershell
$env:MODCSBR_ASSET_MODE = "link"
```

## Build

No Developer PowerShell for Visual Studio:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -UpdateSubmodules
```

Saidas esperadas:

```text
mod/modcsbr/dlls/mp.dll
mod/modcsbr/cl_dlls/client.dll
mod/modcsbr/cl_dlls/menu.dll
```

## Instalacao

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1
```

Recrie a pasta gerada do mod:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1 -Reset
```

Use `-Reset` depois de mudar assets base da Steam ou quando quiser uma pasta gerada limpa.

## Launch

Valide sem abrir processo:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
```

Execute:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

Use `New Game` no menu principal para criar partida local, escolher mapa e definir quantidade de bots.

Launch direto em um mapa:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -AutoMap -Map de_dust2
```

Comando equivalente:

```text
xash3d.exe -game modcsbr -console -dev
```

Nao use `xash3d.exe -game cstrike` como smoke test do projeto.

## Troubleshooting

Se o Xash3D mostrar `Host_InitCommon: couldn't load gfx.wad`, confirme:

```powershell
Test-Path runtime\xash3d\valve\gfx.wad
```

Se retornar `False`, defina `HALF_LIFE_DIR` para a pasta Half-Life da Steam e reinstale.

Se o Xash3D mostrar `Error: native object "MenuFactory" is unavailable`, confirme:

```powershell
Test-Path runtime\xash3d\modcsbr\cl_dlls\menu.dll
```

Se retornar `False`, reconstrua CS16Client e reinstale o runtime.
