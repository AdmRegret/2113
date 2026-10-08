#!/usr/bin/env bash
# Install or remove keywork for the current user
# Usage  ./install.sh [--uninstall]
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
BIN="$HOME/.local/bin"
UNITS="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"
IMAGES="$HOME/Pictures/Wallpapers/keywork"
SOUNDS="$HOME/Music/keywork"

if [ "${1:-}" = "--uninstall" ]; then
    systemctl --user disable --now keywork.timer 2>/dev/null || true
    rm -f "$BIN/keywork" "$UNITS/keywork.service" "$UNITS/keywork.timer"
    systemctl --user daemon-reload
    echo "Removed keywork. Your images and sounds were left in place"
    exit 0
fi

missing=()
for cmd in python3 shuf plasma-apply-wallpaperimage; do
    command -v "$cmd" &>/dev/null || missing+=("$cmd")
done
if [ ${#missing[@]} -gt 0 ]; then
    echo "Missing dependencies, ${missing[*]}" >&2
    exit 1
fi
command -v pw-play &>/dev/null || command -v mpv &>/dev/null || command -v paplay &>/dev/null \
    || echo "No audio player found (pw-play, mpv, or paplay), keywork will run silently"

mkdir -p "$BIN" "$UNITS" "$IMAGES" "$SOUNDS"
install -m 755 "$SRC/keywork" "$BIN/keywork"
install -m 644 "$SRC/systemd/keywork.service" "$UNITS/keywork.service"
install -m 644 "$SRC/systemd/keywork.timer" "$UNITS/keywork.timer"

systemctl --user daemon-reload
systemctl --user enable --now keywork.timer
echo "Installed. Add wallpapers to $IMAGES and clips to $SOUNDS"
echo "Test with  KEYWORK_SECONDS=10 keywork"
