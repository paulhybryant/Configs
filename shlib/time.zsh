# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

init::sourced "${0:a}" && return

function time::human_readable_date() {
  local _time_str
  if os::OSX && [[ -z ${CMDPREFIX} ]]; then
    _time_str=$(date -r "$1")
  else
    _time_str=$(date --date=@"$1")
  fi
  echo "${_time_str}"
}

function time::seconds() {
  local _time_str
  _time_str=$(date +%s)
  echo "${_time_str}"
}
