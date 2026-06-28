#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
MOD_NAME="${MOD_NAME:-modcsbr}"
MODCSBR_RENDERER="${MODCSBR_RENDERER:-soft}"
MODCSBR_LAUNCH_METHOD="${MODCSBR_LAUNCH_METHOD:-steam}"

detect_half_life_dir() {
	if [ -n "${HALF_LIFE_DIR:-}" ]; then
		printf '%s\n' "$HALF_LIFE_DIR"
		return
	fi

	for candidate in \
		"$HOME/.steam/debian-installation/steamapps/common/Half-Life" \
		"$HOME/.local/share/Steam/steamapps/common/Half-Life" \
		"$HOME/.steam/steam/steamapps/common/Half-Life"; do
		if [ -x "$candidate/hl_linux" ]; then
			printf '%s\n' "$candidate"
			return
		fi
	done

	printf 'Could not find Half-Life Steam install. Set HALF_LIFE_DIR=/path/to/Half-Life.\n' >&2
	exit 1
}

add_library_path() {
	local path="$1"

	if [ -d "$path" ]; then
		case ":$LD_LIBRARY_PATH:" in
			*":$path:"*)
				return
				;;
		esac

		LD_LIBRARY_PATH="$path${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
	fi
}

"$ROOT_DIR/scripts/install/modcsbr-steam-linux.sh"

HALF_LIFE_DIR="$(detect_half_life_dir)"
STEAM_DIR="$(cd "$HALF_LIFE_DIR/../../.." && pwd)"
cd "$HALF_LIFE_DIR"

for required_file in libsteam_api.so hw.so; do
	if [ ! -f "$HALF_LIFE_DIR/$required_file" ]; then
		printf 'Missing required Half-Life runtime file: %s\n' "$HALF_LIFE_DIR/$required_file" >&2
		exit 1
	fi
done

export LC_ALL="C.UTF-8"
export LANG="C.UTF-8"

LD_LIBRARY_PATH="${LD_LIBRARY_PATH:-}"
add_library_path "$STEAM_DIR/ubuntu12_32/steam-runtime/usr/lib/i386-linux-gnu"
add_library_path "$STEAM_DIR/steamapps/common/SteamLinuxRuntime/steam-runtime/usr/lib/i386-linux-gnu"
while IFS= read -r runtime_lib; do
	add_library_path "$(dirname "$runtime_lib")"
done < <(find "$STEAM_DIR" -path '*/i386-linux-gnu/libopenal.so.1' -print 2>/dev/null)
add_library_path "$HALF_LIFE_DIR"
export LD_LIBRARY_PATH

case "$MODCSBR_RENDERER" in
	soft)
		renderer_arg="-soft"
		;;
	gl)
		renderer_arg="-gl"
		;;
	*)
		printf 'Invalid MODCSBR_RENDERER: %s. Use soft or gl.\n' "$MODCSBR_RENDERER" >&2
		exit 1
		;;
esac

case "$MODCSBR_LAUNCH_METHOD" in
	steam)
		if ! command -v steam >/dev/null 2>&1; then
			printf 'Missing steam command. Try MODCSBR_LAUNCH_METHOD=direct.\n' >&2
			exit 1
		fi

		exec steam -applaunch 70 -game "$MOD_NAME" "$renderer_arg" -console -dev +map "${MAP:-de_dust2}" "$@"
		;;
	direct)
		exec ./hl_linux -steam -game "$MOD_NAME" "$renderer_arg" -console -dev +map "${MAP:-de_dust2}" "$@"
		;;
	*)
		printf 'Invalid MODCSBR_LAUNCH_METHOD: %s. Use steam or direct.\n' "$MODCSBR_LAUNCH_METHOD" >&2
		exit 1
		;;
esac
