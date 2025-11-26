# ASDF configuration code
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

set -gx PATH (string match -v $_asdf_shims $PATH)
set -gx --prepend PATH $_asdf_shims
set --erase _asdf_shims
