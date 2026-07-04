# Build CS16Client no Windows

Este documento registra o caminho de build no Windows para o fork `WilliamSampaio/cs16-client`.

## Ambiente Necessario

- Sistema operacional: Windows 11
- Toolchain: Visual Studio Build Tools / Visual Studio Installer com suporte C++
- Sistema de build: CMake
- Dependencia de script: Python 3 como `python` no PATH ou pelo launcher `py -3`
- Plataforma: Win32/x86
- Saida: `client.dll` e `menu.dll`

## Layout do Codigo

Inicialize o submodulo:

```powershell
git submodule sync --recursive
git submodule update --init --recursive
```

O submodulo fica em:

```text
upstream/cs16-client
```

Ele aponta para `https://github.com/WilliamSampaio/cs16-client.git` e acompanha a branch `modcsbr`. O projeto upstream original e `https://github.com/Velaron/cs16-client`.

Depois de inicializar, troque o checkout editavel de detached `HEAD` para a branch de desenvolvimento:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/dev/switch-modcsbr-branches.ps1
```

## Passos de Build

Abra Developer PowerShell for Visual Studio em `C:\dev\modcsbr` e rode:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -UpdateSubmodules
```

`-UpdateSubmodules` inicializa as dependencias aninhadas em `upstream\cs16-client\3rdparty`, incluindo YaPB, ReGameDLL_CS, MainUI e MiniUTL.

O checkout `upstream\cs16-client\3rdparty\ReGameDLL_CS` faz parte do grafo de build do CS16Client. Ele nao e a GameDLL de servidor autoritativa do `modcsbr`; trabalho de servidor deve ficar no submodulo de topo `upstream\ReGameDLL_CS`.

O wrapper executa CMake, compila em Release e copia os `client.dll` e `menu.dll` mais novos para:

```text
mod/modcsbr/cl_dlls/client.dll
mod/modcsbr/cl_dlls/menu.dll
```

## Caminhos Customizados

Use caminhos explicitos para testar outro checkout ou pasta de saida:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 `
  -SourceDir D:\src\cs16-client `
  -BuildDir build\windows\cs16-client-test `
  -InstallDir build\windows\cs16-client-test-install
```

Pule a copia para o layout do mod:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -NoInstallToMod
```

## Validacao

Depois do build, instale e execute o runtime Xash3D:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

Caminho esperado no runtime instalado:

```text
runtime/xash3d/modcsbr/cl_dlls/client.dll
runtime/xash3d/modcsbr/cl_dlls/menu.dll
```

Se o Xash3D mostrar `Error: native object "MenuFactory" is unavailable`, reconstrua o CS16Client e reinstale o runtime. Normalmente isso significa que `menu.dll` esta ausente ao lado de `client.dll`.

Se o CMake disser que Python esta faltando, instale Python 3 e verifique:

```powershell
python --version
py -3 --version
```
