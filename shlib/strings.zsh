# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

source ${__MYZSHLIB__}/base.zsh
base::should_source ${0:a} $__STRINGS__ || return
__STRINGS__="$(base::script_signature ${0:a})"

function strings::strip_slash() {
  [[ $1 =~ .*/$ ]] && echo ${1%/}
}
