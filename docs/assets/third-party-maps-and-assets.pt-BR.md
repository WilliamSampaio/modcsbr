# Mapas e assets de terceiros

O `modcsbr` não deve usar o repositório principal como dump de mapas comunitários ou pacotes de assets baixados da internet.

Mapas de terceiros, arquivos NAV, overviews, sons, modelos, sprites, skyboxes e WADs precisam de origem, créditos, hashes e status de redistribuição documentados antes de serem hospedados pelo projeto.

Política:

- manter o repo principal focado em código, configuração, documentação, specs, scripts e assets próprios;
- não versionar assets da Valve/Steam nem runtime gerado;
- não versionar binários de mapas comunitários sem permissão e procedência documentadas;
- registrar metadados de mapas de terceiros em um repo separado de map packs antes de hospedar arquivos;
- tratar mirrors sem créditos como evidência insuficiente para redistribuição;
- preferir instalação opcional de map packs em vez de embutir mapas comunitários no mod principal.

A proposta de política atual está em:

- [Política para mapas e assets de terceiros](../../specs/backlog/third-party-maps-and-assets-policy.md)

O seed inicial do repositório separado está em:

- [Template do repositório de mapas comunitários](community-maps-repo-template/README.md)

O catálogo externo é:

- https://github.com/modcsbr/community-maps

O repositório principal `modcsbr` não hospeda mais os payloads comunitários iniciais não auditados de `cs_rio`, `de_sampa`, `fy_pool_day` e `fy_poolparty`. Os metadados permanecem no catálogo externo até a origem e a redistribuição serem resolvidas.
