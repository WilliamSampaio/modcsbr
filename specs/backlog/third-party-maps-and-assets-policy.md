# Política para mapas e assets de terceiros

Status: backlog — política proposta; catálogo externo criado e limpeza inicial do repo principal aplicada

## Objetivo

Definir como o `modcsbr` deve lidar com mapas, NAVs, overviews, sons, modelos, skyboxes e outros assets criados por terceiros ou baixados da internet.

O objetivo é evitar que o repositório principal vire um pacote redistribuidor de conteúdo comunitário sem origem, licença e créditos verificáveis.

## Problema

O repositório principal atualmente versiona mapas e assets comunitários que parecem ter vindo de fontes externas. Isso cria três riscos:

- **licença e permissão:** o fato de um mapa estar disponível na internet não significa que ele pode ser redistribuído neste projeto;
- **crédito:** autores, colaboradores, portadores e mirrors podem ser confundidos;
- **autenticidade:** arquivos `.bsp`, `.res`, `.nav`, sons e modelos podem ter sido alterados por servidores, repacks, ports ou mirrors sem manter histórico claro.

## Decisão proposta

O repositório principal `modcsbr` não deve manter binários de mapas/assets de terceiros sem origem e permissão documentadas.

Mapas comunitários devem ir para o repositório separado:

```text
github.com/modcsbr/community-maps
```

Esse repositório separado deve começar como catálogo auditável, não como dump de arquivos.

## O que pode ficar no repo principal

Pode permanecer no `modcsbr`:

- arquivos próprios do mod;
- configurações mínimas;
- placeholders `.gitkeep`;
- scripts de instalação;
- documentação;
- specs;
- assets autorais do projeto com licença clara;
- arquivos pequenos necessários para desenvolvimento, desde que sua origem esteja documentada.

Não deve permanecer no repo principal:

- mapas `.bsp` de terceiros;
- `.nav` gerados para mapas de terceiros, salvo se forem tratados como derivativos com permissão clara;
- `.res`, `.txt` e overviews associados a mapas redistribuídos;
- sons, modelos, sprites, skyboxes e WADs de terceiros sem licença/permissão;
- assets extraídos de instalações Steam/Valve;
- repacks baixados de mirrors sem cadeia de origem.

## Inventário inicial a auditar

Arquivos versionados que precisam de auditoria antes de qualquer redistribuição:

| Item | Tipo | Status recomendado |
|---|---|---|
| `mod/modcsbr/maps/cs_rio.bsp` | mapa comunitário | mover para catálogo, exigir origem/permissão |
| `mod/modcsbr/maps/de_sampa.bsp` | mapa comunitário | mover para catálogo, exigir origem/permissão |
| `mod/modcsbr/maps/fy_pool_day.bsp` | mapa comunitário | mover para catálogo, exigir origem/permissão |
| `mod/modcsbr/maps/fy_poolparty.bsp` | mapa comunitário | mover para catálogo, exigir origem/permissão |
| `mod/modcsbr/maps/*.nav` | navegação de bot | auditar origem; pode ser derivativo |
| `mod/modcsbr/maps/*.res` | dependências de mapa | auditar junto do mapa |
| `mod/modcsbr/maps/*.txt` | descrição de mapa | auditar junto do mapa |
| `mod/modcsbr/overviews/*` | overview/radar | auditar junto do mapa |
| `mod/modcsbr/gfx/env/*` | skyboxes | auditar origem |
| `mod/modcsbr/models/sampa/*` | modelos | auditar junto de `de_sampa` |
| `mod/modcsbr/sound/*` | sons | auditar origem |
| `mod/modcsbr/sprites/*` | sprites | auditar origem |
| `maps/fy_teste.rmf` | fonte de mapa | confirmar autoria antes de manter |

## Limpeza inicial aplicada

O repo principal removeu do versionamento os binários e assets diretamente acoplados aos quatro mapas comunitários iniciais:

- `cs_rio`;
- `de_sampa`;
- `fy_pool_day`;
- `fy_poolparty`.

Foram removidos mapas, NAVs, RES/TXT, overviews, skyboxes e assets diretamente referenciados pelos `.res`, além do waypoint PODBot de `de_sampa`.

Os payloads, metadados e hashes foram movidos para o catálogo externo `github.com/modcsbr/community-maps`. O template em `docs/assets/community-maps-repo-template` continua servindo como referência de estrutura e validação para novos pacotes.

Esta limpeza não removeu NAVs de mapas oficiais do CS 1.6 nem alterou runtime local, submódulos ou assets copiados da instalação Steam do usuário.

Hashes atuais dos BSPs versionados:

| Arquivo | SHA256 | MD5 |
|---|---|---|
| `cs_rio.bsp` | `090BABAA55F3E6DD2BE47FE844244D1E86F554ED0676B1DA01AA44138ABEA1BB` | `0D3FB1CEE6B9666E349EE8443FBEE5F0` |
| `de_sampa.bsp` | `ECDA9EACEA3494755275C434BA47445450AE2C69F089B985A3147A48965A20FD` | `5A646D8B0AACA0E56C9C53C68533C9D3` |
| `fy_poolparty.bsp` | `44F696ADE6C9F457BE8C5FEEE737D248A01E14D86F94296DD96ABAAFE55C3CB3` | `E8E2A6593BFE60A3820A211D5699D4D9` |
| `fy_pool_day.bsp` | `FB22BA78A20D762A7114BDD56D62EC01794695AC48C6777F1BBD676AB769D208` | `70467B0201468CC5CFF7712C7A276299` |

