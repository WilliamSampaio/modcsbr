#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

print_section() {
	printf '\n== %s ==\n' "$1"
}

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
}

print_section "Repository"
printf 'Path: %s\n' "$ROOT_DIR"
df -h "$ROOT_DIR"

if [[ "$ROOT_DIR" == /mnt/* ]]; then
	printf 'Warning: repo is under /mnt. Move it to the Linux filesystem for faster builds.\n'
else
	printf 'OK: repo is on the Linux filesystem.\n'
fi

print_section "Block Devices"
lsblk -f

if df "$ROOT_DIR" | awk 'NR == 2 {print $1}' | grep -q '/dev/sdd'; then
	printf 'OK: repo filesystem is on /dev/sdd.\n'
else
	printf 'Note: repo filesystem is not reported as /dev/sdd. Check if this is expected.\n'
fi

print_section "Steam CS 1.6"
if command -v steam >/dev/null 2>&1; then
	printf 'OK: steam command -> %s\n' "$(command -v steam)"
else
	printf 'Missing: steam command. The launcher can still use MODCSBR_LAUNCH_METHOD=direct for debugging.\n'
fi

HALF_LIFE_DIR_DETECTED="$(detect_half_life_dir || true)"
if [ -n "$HALF_LIFE_DIR_DETECTED" ]; then
	printf 'Half-Life path: %s\n' "$HALF_LIFE_DIR_DETECTED"
	printf 'OK: found hl_linux and cstrike.\n'

	STEAM_DIR="$(cd "$HALF_LIFE_DIR_DETECTED/../../.." && pwd)"
	for required_file in "$HALF_LIFE_DIR_DETECTED/libsteam_api.so" "$HALF_LIFE_DIR_DETECTED/hw.so"; do
		if [ -f "$required_file" ]; then
			printf 'OK: found %s\n' "$required_file"
		else
			printf 'Missing: %s\n' "$required_file"
		fi
	done

	if find "$STEAM_DIR" -path '*/i386-linux-gnu/libopenal.so.1' -print -quit 2>/dev/null | grep -q .; then
		printf 'OK: found Steam Runtime i386 libopenal.so.1.\n'
	else
		printf 'Missing: Steam Runtime i386 libopenal.so.1.\n'
	fi
else
	printf 'Warning: could not find Steam Half-Life. Set HALF_LIFE_DIR=/path/to/Half-Life.\n'
fi

print_section "Build Tools"
for tool in git cmake make gcc g++; do
	if command -v "$tool" >/dev/null 2>&1; then
		printf 'OK: %s -> %s\n' "$tool" "$(command -v "$tool")"
	else
		printf 'Missing: %s\n' "$tool"
	fi
done
