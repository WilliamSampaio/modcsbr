# Facções, funções e kits predefinidos

Status: backlog — exploração de produto, não aprovada

## Convenções desta spec

- **Fato:** confirmado no repositório ou na arquitetura atual.
- **Hipótese:** suposição que precisa de playtest ou investigação.
- **Recomendação:** direção preferida para experimentar, ainda não aprovada.
- **Decisão pendente:** escolha que cabe ao responsável do produto.

Esta spec registra uma exploração de ideia e uma proposta de MVP. Ela não autoriza implementação, não aprova a remoção da economia e não define as quatro funções como permanentes.

## Registro da proposta original

A proposta recebida busca substituir a divisão permanente Terrorists/Counter-Terrorists por facções e lados operacionais neutros; selecionar duas facções por partida; transformar as quatro opções tradicionais de modelo em combatentes com função tática; conceder kits predefinidos sem dinheiro ou compra; representar munição como carregadores; preservar o estado de munição de armas coletadas; e decidir como munição de mortos, limites de função, supressão, objetivos e assimetria devem funcionar.

Ela considera funções como Assault, Support, Sniper, Medic, Engineer, Breacher e Recon, mas não aprova nenhuma. Também apresenta três direções de produto — classes leves, esquadrões táticos e identidade intermediária — e pede um MVP que preserve a resposta rápida do gunplay clássico sem transformar o mod em simulador militar.

## Estado atual confirmado e limites da análise

- **Fato:** o runtime alvo é Xash3D FWGS, com ReGameDLL_CS como GameDLL autoritativa e CS16Client como cliente/HUD/menu.
- **Fato:** mudanças de gameplay devem começar em `specs/backlog`; nenhuma spec relacionada estava salva no backlog no início desta análise.
- **Fato:** `docs/product/product-vision.md` e `docs/product/design-pillars.md` existem, mas estão vazios.
- **Fato:** não houve mudança de código ou de submódulo nesta exploração.
- **Necessidade de investigação técnica:** esta análise não auditou o comportamento herdado de compra, munição, drop, bots e objetivos no código. Referências ao CS clássico servem como baseline de produto declarada na proposta, não como confirmação de cada detalhe da build atual.

## 1. Resumo executivo

**Tese:** a identidade promissora não é “CS 1.6 mais realista”, mas um FPS por rodadas em que facções têm identidade própria, os jogadores assumem responsabilidades legíveis e entram em cada rodada com kits previsíveis. O valor vem da composição e da execução da equipe, não do inventário detalhado.

**Recomendação:** prototipar a Direção C, uma identidade intermediária. Separar identidade permanente de facção dos papéis temporários de Atacante e Defensor; usar confrontos coerentes definidos pelo cenário do mapa; começar com facções mecanicamente espelhadas; testar quatro funções equivalentes; remover compra apenas como experimento reversível; e preparar um teste posterior de carregadores individuais simplificados com uma única recarga tática.

O primeiro protótipo deve evitar assimetria forte, facções reais, cura, efeitos artificiais de supressão, saque de carregadores, inventário manual, peso, acessórios e progressão entre rodadas. Esses sistemas custam clareza antes de a hipótese principal — “funções e kits melhoram decisões de equipe sem destruir o ritmo clássico” — estar validada.

O risco central é substituir a economia do CS por vários sistemas menores e mais difíceis de compreender. Se classes, limites, carregadores, saque, recursos coletivos e habilidades especiais estrearem juntos, um playtest negativo não revelará qual premissa falhou.

## 2. Tese central da proposta

O problema real não é apenas a nomenclatura “Terrorist” e “Counter-Terrorist”. É o acoplamento entre três conceitos que deveriam ser independentes:

1. **Facção:** identidade persistente, visual, sonora e narrativa.
2. **Lado operacional:** papel temporário no cenário, como Atacante ou Defensor.
3. **Função:** responsabilidade individual e kit dentro da equipe.

Separar esses eixos permite que uma facção ataque em um cenário e defenda em outro sem receber um julgamento moral permanente. Também permite trocar lados na metade da partida sem trocar a identidade da facção, se o cenário suportar essa inversão.

**Hipótese principal:** escolhas de função e kits predefinidos podem substituir parte da decisão tática hoje concentrada na compra, mantendo rodadas justas e legíveis.

