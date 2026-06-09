# Aliases

alias g git

# Variables

set -gx SRCPATH "$HOME/src/"
set -gx project_dirs "$SRCPATH/github.com/wanderu/:$SRCPATH/github.com/fredsmith/:$SRCPATH/github.com/smith-bz/"
set -gx RUNDOWN_PERSONAL_REPO_PATTERNS "fredsmith/*,smith-bz/*"

# Functions

function gco
  set REPO $argv[1]
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
