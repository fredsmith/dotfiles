# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# environment
export PATH=~/bin/:$PATH:/sbin:/usr/sbin:/usr/local/sbin:/usr/local/bin:/usr/libexec/git-core:/usr/lpp/mmfs/bin:/opt/SGE/bin/lx24-amd64
export TZ=US/Eastern
export FULLNAME="Fred Smith"
export EMAIL="fred.smith@fredsmith.org"

# set home to be wherever .bashrc is
export HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# set configdir to be ~/[.]dotfiles
export CONFIGDIR=$HOME;
if [ -d $HOME/dotfiles ]; then
   export CONFIGDIR="$HOME/dotfiles";
else if [-d $HOME/.dotfiles ]; then
   export CONFIGDIR="$HOME/.dotfiles";
fi
fi

# source system profile scripts
for PROFILEFILE in /etc/profile.d/*.sh; do
   source $PROFILEFILE;
done >/dev/null 2>&1

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
      . $HOME/.bashrc
   fi
}
