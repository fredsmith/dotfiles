function __llm_pass_keys
    set -l store $PASSWORD_STORE_DIR
    test -z "$store"; and set store $HOME/.password-store
    test -d $store; or return
    find -L $store -name '*.gpg' -type f 2>/dev/null \
        | sed -e "s#^$store/##" -e 's/\.gpg$//'
end

complete -c llm-pass -f
complete -c llm-pass -n __fish_use_subcommand -a show -d 'Read a secret value (gated)'
complete -c llm-pass -n __fish_use_subcommand -a ls -d 'List key names (gated)'
complete -c llm-pass -n __fish_use_subcommand -a find -d 'Find key names (gated)'
complete -c llm-pass -n __fish_use_subcommand -a 'insert edit generate rm mv cp git init help version'
complete -c llm-pass -a '(__llm_pass_keys)' -d 'pass key'
