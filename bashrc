# If not running interactively, don't do anything
[ -z "$PS1" ] && return
export FULLNAME="Fred Smith"
export EMAIL="fred.smith@fredsmith.org"

CONFIGDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export HOME=$CONFIGDIR

# source system profile scripts
for PROFILEFILE in /etc/profile.d/*.sh; do
   source $PROFILEFILE;
done >/dev/null 2>&1

# bash modules

shopt -s autocd &> /dev/null
shopt -s checkwinsize &> /dev/null

#Import ~/.bash modules
if [ -d $CONFIGDIR/.bash ]; then
   for BASHMODULE in  $CONFIGDIR/.bash/*; do
      . $BASHMODULE;
   done
fi


# environment
export PATH=$CONFIGDIR/bin/:$PATH:/sbin:/usr/sbin:/usr/local/sbin:/usr/local/bin:/usr/libexec/git-core:/usr/lpp/mmfs/bin:/opt/SGE/bin/lx24-amd64
export TZ=US/Eastern


# functions
function rehash { 
   if [ -f $CONFIGDIR/.bashrc ]; then
      . $CONFIGDIR/.bashrc
   fi
   if [ -f $CONFIGDIR/bashrc ]; then
      . $CONFIGDIR/bashrc
   fi
}
