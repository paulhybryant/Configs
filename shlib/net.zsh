# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

init::sourced "${0:a}" && return

function net::external_ip() {
  local _ip
  _ip="$(curl -x '' ipecho.net/plain 2> /dev/null)"
  echo "${_ip}"
}
function net::ssh() {
  # local _ssh_info_=$(mktemp)
  # case "$(uname -s)" in
    # Linux)
      # ;;
    # Darwin)
      # ;;
    # *)
      # echo 'Unsupported OS'
      # exit
      # ;;
  # esac

  # cat ~/.ssh/config ~/.ssh/config.* > "$_ssh_info_" 2>/dev/null
  # ssh -F "$_ssh_info_" -Y "$@" -t "export SSH_OS=\"`uname`\"; zsh"
  ssh -Y "$@" -t "export SSH_OS=\"`uname`\"; zsh"
}
# Usage:
#   is_port_open 127.0.0.1 80
#   is_port_open 127.0.0.1 80 90
#   is_port_open 127.0.0.1 80-90
function net::is_port_open() {
  nc -zv "$1" 2> /dev/null && return 0
  return 1
}
