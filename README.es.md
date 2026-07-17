# modcsbr

## Idiomas

- English: [README.md](README.md)
- Portugues (Brasil): [README.pt-BR.md](README.pt-BR.md)
- Espanol: este archivo

`modcsbr` es un mod personalizado de la familia Counter-Strike 1.6 / GoldSrc para Xash3D FWGS en Windows.

El proyecto usa:

- Xash3D FWGS como motor de runtime;
- CS16Client como DLL cliente y DLL MainUI;
- ReGameDLL_CS como GameDLL del servidor;
- archivos Steam legalmente adquiridos de Half-Life / Counter-Strike 1.6 como base local de assets.

El flujo antiguo de lanzamiento con Steam/GoldSrc no esta soportado. La unica ruta de runtime soportada es:

```text
runtime/xash3d/xash3d.exe -game modcsbr
```

No uses `runtime/xash3d/xash3d.exe -game cstrike` como smoke test del proyecto. La carpeta generada `runtime/xash3d/cstrike` es una base de assets copiada desde Steam; su `cl_dlls/client.dll` stock puede generar un assert de estado Steam GameUI cuando Xash3D lo carga directamente.

## Estado

Este repositorio se esta preparando para colaboracion publica. El foco actual es obtener una base Windows Xash3D limpia antes de ampliar cambios de gameplay y assets.

El descubrimiento de gameplay comenzo con una exploracion no aprobada, en el backlog, sobre equipos, composicion libre, kits predefinidos sin dinero ni compra y equipos tematicos creados por la comunidad dentro de contratos simetricos de tipo. El MVP usa cuatro tipos iniciales fijos — Assault, Support, Marksman y Breacher — sin convertir cuatro en un limite permanente del catalogo. El dano permanece fijo; el contenido comunitario puede definir la capacidad del cargador hasta el limite de balas del slot y variar retroceso y cadencia dentro de intervalos validados por el servidor. La capacidad, la municion total, el comportamiento, el tiempo y la animacion de recarga siguen siendo parametros separados. En el MVP, el tiempo de recarga es fijo por categoria, usa referencias de CS 1.6 y lo impone el servidor; los assets comunitarios deben adaptarse a el, sin definirlo. Las escopetas de corredera y semiautomaticas siguen las baselines cartucho por cartucho de la M3 y XM1014; las escopetas totalmente automaticas quedan fuera del alcance. La referencia principal de balance del MVP es 10v10, con validacion obligatoria desde 6v6 hasta 12v12; las partidas hasta 16v16 siguen soportadas cuando mapa y servidor lo permitan, pero no son el centro inicial del balance. Los equipos pueden diferir como maximo en un jugador activo, y las reconexiones obedecen la disponibilidad actual sin reservar la plaza anterior. La retrocompatibilidad con mapas y modos de juego de CS 1.6 es un pilar inicial, pero los mapas legacy no reactivan la economia. La base actual admite hasta 32 clientes conectados, aunque los servidores pueden configurar menos. Es una propuesta para playtests, no el comportamiento actual del juego.

La Direccion C — identidad propia intermedia con modos legacy de CS 1.6, equipos ficticios, tipos simetricos, kits predefinidos y profundidad tactica controlada — esta autorizada como hipotesis de prototipado del MVP, pero todavia no es una spec aprobada para implementacion.

Los primeros equipos ficticios de playtest del MVP son Atlas y Vesper, dentro de un ejercicio operacional neutral con un dispositivo de validacion. Atlas usa los aliases iniciales Operador, Artillero, Vigia y Rompedor; Vesper usa Avanzado, Cobertura, Centinela y Entrada. Estos nombres prueban identidad y legibilidad, sin cambiar la simetria mecanica.

