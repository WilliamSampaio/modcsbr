# Build ReGameDLL_CS no Windows

Este documento registra o caminho de build da GameDLL do servidor para `modcsbr`.

O runtime suportado e Windows Xash3D FWGS, que carrega `dlls/mp.dll` a partir da pasta gerada `runtime/xash3d/modcsbr`.

## Ambiente Necessario

- Sistema operacional: Windows 11
- Toolchain: Visual Studio Build Tools / Visual Studio Installer com ferramentas C++
- Sistema de build: MSBuild
- Plataforma: Win32/x86
- Saida: `mp.dll`

## Passos de Build

Abra o Developer PowerShell for Visual Studio e rode:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1
```

Para mudancas de codigo, mantenha o submodulo na branch de desenvolvimento em vez de detached `HEAD`:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/dev/switch-modcsbr-branches.ps1
```

Saida esperada no repositorio:

```text
mod/modcsbr/dlls/mp.dll
```

O instalador do Xash3D copia esse arquivo para:

```text
runtime/xash3d/modcsbr/dlls/mp.dll
```

## Validacao

Valide o comando de launch sem abrir o jogo:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
```

Depois execute:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

## Notas

- Mantenha o build em Win32/x86, a menos que todas as bibliotecas carregadas pelo Xash3D sejam reconstruidas juntas para outra arquitetura.
- Mantenha mudancas customizadas de ReGameDLL_CS em `upstream/ReGameDLL_CS` na branch `modcsbr`.
- Os fluxos antigos de Steam/GoldSrc e validacao de biblioteca Linux foram removidos deste projeto.
