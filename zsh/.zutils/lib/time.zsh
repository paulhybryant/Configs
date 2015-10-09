# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: time.zsh - Time related utility functions

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

init::sourced "${0:a}" && return

: <<=cut
=item Function C<time::human_readable_date>

Print time in human readable format.

$1 Current time in seconds since epoch

@return string in human readable format for the specified time.
=cut
function time::human_readable_date() {
  local _time_str
  if os::OSX && [[ -z ${CMDPREFIX} ]]; then
    _time_str=$(date -r "$1")
  else
    _time_str=$("${CMDPREFIX}date" --date=@"$1")
  fi
  echo "${_time_str}"
}

: <<=cut
=item Function C<time::_seconds>

Print current time in seconds since epoch.

@return string of current time in seconds since epoch
=cut
function time::_seconds() {
  local _time_str
  _time_str=$("${CMDPREFIX}"date +%s)
  echo "${_time_str}"
}

: <<=cut
=back
=cut
