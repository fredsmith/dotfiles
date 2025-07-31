#! /usr/bin/env zsh

### Amazon Web Services

if [[ -f ~/.aws/config ]]; then

  #functions
  function setawsenv {
    export AWS_PROFILE="$1"
    aws iam list-account-aliases > /dev/null 2>&1 || aws sso login
    export SETENV_NAME=$(aws iam list-account-aliases | jq '.AccountAliases[0]' | sed -e 's/"//g')
    if [[ -z $SETENV_NAME ]] || [[ "$SETENV_NAME" == "null" ]]; then
      export SETENV_NAME=$AWS_PROFILE
    fi
    echo "AWS set to $1"
  }
  compctl -k "($(aws configure list-profiles | tr '\n' ' '))" setawsenv

  function setawsregion {
    export AWS_REGION="$1"
  }
  compctl -k "(us-east-1 us-west-2)" setawsregion

fi

if which aws &> /dev/null; then
  if which aws_completer &> /dev/null; then
    compctl -K aws_completer aws
  fi
fi

function aws_prompt() {
  # Load colors for zsh
  autoload -U colors && colors
  
  if ! [ -z "$AWS_PROFILE" ]; then
    echo -n "%{$fg[blue]%}[A:%{$fg[green]%}$AWS_PROFILE%{$reset_color%}]-";
  fi
  if ! [ -z "$AWS_REGION" ]; then
    echo -n "%{$fg[blue]%}[R:%{$fg[green]%}$AWS_REGION%{$reset_color%}]-";
  fi

}

# Enable prompt substitution for zsh
setopt PROMPT_SUBST
PS1='$(aws_prompt)'$PS1