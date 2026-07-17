# Downloads locais, runtime de desenvolvimento e map packs

## Objetivo

Definir um fluxo técnico para preparar o ambiente local de desenvolvimento do `modcsbr` sem versionar binários de runtime, assets Valve/Steam, engine Xash3D ou mapas comunitários dentro do repositório principal.

A ideia central é usar:

- `.downloads/` como cache local ignorado;
- `runtime/` como instalação local gerada;
- `modcsbr/community-maps` como catálogo opcional de mapas comunitários;
- binários oficiais do Xash3D FWGS como runtime da engine, sem fork da engine neste projeto.

Esta spec permanece em `backlog` até ser aprovada para implementação.

## Proposta original

Criar um diretório local como `./.downloads` para baixar assets externos usados no desenvolvimento, como map packs comunitários e binários do Xash3D FWGS.

Depois, criar scripts para:

1. buscar ou atualizar esses arquivos;
2. validar o que foi baixado quando houver manifesto/hash;
3. copiar ou extrair os arquivos para `runtime/xash3d`;
4. deixar o runtime pronto para desenvolvimento local.

Também foi proposto que o Xash3D FWGS possa ser baixado/atualizado automaticamente quando `runtime/xash3d` não existir ou quando houver uma versão mais atual, já que o projeto não pretende manter um fork da engine.

## Princípios

- O repositório principal não deve commitar downloads, ZIPs, binários de engine, assets Valve/Steam ou mapas comunitários.
- `.downloads/` é cache descartável, não fonte de verdade.
- `runtime/` é saída gerada, não fonte de verdade.
- Mapas comunitários continuam fora do repo principal.
- O consumo de mapas comunitários deve ser opcional para desenvolvimento.
- O instalador não deve depender de um mapa comunitário para funcionar.
- O Xash3D FWGS deve vir de distribuição oficial ou fonte explicitamente configurada.
- Scripts devem preferir validação por hash quando o artefato tiver manifesto conhecido.

## Modelo recomendado

### Diretórios

```text
.downloads/
  xash3d/
  community-maps/

runtime/
  xash3d/
    xash3d.exe
    valve/
    cstrike/
    modcsbr/
```

`./.downloads` e `./runtime` devem permanecer ignorados pelo Git.

### Responsabilidades

| Área | Responsabilidade |
| --- | --- |
| `.downloads/` | Cache local de ZIPs, releases, clones temporários ou pacotes baixados. |
| `runtime/xash3d/` | Instalação local executável usada nos testes. |
| `mod/modcsbr/` | Overlay fonte versionado do mod. |
| `modcsbr/community-maps` | Catálogo externo opcional de mapas comunitários, manifests e payloads permitidos. |
| scripts de instalação | Baixar, validar, extrair e copiar para o runtime. |

## Fluxo para mapas comunitários

### MVP técnico

Criar um script opcional para instalar map packs comunitários no runtime.

Nome sugerido:

```text
scripts/install/community-maps-windows.ps1
```

Comportamento recomendado:

1. aceitar um caminho local para `community-maps`;
2. se o caminho não existir, permitir clonar/baixar o catálogo para `.downloads/community-maps`;
3. ler os `manifest.json`;
4. validar arquivos hospedados por hash;
5. copiar `maps/<mapa>/files/**` para `runtime/xash3d/modcsbr/**`;
6. permitir instalar todos os mapas ou uma lista explícita;
7. não sobrescrever arquivos conflitantes sem uma opção clara.

Exemplo conceitual:

```text
C:\dev\community-maps\maps\cs_rio\files\maps\cs_rio.bsp
        -> runtime\xash3d\modcsbr\maps\cs_rio.bsp

C:\dev\community-maps\maps\cs_rio\files\gfx\env\riobk.tga
        -> runtime\xash3d\modcsbr\gfx\env\riobk.tga
```

### Parâmetros sugeridos

```text
-CommunityMapsDir C:\dev\community-maps
-Maps cs_rio,de_sampa
-All
-Force
-ValidateOnly
-NoDownload
```

### Regras de segurança

- Se `manifest.json` existir, validar hash antes de copiar.
- Se o arquivo de destino existir com hash diferente, falhar por padrão.
- `-Force` pode sobrescrever, mas deve mostrar quais arquivos serão substituídos.
- Não copiar arquivos fora de `runtime/xash3d/modcsbr`.
- Não instalar arquivos marcados como `redistribution: unknown`, `not-allowed`, `valve-owned` ou `remove`.
- Não copiar artefatos temporários de `.downloads`.

## Fluxo para Xash3D FWGS

### MVP técnico

Evoluir o instalador atual para conseguir preparar `runtime/xash3d` quando os binários oficiais ainda não existem localmente.

Nome possível:

```text
scripts/install/xash3d-fwgs-windows.ps1
```

