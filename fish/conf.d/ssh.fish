#! /usr/bin/env fish

# ssh agent
#alias lock='echo "KEYINFO --ssh-list --ssh-fpr" | gpg-connect-agent | grep MD5 | awk "{print \$3}" | while read -l KEY; echo "DELETE_KEY $KEY" | gpg-connect-agent'
alias lock='ssh-add -D'
alias list='ssh-add -l'

# GPG Agent running as ssh-agent
set GPG_AUTH_SOCK_FILENAME /run/user/(id -u)/gnupg/S.gpg-agent.ssh
if test -S $GPG_AUTH_SOCK_FILENAME
    set -x SSH_AUTH_SOCK $GPG_AUTH_SOCK_FILENAME
    alias lock='echo > ~/.gnupg/sshcontrol'
end


# fish completion for ssh config
if test -f ~/.ssh/config
    complete -c ssh -a "(cat ~/.ssh/config 2>/dev/null | grep 'Host \w' | cut -f 2 -d ' ')"
    complete -c sshow -a "(cat ~/.ssh/config 2>/dev/null | grep 'Host \w' | cut -f 2 -d ' ')"
end

# functions
function sshclear
    if test $argv[1] -gt 0
        set REGEXP "$argv[1]d"
        sed -i".bak" $REGEXP ~/.ssh/known_hosts
    end
end

set -x PASSWORD_STORE_DIR $HOME/src/github.com/fredsmith/password-store
if test -d $PASSWORD_STORE_DIR/ssh
    function add
        set -lx SSH_ASKPASS_REQUIRE never
        ssh-add (pass ssh/$argv[1] | psub) < /dev/tty
    end
    complete -f add
    complete -c add -a "(ls $PASSWORD_STORE_DIR/ssh/*.*sa.gpg 2>/dev/null | sed -e 's/.*\///' -e 's/.gpg//')"
end

function sshow
    for ARG in $argv
        grep -A 1 $ARG ~/.ssh/config
    end
end
