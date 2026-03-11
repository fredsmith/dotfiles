#!/usr/bin/env bash
set -euo pipefail

CONFIGDIR="$HOME/src/github.com/fredsmith/dotfiles"

if [ -d "$CONFIGDIR" ]; then
  echo "Dotfiles already installed at $CONFIGDIR, pulling latest..."
  git -C "$CONFIGDIR" pull
else
  echo "Cloning dotfiles to $CONFIGDIR..."
  mkdir -p "$(dirname "$CONFIGDIR")"
  git clone https://github.com/fredsmith/dotfiles.git "$CONFIGDIR"
fi

# Link shell configs
for rc in bashrc zshrc profile; do
  if [ -f "$HOME/.$rc" ] && [ ! -L "$HOME/.$rc" ]; then
    mv "$HOME/.$rc" "$HOME/.$rc.old"
  fi
  ln -sf "$CONFIGDIR/$rc" "$HOME/.$rc"
done

# Fish config - link the whole directory
mkdir -p "$HOME/.config"
if [ -d "$HOME/.config/fish" ] && [ ! -L "$HOME/.config/fish" ]; then
  mv "$HOME/.config/fish" "$HOME/.config/fish.old"
fi
ln -sf "$CONFIGDIR/fish" "$HOME/.config/fish"

echo "Done! Start a new shell to pick up changes."
