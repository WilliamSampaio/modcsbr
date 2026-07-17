# Visao de Arquitetura

O projeto separa codigo original de terceiros, arvores locais de runtime ignoradas e arquivos customizados do mod.

## Upstream

`upstream/ReGameDLL_CS` contem o projeto ReGameDLL_CS como submodulo Git. A URL aponta para `WilliamSampaio/ReGameDLL_CS` e acompanha a branch `modcsbr`, onde o trabalho especifico da GameDLL de servidor deve ficar.

`upstream/cs16-client` contem o projeto CS16Client como submodulo Git. A URL aponta para `WilliamSampaio/cs16-client` e acompanha a branch `modcsbr`, onde o trabalho especifico do client DLL deve ficar.

CS16Client tem dependencias aninhadas em `upstream/cs16-client/3rdparty`, incluindo um checkout aninhado de `ReGameDLL_CS`. Esse checkout existe para o grafo de build e interfaces compartilhadas do CS16Client. Ele nao e a arvore autoritativa da GameDLL de servidor deste repositorio; use o submodulo de topo `upstream/ReGameDLL_CS` para trabalho em `mp.dll`.

`runtime/xash3d` e um runtime local ignorado contendo binarios oficiais do Xash3D FWGS, assets base da Steam e a pasta instalada `modcsbr`. A pasta instalada `modcsbr` e gerada a partir de uma copia local dos assets Steam `cstrike`, com arquivos do repositorio e DLLs compiladas aplicados por cima.

## Arquivos do Mod

`mod/modcsbr` e reservado para o layout fonte do mod copiado para o runtime Xash3D:

- `cl_dlls/` - saida compilada do CS16Client como `client.dll` e `menu.dll`.
- `dlls/` - saida compilada da GameDLL para testes.
- `models/` - assets de modelos.
- `sound/` - assets de som.
- `sprites/` - assets de sprites.
- `resource/` - arquivos de UI/resource.
- `maps/` - arquivos de mapas.

O runtime Windows ativo fica em:

```text
runtime/xash3d/modcsbr
```

A instalacao Xash3D usa `modcsbr/liblist.gam`, carrega `cl_dlls/client.dll`, `cl_dlls/menu.dll` e `dlls/mp.dll`, e mantem uma base local completa de assets `cstrike` dentro da pasta ignorada de runtime do mod.

## Specs

Mudancas de gameplay e feature devem comecar como specs. Mova specs por:

- `specs/backlog`
- `specs/approved`
- `specs/implementing`
- `specs/completed`

A proposta atual de equipes, composicao livre de tipos, diferenca maxima de um jogador ativo entre equipes e aliases por equipe esta documentada em [`specs/backlog/teams-player-types-and-predefined-kits.md`](../../specs/backlog/teams-player-types-and-predefined-kits.md). A intencao e que o servidor valide a disponibilidade em entradas, trocas e reconexoes; reconectar nao reserva a vaga da equipe anterior. O codigo atual do ReGameDLL_CS e do CS16Client usa um maximo de 32 clientes, enquanto cada servidor pode configurar menos. A proposta permanece nao aprovada e nao descreve gameplay implementada.

Retrocompatibilidade com mapas e modos de jogo do CS 1.6 e um pilar inicial do produto. Mudancas futuras de gameplay devem preservar a leitura das entidades legadas de spawn e objetivo e nao devem exigir recompilar mapas antigos apenas para carregar e concluir uma rodada. Identificadores internos legados dos lados podem permanecer como camada de compatibilidade mesmo quando as equipes exibidas usam outros nomes.

A direcao atual remove dinheiro e compra: o servidor concede um kit predefinido no spawn. Equipes criadas pela comunidade podem mapear armas e apresentacao tematicas sobre contratos globais de tipo. O dano permanece fixo no perfil global da arma. A capacidade do carregador pode variar de 1 ate o teto de balas do slot; recuo e cadencia podem variar dentro de intervalos e combinacoes validados pelo servidor. O servidor deve validar o pacote completo antes de aceita-lo. Carregar um mapa legado nao restaura a economia classica.

Capacidades extremas de carregador sao escolhas tematicas validas, como uma crossbow de tiro unico, mas o valor declarado permanece separado do asset visual e precisa respeitar o teto do slot. Modelos, animacoes, sons e HUD devem comunicar de forma coerente o comportamento aceito.
