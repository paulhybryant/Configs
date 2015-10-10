# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: shell.zsh - Utilities for shell

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

(( ${+functions[init::sourced]} )) && init::sourced "${0:a}" && return 0

source "${0:h}/io.zsh"
source "${0:h}/mode.zsh"

: <<=cut
=item Function C<shell::eval>

Eval the strings, and output logs based on verbose level.

@return NULL
=cut
function shell::eval() {
  setopt localoptions err_return nounset
  if mode::dryrun; then
    printf "%-${PREFIXWIDTH}s $*\n" "[Dryrun]"
  else
    eval "$*"
  fi
}
