#! /usr/bin/env fish

### Google Workspace CLI

set -gx GWS_PROFILE_ROOT ~/.config/gws-profiles

# morning-rundown ships a generic default; point it at the work account
set -gx RUNDOWN_GWS_PROFILE wanderu

if type -q gws

  function setgwsprofile
    if test -z "$argv[1]"
      echo "usage: setgwsprofile <name>   (available: "(__gws_profiles | string join ' ')")"
      return 1
    end
    set -l dir $GWS_PROFILE_ROOT/$argv[1]
    if not test -d $dir
      echo "no such gws profile: $argv[1]"
      return 1
    end
    set -gx GOOGLE_WORKSPACE_CLI_CONFIG_DIR $dir
    set -gx GWS_PROFILE $argv[1]
    echo "gws profile set to $argv[1] ("(gws auth status 2>/dev/null | jq -r '.user // "not authenticated"')")"
  end

  function newgwsprofile
    if test -z "$argv[1]"
      echo "usage: newgwsprofile <name>"
      return 1
    end
    mkdir -p $GWS_PROFILE_ROOT/$argv[1]
    chmod 700 $GWS_PROFILE_ROOT/$argv[1]
    setgwsprofile $argv[1]
  end

  function __gws_profiles
    for d in $GWS_PROFILE_ROOT/*
      basename $d
    end
  end

  complete -c setgwsprofile -f
  complete -c setgwsprofile -a "(__gws_profiles)"

  if test -z "$GOOGLE_WORKSPACE_CLI_CONFIG_DIR"
    set -gx GOOGLE_WORKSPACE_CLI_CONFIG_DIR $GWS_PROFILE_ROOT/personal
    set -gx GWS_PROFILE personal
  end

end
