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
		if [ -x "$candidate/hl_linux" ]; then
			printf '%s\n' "$candidate"
			return
		fi
	done

	printf 'Could not find Half-Life Steam install. Set HALF_LIFE_DIR=/path/to/Half-Life.\n' >&2
	exit 1
}

"$ROOT_DIR/scripts/install/modcsbr-steam-linux.sh"

HALF_LIFE_DIR="$(detect_half_life_dir)"
cd "$HALF_LIFE_DIR"

exec ./hl_linux -steam -game "$MOD_NAME" -console -dev +map "${MAP:-de_dust2}" "$@"