## Como verificar origem e autenticidade

Para cada mapa ou asset, registrar:

1. nome do arquivo original;
2. hash SHA256 e MD5;
3. tamanho em bytes;
4. fonte de download;
5. data de download;
6. autor original declarado;
7. autores de ports, edits ou repacks, quando houver;
8. licença ou declaração de redistribuição;
9. dependências do `.res`;
10. arquivos acompanhantes;
11. evidências de origem;
12. status de redistribuição.

Uma fonte boa é, em ordem de preferência:

1. site oficial do autor;
2. página arquivada do autor;
3. pacote original preservado com créditos internos;
4. repositório ou página oficial de uma comunidade reconhecida;
5. mirror que preserva créditos e arquivos originais;
6. mirror sem créditos claros.

Mirrors sem créditos claros não bastam para hospedar o binário no projeto.

## Manifesto recomendado para o repo de mapas

Cada mapa deve ter um diretório próprio:

```text
maps/cs_rio/
  README.md
  manifest.json
  files/
    .gitkeep
```

O diretório `files/` só deve receber binários quando a redistribuição estiver permitida ou explicitamente aceita pelo responsável do produto.

Exemplo de `manifest.json`:

```json
{
  "id": "cs_rio",
  "title": "cs_rio",
  "game": "Counter-Strike 1.6",
  "authors": [
    {
      "name": "Mataleone",
      "role": "map author",
      "source": "source pending confirmation"
    }
  ],
  "redistribution": "unknown",
  "source_status": "unverified",
  "files": [
    {
      "path": "cs_rio.bsp",
      "sha256": "090BABAA55F3E6DD2BE47FE844244D1E86F554ED0676B1DA01AA44138ABEA1BB",
      "md5": "0D3FB1CEE6B9666E349EE8443FBEE5F0",
      "size_bytes": 3997188
    }
  ],
  "notes": [
    "Do not redistribute until source and permission are documented."
  ]
}
```

Valores permitidos para `redistribution`:

- `allowed`;
- `permission-granted`;
- `unknown`;
- `not-allowed`;
- `valve-owned`;
- `remove`.

Valores permitidos para `source_status`:

- `primary`;
- `archived-primary`;
- `community-preserved`;
- `mirror-only`;
- `unverified`.

## Fontes iniciais encontradas

Estas fontes servem apenas como ponto de partida. Elas não aprovam redistribuição automaticamente.

- `de_sampa`: página arquivada do Mataleone informa Half-Life / Counter-Strike, Bomb Defuse, mapeado por Mataleone, design/texturas por Mataleone & Crocodilo, lançamento em 12/Abr/2002 e download `de_sampa.zip`.
  - https://arquivo.mataleone.com/php/main.php?map=de_sampa&page=map
- `cs_rio`: fontes públicas citam autores como Mataleone/Crocodilo e também Joca Prado/Roger Sodré em matéria jornalística; a divergência precisa ser reconciliada antes de crédito final.
  - https://www.uol.com.br/start/ultimas-noticias/2017/04/28/csrio-como-mapa-feito-por-fas-fez-counter-strike-ser-banido-do-brasil.htm
  - https://www.hardmob.com.br/threads/750-Vote-cs_rio
- `fy_pool_day`: fontes comunitárias citam Squall como autor.
  - https://gamemodding.com/en/counter-strike-1-6/maps/53358-fy_pool_day.html
  - https://mods.vg/maps/fy-pool-day
- `fy_poolparty`: fontes de ports/reuploads citam Squall como autor original, mas ainda precisam de confirmação primária.
  - https://steamcommunity.com/sharedfiles/filedetails/?id=2292172552

## Política de instalação futura

O instalador do `modcsbr` não deve depender de mapas comunitários não auditados.

Fluxo recomendado:

1. instalar runtime base com assets legais do Steam local do usuário;
2. overlay do `modcsbr`;
3. opcionalmente instalar map packs externos;
4. validar hashes e manifestos antes de copiar arquivos externos;
5. avisar quando um mapa estiver ausente em vez de embutir cópia não auditada.

## Fora de escopo desta spec

- Automatizar download/instalação dos pacotes hospedados no repositório `community-maps`.
- Promover novos mapas além do catálogo inicial.
- Contatar autores.
- Decidir licenças caso a licença original esteja ausente.
- Reescrever instaladores.

## Próximo passo recomendado

1. Usar `github.com/modcsbr/community-maps` como catálogo separado de mapas comunitários.
2. Migrar primeiro os metadados e hashes, não os binários.
3. Remover do repo principal os binários de mapas/assets comunitários sem origem clara.
4. Atualizar instaladores para tratar map packs externos como opcionais.
