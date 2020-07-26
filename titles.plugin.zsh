# Copyright 2015 John Reese
# Licensed under the MIT license
#
# Update terminal/tmux window titles based on location/command

function update_title() {
  local a
  # escape '%' in $1, make nonprintables visible
  a=${(V)1//\%/\%\%}
  print -nz "%20>...>$a"
  read -rz a
  # remove newlines
  a=${a//$'\n'/}
  if [[ -n "$TMUX" ]] && [[ $TERM == screen* || $TERM == tmux* ]]; then
    print -n "\ek${(%)a}:${(%)2}\e\\"
  elif [[ "$TERM" =~ "screen*" ]]; then
    print -n "\ek${(%)a}:${(%)2}\e\\"
  elif [[ "$TERM" =~ "xterm*" || "$TERM" = "alacritty" || "$TERM" =~ "st*" ]]; then
    print -n "\e]0;${(%)a}:${(%)2}\a"
  elif [[ "$TERM" =~ "^rxvt-unicode.*" ]]; then
    printf '\33]2;%s:%s\007' ${(%)a} ${(%)2}
  fi
}

# called just before the prompt is printed
function _zsh_title__precmd() {
  update_title "zsh" "%20<...<%~"
}

# called just before a command is executed
function _zsh_title__preexec() {
  local -a cmd
  
  # Escape '\'
  1=${1//\\/\\\\\\\\}

  cmd=(${(z)1})             # Re-parse the command line

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
