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
