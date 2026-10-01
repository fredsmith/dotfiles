# Aliases

alias g git

# Variables

set -gx SRCPATH "$HOME/src/"
set -gx project_dirs "$SRCPATH/github.com/wanderu/:$SRCPATH/github.com/fredsmith/:$SRCPATH/github.com/smith-bz/"
set -gx RUNDOWN_PERSONAL_REPO_PATTERNS "fredsmith/*,smith-bz/*"

# Functions

function gco
  set REPO $argv[1]
  # Expand shorthand "owner/repo" to a GitHub SSH URL
  if string match -qr '^[[:alnum:]_.-]+/[[:alnum:]_.-]+$' -- $REPO
    set REPO "git@github.com:$REPO.git"
  end
  set REPOPATH (string replace -r '.*@' '' $REPO | string replace -r ':' '/' | string replace -r '.*\/\/' '' | string replace -r '\.git$' '' | string replace -r '/[[:alnum:]_-]+$' '')
  set REPONAME (string replace -r '.*\/' '' $REPO | string replace -r '\.git$' '')
  echo "Cloning $REPONAME into $REPOPATH"
  if not test -d "$SRCPATH$REPOPATH"
    mkdir -p "$SRCPATH$REPOPATH"
  end
  cd "$SRCPATH$REPOPATH"
  if not test -d "$REPONAME"
    git clone "$REPO" "$REPONAME"
  end
  cd "$REPONAME"
end

function gwt
  if test (count $argv) -eq 0
    git worktree list
    return
  end
  set BRANCHNAME $argv[1]
  set PRREF (string match -r '^((?:[[:alnum:]_.-]+/)?)([[:alnum:]_.-]+)#([0-9]+)$' -- $BRANCHNAME)
  if test -n "$PRREF"
    set OWNER (string trim -r -c / -- $PRREF[2])
    set REPONAME $PRREF[3]
    set PRNUM $PRREF[4]
    set CANDIDATES
    if test -n "$OWNER"
      set CANDIDATES "$SRCPATH"github.com/$OWNER/$REPONAME
    else
      for dir in (string split ':' -- $project_dirs)
        set -a CANDIDATES (string trim -r -c / -- $dir)/$REPONAME
      end
    end
    set REPODIR
    for c in $CANDIDATES
      if test -d "$c"
        set REPODIR $c
        break
      end
    end
    if test -z "$REPODIR"
      echo "No local clone of $REPONAME found in: $CANDIDATES"
      return 1
    end
    cd "$REPODIR"; or return
    set PRINFO (gh pr view $PRNUM --json headRefName,isCrossRepository --jq '.headRefName, .isCrossRepository'); or return
    set BRANCHNAME $PRINFO[1]
    if test "$PRINFO[2]" = true; and not git show-ref --verify --quiet "refs/heads/$BRANCHNAME"
      git fetch origin "pull/$PRNUM/head:$BRANCHNAME"; or return
    end
    echo "$REPONAME#$PRNUM -> $BRANCHNAME"
  end
  set REPOROOT (git worktree list --porcelain 2>/dev/null | grep -m1 '^worktree ' | string replace 'worktree ' '')
  if test -z "$REPOROOT"
    echo "Not in a git repo"
    return 1
  end
  set SAFENAME (string replace -a '/' '-' $BRANCHNAME)
  set WTPATH "$REPOROOT/.worktrees/$SAFENAME"

  # If this branch is checked out in ANY worktree, cd there
  set EXISTING (git worktree list --porcelain | awk -v b="refs/heads/$BRANCHNAME" '
    /^worktree / { wt = $2 }
    $0 == "branch " b { print wt; exit }
  ')
  if test -n "$EXISTING"
    cd "$EXISTING"
    return
  end

  git fetch --all
  if git show-ref --verify --quiet "refs/heads/$BRANCHNAME"
    git worktree add "$WTPATH" "$BRANCHNAME"; or return
  else if git show-ref --verify --quiet "refs/remotes/origin/$BRANCHNAME"
    git worktree add "$WTPATH" "$BRANCHNAME"; or return
  else
    git worktree add "$WTPATH" -b "$BRANCHNAME"; or return
  end
  cd "$WTPATH"
end
