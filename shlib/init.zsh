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
    _signature="$1-$(${CMDPREFIX}stat -c "%Y" $1)"
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
=back
=cut
