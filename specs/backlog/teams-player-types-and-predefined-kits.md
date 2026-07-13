# Equipes, tipos de jogador e kits predefinidos

Status: backlog — exploração de produto, não aprovada

## Convenções desta spec

- **Fato:** confirmado no repositório ou na arquitetura atual.
- **Hipótese:** suposição que precisa de playtest ou investigação.
- **Recomendação:** direção preferida para experimentar, ainda não aprovada.
- **Decisão pendente:** escolha que cabe ao responsável do produto.

Esta spec registra uma exploração de ideia e uma proposta de MVP. Ela não autoriza implementação. Os quatro tipos iniciais do MVP estão definidos, mas seus valores de kit não são permanentes. A remoção da economia e a concessão de kits predefinidos já são decisões confirmadas.

## Decisões de produto confirmadas

- **Decisão:** o produto usará **equipe** como termo para a identidade coletiva e para o grupo ao qual o jogador pertence. O termo anterior foi removido da linguagem do produto.
- **Decisão atualizada:** os tipos de jogador serão estruturalmente simétricos entre as equipes: mesmos contratos de slots, categorias, limites e orçamento. Cada equipe pode mapear armas e equipamentos temáticos dentro desses mesmos limites.
- **Decisão:** cada equipe poderá dar um nome temático diferente ao mesmo tipo base. Por exemplo, o mesmo tipo de precisão poderá ser apresentado como “Caçador” em uma equipe e “Matador” em outra; esses nomes são exemplos, não nomes aprovados.
- **Decisão:** não existe formato obrigatório de cinco jogadores por equipe. O servidor pode operar com quantidades variáveis dentro de sua capacidade configurada.
- **Decisão:** a composição de tipos é livre. Todos os jogadores de uma equipe podem escolher o mesmo tipo, sem cotas, reservas, filas ou tipos obrigatórios.
- **Decisão de MVP:** os quatro tipos iniciais fixos são Assault, Support, Marksman e Breacher, disponíveis simetricamente para as duas equipes.
- **Decisão de produto:** quatro tipos não é um limite estrutural. O catálogo poderá crescer após o MVP, desde que cada novo tipo possua contrato simétrico, função distinta, contrajogo e suporte de conteúdo e interface.
- **Decisão:** as equipes podem diferir em no máximo um jogador ativo. Quando uma equipe já tem um jogador a mais, somente a equipe menor fica disponível para novas entradas.
- **Decisão:** reconexão não reserva vaga nem garante a equipe anterior. O jogador obedece à disponibilidade existente no momento em que retorna.
- **Decisão:** preservar retrocompatibilidade com mapas e modos de jogo do Counter-Strike 1.6 é um objetivo estrutural do produto.
- **Decisão:** dinheiro, recompensas monetárias, preços e menu de compra deixam de fazer parte das regras normais do mod. Cada spawn recebe o kit predefinido do tipo escolhido.
- **Objetivo de produto:** permitir que a comunidade crie equipes temáticas, com nomes, modelos, vozes e mapeamentos próprios de equipamento, desde que respeitem contratos globais validados pelo servidor.
- **Decisão:** criadores não podem alterar dano. Cada perfil de arma tem dano padrão definido globalmente. Capacidade do carregador pode ser definida pelo criador entre 1 e o teto de balas do contrato. Recuo e cadência podem variar somente dentro dos intervalos definidos pelo contrato e validados pelo servidor.
- **Decisão:** capacidades extremas são intencionais quando sustentam a fantasia da arma temática; o contrato não impõe outra faixa além de 1 até o teto de balas do tipo/slot.
- **Decisão:** capacidade do carregador, teto total de munição, comportamento de recarga, tempo de recarga e animação são parâmetros separados. A capacidade não determina automaticamente a duração da recarga.
- **Decisão de MVP:** cada categoria de arma possui um único tempo de recarga definido pela regra do jogo. O pacote comunitário não pode alterá-lo. O servidor aplica o tempo da categoria; animação e som devem comunicá-lo, mas não são fontes autoritativas.
- **Decisão de MVP:** os tempos do CS 1.6 serão usados como baseline. Como o jogo original define valores por arma, cada categoria do contrato deve indicar explicitamente sua arma de referência.
- **Decisão de MVP:** escopetas possuem duas categorias: pump-action, com M3 como referência, e semiautomática, com XM1014 como referência. Ambas recarregam cartucho por cartucho. Escopetas de fogo totalmente automático ficam fora do MVP.
- **Regra decorrente:** aliases não alteram o contrato do tipo. Conteúdo temático pode trocar a representação e mapear opções permitidas, mas não exceder slots, categorias, munição, utilidade ou orçamento global.
- **Recomendação de legibilidade:** tipos equivalentes devem manter o mesmo ícone, posição no menu e descrição funcional para que o jogador reconheça a equivalência entre equipes.

## Registro da proposta original

A proposta recebida busca substituir a divisão permanente Terrorists/Counter-Terrorists por equipes e lados operacionais neutros; selecionar duas equipes por partida; transformar as quatro opções tradicionais de modelo em combatentes com tipo tático; conceder kits predefinidos sem dinheiro ou compra; representar munição como carregadores; preservar o estado de munição de armas coletadas; e decidir como munição de mortos, limites de tipo, supressão, objetivos e identidade das equipes devem funcionar.

Ela considera tipos como Assault, Support, Sniper, Medic, Engineer, Breacher e Recon, mas não aprova nenhum. Também apresenta três direções de produto — tipos leves, esquadrões táticos e identidade intermediária — e pede um MVP que preserve a resposta rápida do gunplay clássico sem transformar o mod em simulador militar.

## Estado atual confirmado e limites da análise

- **Fato:** o runtime alvo é Xash3D FWGS, com ReGameDLL_CS como GameDLL autoritativa e CS16Client como cliente/HUD/menu.
- **Fato técnico:** ReGameDLL_CS e CS16Client definem `MAX_CLIENTS` como 32. Esse é o teto de clientes da base atual; o valor efetivo do servidor pode ser menor e não garante que todo mapa comporte 32 jogadores ativos adequadamente.
- **Fato técnico:** a GameDLL conta e seleciona pontos de spawn definidos pelo mapa para cada lado legado. A capacidade prática depende do conteúdo do mapa, não apenas de `MAX_CLIENTS`.
- **Fato:** mudanças de gameplay devem começar em `specs/backlog`; nenhuma spec relacionada estava salva no backlog no início desta análise.
- **Fato:** `docs/product/product-vision.md` e `docs/product/design-pillars.md` existem, mas estão vazios.
- **Fato:** não houve mudança de código ou de submódulo nesta exploração.
- **Necessidade de investigação técnica:** esta análise não auditou o comportamento herdado de compra, munição, drop, bots e objetivos no código. Referências ao CS clássico servem como baseline de produto declarada na proposta, não como confirmação de cada detalhe da build atual.

## 1. Resumo executivo

**Tese:** a identidade promissora não é “CS 1.6 mais realista”, mas um FPS por rodadas em que equipes têm identidade própria, os jogadores assumem responsabilidades legíveis e entram em cada rodada com kits previsíveis. O valor vem da composição e da execução da equipe, não do inventário detalhado.

**Recomendação atualizada:** prototipar uma identidade intermediária. Separar a identidade da equipe dos papéis temporários de Atacante e Defensor; usar confrontos coerentes definidos pelo cenário do mapa; manter contratos simétricos; testar Assault, Support, Marksman e Breacher com kits predefinidos e sem compra; e preparar um teste posterior de carregadores individuais simplificados com uma única recarga tática.

O primeiro protótipo deve evitar diferenças mecânicas entre equipes, equipes baseadas diretamente em organizações reais, cura, efeitos artificiais de supressão, saque de carregadores, inventário manual, peso, acessórios e progressão entre rodadas. Esses sistemas custam clareza antes de a hipótese principal — “tipos de jogador e kits melhoram decisões de equipe sem destruir o ritmo clássico” — estar validada.

O risco central é substituir a economia do CS por vários sistemas menores e mais difíceis de compreender. Se classes, limites, carregadores, saque, recursos coletivos e habilidades especiais estrearem juntos, um playtest negativo não revelará qual premissa falhou.

## 2. Tese central da proposta