**Contraponto:** neutralizar os nomes do sistema não neutraliza o conteúdo. Um confronto entre organizações reais continua comunicando uma posição editorial por meio do objetivo, do mapa, das falas, da vitória e da própria seleção de participantes.

## 3. O que realmente diferencia o mod

### Diferenciadores fortes

- Facção desvinculada de Atacante/Defensor.
- Responsabilidade tática reconhecível antes do spawn.
- Kits de disponibilidade previsível, reduzindo a barreira do menu de compra.
- Munição por carregadores, se criar decisões rápidas e legíveis.
- Cenários que definem confrontos e objetivos coerentes, em vez de qualquer facção contra qualquer facção.

### Diferenciadores fracos ou genéricos

- Apenas renomear CT/T para Equipe 1/Equipe 2.
- Trocar quatro skins por quatro rótulos sem alterar responsabilidades.
- Usar armas diferentes por facção sem uma linguagem comum de balanceamento.
- Adicionar realismo de inventário que não afeta decisões relevantes.

## 4. Partes que podem prejudicar ritmo ou clareza

- Dois comandos de recarga, inspeção, seleção manual e consolidação de carregadores sobrecarregam o gunplay rápido.
- Esconder a munição de uma arma coletada por muito tempo produz mortes percebidas como arbitrárias.
- Saquear corpo, munição, acessórios e carregadores desvia o foco do objetivo.
- Cura em rodadas sem respawn pode tornar o Medic obrigatório e apagar a importância do dano acumulado.
- Supressão com tremor, blur, lentidão ou perda de precisão reduz controle e pode premiar spam.
- Limites rígidos sem fila justa transformam uma função popular em disputa social.
- Assimetria forte multiplica exceções de mapa, composição, bots, HUD e balanceamento.
- Recursos entre rodadas podem recriar uma economia menos transparente que a original.

## 5. Problemas ainda não resolvidos

- A visão e os pilares oficiais de produto estão vazios no repositório; falta uma referência aprovada para arbitrar “clássico” versus “tático”.
- Não há decisão sobre público-alvo, duração desejada, tamanho típico de equipe nem prioridade entre competitivo e servidor comunitário casual.
- Não foi definido se o objetivo principal continuará baseado em rodada sem respawn.
- Não há política editorial para facções reais, conflitos contemporâneos e organizações criminosas.
- Não há taxonomia de equivalência entre armas nem orçamento de poder por kit.
- Não foi validado se mapas existentes continuam jogáveis sem compra e com kits garantidos.
- Não foi investigado o custo de animações, HUD, mensagens de rede e bots para carregadores individuais.
- Não foi definida uma regra social justa para funções limitadas.

## 6. Terminologia recomendada

| Conceito | Termo recomendado | Evitar como termo de sistema | Motivo |
|---|---|---|---|
| Identidade coletiva | **Facção** | Equipe 1/2 | Tem identidade sem atribuir moralidade. |
| Grupo competitivo atual | **Equipe** | Facção | Uma equipe é a instanciação de jogadores; a facção é o conteúdo escolhido. |
| Papel no objetivo | **Atacante / Defensor** | T / CT | É temporário e descritivo. |
| Responsabilidade mecânica | **Função** | Classe | “Função” enfatiza contribuição, não progressão rígida. |
| Identidade representada | **Combatente** | Operador/personagem | “Operador” traz expectativas de herói e habilidades únicas; “personagem” sugere indivíduo canônico. |
| Equipamento concedido | **Kit** | Loadout livre | Comunica um pacote predefinido. |
| Variação pequena do kit | **Opção de kit** | Subclasse | Evita uma hierarquia prematura. |
| Conteúdo mapa + modo + facções | **Cenário** | Matchup livre | Reúne coerência narrativa e regras. |

Função e combatente devem ser entidades separadas. “Marksman” é uma função; cada facção pode ter um combatente visualmente distinto que a exerce. No MVP, combatentes não possuem estatísticas próprias.

## 7. Modelo recomendado para facções

### Comparação

| Modelo | Clareza | Identidade | Balanceamento | Conteúdo/manutenção | Risco dominante |
|---|---|---|---|---|---|
| Espelhado | Alta | Baixa a média | Baixo | Baixo | Facções parecerem skins. |
| Parcialmente assimétrico | Média/alta | Alta | Médio | Médio | Uma arma equivalente ser claramente superior. |
| Fortemente assimétrico | Baixa no início | Muito alta | Muito alto | Muito alto | Facção/meta obrigatória e mapas incompatíveis. |

