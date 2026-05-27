# Aliases

alias g git

# Variables

set -gx SRCPATH "$HOME/src/"

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
  set REPOROOT (git rev-parse --show-toplevel 2>/dev/null)
  if test -z "$REPOROOT"
    echo "Not in a git repo"
    return 1
  end
  # branch names can contain /, which we don't want as nested dirs
  set SAFENAME (string replace -a '/' '-' $BRANCHNAME)
  set WTPATH "$REPOROOT/.worktrees/$SAFENAME"

  git fetch --all
  if git show-ref --verify --quiet "refs/heads/$BRANCHNAME"
    git worktree add "$WTPATH" "$BRANCHNAME"
  else if git show-ref --verify --quiet "refs/remotes/origin/$BRANCHNAME"
    git worktree add "$WTPATH" "$BRANCHNAME"
  else
    git worktree add "$WTPATH" -b "$BRANCHNAME"
  end
  cd "$WTPATH"
end