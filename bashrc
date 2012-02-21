# If not running interactively, don't do anything
[ -z "$PS1" ] && return
export FULLNAME="Fred Smith"
export EMAIL="fred.smith@fredsmith.org"



# bash modules

shopt -s autocd &> /dev/null
shopt -s checkwinsize &> /dev/null

#Import functions
. .bashrc-funcs

#Redhat specific
if which rpm &> /dev/null; then
	if [ "$LOGNAME" = "root" ]; then
		alias yum='yum -y'
		alias apt-get='yum -y'
	else

		alias yum='sudo yum -y'
		alias apt-get='sudo yum -y'
	fi
	alias listfiles='rpm -q --filesbypkg'
fi

#debian specific
if which dpkg &> /dev/null; then
	if [ "$LOGNAME" = "root" ]; then
		alias yum='aptitude'
		alias apt-get='aptitude'
	else

		alias yum='sudo aptitude'
		alias apt-get='sudo aptitude'
	fi
	alias listfiles='dpkg --listfiles'
fi

export PROMPTCHAR="#"
# cross-distro, if not root
if ! [ "$LOGNAME" = "root" ]; then
	alias service='sudo service'
	export PROMPTCHAR="$"
	if ! which root &> /dev/null; then
		alias root="sudo -i"
	fi
fi

# bash completion for service
if [ -d /etc/init.d/ ]; then
   complete -W "$(ls /etc/init.d/)" service
fi
# bash completion for ssh config
if [ -f ~/.ssh/config ]; then
   complete -W "$(cat ~/.ssh/config | grep "Host \w" | cut -f 2 -d ' ')" ssh
fi

# Get FQDN somehow
HOSTNAMEVER=$(hostname --version 2>&1 | grep hostname | cut -f 2 -d ' ' | cut -f 1 -d '.' | head -n 1)

if [ $HOSTNAMEVER -gt 1 2>/dev/null ]; then
	export FQDN=$(hostname -A)
else
	export FQDN=$(hostname -f)
fi

# Set up environment-specific markers
ENVDESIGNATOR=$(echo $FQDN | cut -f 2 -d '.')
case "$ENVDESIGNATOR" in

	pr)
		TXT_COLOR="\[\e[1;31m\]"
		ENVPROMPT="$TXT_COLOR[PROD]\[\e[0m\]"
	;;
	st)
		TXT_COLOR="\[\e[1;33m\]"
		ENVPROMPT="$TXT_COLOR[STAGE]\[\e[0m\]"
	;;
	si)
		TXT_COLOR="\[\e[1;36m\]"
		ENVPROMPT="$TXT_COLOR[SI]\[\e[0m\]"
	;;
	pt)
		TXT_COLOR="\[\e[1;32m\]"
		ENVPROMPT="$TXT_COLOR[PERF]\[\e[0m\]"
	;;
	*)
		unset ENVDESIGNATOR
	;;
esac

# environment
export EDITOR=vim
export PATH=~/bin/:$PATH:/sbin:/usr/sbin:/usr/local/sbin:/usr/local/bin:/usr/libexec/git-core
export TZ=US/Eastern

# source proxy information
if [ -f ~/.proxy ]; then
	. ~/.proxy
fi

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth
unset HISTFILESIZE
export HISTFILESIZE
unset HISTSIZE
export HISTSIZE
# append to the history file without overwriting, and write history out after every command execution
export HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S - '
shopt -s histappend
export PROMPT_COMMAND='post_history; history -a'

# set pretty prompt
export PS1="\[\e]0;\u@\h: \w\a\]\[\033[36m\][\t] \[\033[1;33m\]\u\[\033[0m\]@\h$ENVPROMPT\[\033[36m\][\w]$PROMPTCHAR\[\033[0m\] "


ADDNEWLINE=false