**Recomendação para o MVP:** facções espelhadas em poder e função, com identidade visual, sonora e nominal diferente. Armas podem ter aparência diferente apenas se compartilharem o mesmo perfil mecânico no teste.

**Recomendação futura:** assimetria parcial por substituições laterais, usando um orçamento comum: alcance, dano, cadência, mobilidade, utilidade e dificuldade. Nenhuma facção deve receber vantagem líquida, função exclusiva obrigatória ou resposta única a um objetivo.

**Rejeição para o início:** assimetria forte. Ela impede distinguir falha de função, arma, mapa ou facção.

Não permitir qualquer facção contra qualquer outra. Cada cenário mantém uma lista de facções e pares coerentes. Espelho da mesma facção pode existir apenas como modo de treino, teste ou competição abstrata, com apresentação que diferencie claramente as equipes.

## 8. Fluxo recomendado para escolha das facções

### Consequências dos modelos de seleção

| Modelo | Benefício | Consequência/risco | Uso recomendado |
|---|---|---|---|
| Mapa fixa o confronto | Coerência e balanceamento altos | Pouca variedade por mapa | MVP e competitivo. |
| Administrador escolhe | Curadoria comunitária | Configuração ruim pode quebrar narrativa/meta | Presets validados. |
| Voto escolhe cenário | Agência coletiva | Popularidade repetitiva e voto estratégico | Entre poucos cenários completos. |
| Jogadores escolhem cada facção | Expressão | Equipes escolhem vantagem, espelhos e combinações incoerentes | Não recomendado. |
| Qualquer contra qualquer | Muito conteúdo combinável | Custo combinatório de balanceamento, vozes, objetivos e narrativa | Rejeitado. |
| Confrontos predefinidos globais | Controle editorial | Menor liberdade para servidores | Catálogo padrão, extensível por configuração. |

1. O mapa publica cenários compatíveis, cada um com modo, objetivo, lados e pares de facções permitidos.
2. O administrador ou a rotação do servidor define um cenário padrão e pode limitar a lista.
3. Opcionalmente, os jogadores votam entre cenários completos; não votam separadamente em duas facções que talvez sejam incoerentes.
4. O servidor sorteia ou balanceia jogadores entre as equipes depois da escolha do cenário.
5. Cada equipe recebe uma facção e um lado operacional.
6. Em formato competitivo, lados são trocados na metade quando o cenário for mecanicamente reversível; as facções podem ser trocadas junto com o lado para preservar a narrativa.
7. Reconexão restaura equipe, facção e elegibilidade, sem reabrir benefícios.

Para servidor comunitário, o administrador precisa de presets, lista permitida e opção de votação. O cliente nunca decide sozinho uma combinação válida.

## 9. Modelo recomendado para funções

### Modelos comparados

| Modelo | Clareza | Identidade | Variedade | Balanceamento/manutenção | Competitividade |
|---|---|---|---|---|---|
| 1 — Universais | Alta | Média | Média | Baixo | Alta |
| 2 — Assimétricas | Baixa/média | Alta | Alta | Muito alto | Baixa até maturar |
| 3 — Híbrido | Alta | Alta | Alta | Médio | Alta se equivalências forem auditáveis |

**Recomendação:** Modelo 3, mas em duas etapas. Primeiro, funções universais e espelhadas. Depois, pequenas variações de kit por facção, sem alterar a responsabilidade fundamental.

Cada função precisa de:

- uma frase de fantasia;
- um verbo de contribuição principal;
- um kit-base e no máximo uma pequena escolha;
- uma fraqueza perceptível;
- um ícone e uma silhueta legíveis;
- utilidade no objetivo além de dano;
- comportamento útil em equipes pequenas.

Não usar atributos passivos de vida, velocidade ou dano no MVP. Eles tornam confrontos menos previsíveis e fazem o modelo visual carregar informação competitiva demais.

## 10. Quatro funções sugeridas para o primeiro protótipo

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
- **Quantidade:** livre no primeiro teste, com telemetria; limite configurável se surgir composição dominante.
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
- **Mapas grandes:** função natural, sujeita a linhas e contrajogo.
- **Quantidade:** limite inicial proporcional e configurável.
- **Risco:** arma de alto impacto virar escolha obrigatória ou prêmio social disputado.

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

