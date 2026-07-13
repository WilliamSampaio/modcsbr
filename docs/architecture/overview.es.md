# Vista de Arquitectura

El proyecto separa codigo original de terceros, arboles locales de runtime ignorados y archivos personalizados del mod.

## Upstream

`upstream/ReGameDLL_CS` contiene el proyecto ReGameDLL_CS como submodulo Git. La URL apunta a `WilliamSampaio/ReGameDLL_CS` y sigue la branch `modcsbr`, donde debe vivir el trabajo especifico de la GameDLL del servidor.

`upstream/cs16-client` contiene el proyecto CS16Client como submodulo Git. La URL apunta a `WilliamSampaio/cs16-client` y sigue la branch `modcsbr`, donde debe vivir el trabajo especifico del client DLL.

CS16Client tiene dependencias anidadas en `upstream/cs16-client/3rdparty`, incluyendo un checkout anidado de `ReGameDLL_CS`. Ese checkout existe para el grafo de build e interfaces compartidas de CS16Client. No es el arbol autoritativo de la GameDLL del servidor de este repositorio; usa el submodulo superior `upstream/ReGameDLL_CS` para trabajo en `mp.dll`.

`runtime/xash3d` es un runtime local ignorado que contiene binarios oficiales de Xash3D FWGS, assets base de Steam y la carpeta instalada `modcsbr`. La carpeta instalada `modcsbr` se genera desde una copia local de assets Steam `cstrike`, con archivos del repositorio y DLLs compiladas aplicados encima.

## Archivos del Mod

`mod/modcsbr` esta reservado para el layout fuente del mod copiado al runtime Xash3D:

- `cl_dlls/` - salida compilada de CS16Client como `client.dll` y `menu.dll`.
- `dlls/` - salida compilada de GameDLL para pruebas.
- `models/` - assets de modelos.
- `sound/` - assets de sonido.
- `sprites/` - assets de sprites.
- `resource/` - archivos de UI/resource.
- `maps/` - archivos de mapas.

El runtime Windows activo vive en:

```text
runtime/xash3d/modcsbr
```

La instalacion Xash3D usa `modcsbr/liblist.gam`, carga `cl_dlls/client.dll`, `cl_dlls/menu.dll` y `dlls/mp.dll`, y mantiene una base local completa de assets `cstrike` dentro de la carpeta ignorada de runtime del mod.

## Specs

Los cambios de gameplay y feature deben comenzar como specs. Mueve specs por:

- `specs/backlog`
- `specs/approved`
- `specs/implementing`
- `specs/completed`

La propuesta actual de equipos, composicion libre de tipos, diferencia maxima de un jugador activo entre equipos y aliases por equipo esta documentada en [`specs/backlog/teams-player-types-and-predefined-kits.md`](../../specs/backlog/teams-player-types-and-predefined-kits.md). La intencion es que el servidor valide la disponibilidad en entradas, cambios y reconexiones; reconectar no reserva la plaza del equipo anterior. El codigo actual de ReGameDLL_CS y CS16Client usa un maximo de 32 clientes, aunque cada servidor puede configurar menos. La propuesta permanece sin aprobar y no describe gameplay implementado.

La retrocompatibilidad con mapas y modos de juego de CS 1.6 es un pilar inicial del producto. Los cambios futuros de gameplay deben preservar la lectura de entidades legacy de spawn y objetivo y no deben exigir recompilar mapas antiguos solo para cargar y completar una ronda. Los identificadores internos legacy de los lados pueden permanecer como capa de compatibilidad aunque los equipos visibles usen otros nombres.

La direccion actual elimina dinero y compra: el servidor concede un kit predefinido al hacer spawn. Los equipos creados por la comunidad pueden mapear armas y presentacion tematicas sobre contratos globales de tipo. El dano permanece fijo en el perfil global del arma. La capacidad del cargador puede variar de 1 hasta el limite de balas del slot; retroceso y cadencia pueden variar dentro de intervalos y combinaciones validados por el servidor. El servidor debe validar el paquete completo antes de aceptarlo. Cargar un mapa legacy no restaura la economia clasica.

Las capacidades extremas del cargador son elecciones tematicas validas, como una crossbow de un solo tiro, pero el valor declarado permanece separado del asset visual y debe respetar el limite del slot. Modelos, animaciones, sonidos y HUD deben comunicar de forma coherente el comportamiento aceptado.
