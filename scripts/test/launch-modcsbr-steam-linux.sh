#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
MOD_NAME="${MOD_NAME:-modcsbr}"
MODCSBR_LAUNCH_METHOD="${MODCSBR_LAUNCH_METHOD:-steam}"
MODCSBR_STEAM_APP_ID="${MODCSBR_STEAM_APP_ID:-70}"
MODCSBR_AUTO_MAP="${MODCSBR_AUTO_MAP:-0}"
INSTALL_ARGS=()
LAUNCH_ARGS=()
RESET_INSTALL=0
FULL_MOD_COPY=0
NO_FULL_MOD_COPY=0

if [ "${MODCSBR_FULL_MOD_COPY:-0}" = "1" ]; then
	FULL_MOD_COPY=1
fi

for arg in "$@"; do
	case "$arg" in
		--reset)
			RESET_INSTALL=1
			INSTALL_ARGS+=("$arg")
			;;
		--full-mod-copy)
			FULL_MOD_COPY=1
			INSTALL_ARGS+=("$arg")
			;;
		--no-full-mod-copy)
			NO_FULL_MOD_COPY=1
			;;
		--no-zbot|--no-hostage-ai|--no-regamedll-extras)
			INSTALL_ARGS+=("$arg")
			;;
		*)
			LAUNCH_ARGS+=("$arg")
			;;
	esac
done

if [ "$FULL_MOD_COPY" = "1" ] && [ "$NO_FULL_MOD_COPY" = "1" ]; then
	printf 'Use only one of --full-mod-copy or --no-full-mod-copy.\n' >&2
	exit 1
fi

if [ "$RESET_INSTALL" = "1" ] && [ "$FULL_MOD_COPY" != "1" ] && [ "$NO_FULL_MOD_COPY" != "1" ]; then
	INSTALL_ARGS+=(--full-mod-copy)
fi

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

"$ROOT_DIR/scripts/install/modcsbr-steam-linux.sh" "${INSTALL_ARGS[@]}"

HALF_LIFE_DIR="$(detect_half_life_dir)"
STEAM_DIR="$(cd "$HALF_LIFE_DIR/../../.." && pwd)"
STEAMAPPS_DIR="$(cd "$HALF_LIFE_DIR/../.." && pwd)"
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

if [ "$MODCSBR_AUTO_MAP" = "1" ]; then
	LAUNCH_ARGS+=(+map "${MAP:-de_dust2}")
fi

case "$MODCSBR_LAUNCH_METHOD" in
	steam)
		if ! command -v steam >/dev/null 2>&1; then
			printf 'Missing steam command. Try MODCSBR_LAUNCH_METHOD=direct.\n' >&2
			exit 1
		fi

		if [ ! -f "$STEAMAPPS_DIR/appmanifest_${MODCSBR_STEAM_APP_ID}.acf" ]; then
			printf 'Missing Steam app manifest: %s\n' "$STEAMAPPS_DIR/appmanifest_${MODCSBR_STEAM_APP_ID}.acf" >&2
			printf 'Install Half-Life in Steam or set MODCSBR_STEAM_APP_ID manually.\n' >&2
			exit 1
		fi

		printf 'Launching %s through Steam AppID %s.\n' "$MOD_NAME" "$MODCSBR_STEAM_APP_ID"
		exec steam -applaunch "$MODCSBR_STEAM_APP_ID" -game "$MOD_NAME" -console -dev "${LAUNCH_ARGS[@]}"
		;;
	direct)
		printf 'Launching %s directly through hl_linux.\n' "$MOD_NAME"
		exec ./hl_linux -steam -game "$MOD_NAME" -console -dev "${LAUNCH_ARGS[@]}"
		;;
	*)
		printf 'Invalid MODCSBR_LAUNCH_METHOD: %s. Use steam or direct.\n' "$MODCSBR_LAUNCH_METHOD" >&2
		exit 1
		;;
esac
