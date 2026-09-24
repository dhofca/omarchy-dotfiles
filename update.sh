#!/bin/bash

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# re-exec after pulling so the newest version of this script runs
if [ -z "${DOTFILES_UPDATED:-}" ]; then
  echo "updating the dotfiles..."
  git -C "$DOTFILES" pull --ff-only
  exec env DOTFILES_UPDATED=1 "$DOTFILES/update.sh" "$@"
fi

"$DOTFILES/install.sh"

echo
echo "the dotfiles are updated"
