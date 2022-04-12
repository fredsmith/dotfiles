# Fred Smith's ~/dotfiles directory.   

This is my dotfiles directory, with some magic to automatically find home depending on where bashrc is located, as well as automatically setting config files for commands like tmux, vim, screen, etc without having to copy or link them out of ~/dotfiles.

## Installation
```
curl https://get.derf.cloud/dotfiles/master/bashrc | bash
```

## testing

check out this repo, then do `docker build .`  you will be dropped into a bash shell with my dotfiles installed.
