# modcsbr

## Idiomas

- English: [README.md](README.md)
- Portugues (Brasil): este arquivo
- Espanol: [README.es.md](README.es.md)

`modcsbr` e um mod customizado da familia Counter-Strike 1.6 / GoldSrc para Xash3D FWGS no Windows.

O projeto usa:

- Xash3D FWGS como engine de runtime;
- CS16Client como DLL cliente e DLL MainUI;
- ReGameDLL_CS como GameDLL do servidor;
- arquivos Steam legalmente possuidos de Half-Life / Counter-Strike 1.6 como base local de assets.

O fluxo antigo de execucao pelo Steam/GoldSrc nao e suportado. O unico caminho de runtime suportado e:

```text
runtime/xash3d/xash3d.exe -game modcsbr
```

Nao use `runtime/xash3d/xash3d.exe -game cstrike` como smoke test do projeto. A pasta gerada `runtime/xash3d/cstrike` e uma base de assets copiada da Steam; o `cl_dlls/client.dll` stock dela pode gerar assert de estado Steam GameUI quando carregado diretamente pelo Xash3D.

## Status

Este repositorio esta sendo preparado para colaboracao publica. O foco atual e obter uma base Windows Xash3D limpa antes de ampliar mudancas de gameplay e assets.

A descoberta de gameplay comecou com uma exploracao nao aprovada, no backlog, sobre equipes, composicao livre, kits predefinidos sem dinheiro ou compra e equipes tematicas criadas pela comunidade dentro de contratos simetricos de tipo. O MVP usa quatro tipos iniciais fixos — Assault, Support, Marksman e Breacher — sem transformar quatro em limite permanente do catalogo. O dano permanece fixo; conteudo comunitario pode definir a capacidade do carregador ate o teto de balas do slot e variar recuo e cadencia dentro de intervalos validados pelo servidor. Capacidade, municao total, comportamento, tempo e animacao de recarga permanecem parametros separados. No MVP, o tempo de recarga e fixo por categoria, usa referencias do CS 1.6 e e imposto pelo servidor; os assets comunitarios devem se adaptar a ele, sem defini-lo. Escopetas pump-action e semiautomaticas seguem as baselines cartucho por cartucho da M3 e XM1014; escopetas totalmente automaticas ficam fora do escopo. A referencia principal de balanceamento do MVP e 10v10, com validacao obrigatoria de 6v6 ate 12v12; partidas ate 16v16 continuam suportadas quando mapa e servidor comportarem, mas nao sao o centro inicial do balanceamento. Equipes podem diferir em no maximo um jogador ativo, e reconexoes obedecem a disponibilidade atual sem reservar a vaga anterior. Retrocompatibilidade com mapas e modos de jogo do CS 1.6 e um pilar inicial, mas mapas legados nao reativam a economia. A base atual suporta ate 32 clientes conectados, enquanto servidores podem configurar menos. Ela e uma proposta para playtest, nao o comportamento atual do jogo.

As primeiras equipes ficticias de playtest do MVP sao Atlas e Vesper, em um exercicio operacional neutro com dispositivo de validacao. Atlas usa os aliases iniciais Operador, Artilheiro, Vigia e Rompedor; Vesper usa Avancado, Cobertura, Sentinela e Entrada. Esses nomes testam identidade e leitura, sem alterar a simetria mecanica.

Assault escolhe uma variacao exclusiva de Rifle ou SMG, ambas com pistola, faca, uma granada de fragmentacao e duas flashbangs. Seu catalogo global inicial contem quatro perfis mecanicos: 7,62 de poder/AK-47, 5,56 de controle/M4A1 sem silenciador, 9 mm de controle/MP5 e .45 de poder/UMP-45. Essas armas sao baselines mecanicas, nao identidades visuais obrigatorias. As primarias do Assault usam somente fogo automatico no MVP; burst, silenciador acoplavel, FAMAS, Galil, TMP, MAC-10 e P90 ficam fora do catalogo inicial. Armas comunitarias de Assault escolhem um preset completo de manuseio — `controlled`, `baseline` ou `aggressive` — em vez de misturar livremente sliders de recuo, cadencia e precisao. A mecanica da faca e global mesmo quando a equipe troca sua apresentacao, e o dano da arma sempre segue o perfil validado pelo servidor. Um sobrevivente pode levar uma arma coletada para a rodada seguinte como substituta do mesmo slot; ela recebe somente carregadores completos ate o teto de sua propria categoria, e trocar tipo ou variacao restaura o kit predefinido escolhido.

Support usa um unico kit no MVP: machine gun com teto de 250 balas, pistola com teto de 45, faca, uma flashbang e uma smoke. Seu catalogo global inicial tem dois perfis: `support_lmg_556_sustain`, baseado na M249, com dano 32 e cadencia-base de 600 RPM, e `support_lmg_762_power`, com dano 36, cadencia-base de 500 RPM e recuo mais pesado. Ambos usam recarga de 4,7 segundos, capacidade-base 100 e teto do slot 250. Armas de Support tambem usam presets completos de manuseio `controlled`, `baseline` ou `aggressive`, mas com faixas mais conservadoras que Assault porque LMGs combinam teto alto de municao e fogo sustentado. "Supressao" e linguagem tatica para fogo sustentado inspirada no uso em combate real; no MVP, permanece emergente em vez de impor penalidade artificial ao adversario.