O problema real não é apenas a nomenclatura “Terrorist” e “Counter-Terrorist”. É o acoplamento entre três conceitos que deveriam ser independentes:

1. **Equipe:** identidade coletiva, grupo de jogadores e apresentação visual, sonora e narrativa.
2. **Lado operacional:** papel temporário no cenário, como Atacante ou Defensor.
3. **Tipo de jogador:** responsabilidade mecânica e contrato de kit simétrico, independentemente do alias e do mapeamento temático usado por cada equipe.

Separar equipe, lado operacional e tipo de jogador permite que uma equipe ataque em um cenário e defenda em outro sem receber um julgamento moral permanente. Também permite trocar lados na metade da partida sem trocar a identidade da equipe, se o cenário suportar essa inversão.

**Hipótese principal:** escolhas de tipo e kits predefinidos podem substituir parte da decisão tática hoje concentrada na compra, mantendo rodadas justas e legíveis.

**Contraponto:** neutralizar os nomes do sistema não neutraliza o conteúdo. Um confronto entre organizações reais continua comunicando uma posição editorial por meio do objetivo, do mapa, das falas, da vitória e da própria seleção de participantes.

## 3. O que realmente diferencia o mod

### Diferenciadores fortes

- Equipe desvinculada de Atacante/Defensor.
- Responsabilidade tática reconhecível antes do spawn.
- Kits de disponibilidade previsível, reduzindo a barreira do menu de compra.
- Munição por carregadores, se criar decisões rápidas e legíveis.
- Cenários que definem confrontos e objetivos coerentes, em vez de qualquer equipe contra qualquer equipe.

### Diferenciadores fracos ou genéricos

- Apenas renomear CT/T para Equipe 1/Equipe 2.
- Trocar quatro skins por quatro rótulos sem alterar responsabilidades.
- Usar armas diferentes por equipe apesar da decisão de simetria mecânica.
- Adicionar realismo de inventário que não afeta decisões relevantes.

## 4. Partes que podem prejudicar ritmo ou clareza

- Dois comandos de recarga, inspeção, seleção manual e consolidação de carregadores sobrecarregam o gunplay rápido.
- Esconder a munição de uma arma coletada por muito tempo produz mortes percebidas como arbitrárias.
- Saquear corpo, munição, acessórios e carregadores desvia o foco do objetivo.
- Cura em rodadas sem respawn pode tornar o Medic obrigatório e apagar a importância do dano acumulado.
- Supressão com tremor, blur, lentidão ou perda de precisão reduz controle e pode premiar spam.
- Um tipo excessivamente forte pode produzir composições inteiras iguais; isso deve ser corrigido no kit, no contrajogo ou no mapa, não por uma cota automática.
- Assimetria forte multiplica exceções de mapa, composição, bots, HUD e balanceamento.
- Recursos entre rodadas podem recriar uma economia menos transparente que a original.

## 5. Problemas ainda não resolvidos

- A visão e os pilares oficiais de produto estão vazios no repositório; falta uma referência aprovada para arbitrar “clássico” versus “tático”.
- Não há decisão sobre público-alvo, duração desejada, tamanho típico de equipe nem prioridade entre competitivo e servidor comunitário casual.
- Não foi definido se o objetivo principal continuará baseado em rodada sem respawn.
- Não há política editorial para equipes baseadas em organizações reais, conflitos contemporâneos e organizações criminosas.
- Não há taxonomia de equivalência entre armas nem orçamento de poder por kit.
- Ainda falta uma matriz de compatibilidade que valide mapas e modos legados com kits, economia e terminologia novos.
- Não foi investigado o custo de animações, HUD, mensagens de rede e bots para carregadores individuais.

## 6. Terminologia recomendada

| Conceito | Termo recomendado | Evitar como termo de sistema | Motivo |
|---|---|---|---|
| Identidade coletiva e grupo competitivo | **Equipe** | Equipe 1/2 como nome final | Tem identidade própria sem atribuir moralidade. |
| Papel no objetivo | **Atacante / Defensor** | T / CT | É temporário e descritivo. |
| Responsabilidade mecânica simétrica | **Tipo de jogador** | Classe | Separa o contrato global do alias e do conteúdo temático exibido por equipe. |
| Identidade representada | **Combatente** | Operador/personagem | “Operador” traz expectativas de herói e habilidades únicas; “personagem” sugere indivíduo canônico. |
| Equipamento concedido | **Kit** | Loadout livre | Comunica um pacote predefinido. |
| Variação pequena do kit | **Opção de kit** | Subclasse | Evita uma hierarquia prematura. |
| Conteúdo mapa + modo + equipes | **Cenário** | Matchup livre | Reúne coerência narrativa e regras. |

Tipo base, alias, kit temático e combatente devem ser entidades separadas. “Atirador de precisão” pode ser o tipo base; cada equipe pode exibir um alias, armas permitidas e um combatente visualmente distinto para esse mesmo contrato. Alias e combatente não possuem estatísticas próprias; qualquer variação de equipamento obedece aos limites globais.

## 7. Modelo confirmado para equipes

### Comparação

| Modelo | Clareza | Identidade | Balanceamento | Conteúdo/manutenção | Risco dominante |
|---|---|---|---|---|---|
| Espelhado | Alta | Baixa a média | Baixo | Baixo | Equipes parecerem apenas skins. |
| Parcialmente assimétrico | Média/alta | Alta | Médio | Médio | Uma arma equivalente ser claramente superior. |
| Fortemente assimétrico | Baixa no início | Muito alta | Muito alto | Muito alto | Equipe/meta obrigatória e mapas incompatíveis. |

**Decisão atualizada:** equipes terão os mesmos tipos base, slots, categorias e limites. Identidade visual, sonora, nominal e mapeamento de armas podem ser diferentes. Variações mecânicas só são válidas dentro de perfis e orçamentos globais aprovados.

**Consequência:** assimetria livre por equipe deixa de ser direção desta spec. Variedade vem de cenário, apresentação, nomes e mapeamentos limitados pelo mesmo contrato de poder.

**Rejeição:** assimetria mecânica entre equipes. Ela contradiz a decisão de produto e dificulta distinguir falha de tipo, arma, mapa ou lado.

Não permitir qualquer identidade de equipe contra qualquer outra. Cada cenário mantém uma lista de equipes e pares coerentes. Duas equipes com a mesma identidade podem existir apenas como modo de treino, teste ou competição abstrata, com apresentação que diferencie claramente os lados.

## 8. Fluxo recomendado para escolha das equipes

### Consequências dos modelos de seleção

| Modelo | Benefício | Consequência/risco | Uso recomendado |
|---|---|---|---|
| Mapa fixa o confronto | Coerência e balanceamento altos | Pouca variedade por mapa | MVP e competitivo. |
| Administrador escolhe | Curadoria comunitária | Configuração ruim pode quebrar narrativa/meta | Presets validados. |
| Voto escolhe cenário | Agência coletiva | Popularidade repetitiva e voto estratégico | Entre poucos cenários completos. |
| Jogadores escolhem cada equipe | Expressão | Pode produzir espelhos e combinações narrativamente incoerentes | Não recomendado. |
| Qualquer contra qualquer | Muito conteúdo combinável | Custo combinatório de balanceamento, vozes, objetivos e narrativa | Rejeitado. |
| Confrontos predefinidos globais | Controle editorial | Menor liberdade para servidores | Catálogo padrão, extensível por configuração. |

1. O mapa publica cenários compatíveis, cada um com modo, objetivo, lados e pares de equipes permitidos.
2. O administrador ou a rotação do servidor define um cenário padrão e pode limitar a lista.
3. Opcionalmente, os jogadores votam entre cenários completos; não votam separadamente em duas equipes que talvez sejam incoerentes.
4. O servidor sorteia ou balanceia jogadores entre as equipes depois da escolha do cenário.
5. Cada grupo de jogadores recebe a identidade de uma equipe e um lado operacional.
6. Em formato competitivo, lados são trocados na metade quando o cenário for mecanicamente reversível; as identidades das equipes podem ser trocadas junto com o lado para preservar a narrativa.
7. Reconexão restaura a sessão, mas equipe, lado e tipo só são atribuídos depois de uma nova adesão válida.

Para servidor comunitário, o administrador precisa de presets, lista permitida e opção de votação. O cliente nunca decide sozinho uma combinação válida.

