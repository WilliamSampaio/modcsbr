# modcsbr

`modcsbr` e o nome temporario do nosso mod de Counter-Strike 1.6 para Linux.

A ideia e simples:

1. pegar o codigo original do ReGameDLL_CS;
2. compilar a biblioteca Linux `cs.so`;
3. instalar essa biblioteca como um mod separado chamado `modcsbr`;
4. abrir o Counter-Strike 1.6 da Steam usando esse mod;
5. so depois disso comecar a alterar codigo.

## O Que Voce Precisa Ter

Use Ubuntu Linux. Este projeto foi preparado na maquina com Ubuntu 24.04.

Voce precisa ter:

- Steam instalada;
- Counter-Strike 1.6 instalado pela Steam;
- este repositorio baixado;
- senha de `sudo`, porque vamos instalar pacotes de compilacao.

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

## Resetar E Reinstalar O Mod

Se o HUD nao aparecer, faca uma instalacao limpa do mod. Isso apaga a pasta `modcsbr` instalada na Steam e recria tudo.

Primeiro feche o CS 1.6.

Depois rode:

```bash
MODCSBR_ASSET_MODE=copy scripts/install/modcsbr-steam-linux.sh --reset
```

Esse modo copia os arquivos do `cstrike` para `modcsbr` em vez de usar links. E mais pesado, mas e melhor para tirar duvida com HUD/client.

Depois abra:

```bash
scripts/test/launch-modcsbr-steam-linux.sh
```

Atalho para resetar e abrir em seguida:

```bash
MODCSBR_ASSET_MODE=copy scripts/test/launch-modcsbr-steam-linux.sh --reset
```

## Abrir O Jogo Com O Mod

Para testar:

```bash
scripts/test/launch-modcsbr-steam-linux.sh
```

Esse script instala o mod e pede para a Steam abrir o Half-Life com `modcsbr`.

Por baixo, ele usa algo equivalente a:

```text
steam -applaunch 10 -game modcsbr -console -dev
```

O AppID `10` e importante: ele abre o Counter-Strike 1.6. Usar AppID `70` abre Half-Life e pode fazer o HUD do CS nao carregar corretamente.

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

Se algum dia precisar trocar o AppID manualmente:

```bash
MODCSBR_STEAM_APP_ID=10 scripts/test/launch-modcsbr-steam-linux.sh
```

## Conferir Se Funcionou

Quando o jogo abrir, inicie um mapa pelo menu `New Game`.

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
mod/
  modcsbr/
    liblist.gam
    dlls/
scripts/
  build/
    regamedll-linux.sh
  install/
    linux-build-deps-ubuntu.sh
    modcsbr-steam-linux.sh
  test/
    check-linux-environment.sh
    launch-modcsbr-steam-linux.sh
upstream/
  ReGameDLL_CS/
```

## Regra Mais Importante

Primeiro faca o ReGameDLL_CS original compilar e abrir no jogo.

So depois comece a mudar codigo.

Assim, se algo quebrar no futuro, voce sabe que o ambiente Linux, a Steam, o CS 1.6 e o carregamento do mod ja estavam funcionando.
