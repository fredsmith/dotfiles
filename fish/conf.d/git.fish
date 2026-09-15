# Aliases

alias g git

# Variables

set -gx SRCPATH "$HOME/src/"

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
