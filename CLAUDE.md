# Dotfiles Repository

Cross-platform (macOS + Linux) dotfiles, checked out to `~/src/github.com/fredsmith/dotfiles/`.

## Key Variables

- `CONFIGDIR` — points to this repo checkout
- `XDG_CONFIG_HOME` — set to `$CONFIGDIR`
- Always reference `$CONFIGDIR` or `$XDG_CONFIG_HOME` instead of the full path
- Never hard-code usernames or absolute paths — this repo runs on multiple systems with different usernames

## Shell Function/Config Organization

Functions, aliases, and tool-specific config go in dedicated `conf.d/` files, **not** in top-level rc files:

| Shell | Location | Naming |
|-------|----------|--------|
| fish  | `fish/conf.d/<tool>.fish` | e.g. `fish/conf.d/aws.fish` |
| bash  | `bash/<tool>` | e.g. `bash/aws` |
| zsh   | `zsh/<tool>.zsh` | e.g. `zsh/kubectl.zsh` |

## Top-Level RC Files

The top-level config files (`bashrc`, `zshrc`, `fish/config.fish`) should only contain:
- Sourcing/loading of conf.d files
- Core shell settings (prompt, history, key bindings)
- `CONFIGDIR` / `XDG_CONFIG_HOME` setup

**Police these files.** Tools frequently append lines to rc files during installation. When you see tool-specific additions (PATH modifications, eval statements, completions, aliases) in `bashrc`, `zshrc`, or `fish/config.fish`, move them to the appropriate `conf.d/` file.

## .gitignore Policy

Because `XDG_CONFIG_HOME` points here, many tools auto-create files and directories in this repo. Aggressively `.gitignore` them. Only track files that:
1. Provide value to sync across systems
2. Can be manually edited/configured
3. Do not contain secrets

When in doubt, add it to `.gitignore`.

## Git Sync Workflow

The goal is to keep config in sync across systems and reduce setup time on new machines. Before making changes:
1. Offer to pull latest (`git pull`) to avoid conflicts
2. After changes, offer to commit and push so other systems can pick them up
