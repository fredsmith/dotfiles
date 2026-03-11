# Fred Smith's ~/dotfiles directory.

Cross-platform (macOS + Linux) dotfiles with fish as the primary shell. Config is organized into `conf.d/` directories per shell, and the repo doubles as `XDG_CONFIG_HOME`.

## Installation
```
curl -fsSL https://get.derf.cloud/dotfiles/install.sh | bash
```

## Testing

Check out this repo, then do `docker build -t dotfiles . && docker run -it dotfiles` to get dropped into a fish shell with dotfiles installed.
