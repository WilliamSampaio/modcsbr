# Setup de Desenvolvimento C/C++ no Windows 11

Este projeto usa a toolchain MSVC do Visual Studio para builds Windows e VS Code como editor.

O runtime suportado e Xash3D FWGS no Windows. Os builds Windows produzem `mp.dll` a partir de ReGameDLL_CS e `client.dll`/`menu.dll` a partir de CS16Client.

## Objetivo

Configurar Windows 11 para que o VS Code consiga:

- editar C/C++ com IntelliSense;
- encontrar headers e bibliotecas MSVC;
- executar `cl.exe`;
- executar `msbuild.exe`;
- executar `cmake.exe`;
- executar `python.exe`;
- compilar ReGameDLL_CS como `Release | Win32`;
- compilar CS16Client como `Release | Win32`;
- executar `modcsbr` pelo Xash3D FWGS.

## 1. Instale Git

Instale Git for Windows:

```text
https://git-scm.com/download/win
```

Verifique:

```powershell
git --version
```

## 2. Instale VS Code

Instale VS Code:

```text
https://code.visualstudio.com/
```

Verifique:

```powershell
code --version
```

Se o comando nao existir, reinstale marcando `Add to PATH` ou use no VS Code:

```text
Ctrl+Shift+P > Shell Command: Install 'code' command in PATH
```

## 3. Instale a Toolchain C++ do Visual Studio

Instale Visual Studio Build Tools ou Visual Studio Community:

```text
https://visualstudio.microsoft.com/vs/community/
```

Este projeto foi validado com Visual Studio Installer / Build Tools 18.x. Visual Studio 2022 Build Tools tambem deve funcionar com os mesmos componentes C++.

No instalador, selecione o workload:

```text
Desktop development with C++
```

Em `Installation details`, confirme os componentes opcionais:

- MSVC build tools para x64/x86, versao mais nova disponivel;
- Windows 11 SDK `10.0.26100.8249` ou mais novo;
- C++ CMake tools for Windows;
- C++ test tools core features;
- MSVC AddressSanitizer;
- vcpkg package manager.

ATL, MFC, C++/CLI, Clang e toolsets MSVC antigos nao sao necessarios, salvo se uma dependencia futura exigir.

## 4. Instale Python 3

O configure do CS16Client via CMake precisa de um interpretador Python.

Instale Python 3:

```text
https://www.python.org/downloads/windows/
```

Durante a instalacao, habilite:

```text
Add python.exe to PATH
py launcher
```

Verifique em um novo PowerShell:

```powershell
python --version
py -3 --version
```

Se o Windows abrir a Microsoft Store ou resolver `python` para `WindowsApps\python.exe`, desative os aliases:

```text
Settings > Apps > Advanced app settings > App execution aliases
```

Desative `python.exe` e `python3.exe`.

## 5. Abra Developer PowerShell

Abra pelo menu iniciar:

```text
Developer PowerShell for VS
Developer PowerShell for VS 2022
Developer PowerShell for VS 2026
```

Esse shell carrega variaveis MSVC necessarias para `cl.exe` e `msbuild.exe`.

Verifique:

```powershell
cl
msbuild -version
python --version
```

## 6. Abra o Projeto no VS Code

Ainda no Developer PowerShell:

```powershell
cd C:\dev\modcsbr
code .
```

Abrir o VS Code assim faz o terminal integrado herdar o ambiente MSVC.

No terminal do VS Code, verifique novamente:

```powershell
cl
msbuild -version
python --version
```

## 7. Instale Extensoes Recomendadas

O VS Code deve detectar `.vscode/extensions.json`.

Instale:

- C/C++ by Microsoft;
- CMake Tools by Microsoft;
- PowerShell by Microsoft;
- GitLens.

## 8. Inicialize Submodulos

```powershell
git submodule sync --recursive
git submodule update --init --recursive
```

Antes de editar submodulos principais, mude-os para as branches `modcsbr`:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/dev/switch-modcsbr-branches.ps1
```

## 9. Build ReGameDLL_CS

Pelo VS Code, use:

```text
Terminal > Run Build Task
```

Selecione:

```text
ReGameDLL: build Windows Release Win32
```

Ou rode diretamente:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1
```

Saida:

```text
mod\modcsbr\dlls\mp.dll
```

## 10. Build CS16Client

Pelo VS Code, selecione:

```text
CS16Client: build Windows Release Win32
```

Ou rode diretamente:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -UpdateSubmodules
```

Saidas:

```text
mod\modcsbr\cl_dlls\client.dll
mod\modcsbr\cl_dlls\menu.dll
```

## 11. Instale e Execute com Xash3D FWGS

Coloque os binarios oficiais Windows do Xash3D FWGS em:

```text
runtime\xash3d
```

A pasta deve conter:

```text
xash3d.exe
```

Instale:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1
```

Recrie a pasta gerada do mod:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1 -Reset
```

Valide sem abrir o jogo:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
```

Execute:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

Use caminhos customizados se necessario:

```powershell
$env:XASH3D_DIR = "D:\Games\xash3d-fwgs"
$env:HALF_LIFE_DIR = "D:\SteamLibrary\steamapps\common\Half-Life"
```

## Troubleshooting

Se `cl` nao for encontrado, feche o VS Code, abra Developer PowerShell for Visual Studio e rode `code .` a partir de `C:\dev\modcsbr`.

Se `msbuild` nao for encontrado, confirme que as ferramentas C++ e MSBuild foram selecionadas no Visual Studio Installer.

Se `cmake` nao for encontrado, instale o componente `C++ CMake tools for Windows`.

Se o CS16Client disser que Python esta faltando, instale Python 3, reabra o Developer PowerShell e verifique `python --version` ou `py -3 --version`.

Se `xash3d.exe` nao for encontrado, extraia os binarios oficiais do Xash3D FWGS em `runtime\xash3d` ou defina `XASH3D_DIR`.

Se `runtime\xash3d\xash3d.exe -game cstrike` mostrar uma assercao Microsoft Visual C++ para `g_hGameUIModule`, use o launcher suportado de `modcsbr`. A assercao vem da DLL cliente stock da Steam CS; `modcsbr` usa `client.dll` e `menu.dll` do CS16Client.