Marksman escolhe uma variacao exclusiva Bolt-action ou Semiauto. Bolt-action possui teto total de 50 balas; Semiauto possui teto total de 90 balas e troca menor dano fixo por maior cadencia. As baselines globais iniciais sao dano 75 e recarga de 2,0 segundos para Bolt-action, e dano 70 e recarga de 3,35 segundos para Semiauto, usando Scout e SG-550 apenas como referencias mecanicas, nao como identidades obrigatorias. Armas de Marksman tambem usam presets completos de manuseio com faixas estreitas: `controlled` troca ritmo por estabilidade, enquanto `aggressive` melhora recuperacao ou cadencia ao custo de pior controle. Ambos os tetos incluem o carregador inserido, e ambas as variacoes recebem pistola com teto de 45, faca, uma flashbang e uma smoke. Perfis equivalentes a AWP e informacao automatica de alvos ficam fora do escopo.

Breacher escolhe uma variacao exclusiva pump-action/M3 ou semiautomatica/XM1014. Ambas recebem exatamente 40 cartuchos, pistola com teto de 45, faca, duas flashbangs e uma smoke; nenhuma recebe granada de fragmentacao, SMG, ferramenta de ruptura ou bonus passivo. Shotguns do Breacher usam presets completos de manuseio que trocam ritmo e controle sem alterar dano, comportamento dos pellets, alcance-base, recarga cartucho por cartucho, teto de 40 cartuchos ou identidade de curta distancia.

A primeira fase de gameplay reutiliza modo de dispositivo/desarme, ciclo de rodada, mapas legados, recarga classica, HUD exato de municao agregada, lanterna/visao noturna, armas no chao, verificacao de equipes empilhadas e logica de objetivo dos bots do CS 1.6. Arma coletada e a excecao do HUD: a contagem do carregador inserido fica desconhecida ate o jogador concluir check magazine ou recarregar. Partidas MVP usam 20 rodadas, troca de lados operacionais apos 10 rodadas, terminam quando uma equipe chega a 11 vitorias de rodada e permitem empate 10–10 sem overtime. Em cenarios reversiveis, o servidor troca os lados operacionais na metade da partida sem mudar a identidade da equipe. O equilibrio inicial usa `mp_limitteams 1` com `mp_autoteambalance 0`. Carregadores individuais ficam para uma segunda fase experimental. O catalogo inicial de pistolas contem `backup_pistol_45_standard`, `backup_pistol_9mm_capacity` e os perfis exclusivos do Marksman `marksman_pistol_45_suppressed` e `marksman_pistol_9mm_suppressed`; pistolas usam presets estreitos de manuseio `controlled`, `baseline` ou `quick`, enquanto burst da Glock, Desert Eagle, Dual Elites, Five-Seven e alternancia manual de silenciador ficam fora do MVP. Toda arma tematica comunitaria deve referenciar um perfil mecanico global aprovado; a assimetria compensada pode usar perfis diferentes dentro da mesma allowlist e orcamento de poder. A allowlist global de perfis do servidor vale igualmente em todos os mapas e modos legados suportados; cenarios nao podem filtra-la nem introduzir modos novos.

## Assets Legais

Este repositorio nao inclui binarios/assets da Valve, Half-Life, Counter-Strike, Steam ou runtime Xash3D.

Contribuidores precisam de uma instalacao Steam legal propria do Half-Life / Counter-Strike 1.6. O instalador copia os assets locais necessarios para pastas ignoradas em `runtime/`:

```text
runtime/xash3d/valve
runtime/xash3d/cstrike
runtime/xash3d/modcsbr
runtime/xash3d/steam_api.dll
```

Nao commite arquivos gerados de runtime, binarios de engine ou assets Valve/Counter-Strike.

## Requisitos

- Windows 11.
- Git for Windows.
- VS Code.
- Visual Studio Build Tools / Visual Studio Installer com o workload `Desktop development with C++`.
- CMake do workload C++ do Visual Studio.
- Python 3 disponivel como `python` no PATH, ou pelo Python launcher como `py -3`.
- Binarios oficiais Windows do Xash3D FWGS extraidos em `runtime/xash3d`.
- Half-Life / Counter-Strike 1.6 instalado localmente pela Steam.

Componentes do Visual Studio Installer usados por este projeto:

- Workload: `Desktop development with C++`.
- Ferramentas MSBuild.
- Ferramentas MSVC para x64/x86.
- Windows 11 SDK `10.0.26100.8249` ou mais novo.
- C++ CMake tools for Windows.
- C++ test tools core features.
- MSVC AddressSanitizer.
- vcpkg package manager.

Veja [docs/setup/windows-11.pt-BR.md](docs/setup/windows-11.pt-BR.md) para detalhes do instalador e comandos de verificacao.

