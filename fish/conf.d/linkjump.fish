if status is-interactive
    function j -d "jump to repo or link"
        if test (count $argv) = 1
            if test -L ~/links/$argv
                set REALDIR $(pushd ~/links/$argv >/dev/null && /usr/bin/env pwd -P && popd > /dev/null;)
                if test $status -eq 0
                    pushd "$REALDIR"
                end
            else
                set REALDIR $(pushd ~/src/*/*/$argv > /dev/null && /usr/bin/env pwd -P && popd > /dev/null;)
                if test $status -eq 0
                    pushd "$REALDIR"
                end
            end
        end
    end
end