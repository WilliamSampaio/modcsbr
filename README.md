# modcsbr

`modcsbr` e o nome temporario do nosso mod de Counter-Strike 1.6 baseado no ReGameDLL_CS.

A ideia e simples:

1. pegar o codigo original do ReGameDLL_CS;
2. compilar a biblioteca Linux `cs.so`;
3. instalar essa biblioteca como um mod separado chamado `modcsbr`;
4. abrir o Counter-Strike 1.6 da Steam usando esse mod;
5. so depois disso comecar a alterar codigo.

## Sumario

- [O Que Voce Precisa Ter](#o-que-voce-precisa-ter)
- [Onde O Projeto Deve Ficar](#onde-o-projeto-deve-ficar)
- [Sobre Rodar O Jogo No WSL](#sobre-rodar-o-jogo-no-wsl)
- [Comecando Do Zero](#comecando-do-zero)
- [Instalar As Ferramentas De Build](#instalar-as-ferramentas-de-build)
- [Ambiente De Desenvolvimento No Windows](#ambiente-de-desenvolvimento-no-windows)
- [Compilar O ReGameDLL_CS](#compilar-o-regamedll_cs)
- [Instalar O Mod No Counter-Strike 1.6](#instalar-o-mod-no-counter-strike-16)
- [Instalar O Mod No Counter-Strike 1.6 No Windows](#instalar-o-mod-no-counter-strike-16-no-windows)
- [Resetar E Reinstalar O Mod](#resetar-e-reinstalar-o-mod)
- [Abrir O Jogo Com O Mod](#abrir-o-jogo-com-o-mod)
- [Abrir O Jogo Com O Mod No Windows](#abrir-o-jogo-com-o-mod-no-windows)
- [Conferir Se Funcionou](#conferir-se-funcionou)
- [Se O Jogo Nao Achar A Pasta Da Steam](#se-o-jogo-nao-achar-a-pasta-da-steam)
- [Se A Build Reclamar De Ferramentas Faltando](#se-a-build-reclamar-de-ferramentas-faltando)
- [Se O Projeto Estiver Em /mnt/c](#se-o-projeto-estiver-em-mntc)
- [Se O Jogo Abrir O CS Normal](#se-o-jogo-abrir-o-cs-normal)
- [Se Aparecer Erro De libsteam_api.so, hw.so Ou libopenal.so.1](#se-aparecer-erro-de-libsteam_apiso-hwso-ou-libopenalso1)
- [Estrutura Do Projeto](#estrutura-do-projeto)
- [Regra Mais Importante](#regra-mais-importante)

## O Que Voce Precisa Ter

O caminho principal de build e Ubuntu Linux. Este projeto foi preparado na maquina com Ubuntu 24.04.

Voce precisa ter:

- Steam instalada;
- Counter-Strike 1.6 instalado pela Steam;
- este repositorio baixado;
- senha de `sudo`, porque vamos instalar pacotes de compilacao.

No Windows 11, o ambiente e usado para editar, navegar codigo e fazer builds diagnosticas com MSVC `Release | Win32`. A `cs.so` canonica do mod continua sendo gerada no Linux. Veja:

```text
docs/setup/windows-11.md
```

Para checar o ambiente Windows:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/check-windows-environment.ps1
```

## Onde O Projeto Deve Ficar

Trabalhe no disco Linux `ext4`, nao dentro de `/mnt/c`.

Nesta maquina, o ambiente correto esta em `/dev/sdd`:

```text
/home/william/modcsbr
```

Isso importa porque build C/C++ fica bem mais confiavel e rapido no filesystem Linux.

Para conferir:

```bash
scripts/test/check-linux-environment.sh
```

O resultado bom deve dizer:

```text
OK: repo is on the Linux filesystem.
OK: repo filesystem is on /dev/sdd.
```

## Sobre Rodar O Jogo No WSL

Use o WSL para compilar, instalar e fazer teste rapido de carregamento do mod.

Nao use WSL como referencia de performance do jogo. Se o console mostrar algo como:

```text
GL_RENDERER: llvmpipe
```

o jogo esta renderizando por CPU, nao pela GPU. Nesse modo e normal ter FPS ruim, input atrasado e mouse instavel.

Para jogar e testar sensibilidade/mira de verdade, prefira:

- Linux nativo com driver de GPU funcionando;
- Windows com Steam nativa;
- dual boot Linux/Windows.

No WSL, valide apenas se aparecem os marcadores:

```text
modcsbr: client autoexec.cfg loaded
modcsbr: ReGameDLL game_init.cfg loaded
```

O Counter-Strike 1.6 da Steam normalmente fica aqui:

```text
~/.steam/debian-installation/steamapps/common/Half-Life
```

Dentro dessa pasta deve existir:

```text
cstrike/
hl_linux
```

Se esses dois existem, o jogo esta no lugar certo.

## Comecando Do Zero

Abra um terminal.

Entre na pasta onde voce guarda seus projetos:

```bash
cd ~/dev
```

Baixe o projeto:

```bash
git clone git@github.com:WilliamSampaio/modcsbr.git modcsbr
```

Entre na pasta:

```bash
cd modcsbr
```

Mude para a branch de desenvolvimento:

```bash
git checkout develop
```

Baixe o codigo do ReGameDLL_CS:

```bash
git submodule update --init --recursive
```

Pronto. Agora o codigo original deve existir em:

```text
upstream/ReGameDLL_CS
```

Esse submodule aponta para o fork:

```text
https://github.com/WilliamSampaio/ReGameDLL_CS.git
```

Use a branch `modcsbr` desse fork para as alteracoes futuras do GameDLL do mod. O baseline validado continua sendo o ReGameDLL_CS original sem alteracoes, no commit registrado em `docs/setup/build-regamedll.md`.

## Instalar As Ferramentas De Build

Antes de compilar, instale os pacotes necessarios:

```bash
scripts/install/linux-build-deps-ubuntu.sh --install
```

Esse comando vai pedir sua senha do Linux.

Ele instala coisas como:

- `cmake`;
- `gcc`;
- `g++`;
- `make`;
- suporte para compilar codigo 32-bit.

Isso e importante porque Counter-Strike 1.6 / GoldSrc usa biblioteca 32-bit.

## Ambiente De Desenvolvimento No Windows

Use Windows para VS Code, IntelliSense MSVC x86 e diagnosticos do upstream.

Guia completo:

```text
docs/setup/windows-11.md
```

Check rapido:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/check-windows-environment.ps1
```

Build diagnostica do upstream com MSBuild:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1
```

Se o PowerShell disser que o `.ps1` nao esta assinado digitalmente, use os comandos acima com `-ExecutionPolicy Bypass -File`. Isso libera apenas essa execucao e nao muda a politica global do Windows.

Esse build gera a GameDLL Windows do ReGameDLL_CS, normalmente `mp.dll`. Ele nao substitui:

```text
mod/modcsbr/dlls/cs.so
```

Se o MSBuild reclamar do toolset antigo `v100` / Visual Studio 2010, use o wrapper acima. Ele forca `VisualStudioVersion=17.0` e detecta um toolset Win32 instalado, como `v145` ou `v143`, sem alterar os arquivos do upstream.

Para validar o mod Linux, continue usando:

```bash
scripts/build/regamedll-linux.sh
```

## Compilar O ReGameDLL_CS

Agora compile:

```bash
scripts/build/regamedll-linux.sh
```

Se tudo der certo, no final voce deve ver algo parecido com:

```text
Built: .../upstream/ReGameDLL_CS/build/regamedll/cs.so
Copied: .../mod/modcsbr/dlls/cs.so
```

O arquivo importante e:

```text
mod/modcsbr/dlls/cs.so
```

Esse arquivo e a GameDLL Linux compilada.

Voce so precisa rebuildar quando mudar codigo C++ da GameDLL ou quando quiser garantir uma `cs.so` nova. Problemas de HUD normalmente nao exigem rebuild, porque HUD, mira, vida e municao vem dos arquivos cliente do CS:

```text
cl_dlls/client.so
sprites/hud.txt
sprites/*.spr
resource/
```

## Instalar O Mod No Counter-Strike 1.6

Agora copie o mod para a pasta do jogo:

```bash
scripts/install/modcsbr-steam-linux.sh
```

O script tenta encontrar o Counter-Strike automaticamente.

O destino normal e:

```text
~/.steam/debian-installation/steamapps/common/Half-Life/modcsbr
```

Dentro dessa pasta deve existir:

```text
liblist.gam
dlls/cs.so
```

O arquivo `liblist.gam` diz ao jogo para carregar:

```text
dlls/cs.so
```

Por padrao, o installer tambem ativa os extras recomendados pelo ReGameDLL_CS:

- zBot for CS 1.6;
- CS:CZ hostage AI for CS 1.6.

Ele extrai os arquivos dos zips em `upstream/ReGameDLL_CS/regamedll/extra/` e adiciona no `game_init.cfg` instalado:

```text
bot_enable 1
hostage_ai_enable 1
```

Para instalar sem esses extras:

```bash
scripts/install/modcsbr-steam-linux.sh --no-regamedll-extras
```

Tambem da para desligar so um deles:

```bash
scripts/install/modcsbr-steam-linux.sh --no-zbot
scripts/install/modcsbr-steam-linux.sh --no-hostage-ai
```

Quando precisar copiar todo o conteudo local de `mod/modcsbr` para a pasta instalada do mod, use:

```bash
scripts/install/modcsbr-steam-linux.sh --full-mod-copy
```

Esse modo preserva o comportamento normal de fallback para arquivos do `cstrike`, mas substitui no destino as entradas que existem em `mod/modcsbr`.

## Instalar O Mod No Counter-Strike 1.6 No Windows

No Windows, primeiro gere a GameDLL diagnostica:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1
```

Depois instale o mod na pasta oficial da Steam:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-steam-windows.ps1
```

O script tenta detectar a Steam pelo registro do Windows e pelo arquivo `steamapps\libraryfolders.vdf`.

O destino normal e:

```text
C:\Program Files (x86)\Steam\steamapps\common\Half-Life\modcsbr
```

Dentro dessa pasta deve existir:

```text
liblist.gam
dlls\mp.dll
```

Por padrao, o installer tambem ativa os extras recomendados pelo ReGameDLL_CS:

- zBot for CS 1.6;
- CS:CZ hostage AI for CS 1.6.

Ele extrai os arquivos dos zips em `upstream\ReGameDLL_CS\regamedll\extra\` e adiciona no `game_init.cfg` instalado:

```text
bot_enable 1
hostage_ai_enable 1
```

Para instalar sem esses extras:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-steam-windows.ps1 -DisableReGameDLLExtras
```

Tambem da para desligar so um deles:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-steam-windows.ps1 -DisableZBot
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-steam-windows.ps1 -DisableHostageAI
```

Quando precisar copiar todo o conteudo local de `mod\modcsbr` para a pasta instalada do mod, use:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-steam-windows.ps1 -FullModCopy
```

Esse modo substitui no destino as entradas que existem em `mod\modcsbr`, como `models`, `resource`, `sound` e `sprites`.

Se sua Steam estiver em outro lugar, informe a pasta que contem `hl.exe` e `cstrike\`:

```powershell
$env:HALF_LIFE_DIR = "D:\SteamLibrary\steamapps\common\Half-Life"
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-steam-windows.ps1
```

Por padrao, no Windows os assets sao copiados do `cstrike` para `modcsbr`. Para tentar links/junctions:

```powershell
$env:MODCSBR_ASSET_MODE = "link"
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-steam-windows.ps1
```

## Resetar E Reinstalar O Mod

Se o HUD nao aparecer ou a aba `Game` do `Create Server` ficar vazia, faca uma instalacao limpa do mod. Isso apaga a pasta `modcsbr` instalada na Steam e recria tudo.

Primeiro feche o CS 1.6.

Depois rode:

```bash
MODCSBR_ASSET_MODE=copy scripts/install/modcsbr-steam-linux.sh --reset
```

Esse modo copia os arquivos do `cstrike` para `modcsbr` em vez de usar links. E mais pesado, mas e melhor para tirar duvida com HUD/client e tambem repara o `settings.scr`, que alimenta as opcoes da aba `Game` no `Create Server`.

Depois abra:

```bash
scripts/test/launch-modcsbr-steam-linux.sh
```

Atalho para resetar e abrir em seguida:

```bash
MODCSBR_ASSET_MODE=copy scripts/test/launch-modcsbr-steam-linux.sh --reset
```

Se quiser resetar e forcar uma copia completa dos arquivos locais do mod:

```bash
MODCSBR_ASSET_MODE=copy scripts/install/modcsbr-steam-linux.sh --reset --full-mod-copy
```

## Abrir O Jogo Com O Mod

Para testar:

```bash
scripts/test/launch-modcsbr-steam-linux.sh
```

Esse script instala o mod e pede para a Steam abrir o Half-Life com `modcsbr`.

Por baixo, ele usa algo equivalente a:

```text
steam -applaunch 70 -game modcsbr -console -dev
```

O AppID `70` e importante para validar o mod: ele abre o Half-Life respeitando `-game modcsbr`.

O AppID `10` abre o Counter-Strike 1.6. Ele pode carregar o contexto do `cstrike` e ignorar o `autoexec.cfg` do `modcsbr`, entao nao use AppID `10` para confirmar se a pasta do mod foi carregada.

Por dentro, o script tambem ajusta:

```text
LD_LIBRARY_PATH
LC_ALL
LANG
```

Isso evita erros como:

```text
Error:libsteam_api.so: cannot open shared object file: No such file or directory
Could not load hw.so.
Error:libopenal.so.1: cannot open shared object file: No such file or directory
```

Por padrao, o launcher abre no menu. Entre em:

```text
New Game
```

e inicie o mapa por la. Esse fluxo inicializa corretamente o HUD do cliente do CS.

Para iniciar direto em um mapa, use:

```bash
MODCSBR_AUTO_MAP=1 MAP=de_inferno scripts/test/launch-modcsbr-steam-linux.sh
```

Se o HUD sumir quando iniciar direto por `+map`, volte ao fluxo pelo menu `New Game`.

O launcher nao forca renderer. Ele deixa a Steam/GoldSrc escolher o caminho normal.

Se precisar testar renderer software manualmente:

```bash
scripts/test/launch-modcsbr-steam-linux.sh -soft
```

Para debug avancado, tambem existe o modo direto:

```bash
MODCSBR_LAUNCH_METHOD=direct scripts/test/launch-modcsbr-steam-linux.sh
```

No WSL, prefira o modo padrao via Steam. Chamar `hl_linux` direto pode crashar mesmo com o CS original.

O padrao ja e AppID `70`. Se quiser abrir o contexto direto do Counter-Strike para comparar comportamento, use AppID `10`, mas essa nao e a validacao principal do `modcsbr`:

```bash
MODCSBR_STEAM_APP_ID=10 scripts/test/launch-modcsbr-steam-linux.sh
```

## Abrir O Jogo Com O Mod No Windows

Para instalar e abrir pela Steam nativa do Windows:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-steam-windows.ps1
```

Por baixo, ele usa algo equivalente a:

```text
steam.exe -applaunch 70 -game modcsbr -console -dev
```

Para resetar a pasta instalada e abrir de novo:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-steam-windows.ps1 -Reset
```

Para abrir sem instalar os extras do ReGameDLL_CS:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-steam-windows.ps1 -DisableReGameDLLExtras
```

Para iniciar direto em um mapa:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-steam-windows.ps1 -AutoMap -Map de_inferno
```

Para validar o comando sem abrir a Steam:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-steam-windows.ps1 -NoLaunch
```

## Conferir Se Funcionou

Quando o jogo abrir, abra o console e procure esta linha:

```text
modcsbr: client autoexec.cfg loaded
```

Se ela aparecer, o CS abriu usando a pasta `modcsbr`.

Se o console mostrar apenas `execing autoexec.cfg` sem a linha acima, provavelmente ele executou outro `autoexec.cfg`, como `valve/autoexec.cfg` ou `cstrike/autoexec.cfg`. Confira se o launcher esta usando AppID `70`.

Depois inicie um mapa pelo menu `New Game`.

Abra o console e procure esta linha:

```text
modcsbr: ReGameDLL game_init.cfg loaded
```

Se ela aparecer, deu certo: o ReGameDLL carregou o `modcsbr/game_init.cfg` ao iniciar o servidor local.

Nao use `game version` ou `game_version` como validacao principal no console do cliente. Esses comandos/cvars pertencem ao lado servidor da GameDLL e podem aparecer como:

```text
Unknown command: game
Unknown command: game_version
```

## Se O Jogo Nao Achar A Pasta Da Steam

Se sua Steam estiver em outro lugar, diga ao script onde fica a pasta `Half-Life`.

Exemplo:

```bash
HALF_LIFE_DIR="/caminho/para/Half-Life" scripts/install/modcsbr-steam-linux.sh
```

E para abrir:

```bash
HALF_LIFE_DIR="/caminho/para/Half-Life" scripts/test/launch-modcsbr-steam-linux.sh
```

A pasta certa e a que contem `hl_linux` e `cstrike/`.

## Se A Build Reclamar De Ferramentas Faltando

Se aparecer algo como:

```text
Missing required tool: cmake
```

rode:

```bash
scripts/install/linux-build-deps-ubuntu.sh --install
```

Depois tente compilar de novo:

```bash
scripts/build/regamedll-linux.sh
```

## Se O Projeto Estiver Em /mnt/c

Nao compile dentro de uma pasta como:

```text
/mnt/c/...
```

Coloque o projeto no Linux, por exemplo:

```text
/home/william/modcsbr
```

Depois rode:

```bash
scripts/test/check-linux-environment.sh
```

## Se O Jogo Abrir O CS Normal

Confira se esta pasta existe:

```text
~/.steam/debian-installation/steamapps/common/Half-Life/modcsbr
```

Confira se ela tem:

```text
liblist.gam
dlls/cs.so
```

Depois abra de novo com:

```bash
scripts/test/launch-modcsbr-steam-linux.sh
```

## Se Aparecer Erro De libsteam_api.so, hw.so Ou libopenal.so.1

Rode:

```bash
scripts/test/check-linux-environment.sh
```

Depois tente abrir pelo script do projeto:

```bash
scripts/test/launch-modcsbr-steam-linux.sh
```

Nao abra `hl_linux` manualmente enquanto estiver testando o mod. O script prepara o mod e, por padrao, deixa a Steam iniciar o runtime correto.

Se aparecer:

```text
Failed to create SDL Window
MESA: error: ZINK: failed to choose pdev
```

teste o renderer software:

```bash
scripts/test/launch-modcsbr-steam-linux.sh -soft
```

## Estrutura Do Projeto

```text
docs/
  setup/
    linux.md
    windows-11.md
mod/
  modcsbr/
    liblist.gam
    dlls/
scripts/
  build/
    regamedll-linux.sh
    regamedll-windows.ps1
  install/
    linux-build-deps-ubuntu.sh
    modcsbr-steam-linux.sh
    modcsbr-steam-windows.ps1
  test/
    check-linux-environment.sh
    check-windows-environment.ps1
    launch-modcsbr-steam-linux.sh
    launch-modcsbr-steam-windows.ps1
upstream/
  ReGameDLL_CS/
```

## Regra Mais Importante

Primeiro faca o ReGameDLL_CS original compilar e abrir no jogo.

So depois comece a mudar codigo na branch `modcsbr` do fork `WilliamSampaio/ReGameDLL_CS`.

Assim, se algo quebrar no futuro, voce sabe que o ambiente Linux, a Steam, o CS 1.6 e o carregamento do mod ja estavam funcionando.
