
ZSH_DISABLE_COMPFIX=true

autoload -U compinit; compinit

if ! { [ -n "$SSH_CONNECTION" ] && [ -S "$SSH_AUTH_SOCK" ]; }; then
  export SSH_AUTH_SOCK="$HOME/.gnupg/S.gpg-agent.ssh"
fi

if [[ -d $HOME/src/github.com/fredsmith/dotfiles ]]; then
  export CONFIGDIR="$HOME/src/github.com/fredsmith/dotfiles";
fi

if (( ${+CONFIGDIR} )); then
  #load modules
  if [[ -d $CONFIGDIR/zsh ]]; then
    for FILE in $CONFIGDIR/zsh/*.zsh; do
      source $FILE;
    done
  fi
fi
