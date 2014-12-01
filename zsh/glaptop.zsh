alias desktopvpn="myssh -X yuhuang2012.mtv.corp.google.com"
alias desktop="myssh -X -p 8022 localhost"
alias dls="myssh -X yuhuang.dls.corp.google.com"

# Check to see if SSH Agent is already running
agent_pid="$(ps -ef | grep "gnubby-ssh-agent" | grep -v "grep" | awk '{print($2)}')"

# If the agent is not running (pid is zero length string)
if [[ -z "$agent_pid" ]]; then
    # Start up SSH Agent

    # this seems to be the proper method as opposed to `exec ssh-agent bash`
    eval "$(gnubby-ssh-agent)"
fi
# }}

export PATH=/opt/local/bin:/opt/local/sbin:$PATH