## Inicio Rapido

Clone e inicialize os submodulos:

```powershell
git submodule sync --recursive
git submodule update --init --recursive
```

Coloque os submodulos principais de desenvolvimento nas branches `modcsbr` antes de edita-los:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/dev/switch-modcsbr-branches.ps1
```

Use tambem `-IncludeMainUI` depois que o submodulo aninhado `mainui_cpp` for forkado e tiver uma branch `modcsbr`.

Se o Half-Life da Steam nao estiver no local padrao, aponte os scripts para a pasta que contem `valve`, `cstrike` e `steam_api.dll`:

```powershell
$env:HALF_LIFE_DIR = "D:\SteamLibrary\steamapps\common\Half-Life"
```

Compile a GameDLL do servidor:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1
```

Compile as DLLs cliente e menu:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -UpdateSubmodules
```

Instale o runtime Xash3D local:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1 -Reset
```

Valide o comando de execucao:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
```

Execute:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

No menu principal, use `New Game` para criar uma partida local. Essa tela permite escolher mapa, definir maximo de jogadores e definir a quantidade de bots.
O default da ReGameDLL do mod e os configs de inicializacao/servidor ativam `mp_flashlight`, entao o comando normal da lanterna (`impulse 100`, geralmente no `F`) funciona em partidas locais.

## Layout do Runtime

O instalador gera um runtime local ignorado:

```text
runtime/xash3d/
  xash3d.exe
  valve/
  cstrike/
  steam_api.dll
  modcsbr/
    base copiada de cstrike
    arquivos sobrepostos de mod/modcsbr
    resource/mainui_english.txt
    resource/modcsbr_english.txt
    cl_dlls/client.dll
    cl_dlls/menu.dll
    dlls/mp.dll
```

`menu.dll` deve ficar ao lado de `client.dll`; a MainUI do Xash3D FWGS espera esse layout para `MenuFactory`.
Os arquivos de localizacao pertencentes ao mod sao dicionarios placeholder intencionalmente pequenos. Eles silenciam avisos de arquivos ausentes do CS16Client/MainUI sem commitar recursos de texto pertencentes a Valve.

## Layout do Repositorio

```text
mod/modcsbr/                  overlay fonte do mod
runtime/xash3d/               runtime local ignorado
scripts/build/                wrappers de build Windows
scripts/install/              instalador do runtime Xash3D
scripts/test/                 checagens de ambiente e launch
upstream/ReGameDLL_CS/        submodulo da GameDLL do servidor
upstream/cs16-client/         submodulo da DLL cliente com dependencias 3rdparty aninhadas
docs/                         notas de setup e arquitetura
specs/                        planejamento orientado por specs
```

O checkout aninhado `upstream/cs16-client/3rdparty/ReGameDLL_CS` pertence ao build do CS16Client. Trabalho na GameDLL do servidor para `modcsbr` deve ficar no submodulo de topo `upstream/ReGameDLL_CS`.

## Documentacao

- Setup do Windows:
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
- Visao de arquitetura:
  [English](docs/architecture/overview.md) |
  [Portugues](docs/architecture/overview.pt-BR.md) |
  [Espanol](docs/architecture/overview.es.md)
- Direcao de produto:
  [Visao](docs/product/product-vision.md) |
  [Pilares de design](docs/product/design-pillars.md)
- [Exploracao de gameplay no backlog: equipes, tipos de jogador e kits predefinidos](specs/backlog/teams-player-types-and-predefined-kits.md) (nao aprovada)
- [Spec aprovada do runtime](specs/approved/xash3d-fwgs-windows-runtime.md)

## Contribuindo

Mantenha mudancas pequenas e documente comportamento em `specs/` antes de grandes features. Nao commite arquivos gerados de runtime ou assets proprietarios de terceiros.

Antes de abrir um pull request, rode:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/check-windows-environment.ps1
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
```

Ao tocar em build, instalacao, launch, caminhos ou comportamento de workflow, atualize a documentacao relevante na mesma mudanca.

## Troubleshooting

Se o Xash3D nao encontrar `gfx.wad`, defina `HALF_LIFE_DIR` e reinstale o runtime.

Se o Xash3D informar que `MenuFactory` esta indisponivel, recompile o CS16Client e confirme:

```powershell
Test-Path runtime\xash3d\modcsbr\cl_dlls\menu.dll
```

Se executar `runtime\xash3d\xash3d.exe -game cstrike` abrir uma caixa de assert Microsoft Visual C++ para `g_hGameUIModule`, volte para o caminho de launch suportado do mod:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

Se `cl`, `msbuild` ou `cmake` estiverem ausentes, reabra o projeto a partir do Developer PowerShell e confirme que os componentes do Visual Studio Installer listados acima estao instalados.

Se o build do CS16Client informar que Python esta faltando, instale Python 3 com `Add python.exe to PATH` ou com o Python launcher habilitado. Se `python --version` apontar para `WindowsApps\python.exe` ou abrir a Microsoft Store, desabilite os aliases de execucao de app do Windows para `python.exe` e `python3.exe`.
