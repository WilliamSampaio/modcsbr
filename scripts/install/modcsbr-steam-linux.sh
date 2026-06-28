#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
MOD_NAME="${MOD_NAME:-modcsbr}"

detect_half_life_dir() {
	if [ -n "${HALF_LIFE_DIR:-}" ]; then
		printf '%s\n' "$HALF_LIFE_DIR"
		return
	fi

	for candidate in \
		"$HOME/.steam/debian-installation/steamapps/common/Half-Life" \
		"$HOME/.local/share/Steam/steamapps/common/Half-Life" \
		"$HOME/.steam/steam/steamapps/common/Half-Life"; do
		if [ -x "$candidate/hl_linux" ] && [ -d "$candidate/cstrike" ]; then
			printf '%s\n' "$candidate"
			return
		fi
	done

	printf 'Could not find Half-Life Steam install. Set HALF_LIFE_DIR=/path/to/Half-Life.\n' >&2
	exit 1
}

link_if_exists() {
	local source="$1"
	local target="$2"

	if [ -e "$target" ] || [ -L "$target" ]; then
		return
	fi

	if [ -e "$source" ]; then
		ln -s "$source" "$target"
	fi
}

HALF_LIFE_DIR="$(detect_half_life_dir)"
CSTRIKE_DIR="$HALF_LIFE_DIR/cstrike"
DEST_DIR="$HALF_LIFE_DIR/$MOD_NAME"

mkdir -p "$DEST_DIR/dlls"
cp "$ROOT_DIR/mod/modcsbr/liblist.gam" "$DEST_DIR/liblist.gam"

if [ -f "$ROOT_DIR/mod/modcsbr/dlls/cs.so" ]; then
	cp "$ROOT_DIR/mod/modcsbr/dlls/cs.so" "$DEST_DIR/dlls/cs.so"
else
	printf 'Warning: %s does not exist yet. Build first with scripts/build/regamedll-linux.sh.\n' "$ROOT_DIR/mod/modcsbr/dlls/cs.so" >&2
fi

for entry in cl_dlls events gfx maps media models overviews resource sound sprites; do
	link_if_exists "$CSTRIKE_DIR/$entry" "$DEST_DIR/$entry"
done

for file in commandmenu.txt game_init.cfg server.cfg titles.txt; do
	link_if_exists "$CSTRIKE_DIR/$file" "$DEST_DIR/$file"
done

printf 'Installed %s mod skeleton at: %s\n' "$MOD_NAME" "$DEST_DIR"
printf 'Game DLL path: %s\n' "$DEST_DIR/dlls/cs.so"
