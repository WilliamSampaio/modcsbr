# Download e atualização controlada do Xash3D FWGS

## Status

Backlog.

## Objetivo

Definir se o `modcsbr` deve baixar e preparar automaticamente binários oficiais do Xash3D FWGS em `.downloads/xash3d` e `runtime/xash3d`, sem fazer fork da engine e sem atualizar para versões desconhecidas automaticamente.

## Contexto

O fluxo atual exige que os binários do Xash3D FWGS já existam em:

```text
runtime/xash3d
```

ou em um caminho definido por:

```text
XASH3D_DIR
```

A ideia pendente é permitir que um script baixe uma release oficial quando o runtime ainda não existir.

## Recomendação inicial

Não usar “latest” como comportamento automático.

O fluxo deve usar:

- versão fixada;
- URL oficial;
- hash conhecido;
- cache em `.downloads/xash3d`;
- instalação em `runtime/xash3d`;
- atualização somente com comando explícito.

## Decisões pendentes

- Qual release oficial do Xash3D FWGS será a primeira versão fixada?
- Onde registrar versão, URL e hash esperados?
- O download deve ficar no instalador atual `modcsbr-xash3d-windows.ps1` ou em script separado?
- Como lidar com versões já instaladas?
- Como validar arquitetura Win32/x86 em relação aos DLLs carregados?
- Como evitar regressões silenciosas quando a engine mudar?

## Fora de escopo

- Compilar Xash3D FWGS a partir do código-fonte.
- Fazer fork da engine.
- Baixar assets Valve/Steam.
- Trocar engine automaticamente durante testes.
