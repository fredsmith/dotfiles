# set home to be wherever .bashrc is
export HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


# set configdir to be ~/[.]dotfiles
export CONFIGDIR=$HOME;
export XDG_CONFIG_HOME=$CONFIGDIR;

# environment
export TZ=US/Eastern
export FULLNAME="Fred Smith"
export EMAIL="fred@smith.bz"
export CONFIGDIR="$HOME/src/github.com/fredsmith/dotfiles";
export PATH=~/bin:~/.local/bin:/usr/local/bin:/usr/local/sbin:/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH:/sbin:/usr/sbin:$HOME/.rvm/bin
# If not running interactively, don't do anything
[ -z "$PS1" ] && return
fd=0   # stdin
if ! [[ -t "$fd" || -p /dev/stdin ]]; then
   return
fi
#set -x


# source system profile scripts
for PROFILEFILE in /etc/profile.d/*.sh; do
   source $PROFILEFILE;
done >/dev/null 2>&1

# source system profile scripts
for PROFILEFILE in /usr/local/etc/bash_completion.d/*; do
   source $PROFILEFILE;
done >/dev/null 2>&1


# we set this twice, in case some system level init scripts overrides it
export XDG_CONFIG_HOME=$CONFIGDIR;

# bash modules

shopt -s autocd &> /dev/null
shopt -s checkwinsize &> /dev/null

#Import ~/.bash modules
if [ -d $CONFIGDIR/bash ]; then
   for BASHMODULE in  $CONFIGDIR/bash/*; do
      source $BASHMODULE;
   done
fi

#Secrets
if [ -f $HOME/.secrets ]; then
   source $HOME/.secrets;
fi


# functions
function rehash { 
   if [ -f $HOME/.bashrc ]; then
     unset PROMPT_PLUGINS
     hash -r
      . $HOME/.bashrc
   fi
}