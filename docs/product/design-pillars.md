# Pilares de design — modcsbr

Status: pilares iniciais confirmados

## 1. Retrocompatibilidade antes de reinvenção de mapas

Mapas e modos do Counter-Strike 1.6 devem continuar sendo uma base utilizável do mod.

- Mapas legados devem carregar sem recompilação específica para `modcsbr`.
- O primeiro protótipo funcional reutiliza instalar/desarmar dispositivo, ciclo de rodada, condições de vitória e mapas legados. Modos novos não fazem parte do escopo atual do produto.
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
- A referência principal de balanceamento do MVP é 10 contra 10.
- A faixa obrigatória de validação é 6v6 a 12v12.
- Partidas até 16v16 são suportadas quando mapa e servidor comportarem, mas não são o centro do balanceamento inicial.
- Nenhum kit deve ser balanceado exclusivamente para 5v5.
- Entradas e trocas mantêm diferença máxima de um jogador ativo entre equipes.
- Reconexão não reserva vaga e segue a disponibilidade existente.
- A configuração inicial usa `mp_limitteams 1` para permitir diferença máxima de um jogador e `mp_autoteambalance 0` para não transferir pessoas automaticamente.
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
- O catálogo inicial do Assault usa quatro perfis globais: 7,62 de poder/AK-47, 5,56 de controle/M4A1 sem silenciador, 9 mm de controle/MP5 e .45 de poder/UMP-45. As referências não obrigam identidade visual.
- Primárias do Assault usam somente fogo automático no MVP; burst, silenciador acoplável, FAMAS, Galil, TMP, MAC-10 e P90 ficam fora do catálogo inicial.
- Support usa um único kit de machine gun, pistola, faca, uma flashbang e uma smoke. O catálogo inicial possui dois perfis globais: `support_lmg_556_sustain`, baseado na M249, com dano 32 e cadência-base de 600 RPM, e `support_lmg_762_power`, com dano 36, cadência-base de 500 RPM e recuo mais pesado. Ambos usam recarga de 4,7 s, capacidade-base 100 e teto do slot 250. “Supressão” descreve o uso tático de fogo sustentado, e seu efeito vem da ameaça real do fogo, nunca de perda artificial de controle do adversário.
- Marksman escolhe Bolt-action com teto total de 50 balas ou Semiauto com teto total de 90 balas; Semiauto possui dano global menor e cadência maior que Bolt-action. Ambas recebem pistola, faca, uma flashbang e uma smoke. Os tetos incluem o carregador inserido; Scout e SG-550 são apenas referências mecânicas iniciais, enquanto perfis equivalentes à AWP e marcação automática ficam fora do MVP.
- O catálogo inicial de pistolas possui dois perfis normais para todos os tipos, `.45` padrão/USP sem silenciador e `9 mm` de capacidade/Glock18 sem burst, além de perfis `.45` e `9 mm` silenciados restritos ao Marksman. Dano é fixo por perfil; skins comunitárias ajustam apresentação, recuo, cadência e precisão apenas dentro do intervalo permitido. Desert Eagle, Dual Elites, Five-Seven, burst da Glock e alternância manual de silenciador ficam fora do MVP.
- Pistolas usam presets inteiros de manuseio (`controlled`, `baseline` ou `quick`) com faixas estreitas. O preset `quick` melhora responsividade com pior controle; nenhum preset cria burst, muda silenciador, altera dano ou transforma backup em primária.
- Em cenários reversíveis, os lados operacionais são trocados na metade da partida sem mover jogadores entre identidades de equipe.
- A partida MVP usa 20 rodadas, troca de lados após 10 rodadas, vitória da primeira equipe a 11 rodadas e empate 10–10 permitido sem overtime. Os tempos internos da rodada começam nas baselines do CS 1.6.
- Breacher escolhe pump-action/M3 ou semiautomática/XM1014 como variações laterais exclusivas, ambas com teto exato de 40 cartuchos, pistola, faca, duas flashbangs e uma smoke; não acumula SMG, fragmentação, ferramenta de ruptura ou bônus passivo.
- Sobreviventes preservam uma arma coletada entre rodadas somente como substituição do mesmo slot; o teto de munição e o dano continuam pertencendo à categoria da arma, e trocar tipo ou variação restaura o kit.
- A Fase 1 usa munição agregada, recarga clássica e HUD exato legados. Carregadores individuais e recarga tática são uma Fase 2 experimental.

## 6. Conteúdo comunitário dentro das regras

A comunidade deve poder criar equipes temáticas que não sejam apenas skins.

- Criadores definem identidade, aliases e mapeamentos permitidos de equipamento.
- Dano é fixo no perfil global da arma.
- Cada arma temática referencia obrigatoriamente um perfil mecânico global aprovado; calibre que altera dano, recuo, cadência ou capacidade pertence a esse perfil, não é apenas apresentação.
- Assimetria compensada por perfis diferentes é permitida dentro da mesma allowlist e orçamento de poder. A allowlist global do servidor é uniforme para todos os mapas e modos; cenários não restringem perfis.
- A categoria mecânica não pode ser falsificada pela apresentação: rifle usa dano de rifle, SMG usa dano de SMG e shotgun usa dano de shotgun.
- Capacidade do carregador pode variar de 1 até o teto de balas do contrato.
- Os extremos desse intervalo são válidos quando comunicados coerentemente pelos modelos, animações, sons e HUD.
- Recuo e cadência podem ser ajustados dentro dos intervalos do contrato.
- Recuo e cadência são validados como combinação dentro de uma região conjunta; valores isoladamente permitidos não garantem que o par seja válido.
- No Assault, o MVP usa presets inteiros de manuseio (`controlled`, `baseline` ou `aggressive`) por arma temática, em vez de sliders livres. O preset altera controle dentro do perfil; dano, calibre, penetração, recarga, mobilidade, modo de disparo e teto de munição continuam fixos.
- No Support, os presets de manuseio seguem a mesma forma, mas são mais conservadores: LMGs possuem mais munição e fogo sustentado, então `aggressive` não pode virar cadência alta com controle fácil.
- No Marksman, os presets de manuseio são ainda mais estreitos: `controlled` sacrifica ritmo por estabilidade e `aggressive` paga recuperação/cadência com pior controle. Nenhum preset remove vulnerabilidade em curta distância ou transforma Bolt-action em Semiauto.
- No Breacher, presets de manuseio preservam a identidade de curta distância: podem trocar ritmo e controle, mas não mudam dano, pellets, alcance-base, recarga cartucho por cartucho, teto de 40 cartuchos nem transformam shotgun em arma de médio alcance.
- Capacidade, munição total, comportamento, tempo e animação de recarga são parâmetros independentes; capacidade não calcula automaticamente a duração da recarga.
- No MVP, cada categoria de arma possui um único tempo de recarga definido pelo jogo e validado pelo servidor; criadores não podem alterá-lo e os assets apenas comunicam a regra aceita.
- A baseline de tempo é o CS 1.6. Escopetas pump-action e semiautomáticas preservam respectivamente os comportamentos da M3 e da XM1014, inclusive recarga cartucho por cartucho; fogo totalmente automático não pertence ao MVP.
- O contrato deve impedir combinações dominantes mesmo quando cada valor isolado estiver no intervalo.
- O servidor valida o pacote completo antes da partida.
- Conteúdo inválido não é aplicado parcialmente.
- Extensibilidade não autoriza ultrapassar tetos, remover fraquezas ou confiar estado competitivo ao cliente.
