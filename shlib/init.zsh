# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod
=head1 NAME

init.zsh - Library source guard.

=head1 SYNOPSIS

    Put the following at the start of all library files.

    source init.zsh
    init::sourced "${0:a}" && return

=head1 DESCRIPTION

Library source guard.

=head2 Methods

=over 12

=item C<init::sourced>

Returns a status indicating whether the library file is already sourced and have
not changed since then.

=back

=head1 LICENSE

=head1 AUTHOR

Yu Huang

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
    _signature="$1-$(stat -c "%Y" $1)"
    # $(${CMDPREFIX}date -r "$1" +%s)
  fi

  if [[ "${_signature}" == "$_cur_signature" ]]; then
    return 0
  else
    eval "${_var}=\"${_signature}\""
    return 1
  fi
}
