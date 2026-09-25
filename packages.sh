#!/bin/bash

set -euo pipefail

FONT="GeistMono Nerd Font"

if fc-list : family | grep -F "$FONT" >/dev/null; then
  echo "$FONT already installed"
else
  echo "installing $FONT..."
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/GeistMono.tar.xz" \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/GeistMono.tar.xz
  mkdir -p "$HOME/.local/share/fonts/GeistMono"
  tar -xf "$tmp/GeistMono.tar.xz" -C "$HOME/.local/share/fonts/GeistMono"
  rm -rf "$tmp"
  fc-cache -f "$HOME/.local/share/fonts"
fi

if command -v omarchy >/dev/null 2>&1 && [ "$(omarchy font current 2>/dev/null)" != "$FONT" ]; then
  echo "setting $FONT as the system monospace font..."
  omarchy font set "$FONT"
fi
