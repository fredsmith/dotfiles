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

# environment.d - systemd reads this at user manager startup, before the
# desktop session begins. Sets XDG_CONFIG_HOME early enough that GUI apps
# and services launched outside a shell still see the right value.
mkdir -p "$HOME/.config/environment.d"
ln -sf "$CONFIGDIR/environment.d/10-dotfiles.conf" "$HOME/.config/environment.d/10-dotfiles.conf"

echo "Done! Log out and back in for environment.d changes to take effect."
