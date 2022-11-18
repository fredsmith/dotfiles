
autoload -U compinit; compinit

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

