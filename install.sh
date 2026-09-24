#!/bin/bash

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

find "$DOTFILES/home" -type f ! -name .gitkeep -print0 | while IFS= read -r -d '' src; do
  target="$HOME/${src#"$DOTFILES/home/"}"

  display="~/${target#"$HOME/"}"

  mkdir -p "$(dirname "$target")"
  ln -sfn "$src" "$target"

  echo "linked $display"
done

"$DOTFILES/packages.sh"

echo
echo "the dotfiles are installed"
