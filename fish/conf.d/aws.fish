#! /usr/bin/env fish

### Amazon Web Services

if test -f ~/.aws/config

  # functions
  function setawsenv
    set -gx AWS_PROFILE "$argv[1]"
    aws iam list-account-aliases > /dev/null 2>&1; or aws sso login
    set SETENV_NAME (aws iam list-account-aliases | jq -r .AccountAliases[0])
    if test -z "$SETENV_NAME" -o "$SETENV_NAME" = "null"
      set -gx SETENV_NAME $AWS_PROFILE
    end
    echo "AWS set to $argv[1]"
  end
  complete -c setawsenv -f
  complete -c setawsenv -a "(aws configure list-profiles)"
  set -gx AWS_REGION "us-east-1"

  function setawsregion
    set -gx AWS_REGION "$argv[1]"
  end

  complete -c setawsregion -f
  complete -c setawsregion -a "us-east-1 us-west-2"

  function makesshconfig
    aws ec2 describe-instances | jq -r '.Reservations[].Instances[] | (.Tags[]|select(.Key=="Name")|.Value), .PrivateIpAddress' | while read -l HOSTNAME; read -l IPADDRESS; echo "Host $HOSTNAME"; echo "    HostName $IPADDRESS"; end
  end

end

if type -q aws
  function __fish_complete_aws
    env COMP_LINE=(commandline -pc) aws_completer | tr -d ' '
  end
  
  complete -c aws -f -a "(__fish_complete_aws)"
end
set -gx AWS_REGION 'us-east-1'
