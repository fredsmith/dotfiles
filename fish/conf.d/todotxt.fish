#! /usr/bin/env fish

### todo.txt — kanban-style helpers around todo.sh
###
### Vocabulary:
###   now        → (A) actively in progress (list, or with args, add)
###   next       → (B) pull-next queue
###   someday    → (C) backlog
###   snooze N   → hide item N until a date (uses todo.txt t:YYYY-MM-DD threshold)
###   wake N     → strip the snooze tag
###   snoozed    → list sleeping items and when they wake
###   all        → show every active item, including snoozed (bypasses filter)
###   done-today → today's completions

set -gx TODOTXT_DEFAULT_ACTION list
set -gx TODOTXT_AUTO_ARCHIVE 1
set -gx TODOTXT_CFG_FILE $HOME/Documents/todo/todo.cfg

if type -q todo.sh
    alias t 'todo.sh'

    function now --description '(A) — list, or with args, add as (A)'
        if test (count $argv) -gt 0
            todo.sh add "(A) $argv"
        else
            todo.sh lsp A
        end
    end

    function next --description '(B) — list, or with args, add as (B)'
        if test (count $argv) -gt 0
            todo.sh add "(B) $argv"
        else
            todo.sh lsp B
        end
    end

    function someday --description '(C) — list, or with args, add as (C)'
        if test (count $argv) -gt 0
            todo.sh add "(C) $argv"
        else
            todo.sh lsp C
        end
    end

    function snooze --description 'Snooze item until +N days (default 7) or YYYY-MM-DD'
        if test (count $argv) -lt 1
            echo "usage: snooze ITEM# [days|YYYY-MM-DD]" >&2
            return 1
        end
        set -l item $argv[1]
        set -l when 7
        if test (count $argv) -gt 1
            set when $argv[2]
        end
        set -l date
        if string match -q -r '^\d{4}-\d{2}-\d{2}$' -- $when
            set date $when
        else if date -v+1d +%Y-%m-%d >/dev/null 2>&1
            set date (date -v+"$when"d +%Y-%m-%d)
        else
            set date (date -d "+$when days" +%Y-%m-%d 2>/dev/null)
        end
        if test -z "$date"
            echo "snooze: couldn't compute date for '$when' (need a number of days or YYYY-MM-DD)" >&2
            return 1
        end
        set -l current (sed -n "$item"p $HOME/Documents/todo/todo.txt)
        if test -z "$current"
            echo "snooze: no task at line $item" >&2
            return 1
        end
        set -l stripped (echo $current | sed -E 's/ +t:([0-9]{4}-[0-9]{2}-[0-9]{2})?//g')
        todo.sh replace $item "$stripped t:$date"
    end

    function wake --description 'Remove snooze tag from item'
        if test (count $argv) -lt 1
            echo "usage: wake ITEM#" >&2
            return 1
        end
        set -l item $argv[1]
        set -l current (sed -n "$item"p $HOME/Documents/todo/todo.txt)
        if test -z "$current"
            echo "wake: no task at line $item" >&2
            return 1
        end
        # Match valid t:YYYY-MM-DD AND any orphan t: tags (e.g. from a failed
        # earlier snooze before this fix landed).
        set -l stripped (echo $current | sed -E 's/ +t:([0-9]{4}-[0-9]{2}-[0-9]{2})?//g')
        todo.sh replace $item "$stripped"
    end

    function snoozed --description 'Show snoozed tasks and their wake dates'
        set -l today (date +%Y-%m-%d)
        awk -v today="$today" '
            !/^x / && match($0, /t:[0-9]{4}-[0-9]{2}-[0-9]{2}/) {
                thresh = substr($0, RSTART+2, 10)
                if (thresh > today) {
                    printf "%4d  wake:%s  %s\n", NR, thresh, $0
                }
            }
        ' $HOME/Documents/todo/todo.txt | sort -k2,2
    end

    function all --description 'List every active task (bypasses snooze filter)'
        TODOTXT_FINAL_FILTER=cat todo.sh ls $argv
    end

    function done-today --description "Today's completions"
        set -l today (date +%Y-%m-%d)
        if test -f $HOME/Documents/todo/done.txt
            grep "^x $today" $HOME/Documents/todo/done.txt
        end
    end

    function todo_edit --description 'Open todo.txt in $EDITOR'
        $EDITOR $HOME/Documents/todo/todo.txt
    end
end
