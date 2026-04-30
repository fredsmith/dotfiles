if test "$TERM_PROGRAM" = "vscode"
    # VS Code 1.111+ and fish 4.x negotiate the Kitty keyboard protocol,
    # but the interaction is broken — raw CSI u sequences appear instead of
    # being handled. Pop/disable the protocol on startup.
    printf '\e[<u'
    set -g fish_vi_force_cursor 0
    set -g fish_escape_delay_ms 300
end
