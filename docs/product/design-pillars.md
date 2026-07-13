# Pilares de design — modcsbr

Status: pilares iniciais confirmados

## 1. Retrocompatibilidade antes de reinvenção de mapas

Mapas e modos do Counter-Strike 1.6 devem continuar sendo uma base utilizável do mod.

- Mapas legados devem carregar sem recompilação específica para `modcsbr`.
- Pontos de spawn, zonas e entidades de objetivo reconhecidas pela base devem continuar funcionais.
- Nomes técnicos legados podem permanecer internamente como compatibilidade, sem aparecer como identidade de produto.
- Geometria, rotas e objetivos não serão redimensionados dinamicamente pelo número de jogadores.
- Cada mapa pode ter uma quantidade recomendada de jogadores determinada por testes.
- Mudanças de gameplay precisam declarar quando alteram o balanceamento ou a experiência de um modo legado.

Este pilar não promete compatibilidade automática com plugins ou outros mods de terceiros, nem que todo mapa funciona bem com 32 jogadores ativos.

## 2. Contratos simétricos, identidade por equipe

Equipes podem ter nomes, modelos, vozes, aliases e armas temáticas diferentes, mas tipos equivalentes obedecem ao mesmo contrato competitivo.

- O contrato fixa slots, categorias, tetos de munição/utilidade e orçamento de poder.
- Alias e apresentação não possuem estatísticas próprias.
- Mapeamentos de armas só usam perfis e intervalos autorizados.
- Tipos equivalentes devem ser reconhecíveis por ícone, posição e descrição funcional.
- Vantagem de equipe deve vir de execução, não de conteúdo exclusivo superior.

## 3. Liberdade de composição

O jogador escolhe o tipo desejado sem cotas, reservas ou composição obrigatória.

- Uma equipe inteira pode escolher o mesmo tipo.
- Nenhum objetivo pode exigir um tipo específico.
- Composição dominante é problema de kit, mapa ou contrajogo, não justificativa automática para bloquear escolhas.
- O MVP disponibiliza Assault, Support, Marksman e Breacher para ambas as equipes; o catálogo poderá receber novos contratos após validação, sem herdar o limite histórico de quatro modelos do CS 1.6.

## 4. Escala comunitária com equilíbrio simples

O jogo aceita quantidades variáveis de jogadores dentro da capacidade do servidor.

- Não existe formato obrigatório de cinco contra cinco.
- Entradas e trocas mantêm diferença máxima de um jogador ativo entre equipes.
- Reconexão não reserva vaga e segue a disponibilidade existente.
- O servidor é autoritativo; o cliente apresenta as opções válidas e explica rejeições.

## 5. Kits predefinidos, sem economia

Dinheiro e compra não fazem parte do loop normal. O jogador nasce com o kit do tipo escolhido.

- Não há preços, recompensas monetárias, eco ou menu de compra.
- Mapas legados não reativam a economia.
- Cada kit precisa de uma fraqueza clara porque estará disponível em todas as rodadas.
- Munição e utilidades são limitadas pelo contrato do tipo e validadas pelo servidor.
- Todos os tipos recebem lanterna; visão noturna permanece uma opção em estudo.
- Todos os tipos recebem faca em slot próprio; equipes podem tematizar sua apresentação, nunca seus atributos globais.
- Assault escolhe Rifle ou SMG como variações laterais mutuamente exclusivas, sem receber as duas armas na mesma vida.
- Support usa um único kit de machine gun, pistola, faca, uma flashbang e uma smoke; sua supressão vem da ameaça real do fogo, nunca de perda artificial de controle do adversário.
- Marksman usa um único kit baseado na Scout, com pistola, faca, uma flashbang e uma smoke; disponibilidade livre não inclui perfil equivalente à AWP, rifle semiautomático ou marcação automática no MVP.
- Breacher escolhe pump-action/M3 ou semiautomática/XM1014 como variações laterais exclusivas, ambas com teto exato de 40 cartuchos, pistola, faca, duas flashbangs e uma smoke; não acumula SMG, fragmentação, ferramenta de ruptura ou bônus passivo.
- Sobreviventes preservam uma arma coletada entre rodadas somente como substituição do mesmo slot; o teto de munição e o dano continuam pertencendo à categoria da arma, e trocar tipo ou variação restaura o kit.

## 6. Conteúdo comunitário dentro das regras

A comunidade deve poder criar equipes temáticas que não sejam apenas skins.

- Criadores definem identidade, aliases e mapeamentos permitidos de equipamento.
- Dano é fixo no perfil global da arma.
- A categoria mecânica não pode ser falsificada pela apresentação: rifle usa dano de rifle, SMG usa dano de SMG e shotgun usa dano de shotgun.
- Capacidade do carregador pode variar de 1 até o teto de balas do contrato.
- Os extremos desse intervalo são válidos quando comunicados coerentemente pelos modelos, animações, sons e HUD.
- Recuo e cadência podem ser ajustados dentro dos intervalos do contrato.
- Capacidade, munição total, comportamento, tempo e animação de recarga são parâmetros independentes; capacidade não calcula automaticamente a duração da recarga.
- No MVP, cada categoria de arma possui um único tempo de recarga definido pelo jogo e validado pelo servidor; criadores não podem alterá-lo e os assets apenas comunicam a regra aceita.
- A baseline de tempo é o CS 1.6. Escopetas pump-action e semiautomáticas preservam respectivamente os comportamentos da M3 e da XM1014, inclusive recarga cartucho por cartucho; fogo totalmente automático não pertence ao MVP.
- O contrato deve impedir combinações dominantes mesmo quando cada valor isolado estiver no intervalo.
- O servidor valida o pacote completo antes da partida.
- Conteúdo inválido não é aplicado parcialmente.
- Extensibilidade não autoriza ultrapassar tetos, remover fraquezas ou confiar estado competitivo ao cliente.
