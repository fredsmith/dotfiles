#! /usr/bin/env bash

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
        alias yum='apt-get'
	else
        alias apt-get='sudo apt-get'
        alias apt='sudo apt'
        alias yum='sudo apt'
	fi
	alias listfiles='dpkg --listfiles'
   function whatprovides() {
      if [ -f $1 ]; then
         dpkg -S $1;
      else
         dpkg -S `which $1`
      fi
   }

   complete -W "$(dpkg -l | print 2)" listfiles
   complete -W "$(grep '^Package: ' /var/lib/dpkg/available | sed -e 's/Package: //')" apt-get yum
fi

alias lsb='lsb_release -a'