Ou manter a responsabilidade no instalador atual:

```text
scripts/install/modcsbr-xash3d-windows.ps1
```

com novos parâmetros.

### Comportamento recomendado

1. detectar se `runtime/xash3d/xash3d.exe` existe;
2. se não existir, baixar uma release oficial configurada do Xash3D FWGS para `.downloads/xash3d`;
3. validar hash quando conhecido;
4. extrair para `runtime/xash3d`;
5. depois executar o fluxo já existente que copia assets Steam locais, overlay do mod e DLLs compiladas.

### Atualização de versão

Para o primeiro script, a atualização automática para “a versão mais nova” deve ser evitada.

Recomendação:

- usar uma versão fixada/configurada;
- registrar a versão esperada em documentação ou arquivo simples de configuração;
- permitir `-UpdateXash3D` apenas quando a fonte e o hash forem conhecidos;
- não depender de scraping de páginas;
- não trocar engine automaticamente no meio de um teste sem comando explícito.

Motivo: “mais recente” pode quebrar compatibilidade, mudar comportamento de runtime ou introduzir regressões difíceis de diagnosticar.

## Integração com o instalador atual

O fluxo atual de instalação do runtime deve continuar funcionando sem mapas comunitários.

Ordem recomendada quando tudo for usado:

1. preparar ou atualizar `runtime/xash3d`;
2. copiar assets legais locais de Half-Life/Counter-Strike da instalação Steam do usuário;
3. gerar `runtime/xash3d/modcsbr`;
4. aplicar overlay de `mod/modcsbr`;
5. copiar DLLs compiladas;
6. opcionalmente instalar mapas comunitários;
7. executar smoke test com `-game modcsbr`.

## Fora de escopo do primeiro script

- Forkar ou compilar a engine Xash3D FWGS.
- Baixar assets Valve/Steam.
- Distribuir assets oficiais do Counter-Strike.
- Instalar mapas comunitários por padrão.
- Resolver autoria/licença de novos mapas automaticamente.
- Criar UI gráfica de seleção de mapas.
- Sincronizar com Steam Workshop.
- Atualizar para a versão mais recente do Xash3D sem versão/hash explícitos.
- Instalar conteúdo marcado como redistribuição desconhecida.

## Hipóteses

- Desenvolvedores podem ter `C:\dev\community-maps` localmente.
- O repo `modcsbr/community-maps` pode ser clonado quando necessário.
- Manifests do `community-maps` são a fonte de validação para hashes e status de redistribuição.
- O Xash3D FWGS continuará sendo usado como binário oficial, não como submódulo ou fork.
- O ambiente de desenvolvimento principal continua sendo Windows.

## Decisões pendentes

- Qual URL/release oficial do Xash3D FWGS será considerada a versão fixada inicial?
- Onde registrar a versão/hash esperados do Xash3D?
- O instalador atual deve incorporar o download do Xash3D ou isso deve ser um script separado?
- O script de mapas deve clonar o repo `community-maps` automaticamente ou exigir caminho local na primeira versão?
- Map packs devem ser instalados todos por padrão quando `-All` for usado ou apenas uma allowlist inicial?
- Como reportar arquivos ausentes referenciados por `.res` mas não presentes no pacote preservado?
- O script deve gerar algum índice local de mapas instalados?

## MVP recomendado

1. Adicionar `.downloads/` ao `.gitignore`.
2. Criar script de instalação opcional de mapas comunitários a partir de um `CommunityMapsDir` local.
3. Validar manifests e hashes antes da cópia.
4. Copiar apenas para `runtime/xash3d/modcsbr`.
5. Documentar o uso em `docs/setup/xash3d-windows.md`.
6. Só depois evoluir para download/clonagem automática do `community-maps`.
7. Tratar download/atualização do Xash3D como etapa separada, com versão fixada e hash conhecido.

## Critérios de sucesso

- Um dev com `C:\dev\community-maps` consegue instalar `cs_rio`, `de_sampa`, `fy_pool_day` e `fy_poolparty` no runtime local sem copiar manualmente arquivos.
- O repo principal continua sem binários de mapas comunitários.
- O script falha se um hash de manifesto não bater.
- O script não copia nada para fora de `runtime/xash3d/modcsbr`.
- O runtime continua funcionando sem mapas comunitários.
- O Xash3D não é atualizado automaticamente sem comando explícito e versão conhecida.

## Recomendação final

A ideia é boa e deve virar fluxo oficial de desenvolvimento, mas em duas fases.

Na primeira fase, implementar apenas instalação opcional de mapas a partir de um checkout local de `community-maps`, usando `.downloads/` só como cache futuro e `runtime/` como destino gerado.

Na segunda fase, adicionar download/clonagem automática do `community-maps` e preparação do Xash3D FWGS com versão fixada, hash conhecido e atualização explícita.
