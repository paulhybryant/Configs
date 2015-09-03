# vim: set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker filetype=sh nospell:

source ${__MYZSHLIB__}/base.zsh
base::should_source ${0:a} $__UTIL__ || return
__UTIL__=$(base::script_signature ${0:a})
