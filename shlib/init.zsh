# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

# Library include guard
# $1 library script path
function init::sourced() {
  # strip the .zsh extension
  local _var="__SOURCED_${${1:t:u}%.ZSH}__"
  local _cur_signature="${(P)_var}"

  local _signature
  if [[ "$OSTYPE" == "darwin"* && -z "${CMDPREFIX}" ]]; then
    # Fallback to OSX native stat
    _signature="$1-$(stat -f '%m' $1)"
  else
    _signature="$1-$(stat -c "%Y" $1)"
    # $(${CMDPREFIX}date -r "$1" +%s)
  fi

  if [[ "${_signature}" == "$_cur_signature" ]]; then
    return 0
  else
    eval "${_var}=\"${_signature}\""
    return 1
  fi
}