### Regra confirmada de adesão e equilíbrio numérico

O servidor impede que uma entrada ou troca voluntária crie diferença superior a um jogador ativo:

- com quantidades iguais, ambas as equipes ficam disponíveis;
- quando uma equipe tem um jogador a mais, somente a menor fica disponível;
- uma entrada ou troca que produziria diferença maior que um é rejeitada;
- se uma desconexão produzir diferença maior que um, ninguém é movido à força; somente a equipe menor aceita entradas até recuperar o equilíbrio;
- solicitações simultâneas são processadas sequencialmente pelo servidor, reavaliando a contagem antes de cada adesão;
- espectadores não entram na contagem;
- **Recomendação:** combatentes controlados por humanos ou bots entram na contagem enquanto ocuparem uma equipe ativa.

Exemplos:

| Estado atual | Disponibilidade |
|---|---|
| 10 contra 10 | Ambas as equipes. |
| 10 contra 9 | Somente a equipe com 9. |
| 11 contra 9 após desconexão | Somente a equipe com 9; ninguém é transferido automaticamente. |
| 15 contra 15 | Ambas, respeitando o teto de clientes e vagas de espectador. |

**Regra confirmada para reconexão:** o retorno é validado como nova entrada. Se a equipe anterior estiver indisponível, o jogador aguarda como espectador ou entra na equipe disponível. Não existe reserva temporária de vaga, prioridade por equipe anterior nem exceção à diferença máxima.

### Regra confirmada de retrocompatibilidade de mapas e modos

O comportamento-base segue a estrutura fixa do CS 1.6:

- mapas legados carregam sem recompilação específica para o mod;
- geometria, rotas e objetivos não mudam dinamicamente conforme a quantidade de jogadores;
- pontos de spawn e entidades de objetivo legados continuam sendo reconhecidos;
- nomes técnicos T/CT podem permanecer como identificadores internos de lados e entidades, mas não aparecem como identidade das equipes;
- o administrador configura a quantidade de clientes, respeitando a capacidade prática do mapa;
- mapas podem receber uma faixa recomendada de jogadores após playtest;
- cada modo legado precisa permitir iniciar, executar o objetivo e encerrar a rodada corretamente.

**Limite da decisão:** preservar mapas e modos não significa preservar economia, compra, balanceamento, bots, apresentação ou plugins de terceiros. Dinheiro e compra permanecem removidos mesmo em mapas legados.

**Risco:** kits garantidos, ausência de economia e tipos livres podem tornar jogável, porém desequilibrado, um mapa criado para compra e armamento progressivo. Compatibilidade funcional e equivalência de experiência não são a mesma coisa.

## 9. Modelo confirmado para tipos de jogador

### Modelos comparados

| Modelo | Clareza | Identidade | Variedade | Balanceamento/manutenção | Competitividade |
|---|---|---|---|---|---|
| 1 — Universais | Alta | Média | Média | Baixo | Alta |
| 2 — Assimétricas | Baixa/média | Alta | Alta | Muito alto | Baixa até maturar |
| 3 — Híbrido | Alta | Alta | Alta | Médio | Alta se equivalências forem auditáveis |

**Decisão atualizada:** tipos base universais e contratos simétricos. Cada equipe pode alterar alias, apresentação, identidade do combatente e mapeamento de equipamentos permitido; slots, categorias, tetos e orçamento do tipo equivalente permanecem iguais.

Cada tipo precisa de:

- uma frase de fantasia;
- um verbo de contribuição principal;
- um kit-base e no máximo uma pequena escolha;
- uma fraqueza perceptível;
- um ícone e uma silhueta legíveis;
- utilidade no objetivo além de dano;
- comportamento útil em equipes pequenas.

Não usar atributos passivos de vida, velocidade ou dano no MVP. Eles tornam confrontos menos previsíveis e fazem o modelo visual carregar informação competitiva demais.

## 10. Quatro tipos sugeridos para o primeiro protótipo

Estes nomes e kits são hipóteses, não uma lista definitiva.

### Assault — tomar e sustentar contato

- **Fantasia:** combatente versátil que abre espaço com consistência.
- **Responsabilidade:** primeiro contato e proteção de quem executa o objetivo.
- **Principal:** rifle padrão de uso geral.
- **Equipamento:** granada de fragmentação e uma utilidade de entrada.
- **Vantagem:** flexibilidade em curta e média distância.
- **Limitação:** não tem alcance, volume sustentado ou utilidade especializada superiores.
- **Objetivo:** escolta o portador, limpa a aproximação e ocupa o ponto.
- **Mapas:** funciona em qualquer escala.
- **Quantidade:** sem limite inicial.
- **Risco:** virar escolha universal se os demais kits cobrarem especialização demais.

### Support — controlar espaço e manter a equipe operante

- **Fantasia:** ancora posições e habilita deslocamentos aliados.
- **Responsabilidade:** negar corredores e fornecer cobertura.
- **Principal:** arma de maior capacidade, com pior mobilidade/manuseio.
- **Equipamento:** fumaça e utilidade adicional de cobertura; reabastecimento de aliados fica fora do MVP.
- **Vantagem:** volume sustentado e controle de ângulo.
- **Limitação:** recuperação, troca de arma e deslocamento menos favoráveis; não recebe dano extra.
- **Objetivo:** cobre plantio, captura, desarme ou retirada.
- **Mapas pequenos:** capacidade e utilidade importam; arma não pode dominar hipfire.
- **Mapas grandes:** sustenta linhas, mas não substitui Marksman.
- **Quantidade:** sem limite. Composição dominante exige rebalanceamento do tipo, não restrição de escolha.
- **Risco:** dominar corredores se alta capacidade vier sem custo real.

### Breacher — romper posições preparadas

- **Fantasia:** cria uma janela curta para entrada da equipe.
- **Responsabilidade:** desalojar defensores e liderar entradas próximas.
- **Principal:** carabina compacta ou shotgun, conforme mapa; não ambas.
- **Equipamento:** flash e ferramenta de ruptura ligada ao objetivo ou à geometria suportada.
- **Vantagem:** curta distância e utilidade de entrada.
- **Limitação:** perda clara em alcance e sustentação.
- **Objetivo:** acessa ou abre a área, sem concluir o objetivo mais rápido por passivo oculto.
- **Mapas pequenos:** deve ser forte, mas dependente de timing e consumíveis.
- **Mapas grandes:** precisa de rota/objetivo onde sua utilidade exista.
- **Quantidade:** sem limite inicial; cenários sem ruptura usam uma variante “Pointman”.
- **Risco:** sobrepor Assault ou ser inútil quando o mapa não suporta sua fantasia.

### Marksman — vigiar linhas e punir exposição

- **Fantasia:** precisão deliberada e cobertura de longa distância.
- **Responsabilidade:** observar linhas, negar travessias e proteger o objetivo à distância.
- **Principal:** rifle de precisão; começar sem equivalente direto da AWP de disponibilidade irrestrita.
- **Equipamento:** utilidade limitada; nenhuma informação automática para o time no MVP.
- **Vantagem:** alcance e precisão.
- **Limitação:** baixa flexibilidade próxima, aquisição de alvo e cadência piores.
- **Objetivo:** cobre aproximações e rotações, mas deve reposicionar.
- **Mapas pequenos:** kit alternativo de rifle semiautomático ou indisponibilidade definida pelo cenário.
- **Mapas grandes:** papel natural, sujeito a linhas e contrajogo.
- **Quantidade:** sem limite.
- **Risco:** arma de alto impacto produzir uma equipe inteira de Marksman. O perfil precisa ser um sidegrade com contrajogo, não uma arma superior controlada por cota.

### Por que não Medic, Engineer, Recon ou Squad Leader no MVP

- **Medic:** cura pode ser obrigatória e reduzir a legibilidade do dano em rodada sem respawn.
- **Engineer:** depende de objetos e mapas que ainda não existem.
- **Recon:** informação é extremamente poderosa e difícil de comunicar sem “wallhack institucional”.
- **Squad Leader:** autoridade social e bônus de aura criam conflito; não prova a hipótese dos kits.

Recon e Engineer são bons candidatos futuros. Medic só deve voltar à discussão depois de decidir respawn, duração da rodada e filosofia de letalidade.