Assault elige una variante exclusiva de Rifle o SMG, ambas con pistola, cuchillo, una granada de fragmentacion y dos flashbangs. Su catalogo global inicial contiene cuatro perfiles mecanicos: 7,62 de potencia/AK-47, 5,56 de control/M4A1 sin silenciador, 9 mm de control/MP5 y .45 de potencia/UMP-45. Estas armas son baselines mecanicas, no identidades visuales obligatorias. Las primarias de Assault usan solo fuego automatico en el MVP; rafaga, silenciador acoplable, FAMAS, Galil, TMP, MAC-10 y P90 quedan fuera del catalogo inicial. Las armas comunitarias de Assault eligen un preset completo de manejo — `controlled`, `baseline` o `aggressive` — en vez de mezclar libremente sliders de retroceso, cadencia y precision. La mecanica del cuchillo es global incluso cuando el equipo cambia su presentacion, y el dano del arma siempre sigue el perfil validado por el servidor. Un superviviente puede llevar un arma recogida a la ronda siguiente como sustituta del mismo slot; recibe solo cargadores completos hasta el limite de su propia categoria, y cambiar de tipo o variante restaura el kit predefinido elegido.

Support usa un unico kit en el MVP: machine gun con limite de 250 balas, pistola con limite de 45, cuchillo, una flashbang y una smoke. Su catalogo global inicial tiene dos perfiles: `support_lmg_556_sustain`, basado en la M249, con dano 32 y cadencia-base de 600 RPM, y `support_lmg_762_power`, con dano 36, cadencia-base de 500 RPM y retroceso mas pesado. Ambos usan recarga de 4,7 segundos, capacidad-base 100 y limite del slot 250. Las armas de Support tambien usan presets completos de manejo `controlled`, `baseline` o `aggressive`, pero con rangos mas conservadores que Assault porque las LMG combinan limite alto de municion y fuego sostenido. "Supresion" es lenguaje tactico para fuego sostenido inspirado en su uso en combate real; en el MVP sigue siendo emergente en vez de imponer una penalizacion artificial al adversario.

Marksman elige una variante exclusiva Bolt-action o Semiauto. Bolt-action tiene un limite total de 50 balas; Semiauto tiene un limite total de 90 balas y cambia menor dano fijo por mayor cadencia. Las baselines globales iniciales son dano 75 y recarga de 2,0 segundos para Bolt-action, y dano 70 y recarga de 3,35 segundos para Semiauto, usando Scout y SG-550 solo como referencias mecanicas y no como identidades obligatorias. Las armas de Marksman tambien usan presets completos de manejo con rangos estrechos: `controlled` cambia ritmo por estabilidad, mientras que `aggressive` mejora recuperacion o cadencia a costa de peor control. Ambos limites incluyen el cargador insertado, y ambas variantes reciben pistola con limite de 45, cuchillo, una flashbang y una smoke. Los perfiles equivalentes a la AWP y la informacion automatica de objetivos quedan fuera del alcance.

Breacher elige una variante exclusiva de corredera/M3 o semiautomatica/XM1014. Ambas reciben exactamente 40 cartuchos, pistola con limite de 45, cuchillo, dos flashbangs y una smoke; ninguna recibe granada de fragmentacion, SMG, herramienta de brecha ni bonificaciones pasivas. Las shotguns de Breacher usan presets completos de manejo que intercambian ritmo y control sin cambiar dano, comportamiento de pellets, alcance-base, recarga cartucho por cartucho, limite de 40 cartuchos ni identidad de corta distancia.

La primera fase de gameplay reutiliza el modo de dispositivo/desactivacion, ciclo de ronda, mapas legacy, recarga clasica, HUD exacto de municion agregada, linterna/vision nocturna, armas en el suelo, control de equipos apilados y logica de objetivos de bots de CS 1.6. Un arma recogida es la excepcion del HUD: la cuenta del cargador insertado permanece desconocida hasta que el jugador completa check magazine o recarga. Las partidas MVP usan 20 rondas, intercambian lados operativos despues de 10 rondas, terminan cuando un equipo llega a 11 victorias de ronda y permiten empate 10–10 sin overtime. En escenarios reversibles, el servidor intercambia los lados operativos en la mitad de la partida sin cambiar la identidad del equipo. El equilibrio inicial usa `mp_limitteams 1` con `mp_autoteambalance 0`. Los cargadores individuales quedan para una segunda fase experimental. El catalogo inicial de pistolas contiene `backup_pistol_45_standard`, `backup_pistol_9mm_capacity` y los perfiles exclusivos de Marksman `marksman_pistol_45_suppressed` y `marksman_pistol_9mm_suppressed`; las pistolas usan presets estrechos de manejo `controlled`, `baseline` o `quick`, mientras rafaga de Glock, Desert Eagle, Dual Elites, Five-Seven y alternancia manual de silenciador quedan fuera del MVP. Cada arma tematica comunitaria debe referenciar un perfil mecanico global aprobado; la asimetria compensada puede usar perfiles diferentes dentro de la misma allowlist y presupuesto de poder. La allowlist global de perfiles del servidor se aplica por igual a todos los mapas y modos legacy compatibles; los escenarios no pueden filtrarla ni introducir modos nuevos.

