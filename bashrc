# If not running interactively, don't do anything
[ -z "$PS1" ] && return
export FULLNAME="Fred Smith"
export EMAIL="fred.smith@fredsmith.org"

#Redhat specific
if which rpm &> /dev/null; then
	if [ "$LOGNAME" = "root" ]; then
		alias yum='yum -y'
	else

		alias yum='sudo yum -y'
	fi
	alias listfiles='rpm -q --filesbypkg'
fi

#debian specific
if which dpkg &> /dev/null; then
	alias yum=aptitude
	alias listfiles='dpkg --listfiles'
fi
# cross-distro, if not root, keep certain things in our path
if ! [ "$LOGNAME" = "root" ]; then
	alias service='sudo service'
fi

# environment
export EDITOR=vim
export PATH=~/bin/:$PATH:/sbin:/usr/sbin:/usr/local/sbin:/usr/libexec/git-core
export TZ=US/Eastern

# source proxy information
if [ -f ~/.proxy ]; then
	. ~/.proxy
fi

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file without overwriting, and write history out after every command execution
shopt -s histappend
export PROMPT_COMMAND="history -a"

# set pretty prompt
export PS1="\[\e]0;\u@\h: \w\a\]\[\033[36m\][\t] \[\033[1;33m\]\u\[\033[0m\]@\h:\[\033[36m\][\w]:\[\033[0m\]"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.

shopt -s checkwinsize
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


# Configure vim
if [ ! -f ~/.vimrc ]; then
	echo -en "\033[36m[Vim]\033[0m";
	ADDNEWLINE=true
	echo "syntax on" > ~/.vimrc
fi

if ! which vim &> /dev/null; then
	alias vim=vi
fi

# Configure ssh
if which keychain &> /dev/null; then
	keychain --inherit any --agents ssh --quick --quiet
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

if ! grep derf@azeroth.xicada.com ~/.ssh/authorized_keys > /dev/null; then
	echo -en "\033[36m[~/.ssh/authorized_keys]\033[0m";
	ADDNEWLINE=true
	echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAxKz0Pa5oPXs26d4nf0BgP4c8HZR7MlJDBonktUQZcL0oJFBIgMHxtG5qvlnuP1wN+4fG3+ksTFvqDErPYUTcWNdQ230MtkH7hEX1CYMHVck8/ohooe5pd7+V/Xxqa3HxrfwPHPuP4sfwkVHYswYS+dx6P787O9IGkrh/Lw91eM5E04ub0+irDJJDuGXrjvZ6VC3rOUoZ5SB6mafwKsJGGLoyY4Gks5rFqTpZDervwxM18TKIPgqD43+GQce4wzLRYIa60yMMHpK4THOaet4HMPlr+Immt/OM71/ZubaPxG13XOq7t5JjKuejsJlo0cO4ycbFsy78dRcCOSnStHFQpw== derf@azeroth.xicada.com" >> ~/.ssh/authorized_keys
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

alias add='/usr/bin/ssh-add -t 18000 ~/.ssh/key.dsa ~/.ssh/nokia.rsa'
alias lock='/usr/bin/ssh-add -D'
alias ll='ls -l'
alias la='ls -a'
alias chrome='google-chrome --proxy-server=http://daprx00.americas.nokia.com:8080 --user-agent="Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US) AppleWebKit/534.4 (KHTML, like Gecko) Chrome/8.0.552.200 Safari/534.10" &>/dev/null &'

# functions

function sshclear { if [ $1 -gt "0" ]; then REGEXP="${1}d"; sed -i".bak" $REGEXP ~/.ssh/known_hosts; fi }
