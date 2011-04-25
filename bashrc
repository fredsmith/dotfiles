# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Aliases
alias grep='grep --color=auto'
alias add='/usr/bin/ssh-add -t 18000 ~/.ssh/key.dsa ~/.ssh/nokia.rsa'
alias lock='/usr/bin/ssh-add -D'

if which rpm &> /dev/null; then
	#Redhat specific
	alias yum=yum -y
fi

if which dpkg &> /dev/null; then
	#debian specific
fi


# environment
export EDITOR=vim
export PATH=~/bin/:$PATH
export TZ=US/Eastern

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

# Configure git
if [ ! -f ~/.gitconfig ]; then
	if which git &> /dev/null; then
		echo "configuring Git";
		git config --global user.name "Fred Smith"
		git config --global user.email "fred.smith@fredsmith.org"
	fi
fi


# Configure vim
if [ ! -f ~/.vimrc ]; then
	echo "configuring Vim";
	echo "syntax on" > ~/.vimrc
fi

if ! which vim &> /dev/null; then
	alias vim=vi
fi

# Configure ssh


if [ ! -d ~/.ssh ]; then
	echo "configuring ~/.ssh";
	mkdir ~/.ssh/;
	chmod -R go-rwx ~/.ssh/;
fi

if [ ! -f ~/.ssh/authorized_keys ]; then
	echo "configuring authorized_keys";
	echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAxKz0Pa5oPXs26d4nf0BgP4c8HZR7MlJDBonktUQZcL0oJFBIgMHxtG5qvlnuP1wN+4fG3+ksTFvqDErPYUTcWNdQ230MtkH7hEX1CYMHVck8/ohooe5pd7+V/Xxqa3HxrfwPHPuP4sfwkVHYswYS+dx6P787O9IGkrh/Lw91eM5E04ub0+irDJJDuGXrjvZ6VC3rOUoZ5SB6mafwKsJGGLoyY4Gks5rFqTpZDervwxM18TKIPgqD43+GQce4wzLRYIa60yMMHpK4THOaet4HMPlr+Immt/OM71/ZubaPxG13XOq7t5JjKuejsJlo0cO4ycbFsy78dRcCOSnStHFQpw== derf@azeroth.xicada.com" >> ~/.ssh/authorized_keys
	chmod -R go-rwx ~/.ssh/;
fi


if [ ! -f ~/.ssh/config ]; then
	echo "configuring ssh config";
	echo "Host *
ForwardAgent yes
ServerAliveInterval 120" > ~/.ssh/config
	chmod -R go-rwx ~/.ssh/;
fi