### Fogo de supressão

| Modelo | Valor | Risco |
|---|---|---|
| Emergente — som, impactos e ameaça de dano | Jogadores buscam cobertura por leitura natural | Pode não diferenciar Support o suficiente. |
| Feedback audiovisual leve, sem penalidade | Reforça legibilidade | Pode poluir som/tela. |
| Penalidade de precisão ou movimento | Cria poder explícito | Retira controle e favorece spam. |
| Tremor, blur ou perda de informação | Sensação forte | Desconforto, acessibilidade e confusão com dano. |

**Recomendação:** supressão emergente no MVP, apoiada apenas pelos sons, impactos e risco real que qualquer arma já produz. Não aplicar redução de precisão, movimento, visão ou controle. Se o Support não cumprir seu papel, ajustar capacidade, manuseio, geometria e utilidade antes de adicionar um debuff invisível. Qualquer feedback audiovisual futuro deve ter opções de acessibilidade e não ocultar informação necessária.

## 11. Modelo recomendado para kits

**Decisão:** kit-base predefinido por tipo, concedido automaticamente no spawn e sem compra. Equipes temáticas mapeiam armas e equipamentos dentro do contrato global do tipo. Pequenas opções, como visão noturna, só existem quando o contrato permitir e nunca como vantagem exclusiva de uma equipe.

Regras propostas:

- A seleção ocorre no lobby e pode ser alterada enquanto morto para valer no próximo spawn elegível.
- Não há troca de tipo ou regeneração de kit durante uma vida.
- Cada spawn concede exatamente um kit validado pelo servidor.
- Armas coletadas não mudam o tipo nem concedem os consumíveis do novo papel.
- A morte não cria um novo kit se o modo não tiver respawn.
- Em modos com respawn futuro, cada vida precisa de proteção contra geração infinita de armas e munição.
- Opções de kit devem ser equivalentes, nunca uma progressão vertical desbloqueável.
- Todos os tipos começam equipados com lanterna.
- Visão noturna é uma opção candidata, ainda não aprovada; sua disponibilidade precisa ser simétrica e compatível com o mapa.

Se todos escolherem o mesmo tipo, a composição é aceita e todos entram normalmente na rodada. O HUD pode descrever a composição, mas não deve alertar que ela está “errada” nem impedir o spawn. Nenhum objetivo pode exigir um tipo específico.

### Primeira matriz de kits proposta

Os números abaixo registram a proposta recebida e são **hipóteses de balanceamento**, não valores aprovados.

Para o próximo playtest, esta matriz substitui as sugestões iniciais de armas e equipamentos da seção 10; as fantasias e responsabilidades descritas lá continuam como referência.

| Tipo base | Primary | Secondary | Backup | Fragmentação | Flashbang | Smoke |
|---|---|---|---|---:|---:|---:|
| Support | Machine gun, teto de 250 balas | — | Pistola, teto de 45 | 3 | 2 | 0 |
| Assault | Assault rifle, teto de 150 balas | SMG, teto de 90 | Pistola, teto de 45 | 3 | 3 | 0 |
| Sniper | Sniper rifle, teto de 50 balas | — | Pistola, teto de 45 | 0 | 3 | 2 |
| Breacher | Shotgun pump-action ou semiautomática, teto de 40 balas | SMG, teto de 90 | Pistola, teto de 45 | 2 | 3 | 1 |

Nesta tabela, “granada” foi interpretada como granada de fragmentação; isso precisa de confirmação. “Sniper” também permanece nome provisório do tipo base/alias.

### Regra proposta para teto de munição e carregadores

Interpretação recomendada, consistente com o exemplo fornecido:

- o teto de balas é definido por tipo e slot de arma;
- a capacidade do carregador é definida pela equipe temática, como inteiro positivo que não ultrapassa o teto de balas do tipo/slot;
- o carregador inserido conta no total;
- o kit nasce apenas com carregadores completos;
- quantidade inicial de carregadores = `floor(teto_de_balas / capacidade_do_carregador)`;
- qualquer resto abaixo de um carregador completo não é concedido no spawn.

Exemplo: Assault com teto de 150 balas e rifle com carregador de 35 recebe quatro carregadores completos, totalizando 140 balas. Um deles começa inserido e três ficam na reserva. As dez balas restantes do teto não formam um quinto carregador.

**Decisão pendente:** confirmar se “quatro carregadores” significa quatro no total, incluindo o inserido, como recomendado acima, ou quatro reservas além do inserido.

### Contrato para equipes criadas pela comunidade

Uma equipe temática pode definir:

- nome, emblema, modelos, vozes e aliases;
- arma visual/temática associada a cada slot permitido;
- recuo e cadência somente dentro dos intervalos autorizados para o perfil;
- equipamentos opcionais previstos pelo contrato global.

Uma equipe temática não pode:

- criar novos slots ou exceder os tetos do tipo;
- remover a fraqueza estrutural do tipo;
- conceder equipamento exclusivo sem equivalente para o contrato oposto;
- alterar dano, tempo de recarga ou qualquer parâmetro fora de capacidade do carregador, recuo e cadência;
- enviar estado competitivo confiado ao cliente;
- ser aceita automaticamente apenas porque o arquivo é sintaticamente válido.

O servidor valida o pacote completo antes da partida. Conteúdo inválido é rejeitado sem aplicar parcialmente seus parâmetros. A forma do pacote, distribuição, assinatura e compatibilidade de versões são investigações futuras.

### Parâmetros comunitários de arma

- **Dano:** fixo no perfil global da arma; não configurável pela equipe.
- **Capacidade do carregador:** configurável como inteiro entre 1 e o teto de balas do contrato; participa do cálculo do número de carregadores.
- **Tempo de recarga:** fixo por categoria de arma no MVP; não configurável pela equipe.
- **Recuo:** configurável dentro de `recoil_min` e `recoil_max` do contrato.
- **Cadência:** configurável dentro de `rate_min` e `rate_max` do contrato.
- **Demais parâmetros competitivos:** fixos, salvo nova decisão explícita de produto.

O visual não determina a regra automaticamente. O pacote declara explicitamente a capacidade e associa os assets correspondentes:

- uma crossbow temática de tiro único pode declarar capacidade 1;
- um supercarregador pode declarar capacidade 50 somente quando o teto daquele tipo/slot for pelo menos 50;
- em um contrato de backup com teto 45, capacidade 50 é inválida mesmo que o modelo represente um carregador maior.

A mesma separação vale para recarga. Uma crossbow de tiro único não recebe duração automática por ter capacidade 1, e um supercarregador não recebe duração automática por sua capacidade. No MVP, ambos recebem o tempo fixado para suas respectivas categorias; modelo, animação e som devem ser produzidos para comunicar esse valor. Divergência visual não altera o tempo autoritativo do servidor e torna o pacote inválido para publicação ou carregamento, conforme a política de validação a ser definida.

Validar cada intervalo separadamente não basta. **Recomendação:** o contrato também precisa validar a combinação recuo/cadência por presets aprovados ou orçamento conjunto. Recuo mínimo mais cadência máxima pode criar uma escolha dominante mesmo quando ambos os valores isolados são válidos.

Valores ausentes, não numéricos, infinitos ou fora do intervalo invalidam o pacote. O servidor não deve corrigir silenciosamente com `clamp`, pois isso esconderia erros do criador e poderia produzir diferenças entre o conteúdo testado e o executado.

### Riscos da primeira matriz

- Assault e Breacher carregam três armas, cobrindo mais distâncias que Support e Sniper.
- Dez Assault poderiam gerar 30 granadas de fragmentação e 30 flashes por rodada.
- Dez Breacher poderiam gerar 20 granadas, 30 flashes e 10 smokes.
- Cinquenta balas de sniper podem remover o custo de errar, dependendo do dano e da cadência.
- Uma machine gun com 250 balas pode dominar corredores se mobilidade, recarga e precisão não cobrarem um preço real.
- Visão noturna exclusiva de uma equipe ou tipo pode virar vantagem dependente do mapa.
- Recuo mínimo combinado com cadência máxima pode maximizar precisão e DPS sem custo equivalente.
- Capacidade igual ao teto elimina recargas de reserva; capacidade 1 gera um carregador para cada bala. Ambos são resultados temáticos válidos, mas precisam ser avaliados quanto a ritmo, HUD, estado do servidor e mensagens de rede.
- Modelo, animação, som e feedback que não comuniquem a capacidade e o comportamento reais podem enganar o jogador.

