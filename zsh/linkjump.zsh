#! /usr/bin/env zsh

### linkjump

if [[ -d ~/src ]]; then

  # variables

  # aliases 
  alias jb=popd


  ## Functions
  function j {
     if [[ $# -eq 1 ]]; then
        if [[ -L ~/links/$1 ]]; then
          REALDIR=$(pushd ~/links/$1 > /dev/null && /usr/bin/env pwd -P && popd > /dev/null;)
          if [[ $? -eq 0 ]]; then
            pushd "$REALDIR"
          fi
        else if [[ -L ~/links/*$1* ]]; then
            REALDIR=$(pushd ~/links/*$1* > /dev/null && /usr/bin/env pwd -P && popd > /dev/null;)
            if [[ $? -eq 0 ]]; then
              pushd "$REALDIR"
            fi
          else
            REALDIR=$(pushd ~/src/*/*/$1 > /dev/null && /usr/bin/env pwd -P && popd > /dev/null;)
            if [[ $? -eq 0 ]]; then
              pushd "$REALDIR"
            fi
          fi
        fi
     else
       echo "available links:"
       ls ~/links/
       echo "link stack:"
       dirs
     fi
  }

  function _j {
    JTARGETS=$(for FILE in ~/src/*/*/*; do if [[ -d "$FILE" ]]; then echo -n "$FILE " | sed -e 's/.*\///'; fi; done);
    compadd $JTARGETS
    #echo $JTARGETS
    #compadd foo bar baz
  }

  function linkjump_prompt {
      DIRSCOUNT=$(expr $(dirs | wc -w) - 1);
      if [[ $DIRSCOUNT > 0 ]]; then
          echo -n "$default[L:$blue$DIRSCOUNT$default]-"
      fi
  }
  export PROMPT_PLUGINS="$PROMPT_PLUGINS linkjump_prompt";

  # autocomplete
  compdef _j j 

else
  mkdir -p ~/links
fi

