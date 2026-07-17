# Instalador de map packs comunitários no runtime de desenvolvimento

## Status

Concluído.

Esta spec registra a parte implementada e validada do fluxo de downloads locais e map packs comunitários. A preparação/download automático do Xash3D FWGS foi separada para uma spec futura.

## Objetivo

Permitir que um desenvolvedor instale mapas comunitários opcionais no runtime local `runtime/xash3d/modcsbr` sem versionar mapas, assets de terceiros, ZIPs ou downloads no repositório principal.

## Resultado implementado

Foi criado o script:

```text
scripts/install/community-maps-windows.ps1
```

Ele permite:

- listar mapas disponíveis em release:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/community-maps-windows.ps1 -FromRelease -List
```

- instalar todos os mapas permitidos do release mais recente:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/community-maps-windows.ps1 -FromRelease -All
```

- instalar mapas específicos:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/community-maps-windows.ps1 -FromRelease -Maps cs_rio,fy_poolparty
```

- validar sem instalar:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/community-maps-windows.ps1 -FromRelease -All -ValidateOnly
```

- usar um checkout local do catálogo para manutenção:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/community-maps-windows.ps1 -CommunityMapsDir C:\dev\community-maps -All
```

## Fonte dos pacotes

O repo externo `modcsbr/community-maps` publica releases automatizados com:

- um ZIP por mapa;
- `community-maps-full.zip`;
- `manifest-index.json`;
- `checksums.sha256`.

Release validado:

```text
community-maps-2-1
```

## Regras de segurança implementadas

- Downloads ficam em `.downloads/community-maps`.
- O runtime gerado fica em `runtime/xash3d/modcsbr`.
- O script valida `manifest-index.json`, `checksums.sha256` e os hashes dos arquivos declarados nos manifests.
- O script só instala mapas com `redistribution: allowed` ou `permission-granted`.
- O script recusa copiar fora de `runtime/xash3d/modcsbr`.
- O script falha quando um arquivo de destino existe com conteúdo diferente, a menos que `-Force` seja usado.
- O script aceita `-NoDownload` para reutilizar cache já baixado.

## Validação realizada

Foram validados:

- sintaxe PowerShell do script;
- listagem via latest GitHub Release;
- validação via latest GitHub Release;
- validação via checkout local `C:\dev\community-maps`;
- instalação em runtime falso;
- instalação no runtime real;
- smoke test de carregamento dos quatro mapas no Xash3D.

Mapas validados:

```text
cs_rio
de_sampa
fy_pool_day
fy_poolparty
```

No smoke test, os quatro mapas permaneceram com processo Xash3D vivo por tempo suficiente para indicar ausência de falha fatal imediata de carregamento.

## Documentação atualizada

Foram atualizados:

- `README.md`;
- `README.pt-BR.md`;
- `README.es.md`;
- `docs/setup/xash3d-windows.md`;
- `docs/setup/xash3d-windows.pt-BR.md`;
- `docs/setup/xash3d-windows.es.md`;
- `CHANGELOG.md`.

## Fora do escopo concluído

- Baixar ou atualizar automaticamente o Xash3D FWGS.
- Baixar assets Valve/Steam.
- Distribuir assets oficiais do Counter-Strike.
- Resolver autoria/licença de novos mapas automaticamente.
- Instalar mapas comunitários por padrão.
- Criar UI gráfica de seleção de mapas.
- Sincronizar com Steam Workshop.

## Próxima spec relacionada

O download e atualização controlada do Xash3D FWGS deve ser tratado separadamente, com versão fixada, fonte oficial e hash conhecido.
