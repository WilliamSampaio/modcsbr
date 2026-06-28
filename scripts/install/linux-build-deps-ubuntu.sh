#!/usr/bin/env bash
set -euo pipefail

PACKAGES=(
	build-essential
	cmake
	git
	gcc
	g++
	gcc-multilib
	g++-multilib
	libc6-dev
	libc6-dev-i386
	unzip
)

if [ "${1:-}" != "--install" ]; then
	printf 'Ubuntu build dependencies for ReGameDLL_CS Linux x86:\n\n'
	printf 'sudo dpkg --add-architecture i386\n'
	printf 'sudo apt-get update\n'
	printf 'sudo apt-get install -y'
	printf ' %s' "${PACKAGES[@]}"
	printf '\n\nRun this script with --install to execute those commands.\n'
	exit 0
fi

sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install -y "${PACKAGES[@]}"