**Recomendação:** supressão emergente no MVP, apoiada apenas pelos sons, impactos e risco real que qualquer arma já produz. Não aplicar redução de precisão, movimento, visão ou controle. Se o Support não cumprir sua função, ajustar capacidade, manuseio, geometria e utilidade antes de adicionar um debuff invisível. Qualquer feedback audiovisual futuro deve ter opções de acessibilidade e não ocultar informação necessária.

## 11. Modelo recomendado para kits

**Recomendação:** kit-base fixo por função, com no máximo uma escolha lateral antes do spawn. Exemplo: uma de duas utilidades, ou uma de duas armas do mesmo papel e orçamento de poder. Não oferecer uma árvore completa.

Regras propostas:

- A seleção ocorre no lobby e pode ser alterada enquanto morto para valer no próximo spawn elegível.
- Não há troca de função ou regeneração de kit durante uma vida.
- Cada spawn concede exatamente um kit validado pelo servidor.
- Armas coletadas não mudam a função nem concedem os consumíveis do novo papel.
- A morte não cria um novo kit se o modo não tiver respawn.
- Em modos com respawn futuro, cada vida precisa de proteção contra geração infinita de armas e munição.
- Opções de kit devem ser equivalentes, nunca uma progressão vertical desbloqueável.

Se todos escolherem a mesma função, a composição é aceita para funções comuns e o HUD alerta sobre lacunas sem impedir o spawn. Apenas funções especiais usam limite rígido. Forçar uma composição “correta” pode tornar partidas pequenas impossíveis.

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

**Recomendação para o MVP:** não criar substituto. Testar rodadas simétricas e tratar a ausência de progressão como uma variável deliberada. Um recurso coletivo, tickets ou cooldown de kit só deve ser adicionado se o playtest demonstrar falta de arco entre rodadas, não por apego à complexidade da economia original.

**Rollback:** manter a arquitetura de produto aberta à economia clássica ou a uma economia simplificada. Remoção não é decisão irreversível.

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

Uma recarga com o carregador vazio segue o mesmo comando. Recarga rápida com descarte é experimento futuro e só deve existir se o benefício de timing for perceptível e as animações comunicarem claramente a perda.

O sistema precisa impedir cancelamento que duplique ou restaure munição. A transição do carregador deve ter um ponto autoritativo definido pelo servidor, mesmo se a animação for prevista pelo cliente.

## 15. Regra recomendada para armas coletadas

- A arma no chão preserva exatamente o carregador inserido, o modo de disparo e configurações mecânicas que pertençam à própria entidade.
- Pegar a arma não concede reservas, kit, função nem acessórios externos do antigo dono.
- A quantidade do carregador é desconhecida antes da coleta, mas o HUD a revela exatamente após a animação normal de equipar. Não exigir inspeção no MVP.
- A coleta interrompe ações incompatíveis conforme as regras já legíveis de troca de arma.
- Qualquer função pode usar a arma coletada, salvo proibição explícita do cenário; restrições rígidas reduzem jogadas emergentes.
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

## 17. Limites e regras para funções especiais

**Recomendação inicial:** apenas Marksman tem limite rígido; Support recebe telemetria antes de um limite.

- Limite sugerido para teste: `ceil(jogadores_da_equipe / 6)`, mínimo 1 quando a função estiver habilitada e máximo 2 no MVP.
- Cenários podem reduzir o limite a zero ou substituir o kit em mapas pequenos.
- O jogador informa função preferida e uma função reserva.
- Se houver disputa, o servidor usa uma fila visível com rotação entre rodadas; desconectar remove a posição, reconectar não dá prioridade.
- O detentor não pode reservar a função para toda a partida sem jogar.
- Servidores comunitários podem configurar limite, mas o padrão competitivo deve ser consistente.

**Hipótese alternativa a testar:** um Marksman suficientemente lateral pode dispensar limite. Essa é a melhor solução para conflito social, mas não deve ser presumida enquanto uma arma de alto impacto estiver disponível.

Não usar votação entre jogadores para conceder a função; ela favorece grupos, assédio e popularidade. “Primeiro a clicar” também premia latência e conhecimento de interface.

## 18. Riscos de balanceamento e exploits

