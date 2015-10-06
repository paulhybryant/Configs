# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: mode.zsh - Set or get the variables modes for the shell.

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

init::sourced "${0:a}" && return

: <<=cut
=item Function C<mode::verbose>

Whether the specified verbose level is satisfied

$1 Verbose level

@return 0 if satisfied, 1 otherwise
=cut
function mode::verbose() {
  base::exists '__VERBOSE__' || __VERBOSE__='0'
  [[ "$__VERBOSE__" < "$1" ]] && return 1
  return 0
}

: <<=cut
=item Function C<mode::set_verbose>

Set verbose level of shell.

@return NULL
=cut
function mode::set_verbose() {
  __VERBOSE__=$1
  if [[ $1 -gt 0 ]]; then
    export GIT_CURL_VERBOSE=$1
  else
    unset GIT_CURL_VERBOSE
  fi
}

: <<=cut
=item Function C<mode::dryrun>

Whether it is in dryrun mode.

@return 0 if it is dryrun mode, 1 otherwise.
=cut
function mode::dryrun() {
  base::exists '__DRYRUN__' && return 0
  return 1
}

: <<=cut
=item Function C<mode::toggle_dryrun>

Toggle dryrun mode

@return NULL
=cut
function mode::toggle_dryrun() {
  if base::exists '__DRYRUN__'; then
    unset __DRYRUN__
  else
    export __DRYRUN__=
  fi
}

: <<=cut
=back
=cut