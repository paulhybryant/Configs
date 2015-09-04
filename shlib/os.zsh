# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

[[ -n "${__OS__+1}" ]] && return
__OS__=${0:a}

function os::OSX() {
  [[ "$OSTYPE" == "darwin"* ]] && return true
  return false
}

function os::LINUX() {
  [[ "$OSTYPE" == "linux-gnu"* ]] && return true
  return false
}

function os::CYGWIN() {
  [[ "$OSTYPE" == "cygwin32"* ]] && return true
  return false
}

function os::WINDOWS() {
  [[ "$OSTYPE" == "windows"* ]] && return true
  return false
}
