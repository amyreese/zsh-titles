# Copyright 2015 John Reese
# Licensed under the MIT license
#
# Update terminal/tmux window titles based on location/command

function update_title() {
  if [ -n "$TMUX" ]; then
    # escape '%' in $1, make nonprintables visible
    a=${(V)1//\%/\%\%}
    a=$(print -Pn "%20>...>$a" | tr -d "\n")
    print -Pn "\ek$a:$2\e\\"
  fi
}

# called just before the prompt is printed
function precmd() {
  update_title "zsh" "%20<...<%~"
}

# called just before a command is executed
function preexec() {
  update_title "$1" "%20<...<%~"
}