| Risco | Efeito | Mitigação/experimento |
|---|---|---|
| Todos escolhem Assault | Outras funções não têm valor | Medir escolha e contribuição; melhorar objetivos, não impor cotas gerais. |
| Marksman obrigatório | Meta e disputa social | Sidegrade, limite proporcional, mapas com cobertura e fila justa. |
| Support domina corredor | Spam sem contrajogo | Custos de manuseio, dispersão sustentável e utilidade limitada; sem debuff artificial. |
| Facção tem arma superior | Escolha por vantagem | Perfis espelhados no MVP e testes A/B com troca de lados. |
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
| Composição torna objetivo impossível | Partida decidida no menu | Nenhuma função exclusiva necessária para concluir objetivo. |
| Spawn/drop transfere kit | Exploit cooperativo | Kit não é recurso persistente entre rodadas; regras de pickup consistentes. |

## 19. Riscos de experiência do jogador

- Novatos podem confundir função com arma favorita. O menu precisa mostrar “como ajuda a equipe”, não só estatísticas.
- Uma função indisponível sem motivo visível parece bug; mostrar limite, fila e alternativa.
- Carregadores parciais invisíveis criam a sensação de munição desaparecendo.
- Função com arma inadequada ao mapa vira armadilha de escolha.
- Ser forçado a função reserva pode reduzir agência; a fila deve ser transparente.
- Partidas pequenas não comportam interdependência rígida. Toda equipe precisa conseguir concluir o objetivo com qualquer composição.
- Jogadores experientes podem sentir perda da camada econômica e do prazer de adquirir armas.
- Kits fixos podem produzir monotonia e reduzir expressão individual.
- Termos militares excessivos e HUD denso aumentam a barreira sem melhorar o combate.
- Bots que ignoram função, objetivo, carregadores ou limites quebram tanto treino quanto servidores comunitários.

## 20. Riscos narrativos e de identidade

Remover T/CT evita um rótulo moral fixo, mas não torna neutros objetivos, falas e resultados. “Exército Brasileiro versus PCC”, “Rússia versus Ucrânia” e confrontos entre polícias reais exigem pesquisa, contexto editorial, revisão jurídica e análise de políticas de distribuição. Também podem ser percebidos como simplificação, propaganda, glorificação ou exploração de violência atual.

**Recomendação para o MVP:** duas facções fictícias, plausíveis e não caricatas, em operação competitiva ou conflito ficcional claramente contextualizado. Não usar “simulação/treinamento” como desculpa universal se o restante da apresentação mostrar mortes e conflito real.

Se facções reais forem consideradas depois:

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
| Plantar/desarmar | Alta mecanicamente | Recontextualizar dispositivo e cenário; “bomba genérica” não serve a toda facção. |
| Reféns | Baixa/média | Codifica fortemente papéis morais e exige narrativa específica. |
| Eliminação | Alta para teste técnico | Não valida contribuição não letal das funções. |
| Controle de território | Alta | Neutro e favorece utilidade/composição; requer regras/mapas adequados. |
| Captura de pontos | Alta | Bom para ataque/defesa ou disputa simétrica. |
| Escolta | Média | Forte dependência de mapa, bots e balanceamento. |
| Múltiplos objetivos | Futuro | Aumenta leitura e custo antes do loop básico. |

**Recomendação de modo do MVP:** um cenário de ataque e defesa com objetivo de “instalar/interromper um dispositivo” ou “assegurar uma área”, sem linguagem moral. Usar eliminação como condição secundária, não como único objetivo. O mapa define contexto e facções permitidas.

### Ciclo de vida recomendado

| Momento | Regra de produto | Autoridade |
|---|---|---|
| Entrada no servidor | Recebe cenário, facções, lado, limites e estado da partida. | Servidor |
| Lobby/votação | Vota em cenários completos permitidos. | Servidor valida/contabiliza |
| Escolha de equipe | Preferência sujeita a balanceamento; não escolhe vantagem mecânica livremente. | Servidor |
| Escolha de função | Seleciona preferência e reserva; mostra disponibilidade. | Servidor valida |
| Início da partida | Trava cenário e inicializa placar/lados. | Servidor |
| Início da rodada | Resolve fila de função e limpa estado transitório anterior. | Servidor |
| Spawn | Concede um kit íntegro correspondente. | Servidor |
| Troca/recarga | Mantém arma e carregadores como estados separados e validados. | Servidor; cliente apresenta/prediz |
| Coleta de arma | Transfere entidade com carregador inserido; sem reservas. | Servidor |
| Coleta de munição | Inexistente no MVP. | Servidor |
| Morte | Derruba arma elegível; descarta reservas; encerra ações. | Servidor |
| Espectador | Não recebe informação além da política do modo/equipe. | Servidor filtra |
| Respawn | Ausente no modo principal; se habilitado, segue nova concessão controlada. | Servidor |
| Troca de equipe | Limpa inventário e revalida fila/função; nunca concede benefício imediato. | Servidor |
| Reconexão | Restaura vínculo e restrições; não gera kit/spawn. | Servidor |
| Reinício de rodada | Remove entidades e estados definidos; reinicia kits sem duplicação. | Servidor |
| Mudança de mapa | Carrega cenários/limites do novo mapa; zera filas. | Servidor |
| Encerramento | Congela resultado e apresenta facções/lados sem julgamento moral. | Servidor + cliente |