Esses riscos não invalidam a estrutura do kit, mas exigem que munição, quantidade de utilidades e número de armas sejam testados separadamente. Não tratar os valores como padrão final antes do playtest.

## 12. Consequências da remoção da economia

### O que desaparece

- progressão e narrativa de poder entre rodadas;
- consequência econômica de salvar ou perder arma;
- decisão de compra e coordenação financeira;
- eco, force-buy e compra completa;
- mecanismo de comeback por bônus de derrota;
- variação de armamento causada por recursos;
- valor estratégico de sobreviver com equipamento.

### O que melhora

- cada rodada começa mais comparável;
- iniciantes não são punidos por desconhecer preços;
- o kit comunica responsabilidade imediatamente;
- balanceamento pode avaliar ferramentas sempre disponíveis;
- menos tempo e interface antes do combate.

### O que piora

- rodadas podem parecer repetitivas;
- vitória anterior perde consequência sistêmica;
- armas fortes precisam ser equilibradas em todas as rodadas;
- a partida perde decisões macro entre rodadas;
- salvar pode deixar de ter sentido.

**Decisão:** não criar substituto econômico no MVP. As rodadas começam com os kits definidos, sem dinheiro, preços, recompensas monetárias, eco ou compra. Um recurso coletivo, tickets ou cooldown de kit só pode ser considerado em outra decisão de produto.

Carregar um mapa legado não reativa a economia automaticamente. Retrocompatibilidade preserva mapa, entidades, objetivo e fluxo de rodada; não restaura compra e dinheiro do CS 1.6.

## 13. Modelo recomendado para carregadores

### Alternativas

| Modelo | Clareza | Profundidade | Custo técnico/UI | Ritmo |
|---|---|---|---|---|
| Balas totais | Muito alta | Baixa | Baixo | Clássico |
| Carregadores completos abstratos | Alta | Baixa/média | Baixo/médio | Rápido |
| Lista individual | Média | Alta | Alto | Mais lento |
| Híbrido | Alta | Média | Médio | Próximo do clássico |

**Recomendação:** estado interno por carregador individual, interação híbrida. O servidor conhece a munição de cada carregador; o jogador vê munição exata no carregador inserido, quantidade de reservas e quais reservas estão parciais. Não há tela de inventário.

Regra automática: a recarga escolhe o carregador compatível mais cheio; empate por ordem estável. Carregadores parciais guardados voltam ao conjunto de reservas. Quando só restarem parciais, o mais cheio entra primeiro.

Fora do MVP: reorganizar, consolidar, escolher manualmente, compartilhar, pegar carregador do chão e regra de munição na câmara. Essas ações transformam uma decisão de combate em administração de inventário.

## 14. Regra recomendada para recarga

### Comparação

- **Descarte sempre:** simples e rápido, mas pune hábitos consolidados e pode parecer perda acidental invisível.
- **Tática sempre:** preserva munição, cria o custo de voltar a um carregador parcial e exige pouca entrada adicional.
- **Dois tipos:** oferece maior domínio, mas requer comando, animações, tutorial, feedback e decisão em momentos já intensos.

**Recomendação para o MVP:** uma única recarga tática. O carregador parcial é guardado; o carregador mais cheio disponível é inserido. A duração pode permanecer próxima da recarga clássica até playtests mostrarem necessidade de custo adicional.

**Decisão de contrato para o MVP:** a duração não é calculada pela capacidade nem extraída da animação. O jogo define um único tempo para cada categoria de arma; o servidor controla quando a recarga termina e quando o novo estado de munição passa a valer. A animação cliente deve acompanhar esse estado sem poder antecipá-lo. Perfis alternativos ficam fora do MVP e exigem evidência de playtest de que o tempo único prejudica categorias tematicamente distintas.

**Exceção das escopetas:** pump-action e semiautomática usam recarga incremental cartucho por cartucho, e não troca de carregador. A pump-action usa a baseline da M3: 0,55 s para iniciar e 0,45 s por cartucho. A semiautomática usa a baseline da XM1014: 0,55 s para iniciar e 0,30 s por cartucho. Esses valores são hipóteses iniciais herdadas do CS 1.6 para o playtest, não garantias de balanceamento final. O modo de disparo não altera essa regra de recarga.

Uma recarga com o carregador vazio segue o mesmo comando. Recarga rápida com descarte é experimento futuro e só deve existir se o benefício de timing for perceptível e as animações comunicarem claramente a perda.

O sistema precisa impedir cancelamento que duplique ou restaure munição. A transição do carregador deve ter um ponto autoritativo definido pelo servidor, mesmo se a animação for prevista pelo cliente.

## 15. Regra recomendada para armas coletadas

- A arma no chão preserva exatamente o carregador inserido, o modo de disparo e configurações mecânicas que pertençam à própria entidade.
- Pegar a arma não concede reservas, kit, tipo nem acessórios externos do antigo dono.
- A quantidade do carregador é desconhecida antes da coleta, mas o HUD a revela exatamente após a animação normal de equipar. Não exigir inspeção no MVP.
- A coleta interrompe ações incompatíveis conforme as regras já legíveis de troca de arma.
- Qualquer tipo pode usar a arma coletada, salvo proibição explícita do cenário; restrições rígidas reduzem jogadas emergentes.
- Reservas próprias só funcionam quando o tipo de carregador for compatível. Mesmo calibre não implica compatibilidade.
- Não existe penalidade de peso no MVP.
- A arma coletada não é preservada para a rodada seguinte no modelo sem economia.

Esconder o valor até atirar ou recarregar adiciona incerteza, mas o custo mais comum é uma morte frustrante sem contrajogo. Uma indicação aproximada antes da coleta pode ser testada futuramente apenas se houver inspeção visual barata e confiável.

## 16. Regra recomendada para munição de jogadores mortos

**MVP:** carregadores reservas desaparecem com o jogador. Apenas armas derrubadas persistem, cada uma com seu carregador inserido.

Essa regra sacrifica realismo para evitar objetos, saques demorados, compatibilidade obscura, duplicação e geração de recursos por morte/respawn. O corpo não é um contêiner.

Alternativas futuras, em ordem de complexidade:

1. ação contextual no corpo que transfere no máximo um carregador compatível;
2. bolsa única de munição agregada, com vida útil curta;
3. carregadores físicos individuais — não recomendado sem evidência forte.

Qualquer alternativa futura precisa registrar origem, dono, limite por vida e expiração no servidor para impedir farming por suicídio, troca de equipe ou reconexão.

## 17. Composição livre dos tipos

**Decisão:** nenhum tipo possui limite por equipe. Não existem reserva, fila, votação, prioridade por ordem de clique nem rotação forçada. Uma equipe inteira pode escolher Assault, Support, Breacher, Marksman ou qualquer outro tipo disponível no cenário.

Consequências:

- cada tipo precisa ser uma escolha lateral, nunca uma melhoria líquida;
- objetivos devem ser concluíveis por qualquer composição;
- mapas precisam oferecer contrajogo a composições extremas;
- o menu informa escolhas atuais sem julgar ou bloquear a composição;
- se dez Marksman, dez Support ou dez Assault forem dominantes, a falha está no balanceamento do tipo ou do mapa;
- servidores comunitários não devem precisar administrar disputas por vagas de tipo.

**Risco:** a liberdade permite estratégias monotemáticas frustrantes. A resposta preferida é ajustar alcance, mobilidade, utilidade, exposição e contrajogo. Reintroduzir cotas exigiria nova decisão explícita de produto.

## 18. Riscos de balanceamento e exploits