# Configure git
if [ ! -f ~/.gitconfig ]; then
	if which git &> /dev/null; then
		echo -en "\033[36m[Git]\033[0m";
		echo "[user]
	name = $FULLNAME
	email = $EMAIL" >> ~/.gitconfig
		ADDNEWLINE=true
	fi
fi


if ! which vim &> /dev/null; then
	alias vim=vi
fi

# Configure ssh
if which keychain &> /dev/null; then
	eval `keychain --inherit any --agents ssh --quick --quiet --eval`
fi

if [ ! -d ~/.ssh ]; then
	echo -en "\033[36m[~/.ssh]\033[0m";
	ADDNEWLINE=true
	mkdir ~/.ssh/;
	chmod -R go-rwx ~/.ssh/;
fi

if [ ! -f ~/.ssh/authorized_keys ]; then
	touch ~/.ssh/authorized_keys;
fi

if ! grep derf@derf.us ~/.ssh/authorized_keys > /dev/null; then
	echo -en "\033[36m[~/.ssh/authorized_keys]\033[0m";
	ADDNEWLINE=true
	echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAxKz0Pa5oPXs26d4nf0BgP4c8HZR7MlJDBonktUQZcL0oJFBIgMHxtG5qvlnuP1wN+4fG3+ksTFvqDErPYUTcWNdQ230MtkH7hEX1CYMHVck8/ohooe5pd7+V/Xxqa3HxrfwPHPuP4sfwkVHYswYS+dx6P787O9IGkrh/Lw91eM5E04ub0+irDJJDuGXrjvZ6VC3rOUoZ5SB6mafwKsJGGLoyY4Gks5rFqTpZDervwxM18TKIPgqD43+GQce4wzLRYIa60yMMHpK4THOaet4HMPlr+Immt/OM71/ZubaPxG13XOq7t5JjKuejsJlo0cO4ycbFsy78dRcCOSnStHFQpw== derf@derf.us" >> ~/.ssh/authorized_keys
	chmod -R go-rwx ~/.ssh/;
fi


if [ ! -f ~/.ssh/config ]; then
	echo -en "\033[36m[~/.ssh/config]\033[0m";
	ADDNEWLINE=true
	echo "Host *
ForwardAgent yes
ServerAliveInterval 120" > ~/.ssh/config
	chmod -R go-rwx ~/.ssh/;
fi

$ADDNEWLINE && echo

# Aliases
if [ -f /usr/bin/gnu/grep ]; then
	alias grep='/usr/bin/gnu/grep --color=auto'
else
	alias grep='grep --color=auto'
fi

alias add='/usr/bin/ssh-add -t 18000 ~/.ssh/*.*sa'
alias lock='/usr/bin/ssh-add -D'
alias list='/usr/bin/ssh-add -l'
alias ll='ls -l'
alias la='ls -a'
alias xi='ssh xicada'
alias ssudo='alias sudo=ssudo; ssh -o StrictHostKeyChecking=no root@$HOSTNAME'

#todo.txt

export TODOTXT_DEFAULT_ACTION=ls
alias t='~/bin/todo.sh -d ~/Documents/todo.cfg'





#git

alias ga='git add'
alias gp='git push'
alias gl='git log'
alias gs='git status'
alias gd='git diff'
alias gm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gc='git checkout'
alias gra='git remote add'
alias grr='git remote rm'
alias gpu='git pull'
alias gcl='git clone'

alias screenrd='screen -rd'
alias tm='tmux attach'

alias decode='tr "A-Z" "a-z" | tr "a-d" "W-Z" | tr "e-z" "a-v" | tr "A-Z" "a-z"'
alias encode='tr "A-Z" "a-z" | tr "w-z" "A-D" | tr "a-v" "e-z" | tr "A-Z" "a-z"'




# this has to go after delcaration of portcheck

if portcheck localhost 18080 > /dev/null; then
	sshopts="$sshopts -R 18080:localhost:18080"
fi

alias ssh="ssh $sshopts"
