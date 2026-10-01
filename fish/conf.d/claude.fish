#! /usr/bin/env fish

### Claude Code

alias peon="bash ~/.claude/hooks/peon-ping/peon.sh"

### agent-status skill — display config for `claude agents` fleet reports
set -gx AGENT_STATUS_ROOT $HOME/src/github.com/wanderu
set -gx AGENT_STATUS_ROOT_LABEL "(wanderu)"

function claude_account_a --wraps claude --description "Launch Claude Code as account_a"
  CLAUDE_ACCOUNT=account_a CLAUDE_CONFIG_DIR=$HOME/.claude-account-a command claude $argv
end

function claude_account_b --wraps claude --description "Launch Claude Code as account_b"
  CLAUDE_ACCOUNT=account_b CLAUDE_CONFIG_DIR=$HOME/.claude-account-b command claude $argv
end

function claude --description "Refuse to launch Claude Code without an explicit account"
  if test -z "$CLAUDE_ACCOUNT"
    echo "Use 'claude_account_a' or 'claude_account_b' to launch with the right account." >&2
    return 1
  end
  command claude $argv
end
