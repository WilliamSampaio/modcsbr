#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
MOD_NAME="${MOD_NAME:-modcsbr}"
MODCSBR_ASSET_MODE="${MODCSBR_ASSET_MODE:-link}"
RESET_MOD=0

for arg in "$@"; do
	case "$arg" in
		--reset)
			RESET_MOD=1
			;;
		--help|-h)
			printf 'Usage: %s [--reset]\n\n' "$0"
			printf 'Environment:\n'
			printf '  HALF_LIFE_DIR=/path/to/Half-Life\n'
			printf '  MOD_NAME=modcsbr\n'
			printf '  MODCSBR_ASSET_MODE=link|copy\n'
			exit 0
			;;
		*)
			printf 'Unknown argument: %s\n' "$arg" >&2
			exit 1
			;;
	esac
done

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

install_entry_if_exists() {
	local source="$1"
	local target="$2"

	if [ -e "$target" ] || [ -L "$target" ]; then
		return
	fi

	if [ -e "$source" ]; then
		case "$MODCSBR_ASSET_MODE" in
			link)
				ln -s "$source" "$target"
				;;
			copy)
				cp -a "$source" "$target"
				;;
			*)
				printf 'Invalid MODCSBR_ASSET_MODE: %s. Use link or copy.\n' "$MODCSBR_ASSET_MODE" >&2
				exit 1
				;;
		esac
	fi
}

HALF_LIFE_DIR="$(detect_half_life_dir)"
CSTRIKE_DIR="$HALF_LIFE_DIR/cstrike"
DEST_DIR="$HALF_LIFE_DIR/$MOD_NAME"

if [ "$RESET_MOD" -eq 1 ]; then
	case "$DEST_DIR" in
		"$HALF_LIFE_DIR"/"$MOD_NAME")
			rm -rf "$DEST_DIR"
			;;
		*)
			printf 'Refusing to reset unexpected mod path: %s\n' "$DEST_DIR" >&2
			exit 1
			;;
	esac
fi

mkdir -p "$DEST_DIR/dlls"
cp "$ROOT_DIR/mod/modcsbr/liblist.gam" "$DEST_DIR/liblist.gam"

if [ -f "$ROOT_DIR/mod/modcsbr/autoexec.cfg" ]; then
	cp "$ROOT_DIR/mod/modcsbr/autoexec.cfg" "$DEST_DIR/autoexec.cfg"
fi

if [ -f "$ROOT_DIR/mod/modcsbr/game_init.cfg" ]; then
	cp "$ROOT_DIR/mod/modcsbr/game_init.cfg" "$DEST_DIR/game_init.cfg"
fi

if [ -f "$ROOT_DIR/mod/modcsbr/dlls/cs.so" ]; then
	cp "$ROOT_DIR/mod/modcsbr/dlls/cs.so" "$DEST_DIR/dlls/cs.so"
else
	printf 'Warning: %s does not exist yet. Build first with scripts/build/regamedll-linux.sh.\n' "$ROOT_DIR/mod/modcsbr/dlls/cs.so" >&2
fi

for entry in cl_dlls events gfx maps media models overviews resource sound sprites; do
	install_entry_if_exists "$CSTRIKE_DIR/$entry" "$DEST_DIR/$entry"
done

for file in commandmenu.txt game_init.cfg server.cfg titles.txt; do
	install_entry_if_exists "$CSTRIKE_DIR/$file" "$DEST_DIR/$file"
done

printf 'Installed %s mod skeleton at: %s\n' "$MOD_NAME" "$DEST_DIR"
printf 'Game DLL path: %s\n' "$DEST_DIR/dlls/cs.so"
printf 'Asset mode: %s\n' "$MODCSBR_ASSET_MODE"
