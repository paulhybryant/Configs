# vim: set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker filetype=sh nospell:

[[ -n "${__BASE__+1}" ]] && return
__BASE__=${0:a}

source ${__MYZSHLIB__}/os.zsh

function _base::config_darwin() {
  export BREWHOME=$HOME/.homebrew
  alias updatedb="/usr/libexec/locate.updatedb"
  export CMDPREFIX="g"
  alias ls="${CMDPREFIX}ls"
  alias mktemp="${CMDPREFIX}mktemp"
  alias stat="${CMDPREFIX}stat"
  alias date="${CMDPREFIX}date"
}

function _base::config_linux() {
  export BREWHOME=$HOME/.linuxbrew
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

function base::bootstrap() {
  if os::OSX; then
    _base::config_darwin
  elif os::LINUX; then
    _base::config_linux
  fi
  _base::config_brew
}
base::bootstrap

function base::script_signature() {
  if os::OSX && [[ -z ${CMDPREFIX} ]]; then
    # Fallback to OSX native stat
    echo "$1-$(stat -f '%m' $1)"
  else
    echo "$1-$(stat -c "%Y" $1)"
    # $(${CMDPREFIX}date -r "$1" +%s)
  fi
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
