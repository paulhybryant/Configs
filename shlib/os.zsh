# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

init::sourced ${0:a} && return

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