## Assets Legales

Este repositorio no incluye binarios/assets de Valve, Half-Life, Counter-Strike, Steam o runtime Xash3D.

Los colaboradores necesitan su propia instalacion Steam legal de Half-Life / Counter-Strike 1.6. El instalador copia los assets locales necesarios a carpetas ignoradas en `runtime/`:

```text
runtime/xash3d/valve
runtime/xash3d/cstrike
runtime/xash3d/modcsbr
runtime/xash3d/steam_api.dll
```

No hagas commit de archivos generados de runtime, binarios del motor ni assets Valve/Counter-Strike.
Mapas comunitarios y paquetes de assets de terceros necesitan origen, creditos, hashes y estado de redistribucion documentados antes de ser alojados por el proyecto. Prefiere un repositorio separado y opcional de map packs en vez de incluir mapas comunitarios en el repo principal.

## Requisitos

- Windows 11.
- Git for Windows.
- VS Code.
- Visual Studio Build Tools / Visual Studio Installer con el workload `Desktop development with C++`.
- CMake del workload C++ de Visual Studio.
- Python 3 disponible como `python` en PATH, o mediante el Python launcher como `py -3`.
- Binarios oficiales Windows de Xash3D FWGS extraidos en `runtime/xash3d`.
- Half-Life / Counter-Strike 1.6 instalado localmente por Steam.

Componentes de Visual Studio Installer usados por este proyecto:

- Workload: `Desktop development with C++`.
- Herramientas MSBuild.
- Herramientas MSVC para x64/x86.
- Windows 11 SDK `10.0.26100.8249` o mas nuevo.
- C++ CMake tools for Windows.
- C++ test tools core features.
- MSVC AddressSanitizer.
- vcpkg package manager.

Consulta [docs/setup/windows-11.es.md](docs/setup/windows-11.es.md) para detalles del instalador y comandos de verificacion.

## Inicio Rapido

Clona e inicializa submodulos:

```powershell
git submodule sync --recursive
git submodule update --init --recursive
```

Coloca los submodulos principales de desarrollo en sus branches `modcsbr` antes de editarlos:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/dev/switch-modcsbr-branches.ps1
```

Usa tambien `-IncludeMainUI` despues de que el submodulo anidado `mainui_cpp` sea forkado y tenga una branch `modcsbr`.

Si Half-Life de Steam no esta en la ubicacion predeterminada, apunta los scripts a la carpeta que contiene `valve`, `cstrike` y `steam_api.dll`:

```powershell
$env:HALF_LIFE_DIR = "D:\SteamLibrary\steamapps\common\Half-Life"
```

Compila la GameDLL del servidor:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/regamedll-windows.ps1
```

Compila las DLLs cliente y menu:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build/cs16-client-windows.ps1 -UpdateSubmodules
```

Instala el runtime Xash3D local:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install/modcsbr-xash3d-windows.ps1 -Reset
```

Valida el comando de lanzamiento:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
```

Lanza:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

En el menu principal, usa `New Game` para crear una partida local. Esa pantalla permite elegir mapa, definir maximo de jugadores y definir la cantidad de bots.
El default de la ReGameDLL del mod y los configs de inicio/servidor activan `mp_flashlight`, asi que el comando normal de la linterna (`impulse 100`, normalmente en `F`) funciona en partidas locales.

## Layout del Runtime

El instalador genera un runtime local ignorado:

```text
runtime/xash3d/
  xash3d.exe
  valve/
  cstrike/
  steam_api.dll
  modcsbr/
    base copiada de cstrike
    archivos superpuestos desde mod/modcsbr
    resource/mainui_english.txt
    resource/modcsbr_english.txt
    cl_dlls/client.dll
    cl_dlls/menu.dll
    dlls/mp.dll
