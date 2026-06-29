#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
UPSTREAM_DIR="$ROOT_DIR/upstream/ReGameDLL_CS"
MOD_NAME="${MOD_NAME:-modcsbr}"
MODCSBR_ASSET_MODE="${MODCSBR_ASSET_MODE:-link}"
MODCSBR_FULL_MOD_COPY="${MODCSBR_FULL_MOD_COPY:-0}"
MODCSBR_ENABLE_ZBOT="${MODCSBR_ENABLE_ZBOT:-1}"
MODCSBR_ENABLE_HOSTAGE_AI="${MODCSBR_ENABLE_HOSTAGE_AI:-1}"
RESET_MOD=0

for arg in "$@"; do
	case "$arg" in
		--reset)
			RESET_MOD=1
			;;
		--no-zbot)
			MODCSBR_ENABLE_ZBOT=0
			;;
		--no-hostage-ai)
			MODCSBR_ENABLE_HOSTAGE_AI=0
			;;
		--no-regamedll-extras)
			MODCSBR_ENABLE_ZBOT=0
			MODCSBR_ENABLE_HOSTAGE_AI=0
			;;
		--full-mod-copy)
			MODCSBR_FULL_MOD_COPY=1
			;;
		--help|-h)
			printf 'Usage: %s [--reset] [--full-mod-copy] [--no-zbot] [--no-hostage-ai] [--no-regamedll-extras]\n\n' "$0"
			printf 'Environment:\n'
			printf '  HALF_LIFE_DIR=/path/to/Half-Life\n'
			printf '  MOD_NAME=modcsbr\n'
			printf '  MODCSBR_ASSET_MODE=link|copy\n'
			printf '  MODCSBR_FULL_MOD_COPY=1|0\n'
			printf '  MODCSBR_ENABLE_ZBOT=1|0\n'
			printf '  MODCSBR_ENABLE_HOSTAGE_AI=1|0\n'
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

install_directory_contents_if_missing() {
	local source="$1"
	local target="$2"

	if [ ! -d "$source" ]; then
		return
	fi

	mkdir -p "$target"
	find "$source" -mindepth 1 -print0 | while IFS= read -r -d '' item; do
		local relative
		local item_target
		relative="${item#"$source"/}"
		item_target="$target/$relative"

		if [ -e "$item_target" ] || [ -L "$item_target" ]; then
			continue
		fi

		if [ -d "$item" ]; then
			mkdir -p "$item_target"
		else
			mkdir -p "$(dirname "$item_target")"
			cp -a "$item" "$item_target"
		fi
	done
}

install_settings_script_if_needed() {
	local source="$1"
	local target="$2"

	if [ ! -f "$source" ]; then
		return
	fi

	if [ ! -f "$target" ] || ! grep -q '"mp_roundtime"' "$target"; then
		cp -a "$source" "$target"
	fi
}

copy_full_local_mod_if_enabled() {
	if [ "$MODCSBR_FULL_MOD_COPY" != "1" ]; then
		return
	fi

	find "$ROOT_DIR/mod/modcsbr" -mindepth 1 -maxdepth 1 -print0 | while IFS= read -r -d '' source; do
		local name
		name="$(basename "$source")"
		if [ -d "$source" ]; then
			if [ -L "$DEST_DIR/$name" ] || { [ -e "$DEST_DIR/$name" ] && [ ! -d "$DEST_DIR/$name" ]; }; then
				rm -rf "$DEST_DIR/$name"
			fi
			mkdir -p "$DEST_DIR/$name"
			cp -a "$source/." "$DEST_DIR/$name/"
		else
			rm -rf "$DEST_DIR/$name"
			cp -a "$source" "$DEST_DIR/$name"
		fi
	done
}

