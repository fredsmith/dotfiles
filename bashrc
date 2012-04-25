# If not running interactively, don't do anything
[ -z "$PS1" ] && return
export FULLNAME="Fred Smith"
export EMAIL="fred.smith@fredsmith.org"

CONFIGDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# source system profile scripts
for PROFILEFILE in /etc/profile.d/*.sh; do
   source $PROFILEFILE;
done >/dev/null 2>&1

# bash modules

shopt -s autocd &> /dev/null
shopt -s checkwinsize &> /dev/null

#Import functions
if [ -f $CONFIGDIR/.bashrc-funcs ]; then
   . $CONFIGDIR/.bashrc-funcs
fi
if [ -f $CONFIGDIR/bashrc-funcs ]; then
   . $CONFIGDIR/bashrc-funcs
fi


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


# environment
export PATH=$CONFIGDIR/bin/:$PATH:/sbin:/usr/sbin:/usr/local/sbin:/usr/local/bin:/usr/libexec/git-core:/usr/lpp/mmfs/bin:/opt/SGE/bin/lx24-amd64
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

# yellow prompt
#export PS1="\[\e]0;\u@\h: \w\a\]\[\033[36m\][\t] \[\033[1;33m\]\u\[\033[0m\]@\h$ENVPROMPT\[\033[36m\][\w]$PROMPTCHAR\[\033[0m\] "

# blue prompt
function set_prompt {

   TODO="";
   if which todo.sh &> /dev/null; then
      TODOWORK_COUNT=$(t ls @work | wc -l)
      TODOWORK_COUNT=$(($TODOWORK_COUNT - 2));
      #TODOHOME_COUNT=$(t ls @home | wc -l)
      #TODOHOME_COUNT=$(($TODOHOME_COUNT - 2));
      TODO="-[\[\e[0;34m\]T:\[\033[1;33m\]$TODOWORK_COUNT\[\e[1;34m\]]-"
   fi
   GITPROMPT="";
   GITSTATUS=$(git status --porcelain 2>&1)
   if [[ $? -eq 0 ]]; then
      GITPROMPT="-[\[\e[0;34m\]G:\[\033[1;32m\]✓\[\e[1;34m\]]-";
      GITDIFF=$(echo $GITSTATUS | grep -v '^fatal' | grep -v '^$' | wc -l)
      if [[ $GITDIFF -gt 0 ]]; then
         GITPROMPT="-[\[\e[0;34m\]G:\[\033[1;31m\]✗ $GITDIFF\[\e[1;34m\]]-";
      fi
   fi

   #running this after every command is pretty expensive.  cache it maybe?
   PS1="\n\[\e[1;34m\]┌[\[\e[0;34m\]\u@\h\[\e[1;34m\]]$TODO$GITPROMPT[\[\e[0;34m\]\t \d\[\e[1;34m\]]\[\e[1;34m\]\n└[\[\e[0;34m\]\w\[\e[1;34m\]] ⚡ \[\e[0m\]"
}
export PROMPT_COMMAND="set_prompt; $PROMPT_COMMAND"


# VIM
if [ -f $CONFIGDIR/.vimrc ]; then
   alias vim="vim -u $CONFIGDIR/.vimrc"
   export EDITOR="vim -u $CONFIGDIR/.vimrc"
fi
if [ -f $CONFIGDIR/vimrc ]; then
   alias vim="vim -u $CONFIGDIR/vimrc"
   export EDITOR="vim  -u $CONFIGDIR/vimrc"

fi
if ! which vim &> /dev/null; then
	alias vim=vi
   export EDITOR=vi
fi

# Configure ssh
if which keychain &> /dev/null; then
	eval `keychain --inherit any --agents ssh --quick --quiet --eval`
fi



# Aliases
if [ -f /usr/bin/gnu/grep ]; then
	alias grep='/usr/bin/gnu/grep --color=auto'
else
	alias grep='grep --color=auto'
fi

#ssh stuff
alias add='/usr/bin/ssh-add -t 18000 ~/.ssh/*.*sa'
alias lock='/usr/bin/ssh-add -D'
alias list='/usr/bin/ssh-add -l'
alias xi='ssh xicada'
alias ssudo='alias sudo=ssudo; ssh -o StrictHostKeyChecking=no root@$HOSTNAME'
function grid { ssh -t grid-$1.grid "bash --rcfile /net/yum/admin/work/fred/bashrc"; }
function ibm { ssh -t ibm-$1.grid "bash --rcfile /net/yum/admin/work/fred/bashrc"; }

#tmux 
if [ -f $CONFIGDIR/.tmux.conf ]; then
   alias tmux="tmux -f $CONFIGDIR/.tmux.conf"
fi
if [ -f $CONFIGDIR/tmux.conf ]; then
   alias tmux="tmux -f $CONFIGDIR/tmux.conf"
fi
alias tm='tmux attach'




#file management
alias ls='ls --color=auto -p'
alias ll='ls --color=auto -alk'
alias la='ls --color=auto -ak'


#todo.txt

export TODOTXT_DEFAULT_ACTION=pv
export TODOTXT_AUTO_ARCHIVE=1
export TODOTXT_CFG_FILE=~/Documents/Notes/todo.cfg
alias t='~/bin/todo.sh'


#gpg

alias gpge='gpg --encrypt'
alias gpgd='gpg --decrypt'


#git
[ -s "$CONFIGDIR/.scm_breeze/scm_breeze.sh" ] && source "$CONFIGDIR/.scm_breeze/scm_breeze.sh"

#screen
if [ -f $CONFIGDIR/.screenrc ]; then
   alias screen="screen -c $CONFIGDIR/.screenrc"
fi
if [ -f $CONFIGDIR/screenrc ]; then
   alias screen="screen -c $CONFIGDIR/screenrc"
fi
alias screenrd='screen -rd'



#cipher
alias decode='tr "A-Z" "a-z" | tr "a-d" "W-Z" | tr "e-z" "a-v" | tr "A-Z" "a-z"'
alias encode='tr "A-Z" "a-z" | tr "w-z" "A-D" | tr "a-v" "e-z" | tr "A-Z" "a-z"'

#web

alias hackurl='elinks http://hackurls.com/'

function google {
   TERMS=$(echo $* | tr ' ' '+');
   elinks "https://www.google.com/search?q=$TERMS"
}



# this has to go after delcaration of portcheck

if portcheck localhost 18080 > /dev/null; then
	sshopts="$sshopts -R 18080:localhost:18080"
fi

alias ssh="ssh $sshopts"