### HUD e feedback mínimo

- nome e emblema da facção;
- lado operacional e objetivo atual;
- função e resumo do kit;
- arma atual;
- munição exata no carregador inserido;
- número de carregadores reserva e indicação de quantos estão parciais;
- aviso de incompatibilidade ao tentar usar reserva/pickup;
- marcador de arma coletada até a primeira troca ou por curto período;
- limite, ocupação e fila de função;
- mensagens claras quando uma escolha só valerá no próximo spawn.

Permanecem desconhecidos: reservas de inimigos, munição de arma no chão antes de coletar e composição inimiga antes de ser observada, salvo regra explícita do modo. Espectador competitivo não pode virar fonte de informação privilegiada.

### Divisão de responsabilidades de alto nível

**ReGameDLL_CS:** cenário e facções; lados; função e capacidade; concessão de kit; inventário; lista e quantidade de carregadores; transição de recarga; estado de armas no chão; compatibilidade; pickups; morte; respawn; troca de equipe; vitória; proteção contra reconexão e duplicação.

**CS16Client:** menus de cenário/equipe/função; HUD; ícones; feedback de fila e falha; apresentação de carregadores; animações e sons; previsão apenas onde reconciliável; localização.

**Mensagens de rede:** precisam transportar somente o estado necessário ao destinatário, com identificadores estáveis para facção, função, kit, família de carregador e arma. A forma e o custo são investigação técnica futura.

**Conteúdo:** modelos legíveis, sons/vozes, ícones, textos neutros, cenários/mapas e animações. Não assumir que as animações atuais suportam dois tipos de recarga.

**Bots:** precisam escolher composição, respeitar limites, executar objetivos, avaliar alcance do kit, recarregar sem desperdiçar decisões e coletar arma apenas quando útil. O MVP pode testar primeiro com humanos, mas não pode declarar suporte a bots antes dessa adaptação.

## 22. Comparação entre as direções A, B e C

| Critério | A — Clássico/classes leves | B — Tático/esquadrões | C — Intermediária |
|---|---|---|---|
| Ritmo | Muito próximo do CS | Mais lento | Próximo, com pausas curtas |
| Funções | Leves e permissivas | Fortes e interdependentes | Claras, mas não obrigatórias |
| Facções | Espelhadas | Assimetria relevante | Espelhadas primeiro, parcial depois |
| Kits | Fixos | Especializados/limitados | Fixos + uma escolha lateral |
| Munição | Contador ou mags abstratos | Mags físicos completos | Mags individuais sem inventário manual |
| Saque | Arma simples | Corpo e compatibilidade | Arma com mag inserido; sem reservas |
| Economia | Ausente ou clássica | Recursos/requisição | Ausente no teste, reversível |
| Clareza | Alta | Baixa/média | Alta se HUD for contido |
| Identidade | Baixa/média | Alta, porém derivativa | Alta e própria se cenários forem fortes |
| Custo/risco | Baixo | Muito alto | Médio e controlável |
| Servidores pequenos | Bom | Ruim sem adaptações | Bom se funções não forem obrigatórias |

### Direção A

É a alternativa mínima e o melhor fallback. Valida nomenclatura, kits e fluxo com pouco risco, mas pode parecer apenas CS com loadouts.

### Direção B

Maximiza fantasia de esquadrão, porém conflita com resposta rápida, mapas pequenos, jogadores avulsos e escopo de primeiro protótipo. Deve ser rejeitada como pacote inicial.

### Direção C

Entrega diferenciação suficiente para teste, mantendo regras legíveis. Seu perigo é acumular gradualmente todas as complexidades da Direção B; por isso, precisa de limites explícitos de escopo.

