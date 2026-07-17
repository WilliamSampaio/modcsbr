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

## Build Server

No Developer PowerShell for Visual Studio:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1
```

Saida esperada no repositorio:

```text
mod/modcsbr/dlls/mp.dll
```

## Build Client

Inicialize os submodulos cliente/servidor:

```powershell
git submodule sync --recursive
git submodule update --init --recursive
```

Para trabalho de desenvolvimento, troque os submodulos principais para suas branches `modcsbr`:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/dev/switch-modcsbr-branches.ps1
```

Compile:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -UpdateSubmodules
```

Saida esperada no repositorio:

```text
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

## Mapas comunitários opcionais

Mapas comunitários ficam fora do repositório principal e só são instalados no runtime gerado quando solicitado.

Instale todos os mapas permitidos a partir do release mais recente de `modcsbr/community-maps`:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/community-maps-windows.ps1 -FromRelease -All
```

Instale mapas selecionados:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/community-maps-windows.ps1 -FromRelease -Maps cs_rio,fy_poolparty
```

O instalador baixa os assets de release para `.downloads/community-maps`, valida os hashes do release e dos manifests dos mapas, e copia apenas `maps/<id>/files/**` para `runtime/xash3d/modcsbr`. Use `-CommunityMapsDir C:\dev\community-maps` ao manter o catálogo de mapas localmente.

O default da ReGameDLL do mod e o overlay do repositorio em `game_init.cfg`, `server.cfg` e `listenserver.cfg` definem `mp_flashlight "1"`, permitindo que a ReGameDLL aceite o comando padrao da lanterna (`impulse 100`) em partidas locais.

## Execucao

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

## Notas

- Mantenha todos os binarios de runtime em `runtime/xash3d` ou outro diretorio ignorado.
- Mantenha os builds Xash3D, CS16Client e ReGameDLL alinhados em Win32/x86, a menos que todas as bibliotecas de jogo carregadas sejam reconstruidas juntas para outra arquitetura.
- Nao dependa de fluxos de launch Steam/GoldSrc; Xash3D FWGS e o unico caminho de runtime suportado.

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
