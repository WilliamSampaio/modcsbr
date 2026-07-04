# modcsbr

## Idiomas

- [English](README.md)
- Portugues (Brasil): este arquivo
- Espanol: [README.es.md](README.es.md)

`modcsbr` e um mod customizado da familia Counter-Strike 1.6 / GoldSrc para Xash3D FWGS no Windows.

O projeto usa Xash3D FWGS como engine, CS16Client como `client.dll` e `menu.dll`, ReGameDLL_CS como GameDLL do servidor, e arquivos locais legalmente possuidos do Half-Life / Counter-Strike 1.6 via Steam como base de assets.

O fluxo antigo de execucao pelo Steam/GoldSrc nao e suportado. O caminho de runtime suportado e:

```text
runtime/xash3d/xash3d.exe -game modcsbr
```

Nao use `runtime/xash3d/xash3d.exe -game cstrike` como smoke test do projeto. A pasta `runtime/xash3d/cstrike` gerada existe como base de assets copiada da Steam; o `cl_dlls/client.dll` original dela pode falhar em estado de Steam GameUI quando carregado diretamente pelo Xash3D.

## Status

Este repositorio esta sendo preparado para colaboracao publica. O foco atual e manter uma base Windows Xash3D limpa antes de expandir mudancas de gameplay e assets.

## Assets Legais

Este repositorio nao inclui binarios ou assets da Valve, Half-Life, Counter-Strike, Steam ou Xash3D.

Colaboradores precisam ter uma instalacao legal propria do Half-Life / Counter-Strike 1.6 na Steam. O instalador copia os assets locais necessarios para pastas ignoradas em `runtime/`:

```text
runtime/xash3d/valve
runtime/xash3d/cstrike
runtime/xash3d/modcsbr
runtime/xash3d/steam_api.dll
```

Nao commite arquivos gerados de runtime, binarios de engine ou assets Valve/Counter-Strike.

## Requisitos

- Windows 11.
- Git for Windows.
- VS Code.
- Visual Studio Build Tools / Visual Studio Installer com o workload `Desktop development with C++`.
- CMake instalado pelo workload C++ do Visual Studio.
- Python 3 disponivel como `python` no PATH ou via launcher `py -3`.
- Binarios oficiais Windows do Xash3D FWGS extraidos em `runtime/xash3d`.
- Half-Life / Counter-Strike 1.6 instalado localmente pela Steam.

Componentes do Visual Studio Installer usados pelo projeto:

- Workload: `Desktop development with C++`.
- Ferramentas MSBuild.
- Ferramentas MSVC x64/x86.
- Windows 11 SDK `10.0.26100.8249` ou mais novo.
- C++ CMake tools for Windows.
- C++ test tools core features.
- MSVC AddressSanitizer.
- vcpkg package manager.

Veja o guia de setup do Windows nos idiomas abaixo.

## Inicio Rapido

Clone e inicialize os submodulos:

```powershell
git submodule sync --recursive
git submodule update --init --recursive
```

Antes de editar os submodulos principais, coloque-os nas branches `modcsbr`:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/dev/switch-modcsbr-branches.ps1
```

Se o Half-Life da Steam nao estiver no local padrao:

```powershell
$env:HALF_LIFE_DIR = "D:\SteamLibrary\steamapps\common\Half-Life"
```

Compile a GameDLL do servidor:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1
```

Compile o cliente e o menu:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -UpdateSubmodules
```

Instale o runtime local do Xash3D:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1 -Reset
```

Valide e execute:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

No menu principal, use `New Game` para criar uma partida local, escolher mapa, maximo de jogadores e quantidade de bots.

## Documentacao

- Setup do Windows:
  [English](docs/setup/windows-11.md) |
  [Portugues](docs/setup/windows-11.pt-BR.md) |
  [Espanol](docs/setup/windows-11.es.md)
- Runtime Xash3D FWGS:
  [English](docs/setup/xash3d-windows.md) |
  [Portugues](docs/setup/xash3d-windows.pt-BR.md) |
  [Espanol](docs/setup/xash3d-windows.es.md)
- Build ReGameDLL_CS:
  [English](docs/setup/build-regamedll.md) |
  [Portugues](docs/setup/build-regamedll.pt-BR.md) |
  [Espanol](docs/setup/build-regamedll.es.md)
- Build CS16Client:
  [English](docs/setup/build-cs16-client.md) |
  [Portugues](docs/setup/build-cs16-client.pt-BR.md) |
  [Espanol](docs/setup/build-cs16-client.es.md)
- Visao de arquitetura:
  [English](docs/architecture/overview.md) |
  [Portugues](docs/architecture/overview.pt-BR.md) |
  [Espanol](docs/architecture/overview.es.md)
- [Spec aprovada do runtime](specs/approved/xash3d-fwgs-windows-runtime.md)

## Contribuindo

Mantenha mudancas pequenas e documente comportamento em `specs/` antes de grandes features. Nao commite arquivos gerados de runtime ou assets proprietarios de terceiros.

Antes de abrir um pull request, rode:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/check-windows-environment.ps1
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
```

Ao alterar build, instalacao, launch, caminhos ou workflow, atualize a documentacao relevante no mesmo change.
