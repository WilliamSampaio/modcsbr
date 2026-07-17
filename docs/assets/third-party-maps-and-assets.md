# Third-party maps and assets

`modcsbr` should not use the main repository as a dump for community maps or downloaded asset packs.

Third-party maps, NAV files, overviews, sounds, models, sprites, skyboxes, and WADs need documented origin, credits, hashes, and redistribution status before they are hosted by the project.

Policy:

- keep the main repo focused on source, configuration, documentation, specs, scripts, and project-owned assets;
- do not commit Valve/Steam assets or generated runtime files;
- do not commit community map binaries unless permission and provenance are documented;
- track third-party map metadata in a separate map-pack repository before hosting files;
- treat mirrors without credits as insufficient evidence for redistribution;
- prefer optional map-pack installation over bundling community maps in the core mod.

The current policy draft is:

- [Third-party maps and assets policy](../../specs/backlog/third-party-maps-and-assets-policy.md)
