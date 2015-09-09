# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: util.zsh -

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

init::sourced "${0:a}" && return

function util::geo_country() {
  local _geo="$(curl ipinfo.io 2> /dev/null)"
  local _country="$(echo ${_geo} | jq '.country')"
  echo ${_country}
}
function util::start_ssh_agent() {
  # Start ssh agent if needed
  # Check to see if SSH Agent is already running
  agent_pid="$(ps -ef | grep "ssh-agent" | grep -v "grep" | awk '{print($2)}')"

  # If the agent is not running (pid is zero length string)
  if [[ -z "$agent_pid" ]]; then
      # Start up SSH Agent
      # this seems to be the proper method as opposed to `exec ssh-agent bash`
      eval "$(ssh-agent)"
  fi
}
function util::installed_gnome_shell_exts() {
  grep "name\":" ~/.local/share/gnome-shell/extensions/*/metadata.json /usr/share/gnome-shell/extensions/*/metadata.json | awk -F '"name": "|",' '{print $2}'
}
function util::ta() {
  local setenv=$(mktemp)
  : > "$setenv"
  for var in SSH_OS SSH_CLIENT DISPLAY;
  do
    local value=
    eval value=\$$var
    # local _var_
    # eval "_val_=\"\${$var}\""
    # echo $_val_
    \tmux set-environment -t "$1" $var "$value"
    echo "export $var=\"$value\"" >> "$setenv"
  done
  for window in $(\tmux list-windows -t "$1" -F "#W");
  do
    for pane_id_command in $(\tmux list-panes -t "$1:$window" -F "#P:#{pane_current_command}");
    do
      local id=${pane_id_command%%:*}
      local cmd=${pane_id_command##*:}
      \tmux send-keys -t "$1:$window.$id" C-z
      sleep 0.1
      \tmux send-keys -t "$1:$window.$id" ENTER
      sleep 0.1
      if [[ $cmd != "bash" && $cmd != "zsh" && $cmd != "blaze64" ]]; then
        # run "\\tmux send-keys -t \"$1:$window\" C-z"
        # run "\tmux send-keys -t \"$1:$window.$id\" source \\ $setenv ENTER"
        \tmux send-keys -t "$1:$window.$id" source \ $setenv ENTER
        sleep 0.1
        # run "\\tmux send-keys -t \"$1:$window.$id\" fg ENTER"
        \tmux send-keys -t "$1:$window.$id" fg ENTER
      else
        \tmux send-keys -t "$1:$window.$id" source \ $setenv ENTER
        # run "\\tmux send-keys -t \"$1:$window.$id\" source \\ $setenv ENTER"
      fi
    done
  done
  \tmux attach -d -t "$1"
}
function util::tmux_start() {
  if [[ ! -z "$TMUX" ]]; then
    io::warn "Already in tmux, nothing to be done."
    return
  fi
  \tmux info &> /dev/null
  if [[ $? -eq 1 ]]; then
    io::warn "Starting tmux server..."
    touch "$HOME/.tmux_restore"
    \tmux start-server
    \rm "$HOME/.tmux_restore"
  fi
  if [[ "$#" == 0 ]]; then
    \tmux attach
  else
    \tmux "$@"
  fi
}
function util::histgrep() {
  tac ${HISTFILE:-~/.bash_history} | grep -m 1 "$@"
}
function util::run() {
  local _cmd_="$1"
  local _msg_="$2"
  [[ $VERBOSE == true ]] && echo "$_msg_"
  if [[ $DRYRUN == true ]]; then
    echo "$_cmd_"
  else
    if [[ $LOGCMD == true && -n "$LOGCMDFILE" ]]; then
      local _ts_=$(date "+%Y-%m-%d %T:")
      echo "$_ts_ $_cmd_" >> $LOGCMDFILE
    fi
    set -o noglob
    eval $_cmd_
    set +o noglob
  fi
}

: <<=cut
=back
=cut
