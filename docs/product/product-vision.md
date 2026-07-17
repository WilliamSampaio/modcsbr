# Visão do produto — modcsbr

Status: direção inicial confirmada; visão ainda incompleta

## Visão

`modcsbr` será um FPS multiplayer por rodadas que preserva a resposta direta e o ecossistema de mapas e modos do Counter-Strike 1.6, enquanto substitui os rótulos fixos de Terrorists/Counter-Terrorists por equipes com identidade própria, contratos simétricos de tipo e kits predefinidos sem economia.

## Promessa ao jogador

- Entrar em partidas de tamanho variável, sem depender de um formato fixo de cinco contra cinco.
- Escolher livremente qualquer tipo de jogador disponível, sem cotas ou composição obrigatória.
- Reconhecer contratos equivalentes de tipo mesmo quando cada equipe usa aliases, armas e apresentação temáticos.
- Criar e compartilhar equipes temáticas que vão além de skins, sem ultrapassar os limites competitivos globais.
- Jogar mapas e modos compatíveis com CS 1.6 sem exigir que o mapa seja recompilado para o mod.
- Encontrar regras competitivas validadas pelo servidor, inclusive adesão, troca e reconexão de equipe.

## Decisões confirmadas

- O termo de produto é **equipe**.
- Tipos de jogador usam contratos simétricos de slots, categorias, limites e orçamento entre equipes.
- Cada equipe pode usar aliases e mapeamentos temáticos diferentes dentro do mesmo contrato.
- A composição de tipos é livre.
- Entradas e trocas não podem criar diferença superior a um jogador ativo entre equipes.
- Reconexão obedece à disponibilidade atual e não reserva a equipe anterior.
- A base técnica atual admite até 32 clientes conectados; cada servidor pode configurar menos.
- A referência principal de balanceamento do MVP é 10 contra 10. A faixa obrigatória de validação é 6v6 a 12v12; partidas até 16v16 são suportadas quando mapa e servidor comportarem, mas não são o centro do balanceamento inicial.
- Retrocompatibilidade com mapas e modos de jogo do CS 1.6 é um objetivo estrutural.
- Dinheiro, preços, recompensas monetárias e menu de compra não fazem parte das regras normais do mod.
- Cada spawn recebe automaticamente o kit predefinido do tipo escolhido.
- Todos os tipos começam equipados com lanterna.
- O MVP começa com quatro tipos fixos e simétricos: Assault, Support, Marksman e Breacher. Quatro é um recorte de protótipo, não um limite estrutural para a evolução do catálogo.
- Assault possui duas variações laterais exclusivas: Rifle ou SMG, sempre acompanhada apenas da pistola, faca e utilidades do tipo.
- O catálogo inicial do Assault possui quatro perfis globais: Rifle 7,62 de poder (AK-47), Rifle 5,56 de controle (M4A1 sem silenciador), SMG 9 mm de controle (MP5) e SMG .45 de poder (UMP-45). As armas citadas são baselines mecânicas, não identidades visuais obrigatórias.
- Primárias do Assault usam somente fogo automático no MVP. Burst, silenciador acoplável e perfis baseados em FAMAS, Galil, TMP, MAC-10 e P90 ficam fora do catálogo inicial.
- Support possui machine gun com teto de 250 balas, pistola, faca, uma flashbang e uma smoke. O catálogo inicial possui dois perfis globais: `support_lmg_556_sustain`, baseado na M249, com dano 32 e cadência-base de 600 RPM, e `support_lmg_762_power`, com dano 36, cadência-base de 500 RPM e recuo mais pesado. Ambos usam recarga de 4,7 s, capacidade-base 100 e teto do slot 250. Sua “supressão” é somente a linguagem tática do fogo sustentado, sem fragmentação, arma secundária ou efeito artificial aplicado ao adversário.
- Marksman escolhe uma variação lateral Bolt-action, com teto total de 50 balas, ou Semiauto, com teto total de 90 balas; Semiauto troca menor dano por maior cadência. Ambas recebem pistola, faca, uma flashbang e uma smoke. Os tetos incluem o carregador inserido; Scout e SG-550 são apenas referências mecânicas iniciais, enquanto perfis equivalentes à AWP e informação automática ficam fora do MVP.
- Breacher escolhe uma variação lateral pump-action/M3 ou semiautomática/XM1014, ambas com teto exato de 40 cartuchos, pistola, faca, duas flashbangs e uma smoke; não recebe fragmentação, SMG, ferramenta de ruptura nem bônus passivo.
- Todos os tipos recebem faca mecanicamente global e não descartável; equipes podem alterar somente sua apresentação temática.
- Dano pertence ao perfil global da arma e não pode ser alterado por criadores de equipes.
- Cada arma temática comunitária referencia obrigatoriamente um perfil mecânico global aprovado. O perfil fixa categoria/calibre mecânico, dano, penetração, recarga, slots e limites combinados; apresentação, capacidade, recuo e cadência só variam onde o perfil permitir.
- Assimetria compensada é permitida: equipes podem mapear perfis globais diferentes dentro do mesmo contrato e orçamento de poder. A allowlist global do servidor vale igualmente em todos os mapas e modos; não existem restrições de perfil específicas por cenário.
- O produto permanece nos modos e objetivos legados do CS 1.6. Contexto temático, equipes e aliases não podem criar ou substituir regras de modo, objetivos ou condições de vitória.
- Rifle, SMG e shotgun preservam seus próprios perfis de dano independentemente de skin, alias, equipe ou tipo que coletou a arma.
- Capacidade do carregador pode ser definida pelo criador entre 1 e o teto de balas do contrato do tipo/slot.
- Capacidades extremas são válidas quando representam a fantasia da arma, como crossbow de tiro único ou supercarregador dentro do teto.
- Criadores podem ajustar recuo e cadência somente dentro dos intervalos validados pelo contrato e pelo servidor.
- No Assault, o MVP usa presets inteiros de manuseio (`controlled`, `baseline` ou `aggressive`) por arma temática. O pacote comunitário não combina recuo, cadência e precisão como sliders livres; dano, calibre, penetração, perda por distância, recarga, mobilidade, modos de disparo e teto de munição continuam fixos pelo perfil.
- No Support, o MVP usa os mesmos presets inteiros de manuseio, mas com faixas mais conservadoras que Assault. LMGs não podem combinar teto alto de munição com cadência alta e controle fácil; o preset `aggressive` aumenta pouco a cadência e piora bastante o controle.
- No Marksman, o MVP usa presets inteiros de manuseio com faixas ainda mais restritas: `controlled` troca ritmo por estabilidade, `aggressive` melhora recuperação ou cadência mas piora controle e disparos em sequência. Nenhum preset altera dano, zoom, teto de munição, recarga, disponibilidade ou transforma Bolt-action em Semiauto.
- No Breacher, o MVP usa presets inteiros de manuseio para shotguns pump-action e semiautomáticas. Presets podem trocar ritmo e controle, mas não alteram dano, pellets, alcance-base, recarga cartucho por cartucho, teto de 40 cartuchos nem transformam shotgun em arma de médio alcance.
- Capacidade, teto total de munição, comportamento de recarga, tempo de recarga e animação são parâmetros separados.
- No MVP, o jogo fixa um único tempo de recarga para cada categoria de arma; criadores de equipes não podem alterá-lo. O servidor aplica a regra, enquanto animação e som apenas a apresentam e devem permanecer coerentes com ela.
- Os tempos do CS 1.6 são a baseline do MVP. Escopetas se dividem em pump-action, baseada na M3, e semiautomática, baseada na XM1014; ambas recarregam cartucho por cartucho e escopetas totalmente automáticas ficam fora do MVP.
- O primeiro modo funcional reutiliza o fluxo legado de instalar/desarmar dispositivo, sem economia; ciclo de rodada, mapas, recarga, HUD de munição, lanterna, visão noturna, armas no chão, equilíbrio numérico e bots reutilizam a base do CS 1.6 quando compatível com as novas regras.
- O servidor atribui lados operacionais no início da partida e os troca na metade quando o cenário for reversível; jogadores e identidade permanecem na mesma equipe.
- A primeira fase de playtest usa recarga clássica, munição reserva agregada e HUD exato do CS 1.6. Carregadores individuais entram somente na segunda configuração experimental.
- Equilíbrio numérico usa diferença máxima de um jogador sem transferência automática forçada; a configuração inicial é `mp_limitteams 1` e `mp_autoteambalance 0`.
- O catálogo inicial de pistolas possui `backup_pistol_45_standard` (USP sem silenciador), `backup_pistol_9mm_capacity` (Glock18 sem burst), `marksman_pistol_45_suppressed` (USP silenciada) e `marksman_pistol_9mm_suppressed` (Glock18 sem burst com apresentação silenciada). Os dois perfis normais estão disponíveis para todos os tipos; somente Marksman pode receber perfis silenciados. Desert Eagle, Dual Elites, Five-Seven, burst da Glock e alternância manual de silenciador ficam fora do MVP.
- Pistolas usam presets inteiros de manuseio (`controlled`, `baseline` ou `quick`) com faixas estreitas. Pistola é backup: presets não alteram dano, calibre, recarga, teto de 45, disponibilidade, silenciador, burst ou categoria, e não podem competir com a arma principal.
- Um sobrevivente pode levar para a rodada seguinte a arma coletada que estiver carregando. Ela substitui o equipamento normal do mesmo slot e recebe carregadores completos até o teto da própria categoria; trocar tipo ou variação restaura o kit e remove essa persistência.

## Limites da promessa de retrocompatibilidade

Retrocompatibilidade significa carregar o mapa, reconhecer seus pontos de spawn e objetivos e permitir concluir suas rodadas sem recompilar o arquivo. Ela não garante automaticamente:

- balanceamento adequado para qualquer quantidade de jogadores;
- preservação da economia, compra ou kits originais;
- apresentação idêntica de T/CT;
- compatibilidade com plugins, mods ou extensões de terceiros;
- funcionamento sem validação de todos os modos e entidades legados.

## Ainda não definido

- público principal;
- duração desejada de rodada e partida;
- ordem de validação dos demais modos legados depois do primeiro protótipo de instalar/desarmar dispositivo;
- valores finais de munição, utilidades e quantidade de armas por tipo;
- detalhes de compatibilidade de carregadores e feedback da coleta de armas;
- validação em playtest dos presets de manuseio antes de transformar a spec em comportamento aprovado;
- critérios futuros para decidir se alguma categoria precisa de perfis alternativos de recarga após o MVP;
- disponibilidade de visão noturna;
- equipes e aliases iniciais;
- política para equipes baseadas em organizações reais.