```

`menu.dll` debe quedarse junto a `client.dll`; Xash3D FWGS MainUI espera ese layout para `MenuFactory`.
Los archivos de localizacion propios del mod son diccionarios placeholder intencionalmente pequenos. Silencian avisos de archivos faltantes de CS16Client/MainUI sin commitear recursos de texto propiedad de Valve.

## Layout del Repositorio

```text
mod/modcsbr/                  overlay fuente del mod
runtime/xash3d/               runtime local ignorado
scripts/build/                wrappers de build Windows
scripts/install/              instalador del runtime Xash3D
scripts/test/                 chequeos de ambiente y launch
upstream/ReGameDLL_CS/        submodulo de la GameDLL del servidor
upstream/cs16-client/         submodulo de la DLL cliente con dependencias 3rdparty anidadas
docs/                         notas de setup y arquitectura
specs/                        planificacion orientada por specs
```

El checkout anidado `upstream/cs16-client/3rdparty/ReGameDLL_CS` pertenece al build de CS16Client. El trabajo de GameDLL del servidor para `modcsbr` debe quedarse en el submodulo superior `upstream/ReGameDLL_CS`.

## Documentacion

- Setup de Windows:
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
- Vista de arquitectura:
  [English](docs/architecture/overview.md) |
  [Portugues](docs/architecture/overview.pt-BR.md) |
  [Espanol](docs/architecture/overview.es.md)
- Mapas y assets de terceros:
  [English](docs/assets/third-party-maps-and-assets.md) |
  [Portugues](docs/assets/third-party-maps-and-assets.pt-BR.md) |
  [Espanol](docs/assets/third-party-maps-and-assets.es.md)
- Direccion de producto (portugues):
  [Vision](docs/product/product-vision.md) |
  [Pilares de diseno](docs/product/design-pillars.md)
- [Exploracion de gameplay en el backlog: equipos, tipos de jugador y kits predefinidos](specs/backlog/teams-player-types-and-predefined-kits.md) (portugues; Direccion C autorizada para prototipado, no aprobada para implementacion)
- [Politica en backlog: mapas y assets de terceros](specs/backlog/third-party-maps-and-assets-policy.md) (borrador; portugues)
- [Spec aprobada del runtime](specs/approved/xash3d-fwgs-windows-runtime.md)

## Contribuir

Manten los cambios pequenos y documenta comportamiento en `specs/` antes de grandes features. No hagas commit de archivos generados de runtime ni assets propietarios de terceros.

Antes de abrir un pull request, ejecuta:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/check-windows-environment.ps1
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1 -NoLaunch
```

Al tocar build, instalacion, launch, rutas o comportamiento de workflow, actualiza la documentacion relevante en el mismo cambio.

## Troubleshooting

Si Xash3D no puede encontrar `gfx.wad`, define `HALF_LIFE_DIR` y reinstala el runtime.

Si Xash3D informa que `MenuFactory` no esta disponible, recompila CS16Client y confirma:

```powershell
Test-Path runtime\xash3d\modcsbr\cl_dlls\menu.dll
```

Si ejecutar `runtime\xash3d\xash3d.exe -game cstrike` abre una ventana de assert Microsoft Visual C++ para `g_hGameUIModule`, vuelve a la ruta de lanzamiento soportada del mod:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test/launch-modcsbr-xash3d-windows.ps1
```

Si `cl`, `msbuild` o `cmake` faltan, reabre el proyecto desde Developer PowerShell y confirma que los componentes de Visual Studio Installer listados arriba estan instalados.

Si el build de CS16Client informa que falta Python, instala Python 3 con `Add python.exe to PATH` o con el Python launcher habilitado. Si `python --version` apunta a `WindowsApps\python.exe` o abre Microsoft Store, deshabilita los aliases de ejecucion de app de Windows para `python.exe` y `python3.exe`.
