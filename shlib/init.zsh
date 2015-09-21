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

function init::runonce() {
  if [[ -n "${__RUNONCE__+1}" ]]; then
    return
  else
    export __RUNONCE__="yes"
  fi
  typeset -Ag __lib_registry__
}
init::runonce

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
  if [[ "$OSTYPE" == "darwin"* && -z "${CMDPREFIX}" ]]; then
    # Fallback to OSX native stat
    _signature="$1-$(stat -f '%m' $1)"
  else
    _signature="$1-$(${CMDPREFIX}stat -c '%Y' $1)"
    # $(${CMDPREFIX}date -r "$1" +%s)
  fi

  if [[ "${_signature}" == "$_cur_signature" ]]; then
    return 0
  else
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
  if [[ -z ${__lib_registry__["$1"]} || \
      ${__lib_registry__["$1"]} != "${_mtime}" ]]; then
    __lib_registry__["$1"]="${_mtime}"
    return 1
  else
    return 0
  fi
}

: <<=cut
=item Function C<time::getmtime>

Get last modification time of a file.
$1 Filename

@return string of the last modified time of a file.
=cut
function time::getmtime() {
  local _mtime
  if [[ "$OSTYPE" == "darwin"* && -z "${CMDPREFIX}" ]]; then
    _mtime="$(stat -f '%m' $1)"
  else
    _mtime="$(${CMDPREFIX}stat -c '%Y' $1)"
  fi
  echo "${_mtime}"
}

: <<=cut
=back
=cut
