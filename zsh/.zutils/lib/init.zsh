# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: init.zsh - Library source guard implementation.

=head1 DESCRIPTION

The library file will be sourced, if it has not been sourced before or modified
since last time it was sourced. A guard variable will be defined, with the value
of the concatenation of the file path and modification time (kind of as a
signature) when this file is sourced to avoid sourcing it repetitively.

Put the following boilerplate at the start of all library files.

    source init.zsh
    init::sourced "${0:a}" && return

=head2 Methods

=over 4
=cut

(( ${+functions[init::sourced]} )) && init::sourced "${0:a}" && return 0

: <<=cut
=item Function C<time::getmtime>

Get last modification time of a file.
$1 Filename

@return string of the last modified time of a file.
=cut
function time::getmtime() {
  local _mtime
  if [[ "$OSTYPE" == "darwin"* ]]; then
    _mtime="$(\stat -f '%m' $1)"
  else
    _mtime="$(\stat -c '%Y' $1)"
    # $(${CMDPREFIX}date -r "$1" +%s)
  fi
  echo "${_mtime}"
}

: <<=cut
=item Function C<init::sourced>

$1 Absolute path to the file to be sourced.

@return 0 or 1, indicates whether latest version of this file is sourced.
=cut
function init::sourced() {
  # strip the .zsh extension
  local _var="__SOURCED_${${1:t:u}%.ZSH}__"
  local _cur_signature="${(P)_var}"
  local _signature

  (( ${+functions[io::vlog]} )) && io::vlog 1 "Trying to source ${1:t}"
  _signature="$1-$(time::getmtime $1)"
  if [[ "${_signature}" == "$_cur_signature" ]]; then
    (( ${+functions[io::vlog]} )) && io::vlog 1 "${1:t} already sourced, timestamp: ${_cur_signature}"
    return 0
  else
    (( ${+functions[io::vlog]} )) && io::vlog 1 "sourcing ${1:t}, timestamp: ${_signature}"
    eval "${_var}=\"${_signature}\""
    return 1
  fi
}

: <<=cut
=item Function C<init::registered>

Check if a file is registered (sourced), if not register it.
$1 Absolute path to the file to check.

@return 0 or 1, indicates whether latest version of this file is registered.
=cut
function init::registered() {
  local _mtime
  _mtime="$(time::getmtime $1)"
  if [[ -z ${__LIB_REGISTRY__["$1"]} || \
      ${__LIB_REGISTRY__["$1"]} != "${_mtime}" ]]; then
    __LIB_REGISTRY__["$1"]="${_mtime}"
    return 1
  else
    return 0
  fi
}

source "${0:h}/os.zsh"

function init::runonce() {
  if [[ -n "${__ONCEINIT__+1}" ]]; then
    return 0
  else
    __ONCEINIT__=
  fi
  if os::OSX; then
    export BREWVERSION="homebrew"
    export BREWHOME="$HOME/.$BREWVERSION"
    alias updatedb="/usr/libexec/locate.updatedb"
    export CMDPREFIX="g"
    alias ls='${CMDPREFIX}ls'
    alias mktemp='${CMDPREFIX}mktemp'
    alias stat='${CMDPREFIX}stat'
    alias date='${CMDPREFIX}date'
  elif os::LINUX; then
    export BREWVERSION="linuxbrew"
    export BREWHOME="$HOME/.$BREWVERSION"
  fi
  alias ls="${aliases[ls]:-ls} --color=tty"
  typeset -Ag __LIB_REGISTRY__
  os::OSX && export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
  export PATH="$HOME/.zutils/bin:$HOME/.local/bin:$BREWHOME/bin:$BREWHOME/sbin:$BREWHOME/opt/go/libexec/bin:$PATH"
  export MANPATH="$BREWHOME/share/man:$HOME/.zutils/man:$MANPATH"
  export INFOPATH="$BREWHOME/share/info:$INFOPATH"
  fpath+=($BREWHOME/share/zsh-completions $BREWHOME/share/zsh/site-functions)
}

: <<=cut
=back
=cut
