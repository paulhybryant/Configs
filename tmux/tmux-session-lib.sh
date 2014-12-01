#!/usr/bin/env bash
# vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={{,}} foldlevel=0 foldmethod=marker nospell:

dump_pane() {
  local d=$'\t'
  declare -A pane_cmds
  declare -A pane_pids
  while IFS=$d read pane_path pane_command pane_pid;
  do
    pane_cmds[$pane_path]=$pane_command
    pane_pids[$pane_path]=$pane_pid
  done < <(tmux list-panes -t "$1" -F "#{pane_current_path}${d}#{pane_current_command}${d}#{pane_pid}")

  for i in "${!pane_cmds[@]}"; do
    # Some pane starts a shell script which starts another binary.
    # pane_command will be "bash" in such cases.
    if [ "${pane_cmds[$i]}" == "bash" ]; then
      echo ${pane_pids[$i]}
      # cmd=`ps --ppid ${pane_pids[$i]} -o cmd=`
      if [ "$cmd" == "" ]; then
        echo "        - cd $i"
      else
        echo "        - cd $i; $cmd"
      fi
    else
      echo "        - cd $i; ${pane_cmds[$i]}"
    fi
  done
}

dump_session() {
  local d=$'\t'
  yml=$(mktemp)
  cat <<EOF > $yml
#~/.tmuxinator/$1.yml

name: $1
root: ~/

tmux_options: -f ~/.tmux.conf

windows:
EOF
  while IFS=$d read window_name layout;
  do
    echo "  - ${window_name}:" >> $yml
    echo "      layout: ${layout}" >> $yml
    echo "      panes:" >> $yml
    dump_pane "$1:${window_name}" "$yml"
  done < <(tmux list-windows -t "$1" -F "#W${d}#{window_layout}")

  if [ -e "$HOME/.tmuxinator/$1.yml" ];
  then
    if [ "$2" = "1" ];
    then
      echo "Overwriting $1.yml"; mv $yml $HOME/.tmuxinator/$1.yml
    else
      read -p "$HOME/.tmuxinator/$1.yml exists, overwrite (y/n)? [n] "
      case $REPLY in
        [y]* )
          echo "Overwriting $1.yml"
          mv $yml $HOME/.tmuxinator/$1.yml
          ;;
        [n]* )
          echo "Not overwriting."
          ;;
      esac
    fi
  else
    mv $yml $HOME/.tmuxinator/$1.yml
  fi
}

save() {
  mkdir -p $HOME/.tmuxinator
  for session in $(tmux list-sessions -F "#S");
  do
    dump_session $session $*
  done
}

terminal_size() {
  stty size 2>/dev/null | awk '{ printf "-x%d -y%d", $2, $1 }'
}
