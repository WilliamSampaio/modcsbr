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
- Retrocompatibilidade com mapas e modos de jogo do CS 1.6 é um objetivo estrutural.
- Dinheiro, preços, recompensas monetárias e menu de compra não fazem parte das regras normais do mod.
- Cada spawn recebe automaticamente o kit predefinido do tipo escolhido.
- Todos os tipos começam equipados com lanterna.
- O MVP começa com quatro tipos fixos e simétricos: Assault, Support, Marksman e Breacher. Quatro é um recorte de protótipo, não um limite estrutural para a evolução do catálogo.
- Assault possui duas variações laterais exclusivas: Rifle ou SMG, sempre acompanhada apenas da pistola, faca e utilidades do tipo.
- Support possui machine gun com teto de 250 balas, pistola, faca, uma flashbang e uma smoke; não recebe fragmentação, arma secundária nem supressão artificial.
- Marksman possui rifle de precisão leve baseado na Scout com teto de 50 balas, pistola, faca, uma flashbang e uma smoke; perfis semiautomáticos, equivalentes à AWP e informação automática ficam fora do MVP.
- Todos os tipos recebem faca mecanicamente global e não descartável; equipes podem alterar somente sua apresentação temática.
- Dano pertence ao perfil global da arma e não pode ser alterado por criadores de equipes.
- Rifle, SMG e shotgun preservam seus próprios perfis de dano independentemente de skin, alias, equipe ou tipo que coletou a arma.
- Capacidade do carregador pode ser definida pelo criador entre 1 e o teto de balas do contrato do tipo/slot.
- Capacidades extremas são válidas quando representam a fantasia da arma, como crossbow de tiro único ou supercarregador dentro do teto.
- Criadores podem ajustar recuo e cadência somente dentro dos intervalos validados pelo contrato e pelo servidor.
- Capacidade, teto total de munição, comportamento de recarga, tempo de recarga e animação são parâmetros separados.
- No MVP, o jogo fixa um único tempo de recarga para cada categoria de arma; criadores de equipes não podem alterá-lo. O servidor aplica a regra, enquanto animação e som apenas a apresentam e devem permanecer coerentes com ela.
- Os tempos do CS 1.6 são a baseline do MVP. Escopetas se dividem em pump-action, baseada na M3, e semiautomática, baseada na XM1014; ambas recarregam cartucho por cartucho e escopetas totalmente automáticas ficam fora do MVP.
- Um sobrevivente pode levar para a rodada seguinte a arma coletada que estiver carregando. Ela substitui o equipamento normal do mesmo slot e recebe carregadores completos até o teto da própria categoria; trocar tipo ou variação restaura o kit e remove essa persistência.

## Limites da promessa de retrocompatibilidade

Retrocompatibilidade significa carregar o mapa, reconhecer seus pontos de spawn e objetivos e permitir concluir suas rodadas sem recompilar o arquivo. Ela não garante automaticamente:

- balanceamento adequado para qualquer quantidade de jogadores;
- preservação da economia, compra ou kits originais;
- apresentação idêntica de T/CT;
- compatibilidade com plugins, mods ou extensões de terceiros;
- funcionamento sem validação de todos os modos e entidades legados.

## Ainda não definido

- público principal e tamanho de equipe usado como referência para balanceamento;
- duração desejada de rodada e partida;
- modos prioritários para o primeiro protótipo;
- valores finais de munição, utilidades e quantidade de armas por tipo;
- detalhes de compatibilidade de carregadores e feedback da coleta de armas;
- intervalos e combinações seguros de recuo e cadência para cada perfil de arma;
- critérios futuros para decidir se alguma categoria precisa de perfis alternativos de recarga após o MVP;
- disponibilidade de visão noturna;
- equipes e aliases iniciais;
- política para equipes baseadas em organizações reais.
