#!/bin/bash

set -euo pipefail

if pacman -Q sublime-text >/dev/null 2>&1; then
  echo "sublime text already installed"
else
  echo "installing sublime text..."
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/sublimehq-pub.gpg" https://download.sublimetext.com/sublimehq-pub.gpg
  sudo pacman-key --add "$tmp/sublimehq-pub.gpg"
  sudo pacman-key --lsign-key 8A8F901A
  rm -rf "$tmp"

  if ! grep -q "^\\[sublime-text\\]" /etc/pacman.conf; then
    printf '\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/%s\n' "$(uname -m)" | sudo tee -a /etc/pacman.conf >/dev/null
  fi

  sudo pacman -Sy --needed --noconfirm sublime-text
fi

SUBLIME_INSTALLED="$HOME/.config/sublime-text/Installed Packages"

if [ -f "$SUBLIME_INSTALLED/Package Control.sublime-package" ]; then
  echo "package control already installed"
else
  echo "installing package control..."
  mkdir -p "$SUBLIME_INSTALLED"
  curl -fsSL -o "$SUBLIME_INSTALLED/Package Control.sublime-package" \
    https://github.com/wbond/package_control/releases/latest/download/Package.Control.sublime-package
fi

echo "installing azure cli..."
sudo pacman -S --needed --noconfirm azure-cli

if command -v claude >/dev/null 2>&1; then
  echo "claude code already installed"
else
  echo "installing claude code..."
  omarchy-mise-install claude
fi

if pacman -Q claude-desktop >/dev/null 2>&1; then
  echo "claude desktop already installed"
else
  echo "installing claude desktop..."
  yay -S --needed --noconfirm claude-desktop
fi

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

if command -v omarchy >/dev/null 2>&1; then
  echo "applying the omarchy theme to sublime text..."
  omarchy theme set "$(omarchy theme current)"
fi
