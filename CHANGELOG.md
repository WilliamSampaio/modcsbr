# Changelog

All notable project changes will be documented here.

## Unreleased

- Added initial product vision and design pillars, including backward compatibility with CS 1.6 maps and game modes without mandatory map recompilation.
- Confirmed predefined spawn kits without money or buying, universal flashlights, and a server-validated contract model for community-authored themed teams; recorded initial ammo and utility counts as unapproved balance hypotheses.
- Fixed weapon damage at the global profile level while allowing community teams to set magazine capacity from 1 through the slot ammo ceiling and vary recoil/fire rate within server-validated contract ranges and combinations.
- Clarified that extreme magazine capacities are intentional thematic choices when they stay within the slot ammo ceiling and are communicated consistently by assets and HUD.
- Separated magazine capacity, total ammunition, reload behavior, reload timing, and animation in the gameplay contract; chose one server-authoritative reload time per weapon category for the MVP, which community packages cannot override, while alternative profiles remain a possible post-MVP experiment.
- Adopted CS 1.6 reload timings as the MVP baseline and split shotguns into pump-action/M3 and semi-automatic/XM1014 shell-by-shell categories; fully automatic shotguns remain out of scope.
- Fixed the MVP catalog to Assault, Support, Marksman, and Breacher while keeping the product catalog structurally extensible beyond the four legacy CS 1.6 model choices.
- Added mutually exclusive Assault Rifle/SMG variants with pistol, knife, one fragmentation grenade, and two flashbangs; standardized the non-droppable knife mechanically across teams and bound damage to validated weapon categories.
- Allowed surviving players to carry a collected weapon into the next round as a replacement for the same slot, refilled only with complete magazines up to that weapon category's ceiling; type, variant, team, connection, and map changes clear the persisted weapon.
- Fixed the MVP Support kit to a 250-round machine-gun ceiling, 45-round pistol ceiling, universal knife, one flashbang, and one smoke; adopted the M249-based `support_lmg_556_sustain` profile with 32 damage and 600 RPM baseline fire rate, and added the heavier `support_lmg_762_power` profile with 36 damage, 500 RPM baseline fire rate, and stronger recoil. Both Support machine-gun profiles use a 4.7-second reload, 100-round baseline capacity, 250-round slot ceiling, and no artificial suppression effects.
- Clarified that Support suppression is tactical language for sustained fire inspired by real combat use, not a separate MVP debuff, visual penalty, movement penalty, or accuracy penalty.
- Split Marksman into mutually exclusive Bolt-action and Semi-auto variants: Bolt-action keeps a 50-round total ceiling, while Semi-auto uses a 90-round total ceiling and trades lower fixed damage for a higher fire rate. Initial global baselines use 75 damage/2.0-second reload for Bolt-action and 70 damage/3.35-second reload for Semi-auto, with Scout and SG-550 serving only as mechanical references; both variants retain the same pistol, knife, flashbang, and smoke kit.
- Adopted CS 1.6 device/defusal flow, round lifecycle, legacy maps, classic reload and exact aggregate-ammo HUD for the first gameplay phase; reused flashlight/night vision, ground weapons, team stacking, and bot objective foundations, set `mp_limitteams 1` with `mp_autoteambalance 0`, deferred individual magazines to a second experiment, restricted suppressed-pistol profiles to Marksman, and recorded Assault Rifle/SMG caliber asymmetry plus side-rotation cadence as pending product decisions.
- Fixed operational-side swaps at halftime for reversible scenarios and allowed community team packages to map normal or suppressed pistol profiles for Marksman only from the global allowlist and under the shared contract/power budget, without scenario-specific profile selection or filtering.
- Approved the initial pistol profile catalog with USP-based `.45` standard, Glock18-based `9 mm` capacity, and Marksman-only suppressed `.45` and `9 mm` profiles; fixed pistol damage by profile while leaving community presentation, recoil, fire rate, and accuracy to fit validated profile ranges, and deferred Glock burst, Desert Eagle, Dual Elites, Five-Seven, and manual suppressor toggling from the MVP.
- Required every community-authored themed weapon to reference an approved global mechanical profile, allowed compensated asymmetry through different profiles within the same allowlist and power budget, applied that server allowlist uniformly across supported legacy maps and modes, and rejected scenario-specific profile filters and new game modes from the current product scope.
- Approved the initial Assault profile catalog with AK-47-based 7.62 power, unsuppressed-M4A1-based 5.56 control, MP5-based 9 mm control, and UMP-45-based .45 power profiles; limited Assault primaries to full-auto for the MVP, coupled recoil/rate validation, and deferred burst, attachable suppressors, FAMAS, Galil, TMP, MAC-10, and P90 profiles.
- Added mutually exclusive Breacher pump-action/M3 and semi-automatic/XM1014 variants, each with exactly 40 shells, a 45-round pistol ceiling, knife, two flashbangs, and one smoke, without fragmentation grenades, an SMG, a breaching tool, or passive bonuses.
- Added a non-approved product exploration spec for variable-size teams, free composition without type quotas, a server-authoritative maximum one-player difference between active teams, and reconnections that obey current availability without reserving the previous team; also covered symmetric player types with team-specific aliases, temporary attacker/defender sides, predefined kits, economy removal, physical-magazine trade-offs, lifecycle, exploits, MVP scope, measurable playtest criteria, and the current 32-client code limit.
- Removed the stray Windows Explorer cache file `mod/modcsbr/overviews/Thumbs.db` from version control and now ignore `Thumbs.db` across the repository.
- Removed the legacy Steam/GoldSrc install, launch, Linux environment, and Linux server-library helper scripts.
- Made Windows Xash3D FWGS the only supported runtime path.
- Added `WilliamSampaio/cs16-client` as an `upstream/cs16-client` submodule on branch `modcsbr`.
- Added Windows CS16Client build support with nested submodule checks and `-UpdateSubmodules`.
- Added Windows Xash3D FWGS install and launch scripts for `runtime/xash3d`.
- Fixed Windows CS16Client build/install flow to copy `menu.dll` beside `client.dll` for Xash3D FWGS MainUI loading.
- Fixed Xash3D asset installation to merge Steam `valve`/`cstrike` assets into existing runtime folders and validate `valve/gfx.wad`.
- Copied Steam `steam_api.dll` into the local Xash3D runtime root for compatibility with copied Steam assets.
- Changed the Xash3D install flow to seed `runtime/xash3d/modcsbr` from a full local Steam `cstrike` copy before overlaying mod files and compiled DLLs.
- Restored the ReGameDLL_CS submodule metadata to the `WilliamSampaio/ReGameDLL_CS` fork and branch `modcsbr`.
- Updated Windows environment checks, VS Code tasks, setup docs, architecture docs, specs, and agent notes for the Xash3D-only workflow.
- Documented the Visual Studio Installer workload/components used for Windows builds.
- Optimized the README for public GitHub contributors with a shorter quick start, legal asset notice, and contribution guidance.
- Updated CS16Client MainUI so `New Game` opens local match creation with map selection and bot count for `modcsbr`.
- Documented the CS16Client Python 3 build dependency and added earlier Windows environment/build checks for `python` or `py -3`.
- Added mod-owned `mainui_english.txt` and `modcsbr_english.txt` localization placeholders so CS16Client/MainUI stop warning about missing language dictionaries at launch.
- Clarified that CS16Client's nested `3rdparty/ReGameDLL_CS` submodule is a client build dependency, while `upstream/ReGameDLL_CS` remains the authoritative mod server GameDLL.
- Documented that stock `-game cstrike` is not a supported Xash3D launch path because the Steam CS client DLL can assert on missing Steam GameUI state.
- Added a development helper script to switch editable submodules from detached `HEAD` onto their `modcsbr` branches.
- Added Portuguese (Brazil) and Spanish README/user documentation, with language links from the main README.
- Aligned Portuguese and Spanish README/setup documentation structure with the English originals.
- Enabled `mp_flashlight` in the mod ReGameDLL default and server startup configs so the player flashlight works in local Xash3D matches.