| Risco | Efeito | Mitigação/experimento |
|---|---|---|
| Todos escolhem Assault | Outros tipos não têm valor | Medir escolha e contribuição; melhorar objetivos, não impor cotas gerais. |
| Equipe inteira de Marksman | Meta de longo alcance | Tornar Marksman um sidegrade, garantir cobertura/rotas e contrajogo próximo. |
| Support domina corredor | Spam sem contrajogo | Custos de manuseio, dispersão sustentável e utilidade limitada; sem debuff artificial. |
| Equipe aparenta ter tipo superior | Escolha por percepção incorreta | Mesmo perfil mecânico, ícone equivalente e testes com troca de lados. |
| Morrer gera armas | Farming em modos com respawn | Limite de entidade/origem por vida, expiração e nenhum reserve drop. |
| Duplicação ao recarregar | Munição infinita | Estado e transições autoritativos; testes de cancelamento e troca. |
| Reconectar restaura kit | Recurso infinito | Restaurar estado/penalidade da sessão; spawn apenas pela regra do modo. |
| Trocar equipe obtém kit | Contrabando e desequilíbrio | Morte/limpeza de inventário e cooldown/regras do servidor. |
| Pickup restaura reserva | Munição criada | Arma carrega apenas seu estado inserido; reservas são inventário separado. |
| Entidade altera munição | Inconsistência/dessincronização | Serialização autoritativa do estado da arma no chão. |
| HUD revela estado remoto | Informação indevida | Mensagens apenas ao possuidor; espectador segue política explícita. |
| Compatibilidade por calibre | Uso indevido | ID de família de carregador, não somente tipo de munição. |
| Objetos acumulam | Desempenho e poluição | Reservas não caem; limite e expiração das armas. |
| Sem economia, repetição | Baixa variedade | Medir antes de adicionar recursos; variar objetivo/rotas e pequenas opções. |
| Composição torna objetivo impossível | Partida decidida no menu | Nenhum tipo exclusivo necessário para concluir objetivo. |
| Spawn/drop transfere kit | Exploit cooperativo | Kit não é recurso persistente entre rodadas; regras de pickup consistentes. |

## 19. Riscos de experiência do jogador

- Novatos podem confundir tipo com arma favorita. O menu precisa mostrar “como ajuda a equipe”, não só estatísticas.
- Carregadores parciais invisíveis criam a sensação de munição desaparecendo.
- Tipo com arma inadequada ao mapa vira armadilha de escolha.
- Partidas pequenas não comportam interdependência rígida. Toda equipe precisa conseguir concluir o objetivo com qualquer composição.
- Jogadores experientes podem sentir perda da camada econômica e do prazer de adquirir armas.
- Kits fixos podem produzir monotonia e reduzir expressão individual.
- Termos militares excessivos e HUD denso aumentam a barreira sem melhorar o combate.
- Bots que ignoram tipo, objetivo ou carregadores quebram tanto treino quanto servidores comunitários.

## 20. Riscos narrativos e de identidade

Remover T/CT evita um rótulo moral fixo, mas não torna neutros objetivos, falas e resultados. “Exército Brasileiro versus PCC”, “Rússia versus Ucrânia” e confrontos entre polícias reais exigem pesquisa, contexto editorial, revisão jurídica e análise de políticas de distribuição. Também podem ser percebidos como simplificação, propaganda, glorificação ou exploração de violência atual.

**Recomendação para o MVP:** duas equipes fictícias, plausíveis e não caricatas, em operação competitiva ou conflito ficcional claramente contextualizado. Não usar “simulação/treinamento” como desculpa universal se o restante da apresentação mostrar mortes e conflito real.

Se equipes baseadas em organizações reais forem consideradas depois:

- cada cenário precisa de descrição factual e neutra;
- objetivos devem descrever ações, não caráter moral;
- vitória não deve usar linguagem de purificação, heroísmo ou demonização;
- símbolos, vozes, nomes e referências precisam de política editorial;
- conteúdo contemporâneo precisa de avaliação regional, indicativa e de plataforma;
- nenhuma combinação é automaticamente permitida só porque os assets existem.

## 21. Estrutura de partida, ciclo de vida, HUD e autoridade

### Modos avaliados

| Modo | Adequação | Observação |
|---|---|---|
| Plantar/desarmar | Alta mecanicamente | Recontextualizar dispositivo e cenário; “bomba genérica” não serve a toda equipe. |
| Reféns | Baixa/média | Codifica fortemente papéis morais e exige narrativa específica. |
| Eliminação | Alta para teste técnico | Não valida contribuição não letal dos tipos. |
| Controle de território | Alta | Neutro e favorece utilidade/composição; requer regras/mapas adequados. |
| Captura de pontos | Alta | Bom para ataque/defesa ou disputa simétrica. |
| Escolta | Média | Forte dependência de mapa, bots e balanceamento. |
| Múltiplos objetivos | Futuro | Aumenta leitura e custo antes do loop básico. |

**Recomendação de modo do MVP:** um cenário de ataque e defesa com objetivo de “instalar/interromper um dispositivo” ou “assegurar uma área”, sem linguagem moral. Usar eliminação como condição secundária, não como único objetivo. O mapa define contexto e equipes permitidas.

### Ciclo de vida recomendado

| Momento | Regra de produto | Autoridade |
|---|---|---|
| Entrada no servidor | Recebe cenário, equipes, lado, tipos disponíveis e estado da partida. | Servidor |
| Lobby/votação | Vota em cenários completos permitidos. | Servidor valida/contabiliza |
| Escolha de equipe | Ambas ficam disponíveis quando empatadas; com diferença de um, apenas a menor aceita adesão. | Servidor |
| Escolha de tipo | Seleciona livremente qualquer tipo disponível no cenário. | Servidor valida |
| Início da partida | Trava cenário e inicializa placar/lados. | Servidor |
| Início da rodada | Confirma o tipo escolhido e limpa estado transitório anterior. | Servidor |
| Spawn | Concede um kit íntegro correspondente. | Servidor |
| Troca/recarga | Mantém arma e carregadores como estados separados e validados. | Servidor; cliente apresenta/prediz |
| Coleta de arma | Transfere entidade com carregador inserido; sem reservas. | Servidor |
| Coleta de munição | Inexistente no MVP. | Servidor |
| Morte | Derruba arma elegível; descarta reservas; encerra ações. | Servidor |
| Espectador | Não recebe informação além da política do modo/equipe. | Servidor filtra |
| Respawn | Ausente no modo principal; se habilitado, segue nova concessão controlada. | Servidor |
| Troca de equipe | Limpa inventário e reapresenta o alias equivalente do tipo; nunca concede benefício imediato. | Servidor |
| Reconexão | Revalida a equipe pela regra de diferença máxima; não gera kit/spawn. | Servidor |
| Reinício de rodada | Remove entidades e estados definidos; reinicia kits sem duplicação. | Servidor |
| Mudança de mapa | Detecta entidades e modo legados, carrega cenário e tipos disponíveis e preserva identificadores compatíveis. | Servidor |
| Encerramento | Congela resultado e apresenta equipes/lados sem julgamento moral. | Servidor + cliente |

### HUD e feedback mínimo

- nome e emblema da equipe;
- lado operacional e objetivo atual;
- alias do tipo e resumo do kit;
- arma atual;
- munição exata no carregador inserido;
- número de carregadores reserva e indicação de quantos estão parciais;
- aviso de incompatibilidade ao tentar usar reserva/pickup;
- marcador de arma coletada até a primeira troca ou por curto período;
- composição atual da própria equipe, sem bloquear escolhas;
- mensagens claras quando uma escolha só valerá no próximo spawn.

Permanecem desconhecidos: reservas de inimigos, munição de arma no chão antes de coletar e composição inimiga antes de ser observada, salvo regra explícita do modo. Espectador competitivo não pode virar fonte de informação privilegiada.

### Divisão de responsabilidades de alto nível

**ReGameDLL_CS:** cenário e equipes; lados; tipo base e capacidade; alias apresentado; concessão de kit; dano fixo do perfil; capacidade de carregador dentro do teto; intervalos e combinações válidas de recuo, cadência e recarga; inventário; lista e quantidade de carregadores; transição de recarga; estado de armas no chão; compatibilidade; pickups; morte; respawn; troca de equipe; vitória; proteção contra reconexão e duplicação.

O servidor também é autoritativo para contagem de jogadores ativos, disponibilidade de adesão e validação de troca. O cliente apenas apresenta as opções liberadas e a razão de uma rejeição.

**CS16Client:** menus de cenário/equipe/tipo; aliases por equipe; HUD; ícones; composição informativa e feedback de falha; apresentação de carregadores; animações e sons; aplicação dos parâmetros aceitos pelo servidor na previsão; localização.

