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
