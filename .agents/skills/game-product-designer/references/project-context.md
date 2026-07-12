# Contexto de produto do modcsbr

## Runtime

- Engine: Xash3D FWGS.
- Plataforma ativa inicial: Windows.
- Arquitetura principal: x86/Win32.
- Pasta do mod: mod/modcsbr.
- Runtime local: runtime/xash3d/modcsbr.

## Código autoritativo

- Servidor: upstream/ReGameDLL_CS.
- Cliente: upstream/cs16-client.
- O checkout upstream/cs16-client/3rdparty/ReGameDLL_CS não é
  a árvore autoritativa do servidor.

## Processo de features

- Ideias começam em specs/backlog.
- Features acordadas vão para specs/approved.
- Features em desenvolvimento vão para specs/implementing.
- Features testadas vão para specs/completed.

## Direção atual

O mod pretende utilizar a base técnica e a sensação responsiva do
Counter-Strike 1.6, mas poderá modificar regras, comportamentos,
personagens, armas, equipamentos, objetivos e sistemas para construir
uma identidade própria.

## Restrições

- Não depender do executável original da Valve como runtime principal.
- Não incluir assets proprietários da Valve no repositório.
- Manter estado competitivo validado pelo servidor.
- Evitar mudanças que dependam apenas de alterações visuais no cliente.
- Considerar servidor dedicado em toda mecânica multiplayer.
