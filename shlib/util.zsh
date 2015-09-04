# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

source ${__MYZSHLIB__}/base.zsh
base::should_source ${0:a} $__UTIL__ || return
__UTIL__="$(base::script_signature ${0:a})"

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
