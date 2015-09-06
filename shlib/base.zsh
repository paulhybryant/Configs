# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

init::sourced ${0:a} && return

source ${0:h}/os.zsh

# In zsh we can get the script name with ${0:a}, it would contain the function
# name if this is used within a function.
# Source: zshexpn(1) man page, section HISTORY EXPANSION, subsection Modifiers
# (or simply info -f zsh -n Modifiers)
# More portable way to get this:
# canonical=$(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)/$(basename -- "$0")")

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
# 1. Variable
# 2. Binary
# 3. File or Directory
function base::exists() {
  eval "[[ -n \${$1+1} ]]" && return 0
  whence "$1" > /dev/null && return 0
  [[ -e "$1" || -d "$1" ]] && return 0
  return 1
}

function base::_verbose() {
  base::exists '__VERBOSE__' && return 0
  return 1
}

function base::verbose_toggle() {
  if base::_verbose; then
    __VERBOSE__='true'
  else
    unset __VERBOSE__
  fi
}
