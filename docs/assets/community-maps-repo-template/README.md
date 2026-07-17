# modcsbr community maps

This repository is intended to catalogue optional community maps and map-related assets for `modcsbr`.

It starts as a provenance and credit catalogue. Do not add `.bsp`, `.nav`, `.res`, `.wad`, model, sound, overview, or skybox binaries until redistribution is allowed or explicitly approved.

## Policy

- Every map must have a `manifest.json`.
- Every map must have a human-readable `README.md`.
- Every hosted binary must have SHA256, MD5, size in bytes, source URL, authorship notes, and redistribution status.
- Mirrors without clear credits are not enough to host binaries.
- Files with unknown permission may be documented but must not be committed.
- Valve/Steam assets must not be committed.

## Suggested layout

```text
maps/
  cs_rio/
    README.md
    manifest.json
    files/
      .gitkeep
schemas/
  map-manifest.schema.json
```

## Status values

`redistribution`:

- `allowed`
- `permission-granted`
- `unknown`
- `not-allowed`
- `valve-owned`
- `remove`

`source_status`:

- `primary`
- `archived-primary`
- `community-preserved`
- `mirror-only`
- `unverified`

## Initial catalogue

- `cs_rio`: documented, redistribution unknown.
- `de_sampa`: documented, redistribution unknown.
- `fy_pool_day`: documented, redistribution unknown.
- `fy_poolparty`: documented, redistribution unknown.

## Related policy

See the main project policy draft:

- `modcsbr/specs/backlog/third-party-maps-and-assets-policy.md`
