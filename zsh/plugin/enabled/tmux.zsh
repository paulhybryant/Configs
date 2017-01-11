# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

zstyle ":registry:var:tmux-vars" registry \
  "SSH_CLIENT" "SSH_OS" "SSH_AUTH_SOCK" "SSH_CONNECTION" \
  "DISPLAY" "SSH_AGENT_PID" "P4DIFF" "G4MULTIDIFF"

autoload -Uz add-zsh-hook
add-zsh-hook -Uz precmd tmux::copy-vars
add-zsh-hook -Uz zshexit tmux::try-switch
trap 'tmux::try-switch' EXIT
