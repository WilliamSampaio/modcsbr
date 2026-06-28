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

print_section "Runtime Graphics"
if grep -qi microsoft /proc/version 2>/dev/null; then
	printf 'Warning: WSL detected. Use it for builds and smoke tests, not performance testing.\n'
	printf 'Note: WSLg can use software rendering and may cause low FPS or unstable mouse input in GoldSrc.\n'
fi

if command -v glxinfo >/dev/null 2>&1; then
	OPENGL_RENDERER="$(glxinfo -B 2>/dev/null | awk -F': ' '/OpenGL renderer string/ {print $2; exit}')"
	if [ -n "$OPENGL_RENDERER" ]; then
		printf 'OpenGL renderer: %s\n' "$OPENGL_RENDERER"
		case "$OPENGL_RENDERER" in
			*llvmpipe*|*softpipe*)
				printf 'Warning: software OpenGL renderer detected. Expect poor game performance and mouse issues.\n'
				;;
		esac
	else
		printf 'Note: glxinfo is installed, but the OpenGL renderer could not be detected.\n'
	fi
else
	printf 'Note: glxinfo not installed; cannot detect the OpenGL renderer automatically.\n'
	printf 'Tip: if the game log says GL_RENDERER: llvmpipe, rendering is CPU-based and will be slow.\n'
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
	STEAMAPPS_DIR="$(cd "$HALF_LIFE_DIR_DETECTED/../.." && pwd)"
	if [ -f "$STEAMAPPS_DIR/appmanifest_70.acf" ]; then
		printf 'OK: Half-Life Steam AppID 70 is installed for mod launch.\n'
	else
		printf 'Missing: %s/appmanifest_70.acf. Install Half-Life in Steam.\n' "$STEAMAPPS_DIR"
	fi

	if [ -f "$STEAMAPPS_DIR/appmanifest_10.acf" ]; then
		printf 'OK: Counter-Strike Steam AppID 10 is installed for CS assets.\n'
	else
		printf 'Missing: %s/appmanifest_10.acf. Install Counter-Strike 1.6 in Steam.\n' "$STEAMAPPS_DIR"
	fi

	for required_file in "$HALF_LIFE_DIR_DETECTED/libsteam_api.so" "$HALF_LIFE_DIR_DETECTED/hw.so"; do
		if [ -f "$required_file" ]; then
			printf 'OK: found %s\n' "$required_file"
		else
			printf 'Missing: %s\n' "$required_file"
		fi
	done

	for cs_file in "$HALF_LIFE_DIR_DETECTED/cstrike/cl_dlls/client.so" "$HALF_LIFE_DIR_DETECTED/cstrike/sprites/hud.txt"; do
		if [ -f "$cs_file" ]; then
			printf 'OK: found CS client/HUD file %s\n' "$cs_file"
		else
			printf 'Missing: %s\n' "$cs_file"
		fi
	done

	for mod_file in "$HALF_LIFE_DIR_DETECTED/modcsbr/cl_dlls/client.so" "$HALF_LIFE_DIR_DETECTED/modcsbr/sprites/hud.txt"; do
		if [ -f "$mod_file" ]; then
			printf 'OK: modcsbr can see %s\n' "$mod_file"
		else
			printf 'Missing from modcsbr view: %s\n' "$mod_file"
		fi
	done

	MOD_SETTINGS_FILE="$HALF_LIFE_DIR_DETECTED/modcsbr/settings.scr"
	if [ -f "$MOD_SETTINGS_FILE" ] && grep -q '"mp_roundtime"' "$MOD_SETTINGS_FILE"; then
		printf 'OK: modcsbr settings.scr has CS create-server game options.\n'
	else
		printf 'Warning: modcsbr settings.scr is missing CS create-server game options.\n'
		printf 'Fix: run MODCSBR_ASSET_MODE=copy scripts/install/modcsbr-steam-linux.sh --reset\n'
	fi

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
