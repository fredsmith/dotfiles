if status is-interactive
    set -x STARSHIP_CONFIG ~/src/github.com/fredsmith/dotfiles/starship.toml
    starship init fish | source
    # Commands to run in interactive sessions can go here
end
