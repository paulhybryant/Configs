# vim: set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker filetype=sh nospell:

[[ -n "${__BASE__+1}" ]] && return

function base::OSX() {
  [[ "$OSTYPE" == "darwin"* ]] && return 0
  return 1
}

function base::LINUX() {
  [[ "$OSTYPE" == "linux-gnu"* ]] && return 0
  return 1
}

function base::CYGWIN() {
  [[ "$OSTYPE" == "cygwin32"* ]] && return 0
  return 1
}

function base::WINDOWS() {
  [[ "$OSTYPE" == "windows"* ]] && return 0
  return 1
}

function _base::config_brew() {
  export PATH=$HOME/.local/bin:$BREWHOME/bin:$BREWHOME/sbin:$PATH
  export MANPATH="$BREWHOME/share/man:$MANPATH"
  export INFOPATH="$BREWHOME/share/info:$INFOPATH"
  export XML_CATALOG_FILES="$BREWHOME/etc/xml/catalog"
  unalias run-help 2>/dev/null
  autoload run-help
  export HELPDIR=$BREWHOME/share/zsh/help
}

function _base::config_darwin() {
  export BREWHOME=$HOME/.homebrew
  alias updatedb="/usr/libexec/locate.updatedb"
  export CMDPREFIX="g"
  alias ls="${CMDPREFIX}ls"
  alias mktemp="${CMDPREFIX}mktemp"
  alias stat="${CMDPREFIX}stat"
}

function _base::config_linux() {
  export BREWHOME=$HOME/.linuxbrew
}

function base::bootstrap() {
  if base::OSX; then
    _base::config_darwin
  elif base::LINUX; then
    _base::config_linux
  fi
  _base::config_brew
}
base::bootstrap

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

function base::defined() {
  eval "if [[ -n \${$1+1} ]]; then return 0; else return 1; fi"
}

__BASE__=${0:a}-$("${CMDPREFIX}stat" -c "%Y" ${0:a})
