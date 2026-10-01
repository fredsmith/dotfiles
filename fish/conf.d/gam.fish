#! /usr/bin/env fish

### GAM7 — Google Workspace admin CLI

set -gx GAM_PROFILE_ROOT ~/.config/gam-profiles

if type -q gam

  function setgamprofile
    if test -z "$argv[1]"
      echo "usage: setgamprofile <name>   (available: "(__gam_profiles | string join ' ')")"
      return 1
    end
    set -l dir $GAM_PROFILE_ROOT/$argv[1]
    if not test -d $dir
      echo "no such gam profile: $argv[1]"
      return 1
    end
    set -gx GAMCFGDIR $dir
    set -gx GAM_PROFILE $argv[1]
    if test -f $dir/oauth2.txt
      echo "gam profile set to $argv[1] (authenticated)"
    else
      echo "gam profile set to $argv[1] (not authenticated -- run: gam oauth create)"
    end
  end

  function newgamprofile
    if test -z "$argv[1]"
      echo "usage: newgamprofile <name>"
      return 1
    end
    mkdir -p $GAM_PROFILE_ROOT/$argv[1]
    chmod 700 $GAM_PROFILE_ROOT/$argv[1]
    setgamprofile $argv[1]
  end

  function __gam_profiles
    for d in $GAM_PROFILE_ROOT/*
      basename $d
    end
  end

  complete -c setgamprofile -f
  complete -c setgamprofile -a "(__gam_profiles)"

  if test -z "$GAMCFGDIR"
    set -gx GAMCFGDIR $GAM_PROFILE_ROOT/pto
    set -gx GAM_PROFILE pto
  end

end