### Direção D — Cenários competitivos modulares

Alternativa futura: o núcleo mantém funções e perfis espelhados, enquanto cada mapa escolhe objetivo, pares de facções, nomes e pequenas opções. A variedade vem do cenário, não de habilidades exclusivas. É compatível com C e pode se tornar a identidade de longo prazo se mapas e ferramentas de autoria suportarem a carga.

## 23. MVP recomendado

O menor protótipo capaz de validar a tese contém:

- um modo de ataque/defesa por rodadas, sem respawn;
- um cenário coerente em um mapa selecionado e uma segunda escala de mapa para comparação;
- duas facções fictícias, mecanicamente espelhadas;
- papéis Atacante/Defensor separados das facções;
- quatro funções universais: Assault, Support, Breacher e Marksman;
- kits fixos, com no máximo uma escolha lateral por função;
- sem dinheiro e sem compra, sob feature flag ou configuração reversível;
- recarga tática única;
- carregadores individuais escolhidos automaticamente pelo “mais cheio”;
- HUD exato para carregador atual e contagem/estado parcial das reservas;
- coleta de arma com o carregador inserido e revelação após equipar;
- reservas do morto descartadas;
- limite proporcional apenas para Marksman;
- supressão apenas emergente por som, impacto e ameaça real;
- estado competitivo autoritativo no servidor;
- parâmetros centralizados e configuráveis para playtest.

Essas variáveis não devem estrear simultaneamente na coleta de evidência. A primeira sessão usa munição agregada para isolar facções, funções, kits e ausência de compra. O mesmo protótipo então habilita carregadores individuais para a comparação da Fase 2. Assim, “carregadores no MVP” significa uma segunda configuração experimental do mesmo programa, não uma dependência para validar o núcleo.

## 24. Fora do primeiro protótipo

- facções reais ou organizações criminosas reais;
- qualquer confronto livre entre facções;
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

### Fase 1 — Baseline controlada

- Grupo: 8–12 jogadores experientes, duas sessões.
- Comparar economia/munição clássicas com kits fixos e munição simples.
- Objetivo: isolar o efeito dos kits e da remoção da compra.

### Fase 2 — Carregadores

- Comparar contador clássico, carregadores abstratos e modelo híbrido recomendado.
- Registrar recargas parciais, munição perdida, mortes com arma vazia, tempo olhando HUD e dúvidas verbais.
- Não adicionar loot de munição nesta fase.

### Fase 3 — Composição e escalas

- Rodar 3v3, 5v5, 8v8 e 12v12 em mapa pequeno e grande.
- Alternar lados e facções para separar mapa de equipamento.
- Testar Marksman sem limite, com limite e com fila.

### Fase 4 — Novatos e servidor comunitário

- Misturar novatos e veteranos sem instrução externa, apenas UI/tutorial do jogo.
- Testar entrada tardia, reconexão, troca de equipe, administração e rotação de mapa.
- Coletar entendimento de objetivo, função e munição após a primeira e a quinta rodada.

### Instrumentação mínima

- escolha, disponibilidade e troca de função;
- composição por rodada e taxa de vitória;
- arma/kit, distância e causa de morte;
- objetivo iniciado/concluído por função;
- recargas com munição restante e distribuição dos carregadores;
- pickups, munição no pickup e mortes antes de revelar/usar;
- desconexão, reconexão e troca de equipe;
- duração de rodada e tempo sem contato;
- vitória por lado, facção, mapa e tamanho de equipe.

## 26. Critérios objetivos de sucesso e rejeição

Valores são hipóteses iniciais de pesquisa, não metas aprovadas.

### Sucesso para avançar

- Pelo menos 80% dos participantes identificam sua responsabilidade e o objetivo após uma rodada, sem explicação externa.
- Pelo menos 75% entendem o estado de seus carregadores após três rodadas.
- Nenhuma função excede 40% das escolhas em equipes de cinco ou mais por preferência persistente, exceto Assault como fallback temporário.
- Nenhuma função apresenta vantagem de vitória superior a 5 pontos percentuais após controlar lado, mapa e habilidade, com amostra suficiente.
- O lado mais forte permanece dentro de 55% de vitórias após troca de lados e ajustes iniciais.
- A mediana de duração de rodada não aumenta mais que 15% sobre a baseline escolhida sem melhora qualitativa clara de decisões.
- Menos de 10% das mortes são atribuídas pelos participantes a munição/recarga incompreensível.
- A maioria prefere jogar outra sessão com kits e descreve ao menos uma decisão de equipe criada por função.

