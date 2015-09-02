# vim: set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker filetype=sh nospell:

[[ -n "${__BASE__+1}" && "${__BASE__}" == "${0:a}-$(stat -c "%Y" ${0:a})" ]] && return

function base::defined() {
  eval "if [[ -n \${$1+1} ]]; then return 0; else return 1; fi"
}

function base::script_signature() {
  echo "$1-$(stat -c "%Y" $1)"
}

# $1: Filename
# $2: Signature
function base::should_source() {
  local _signature=$(base::script_signature $1)
  [[ "$_signature" == "$2" ]] && return 1
  return 0
}

__BASE__=$(base::script_signature ${0:a})
