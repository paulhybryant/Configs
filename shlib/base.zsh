# vim: set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker filetype=sh nospell:

[[ -n "${__BASE__+1}" ]] && return

__BASE__='__BASE__'

function base::defined() {
  eval "if [[ -n \${$1+1} ]]; then return 0; else return 1; fi"
}
