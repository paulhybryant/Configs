# vim: set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker filetype=sh nospell:

source ${__MYZSHLIB__}/base.zsh
base::should_source ${0:a} $__NET__ || return
__NET__="$(base::script_signature ${0:a})"

function net::external_ip() {
  local _ip="$(curl -x '' ipecho.net/plain 2> /dev/null)"
  echo ${_ip}
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
