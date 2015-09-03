# vim: set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker filetype=sh nospell:

[[ -n "${__OS__+1}" ]] && return
__OS__=${0:a}

function os::OSX() {
  [[ "$OSTYPE" == "darwin"* ]] && return 0
  return 1
}

function os::LINUX() {
  [[ "$OSTYPE" == "linux-gnu"* ]] && return 0
  return 1
}

function os::CYGWIN() {
  [[ "$OSTYPE" == "cygwin32"* ]] && return 0
  return 1
}

function os::WINDOWS() {
  [[ "$OSTYPE" == "windows"* ]] && return 0
  return 1
}
