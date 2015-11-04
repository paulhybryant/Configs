function init::start-ssh-agent() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    declare -x -r SSH_AGENT_NAME='gnubby-ssh-agent'
  else
    declare -x -r SSH_AGENT_NAME='ssh-agent'
  fi

  local _agent_pid
  # Start ssh agent if needed
  # Check to see if SSH Agent is already running
  # agent_pid="$(ps -ef | grep "${SSH_AGENT_NAME}" | grep -v "grep" | awk '{print($2)}')"
  _agent_pid=$(pgrep "${SSH_AGENT_NAME}")

  # If the agent is not running (pid is zero length string)
  if [[ -z "${_agent_pid}" ]]; then
      # Start up SSH Agent
      # this seems to be the proper method as opposed to $(exec ssh-agent bash)
      eval "$(${SSH_AGENT_NAME})"
  fi
}