**Mensagens de rede:** precisam transportar somente o estado necessário ao destinatário, com identificadores estáveis para equipe, lado, tipo base, alias, kit, família de carregador e arma. A forma e o custo são investigação técnica futura.

**Conteúdo:** modelos legíveis, sons/vozes, ícones, textos neutros, cenários/mapas e animações. Não assumir que as animações atuais suportam dois tipos de recarga.

**Compatibilidade de mapas:** a implementação futura deve manter leitura das entidades legadas de spawn e objetivo. Novos metadados de cenário devem ser opcionais, com fallback para mapas CS 1.6 que não os possuam.

**Bots:** precisam escolher tipos sem depender de uma composição obrigatória, executar objetivos, avaliar alcance do kit, recarregar sem desperdiçar decisões e coletar arma apenas quando útil. O MVP pode testar primeiro com humanos, mas não pode declarar suporte a bots antes dessa adaptação.

## 22. Comparação entre as direções A, B e C

| Critério | A — Clássico/classes leves | B — Tático/esquadrões | C — Intermediária |
|---|---|---|---|
| Ritmo | Muito próximo do CS | Mais lento | Próximo, com pausas curtas |
| Tipos de jogador | Leves e permissivos | Fortes e interdependentes | Claros, mas não obrigatórios |
| Equipes | Espelhadas | Assimetria relevante | Contratos simétricos, com mapeamentos temáticos limitados |
| Kits | Fixos | Especializados/limitados | Fixos + uma escolha lateral |
| Munição | Contador ou mags abstratos | Mags físicos completos | Mags individuais sem inventário manual |
| Saque | Arma simples | Corpo e compatibilidade | Arma com mag inserido; sem reservas |
| Economia | Ausente ou clássica | Recursos/requisição | Ausente por decisão de produto |
| Clareza | Alta | Baixa/média | Alta se HUD for contido |
| Identidade | Baixa/média | Alta, porém derivativa | Alta e própria se cenários forem fortes |
| Custo/risco | Baixo | Muito alto | Médio e controlável |
| Servidores pequenos | Bom | Ruim sem adaptações | Bom se tipos não forem obrigatórios |

### Direção A

É a alternativa mínima e o melhor fallback. Valida nomenclatura, kits e fluxo com pouco risco, mas pode parecer apenas CS com loadouts.

### Direção B

Maximiza fantasia de esquadrão, porém conflita com resposta rápida, mapas pequenos, jogadores avulsos e escopo de primeiro protótipo. Deve ser rejeitada como pacote inicial.

### Direção C

Entrega diferenciação suficiente para teste, mantendo regras legíveis. Seu perigo é acumular gradualmente todas as complexidades da Direção B; por isso, precisa de limites explícitos de escopo.

### Direção D — Cenários competitivos modulares

Alternativa futura: o núcleo mantém tipos e perfis simétricos, enquanto cada mapa escolhe objetivo, pares de equipes, aliases e pequenas opções equivalentes. A variedade vem do cenário, não de habilidades exclusivas. É compatível com C e pode se tornar a identidade de longo prazo se mapas e ferramentas de autoria suportarem a carga.

## 23. MVP recomendado

O menor protótipo capaz de validar a tese contém:

- um modo de ataque/defesa por rodadas, sem respawn;
- um cenário coerente em um mapa selecionado e uma segunda escala de mapa para comparação;
- duas equipes fictícias com contratos simétricos e mapeamentos temáticos validados;
- papéis Atacante/Defensor separados da identidade das equipes;
- quatro tipos universais fixos no MVP: Assault, Support, Marksman e Breacher;
- kits fixos, com no máximo uma escolha lateral por tipo;
- sem dinheiro, preços, recompensas monetárias ou compra;
- recarga tática única;
- carregadores individuais escolhidos automaticamente pelo “mais cheio”;
- HUD exato para carregador atual e contagem/estado parcial das reservas;
- coleta de arma com o carregador inserido e revelação após equipar;
- reservas do morto descartadas;
- composição totalmente livre, inclusive para Marksman;
- supressão apenas emergente por som, impacto e ameaça real;
- estado competitivo autoritativo no servidor;
- parâmetros centralizados e configuráveis para playtest.
- smoke tests em mapas representativos dos modos legados prioritários, sem recompilar os mapas.

Essas variáveis não devem estrear simultaneamente na coleta de evidência. A primeira sessão usa munição agregada para isolar equipes, tipos de jogador, kits e ausência de compra. O mesmo protótipo então habilita carregadores individuais para a comparação da Fase 2. Assim, “carregadores no MVP” significa uma segunda configuração experimental do mesmo programa, não uma dependência para validar o núcleo.

## 24. Fora do primeiro protótipo

- equipes baseadas em organizações reais ou organizações criminosas reais;
- qualquer confronto livre entre equipes;
- personagens heroicos ou habilidades individuais;
- assimetria mecânica forte;
- Medic, cura, revive, Engineer e construção;
- recursos coletivos, tickets, requisição ou progressão entre rodadas;
- recarga rápida separada, inspeção e animações novas obrigatórias;
- escolha manual, reorganização ou consolidação de carregadores;
- carregadores físicos no chão, saque de corpos e compartilhamento;
- peso, calibre como simulação completa, câmara e acessórios modulares;
- penalidades artificiais de supressão;
- múltiplos objetivos, escolta e respawn;
- ranking, matchmaking e desbloqueios;
- suporte declarado a bots antes de comportamento específico ser validado.

## 25. Plano de playtest

### Fase 0 — Teste de mesa e protótipo de regras

- Simular composições para equipes de 2, 4, 6, 10 e 16 jogadores.
- Verificar se qualquer composição consegue concluir o objetivo.
- Revisar cada kit contra curta, média e longa distância.
- Mapear todos os estados de carregador, pickup, morte, reinício e reconexão.
- Criar uma matriz de entidades e condições de vitória dos modos legados que serão suportados.

### Fase 1 — Baseline controlada

- Grupo: 8–12 jogadores experientes, duas sessões.
- Usar uma sessão clássica apenas como baseline externa e comparar com kits fixos e munição simples.
- Objetivo: medir o efeito dos kits e da ausência de compra, sem tratar a economia como opção do modo.

### Fase 2 — Carregadores

- Comparar contador clássico, carregadores abstratos e modelo híbrido recomendado.
- Registrar recargas parciais, munição perdida, mortes com arma vazia, tempo olhando HUD e dúvidas verbais.
- Não adicionar loot de munição nesta fase.

### Fase 3 — Composição e escalas

- Rodar equipes de 3 contra 3, 5 contra 5, 8 contra 8, 10 contra 10, 12 contra 12 e, quando o runtime/mapa permitirem, 16 contra 16.
- Alternar lados e equipes para separar mapa de equipamento.
- Testar composições extremas, incluindo equipes inteiras de Assault, Support e Marksman.
- Incluir explicitamente dez Assault contra dez Support para verificar se liberdade de composição continua justa e compreensível.
- Testar adesões simultâneas, quantidade ímpar, troca de equipe, desconexão, reconexão e preenchimento com bots sem permitir diferença superior a um por uma ação validada.
- Testar limites e combinações de recuo/cadência, incluindo os quatro cantos do intervalo, contra o mesmo dano fixo.
- Testar capacidade de carregador 1, capacidade igual ao teto e valores que deixam resto, medindo ritmo, memória, rede e legibilidade do HUD.

### Fase 4 — Novatos e servidor comunitário

- Misturar novatos e veteranos sem instrução externa, apenas UI/tutorial do jogo.
- Testar entrada tardia, reconexão, troca de equipe, administração e rotação de mapa.
- Coletar entendimento de objetivo, tipo e munição após a primeira e a quinta rodada.

### Fase 5 — Regressão de mapas e modos legados

- Escolher mapas representativos de cada modo legado prioritário.
- Carregar cada mapa sem recompilação ou metadados obrigatórios do mod.
- Validar spawn das duas equipes, detecção do objetivo, condição de vitória, reinício da rodada e troca de mapa.
- Registrar capacidade prática de jogadores, congestionamento, falhas de bot e impacto da ausência de economia.
- Separar “funciona tecnicamente” de “permanece balanceado e divertido”.

### Instrumentação mínima