extract_regamedll_extra_if_enabled() {
	local enabled="$1"
	local archive="$2"
	local label="$3"

	if [ "$enabled" != "1" ]; then
		printf 'Skipped %s extra.\n' "$label"
		return
	fi

	if [ ! -f "$archive" ]; then
		printf 'Warning: missing %s archive: %s\n' "$label" "$archive" >&2
		return
	fi

	if ! command -v unzip >/dev/null 2>&1; then
		printf 'Missing required tool: unzip\n' >&2
		printf 'On Ubuntu, run: scripts/install/linux-build-deps-ubuntu.sh --install\n' >&2
		exit 127
	fi

	local tmp_dir
	tmp_dir="$(mktemp -d)"
	unzip -q -o "$archive" -d "$tmp_dir"

	if [ -d "$tmp_dir/cstrike" ]; then
		cp -a "$tmp_dir/cstrike/." "$DEST_DIR/"
	else
		printf 'Warning: %s archive did not contain a cstrike folder.\n' "$label" >&2
	fi

	rm -rf "$tmp_dir"
	printf 'Installed %s extra.\n' "$label"
}

configure_regamedll_extras() {
	local config="$DEST_DIR/game_init.cfg"
	local tmp_file
	tmp_file="$(mktemp)"

	touch "$config"
	awk '
		/^\/\/ BEGIN modcsbr ReGameDLL extras$/ { skip = 1; next }
		/^\/\/ END modcsbr ReGameDLL extras$/ { skip = 0; next }
		skip != 1 { print }
	' "$config" > "$tmp_file"
	mv "$tmp_file" "$config"

	{
		printf '\n// BEGIN modcsbr ReGameDLL extras\n'
		if [ "$MODCSBR_ENABLE_ZBOT" = "1" ]; then
			printf 'bot_enable 1\n'
		else
			printf '// bot_enable 1 disabled by MODCSBR_ENABLE_ZBOT=0\n'
		fi

		if [ "$MODCSBR_ENABLE_HOSTAGE_AI" = "1" ]; then
			printf 'hostage_ai_enable 1\n'
		else
			printf '// hostage_ai_enable 1 disabled by MODCSBR_ENABLE_HOSTAGE_AI=0\n'
		fi
		printf '// END modcsbr ReGameDLL extras\n'
	} >> "$config"
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

for entry in cl_dlls events gfx maps media models overviews resource sound sprites; do
	install_entry_if_exists "$CSTRIKE_DIR/$entry" "$DEST_DIR/$entry"
done

install_directory_contents_if_missing "$CSTRIKE_DIR/resource" "$DEST_DIR/resource"

for file in commandmenu.txt game_init.cfg server.cfg titles.txt user.scr; do
	install_entry_if_exists "$CSTRIKE_DIR/$file" "$DEST_DIR/$file"
done

install_settings_script_if_needed "$CSTRIKE_DIR/settings.scr" "$DEST_DIR/settings.scr"
copy_full_local_mod_if_enabled
install_directory_contents_if_missing "$CSTRIKE_DIR/resource" "$DEST_DIR/resource"

mkdir -p "$DEST_DIR/dlls"
if [ -f "$ROOT_DIR/mod/modcsbr/dlls/cs.so" ]; then
	cp "$ROOT_DIR/mod/modcsbr/dlls/cs.so" "$DEST_DIR/dlls/cs.so"
else
	printf 'Warning: %s does not exist yet. Build first with scripts/build/regamedll-linux.sh.\n' "$ROOT_DIR/mod/modcsbr/dlls/cs.so" >&2
fi

extract_regamedll_extra_if_enabled "$MODCSBR_ENABLE_ZBOT" "$UPSTREAM_DIR/regamedll/extra/zBot/bot_profiles.zip" "zBot for CS 1.6"
extract_regamedll_extra_if_enabled "$MODCSBR_ENABLE_HOSTAGE_AI" "$UPSTREAM_DIR/regamedll/extra/HostageImprov/host_improv.zip" "CS:CZ hostage AI for CS 1.6"
configure_regamedll_extras

printf 'Installed %s mod skeleton at: %s\n' "$MOD_NAME" "$DEST_DIR"
printf 'Game DLL path: %s\n' "$DEST_DIR/dlls/cs.so"
printf 'Asset mode: %s\n' "$MODCSBR_ASSET_MODE"
printf 'Full local mod copy: %s\n' "$MODCSBR_FULL_MOD_COPY"
printf 'zBot enabled: %s\n' "$MODCSBR_ENABLE_ZBOT"
printf 'Hostage AI enabled: %s\n' "$MODCSBR_ENABLE_HOSTAGE_AI"
