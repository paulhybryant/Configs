# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

init::sourced ${0:a} && return

source ${0:h}/base.zsh

function mode::verbose() {
  base::exists '__VERBOSE__' || __VERBOSE__='0'
  [[ "$__VERBOSE__" < "$1" ]] && return 1
  return 0
}
function mode::set_verbose() {
  __VERBOSE__=$1
}
