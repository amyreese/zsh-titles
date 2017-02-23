# Copyright 2015 John Reese
# Licensed under the MIT license
#
# Update terminal/tmux window titles based on location/command

function update_title() {
  # escape '%' in $1, make nonprintables visible
  # remove newlines
  if [[ -n "$TMUX" ]]; then
    print -n "\ek${(%)1}\e\\"
  elif [[ "$TERM" =~ "screen*" ]]; then
    print -n "\ek${(%)1}\e\\"
  elif [[ "$TERM" =~ "xterm*" ]]; then
    print -n "\e]0;${(%)1}\a"
  fi
}

# called just before the prompt is printed
function _zsh_title__precmd() {
  #update_title "zsh" "%20<...<%~"
  update_title "%m : %20<...<%~"
}

# called just before a command is executed
function _zsh_title__preexec() {
  local -a cmd; cmd=(${(z)1})             # Re-parse the command line

  # Construct a command that will output the desired job number.
  case $cmd[1] in
    fg)	cmd="${(z)jobtexts[${(Q)cmd[2]:-%+}]}" ;;
    %*)	cmd="${(z)jobtexts[${(Q)cmd[1]:-%+}]}" ;;
  esac
  update_title "$cmd" "%20<...<%~"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _zsh_title__precmd
add-zsh-hook preexec _zsh_title__preexec