- escolha, disponibilidade e troca de tipo;
- composição por rodada e taxa de vitória;
- arma/kit, distância e causa de morte;
- objetivo iniciado/concluído por tipo;
- recargas com munição restante e distribuição dos carregadores;
- pickups, munição no pickup e mortes antes de revelar/usar;
- desconexão, reconexão e troca de equipe;
- duração de rodada e tempo sem contato;
- vitória por lado, equipe, mapa e tamanho de equipe.

## 26. Critérios objetivos de sucesso e rejeição

Valores são hipóteses iniciais de pesquisa, não metas aprovadas.

### Sucesso para avançar

- Pelo menos 80% dos participantes identificam sua responsabilidade e o objetivo após uma rodada, sem explicação externa.
- Pelo menos 75% entendem o estado de seus carregadores após três rodadas.
- Nenhum tipo apresenta vantagem de vitória superior a 5 pontos percentuais após controlar lado, mapa e habilidade, com amostra suficiente.
- Composições monotemáticas continuam capazes de cumprir o objetivo e possuem contrajogo razoável, sem que sua frequência de escolha seja tratada isoladamente como falha.
- O lado mais forte permanece dentro de 55% de vitórias após troca de lados e ajustes iniciais.
- Nenhuma entrada ou troca validada pelo servidor produz diferença superior a um jogador entre as equipes.
- Mapas representativos dos modos legados prioritários carregam sem recompilação e permitem concluir uma rodada.
- Pacotes comunitários não conseguem alterar dano nem executar recuo/cadência fora da região válida do contrato.
- Capacidade zero, negativa, não inteira ou superior ao teto de munição é rejeitada pelo servidor.
- A mediana de duração de rodada não aumenta mais que 15% sobre a baseline escolhida sem melhora qualitativa clara de decisões.
- Menos de 10% das mortes são atribuídas pelos participantes a munição/recarga incompreensível.
- A maioria prefere jogar outra sessão com kits e descreve ao menos uma decisão de equipe criada por tipo.

### Rejeitar ou reformular

- Um tipo é necessário para concluir o objetivo.
- Marksman ou Support determina composição/mapa apesar de ajustes razoáveis.
- Uma composição monotemática não possui contrajogo razoável.
- Carregadores aumentam carga mental sem alterar decisões observáveis.
- A ausência de economia torna rodadas repetitivas para novatos e veteranos em sessões repetidas.
- Equipes com contratos simétricos não são reconhecidas como identidades distintas e aliases, equipamentos e cenário não compensam.
- O HUD necessário encobre combate ou exige tutorial externo.
- Um modo legado prioritário exige alterar ou recompilar seus mapas apenas para iniciar e concluir rodadas.
- Desempenho, rede ou bots exigem custo desproporcional antes de validar valor ao jogador.

### Rollback

Manter cada eixo testável separadamente: equipes/lados, tipos/kits, parâmetros comunitários e carregadores. Poder voltar a munição agregada ou restringir mapeamentos comunitários sem descartar o modelo de cenários. Reintroduzir economia exigiria nova decisão explícita de produto.

## 27. Parâmetros e decisões do responsável do produto

### Parâmetros ajustáveis propostos

| Parâmetro conceitual | Inicial para teste | Faixa segura inicial | Autoridade/configuração |
|---|---:|---:|---|
| Economia habilitada | não | Regra fixa atual | Servidor |
| Escolhas laterais por kit | 1 | 0–1 | Servidor/cenário |
| Diferença máxima entre equipes | 1 jogador | Regra fixa atual | Servidor |
| Tetos de munição por tipo/slot | Matriz da seção 11 | Hipótese para playtest | Servidor/contrato global |
| Quantidade de utilidades | Matriz da seção 11 | Hipótese para playtest | Servidor/contrato global |
| Lanterna inicial | sim | Regra fixa atual | Servidor |
| Visão noturna | não no MVP | desligada/opção simétrica | Servidor/cenário |
| Perfis permitidos para conteúdo comunitário | a definir | allowlist e intervalos seguros | Servidor |
| Dano comunitário | não configurável | valor fixo do perfil | Servidor/contrato global |
| Capacidade comunitária do carregador | por equipe/arma | 1–teto de balas do tipo/slot | Servidor/contrato global |
| Recuo comunitário | a definir por perfil | `recoil_min`–`recoil_max` | Servidor/contrato global |
| Cadência comunitária | a definir por perfil | `rate_min`–`rate_max` | Servidor/contrato global |
| Tempo de recarga | fixo por categoria no MVP | valor centralizado a definir por categoria | Servidor/contrato global |
| Escopeta pump-action | baseline M3 | início 0,55 s; 0,45 s por cartucho | Servidor/contrato global |
| Escopeta semiautomática | baseline XM1014 | início 0,55 s; 0,30 s por cartucho | Servidor/contrato global |
| Combinação recuo/cadência | a definir | presets ou orçamento conjunto | Servidor/contrato global |
| Carregadores por kit | por arma/tipo | 2–6 | Servidor |
| Seleção automática | mais cheio | mais cheio/ordem | Servidor |
| Reservas derrubadas | não | não/saque limitado | Servidor |
| Vida útil de arma no chão | baseline do modo | por mapa/servidor | Servidor |
| Troca de tipo | próximo spawn | próximo spawn/próxima rodada | Servidor |
| Supressão mecânica | nenhuma | nenhuma/experimento leve | Servidor + cliente |

Os valores concretos de armas, munição, tempos e utilidades só devem ser definidos após escolher os perfis e a baseline.

### Decisões pendentes

1. Qual é a visão oficial e quais pilares arbitram ritmo versus realismo?
2. Qual quantidade de jogadores ativos por equipe deve orientar a criação de mapas e o balanceamento, mesmo sem formato obrigatório?
3. A Direção C é autorizada para prototipagem?
4. O primeiro modo é dispositivo, controle de área ou outro objetivo?
5. Qual duração de rodada e de partida é alvo?
6. Quais serão as duas primeiras equipes fictícias?
7. As identidades das equipes são trocadas junto com os lados ou cada equipe executa ambos os papéis?
8. Quais valores iniciais de kit preservam funções distintas entre Assault, Support, Marksman e Breacher?
9. Sniper usa arma de eliminação em um tiro ou um perfil de precisão menos extremo?
10. O HUD mostra munição atual exata ou aproximada?
11. Carregadores individuais entram no primeiro teste ou depois de validar kits?
12. Armas coletadas podem ser usadas por qualquer tipo?
13. Qual é a política futura para equipes baseadas em organizações reais e conflitos contemporâneos?
14. Qual nível de suporte a bots é necessário para considerar o MVP publicável?
15. O teto de munição conta o carregador inserido e descarta o resto que não completa um carregador?
16. Quais intervalos e combinações de recuo/cadência são seguros para cada perfil de arma?
17. As quantidades propostas de granadas, flashes e smokes devem entrar no primeiro playtest ou começar reduzidas?
18. Quais armas do CS 1.6 serão a referência de tempo para as demais categorias no primeiro playtest?

## 28. Recomendação final

Adotar como hipótese a Direção C, com disciplina de Direção A no escopo. A primeira identidade do mod deve ser “cenários por rodadas com equipes sem rótulo moral fixo, tipos legíveis e kits previsíveis”, não “simulação detalhada de equipamentos”.

Separar equipe, lado operacional e tipo base permanece uma decisão robusta. O contrato do tipo é simétrico; alias, apresentação e mapeamento temático permitido podem mudar por equipe. A economia foi removida por decisão. Assault, Support, Marksman e Breacher formam o catálogo fixo do MVP; seus valores e a munição física continuam sujeitos a playtest, e novos tipos só serão considerados depois dessa validação.

Começar por equipes fictícias com contratos simétricos, um objetivo claro, kits predefinidos e munição simples. Validar tipos, limites e mapeamentos comunitários antes de acrescentar carregadores individuais; validar carregadores antes de saque. Se o sistema de carregadores não criar decisões compreendidas e valorizadas, voltar ao contador agregado. Se rodadas iguais parecerem repetitivas, ajustar objetivos e kits antes de inventar requisição, tickets ou cooldowns.

Não avançar esta spec para `approved` até o responsável do produto decidir explicitamente os itens centrais da seção 27 e aprovar uma hipótese de MVP.
