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

source "${0:h}/io.zsh"

function util::geo_country() {
  local _geo="$(curl ipinfo.io 2> /dev/null)"
  local _country="$(echo ${_geo} | jq '.country')"
  echo ${_country}
}
function util::start_ssh_agent() {
  local _agent
  _agent=$1
  # Start ssh agent if needed
  # Check to see if SSH Agent is already running
  # agent_pid="$(ps -ef | grep "${_agent}" | grep -v "grep" | awk '{print($2)}')"
  agent_pid=$(pgrep "${_agent}")

  # If the agent is not running (pid is zero length string)
  if [[ -z "${agent_pid}" ]]; then
      # Start up SSH Agent
      # this seems to be the proper method as opposed to `exec ssh-agent bash`
      eval "$(${_agent})"
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
function util::setup_abbrev() {
  # This can get around the problem where complete_aliases is set and zsh will
  # not expand the alias when doing the completion.
  # source: https://github.com/smly/config/blob/master/.zsh/abbreviations.zsh
  typeset -Ag abbreviations
  abbreviations=()

  function util::magic-abbrev-expand() {
      local left prefix
      left=$(echo -nE "$LBUFFER" | sed -e "s/[_a-zA-Z0-9]*$//")
      prefix=$(echo -nE "$LBUFFER" | sed -e "s/.*[^_a-zA-Z0-9]\([_a-zA-Z0-9]*\)$/\1/")
      LBUFFER=$left${abbreviations[$prefix]:-$prefix}" "
  }
  function util::no-magic-abbrev-expand() {
      LBUFFER+=' '
  }

  zle -N util::magic-abbrev-expand
  zle -N util::no-magic-abbrev-expand
  bindkey " " util::magic-abbrev-expand
  bindkey "^x " util::no-magic-abbrev-expand
}

: <<=cut
=item Function C<util::vim>

Open files with vim in a single vim instance in one tmux window.

@return NULL
=cut
function util::vim() {
  local -a _servers_list
  local _server_name
  if [[ -z "$TMUX" ]]; then
    io::vlog 1 "Not in tmux, invoking vim without server name."
    \vim "$@"
  else
    _servers_list=($(\vim --serverlist))
    io::vlog 1 "Vim servers: ${_servers_list}"
    _server_name=$(tmux display-message -p '#S-#W')
    # Convert to upper case
    _server_name=${_server_name:u}
    io::vlog 1 "Vim server name to use: ${_server_name}"
    local _server_exists
    for server in ${_servers_list}; do
      io::vlog 1 "Found vim server: ${server}"
      if [[ "${_server_name}" == "${server}" ]]; then
        _server_exists='yes'
        break
      fi
    done
    if [[ -z "${_server_exists}" ]]; then
      io::vlog 1 "Starting vim with server name: ${_server_name}"
      \vim --servername "${_server_name}" "$@"
    else
      io::vlog 1 "Connecting to vim server: ${_server_name}"
      \vim --servername ${_server_name} --remote "$@"
    fi
  fi
}

function util::gvim() {
  local -a _servers_list
  _servers_list=($(\vim --serverlist))
  io::vlog 1 "Vim servers: ${_servers_list}"

  local _server_name
  for server in ${_servers_list}; do
    io::vlog 1 "Found vim server: ${server}"
    if [[ "${server}" =~ '^GVIM.*' ]]; then
      _server_name="${server}"
      break
    fi
  done
  if [[ -z "${_server_name}" ]]; then
    _server_name='GVIM-SINGLETON'
    io::vlog 1 "Starting gVim with server name: ${_server_name}"
    \vim -g --servername "${_server_name}" "$@"
  else
    io::vlog 1 "Connecting to gVim server: ${_server_name}"
    \vim -g --servername ${_server_name} --remote "$@"
  fi
}

: <<=cut
=back
=cut
