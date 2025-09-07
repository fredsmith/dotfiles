
if type -q kiro
  string match -q "$TERM_PROGRAM" "kiro" and . (kiro --locate-shell-integration-path fish)
end