# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

[[ -n "${__BASE__+1}" ]] && return
# In zsh we can get the script name with ${0:a}, it would contain the function
# name if this is used within a function.
# Source: zshexpn(1) man page, section HISTORY EXPANSION, subsection Modifiers
# (or simply info -f zsh -n Modifiers)
# More portable way to get this:
# canonical=$(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)/$(basename -- "$0")")
__BASE__="${0:a}"
[[ -n "${__VERBOSE__+1}" ]] && echo "${__BASE__} sourced"

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

function base::_config_darwin() {
  export BREWVERSION="homebrew"
  export BREWHOME="$HOME/.$BREWVERSION"
  alias updatedb="/usr/libexec/locate.updatedb"
  export CMDPREFIX="g"
  alias ls="${CMDPREFIX}ls"
  alias mktemp="${CMDPREFIX}mktemp"
  alias stat="${CMDPREFIX}stat"
  alias date="${CMDPREFIX}date"
}

function base::_config_linux() {
  export BREWVERSION="linuxbrew"
  export BREWHOME="$HOME/.$BREWVERSION"
}

function base::_config_brew() {
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
    base::_config_darwin
  elif os::LINUX; then
    base::_config_linux
  fi
  base::_config_brew
}

# Force reloading base.zsh. Other libraries can be reloaded directly by source
function base::reload() {
  local _base=${__BASE__}
  unset __BASE__
  source ${_base}
}

# Check whether something 'exists'
# The check order is the following:
# 1. Binary
# 2. Variable
# 3. File or Directory
function base::exists() {
  whence "$1" > /dev/null && return 0
  eval "[[ -n \${$1+1} ]]" && return 0
  [[ -e "$1" || -d "$1" ]] && return 0
  return 1
}

# Library include guard
# $1 library script path
function base::sourced() {
  # strip the .zsh extension
  local _var=$(basename ${1%.zsh})
  local _cur_signature=$(eval "echo \$__${_var}__")

  if os::OSX && [[ -z ${CMDPREFIX} ]]; then
    # Fallback to OSX native stat
    local _signature="$1-$(stat -f '%m' $1)"
  else
    local _signature="$1-$(stat -c "%Y" $1)"
    # $(${CMDPREFIX}date -r "$1" +%s)
  fi

  [[ "${_signature}" == "$_cur_signature" ]] && return 0
  eval "__${_var}__=\"${_signature}\""
  [[ -n "${__VERBOSE__+1}" ]] && echo "$1 sourced"
  return 1
}