### Rejeitar ou reformular

- Uma função é necessária para concluir o objetivo.
- Marksman ou Support determina composição/mapa apesar de ajustes razoáveis.
- A fila de função gera abandono, griefing ou conflito recorrente.
- Carregadores aumentam carga mental sem alterar decisões observáveis.
- A ausência de economia torna rodadas repetitivas para novatos e veteranos em sessões repetidas.
- Facções mecanicamente espelhadas não são reconhecidas como identidade significativa e o cenário não compensa.
- O HUD necessário encobre combate ou exige tutorial externo.
- Desempenho, rede ou bots exigem custo desproporcional antes de validar valor ao jogador.

### Rollback

Manter cada eixo testável separadamente: nomenclatura/facções, funções/kits, economia e carregadores. Poder voltar a munição agregada, compra clássica ou funções cosméticas sem descartar o modelo de cenários.

## 27. Parâmetros e decisões do responsável do produto

### Parâmetros ajustáveis propostos

| Parâmetro conceitual | Inicial para teste | Faixa segura inicial | Autoridade/configuração |
|---|---:|---:|---|
| Economia habilitada | não | sim/não | Servidor |
| Escolhas laterais por kit | 1 | 0–1 | Servidor/cenário |
| Limite de Marksman | ceil(N/6), máx. 2 | 0–ceil(N/4) | Servidor/cenário |
| Limite de Support | livre | 1–livre | Servidor/cenário |
| Carregadores por kit | por arma/função | 2–6 | Servidor |
| Seleção automática | mais cheio | mais cheio/ordem | Servidor |
| Reservas derrubadas | não | não/saque limitado | Servidor |
| Vida útil de arma no chão | baseline do modo | por mapa/servidor | Servidor |
| Troca de função | próximo spawn | próximo spawn/próxima rodada | Servidor |
| Supressão mecânica | nenhuma | nenhuma/experimento leve | Servidor + cliente |

Os valores concretos de armas, munição, tempos e utilidades só devem ser definidos após escolher os perfis e a baseline.

### Decisões pendentes

1. Qual é a visão oficial e quais pilares arbitram ritmo versus realismo?
2. O público principal é 5v5 competitivo, servidor comunitário de tamanho variável ou ambos com presets?
3. A Direção C é autorizada para prototipagem?
4. A economia será desligada apenas no experimento, removida do modo principal ou mantida em outro modo?
5. O primeiro modo é dispositivo, controle de área ou outro objetivo?
6. Quais tamanhos de equipe e durações são alvo?
7. As duas primeiras facções serão fictícias?
8. Facções são trocadas junto com os lados ou permanecem e executam ambos os papéis?
9. As quatro funções propostas merecem protótipo, especialmente Breacher versus Recon?
10. Marksman usa arma de eliminação em um tiro ou um perfil de precisão menos extremo?
11. Haverá limite e fila de Marksman no teste inicial?
12. O HUD mostra munição atual exata ou aproximada?
13. Carregadores individuais entram no primeiro teste ou depois de validar kits?
14. Armas coletadas podem ser usadas por qualquer função?
15. Qual é a política futura para facções reais e conflitos contemporâneos?
16. Qual nível de suporte a bots é necessário para considerar o MVP publicável?

## 28. Recomendação final

Adotar como hipótese a Direção C, com disciplina de Direção A no escopo. A primeira identidade do mod deve ser “cenários por rodadas com facções neutras no sistema, funções legíveis e kits previsíveis”, não “simulação detalhada de equipamentos”.

Separar facção, lado operacional e função é uma recomendação robusta mesmo que economia ou carregadores sejam rejeitados depois. Já a remoção da economia, os quatro papéis e a munição física são experimentos independentes e reversíveis.

Começar por facções fictícias espelhadas, um objetivo claro, kits fixos e munição simples. Validar funções antes de acrescentar carregadores individuais; validar carregadores antes de saque. Se o sistema de carregadores não criar decisões compreendidas e valorizadas, voltar ao contador agregado. Se rodadas iguais parecerem repetitivas, comparar a economia clássica antes de inventar requisição, tickets ou cooldowns.

Não avançar esta spec para `approved` até o responsável do produto decidir explicitamente os itens centrais da seção 27 e aprovar uma hipótese de MVP.
