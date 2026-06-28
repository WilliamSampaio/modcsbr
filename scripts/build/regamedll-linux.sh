#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
UPSTREAM_DIR="$ROOT_DIR/upstream/ReGameDLL_CS"
JOBS="${JOBS:-$(nproc 2>/dev/null || printf '1')}"
COMPILER="${COMPILER:-gcc}"

require_tool() {
	if ! command -v "$1" >/dev/null 2>&1; then
		printf 'Missing required tool: %s\n' "$1" >&2
		printf 'On Ubuntu, run: scripts/install/linux-build-deps-ubuntu.sh --install\n' >&2
		exit 127
	fi
}

require_tool git
require_tool cmake
require_tool make
require_tool "$COMPILER"

case "$COMPILER" in
	gcc)
		require_tool g++
		;;
	clang)
		require_tool clang++
		;;
esac

cd "$UPSTREAM_DIR"
./build.sh --compiler="$COMPILER" --jobs="$JOBS" "$@"

CS_SO="$(find "$UPSTREAM_DIR/build" -type f -name cs.so -print -quit)"
if [ -z "$CS_SO" ]; then
	printf 'Build finished, but cs.so was not found under %s/build\n' "$UPSTREAM_DIR" >&2
	exit 1
fi

mkdir -p "$ROOT_DIR/mod/modcsbr/dlls"
cp "$CS_SO" "$ROOT_DIR/mod/modcsbr/dlls/cs.so"

printf 'Built: %s\n' "$CS_SO"
printf 'Copied: %s\n' "$ROOT_DIR/mod/modcsbr/dlls/cs.so"
