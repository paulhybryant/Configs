# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: strings.zsh -

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

init::sourced "${0:a}" && return

function strings::strip_slash() {
  if [[ "$1" =~ .*/$ ]]; then
    echo "${1%/}"
  else
    echo "$1"
  fi
}

: <<=cut
=back
=cut
