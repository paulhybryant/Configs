# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: base.zsh - Basic utiliti functions.

=head1 SYNOPSIS

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

init::sourced "${0:a}" && return

: <<=cut
=item Function C<base::exists>

Examples
  base::exists "VAR"

Check whether something 'exists'
The check order is the following:
1. Variable or Function
2. Binary
3. File or Directory

$1 The thing to be checked whether it exists.

@return 0 or 1. 0 exists, 1 not exists.
=cut
function base::exists() {
  eval "[[ -n \${$1+1} ]]" && return 0
  whence "$1" > /dev/null && return 0
  [[ -e "$1" || -d "$1" ]] && return 0
  return 1
}

: <<=cut
=back
=cut
