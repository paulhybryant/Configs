# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: net.zsh - Utility functions related to network access.

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

init::sourced "${0:a}" && return

: <<=cut
=item Function C<net::external_ip>

Get the external ip address for current host.

@return string of external ip address.
=cut
function net::external_ip() {
  local _ip
  _ip="$(curl -x '' ipecho.net/plain 2> /dev/null)"
  echo "${_ip}"
}

: <<=cut
=item Function C<net::ssh>

Utility function that set some env variables by default when connected through ssh.
Arguments will be passed through to ssh

@return NULL
=cut
function net::ssh() {
  ssh -Y "$@" -t "export SSH_OS=\"`uname`\"; zsh"
}

: <<=cut
=item Function C<net::is_port_open>

Test whether a port / range of ports is / are open.

$1 Host address
$2 Port number

Example:
  net::is_port_open 127.0.0.1 80
  net::is_port_open 127.0.0.1 80 90
  net::is_port_open 127.0.0.1 80-90

@return 0 if the port is open on specified host, 1 otherwise.
=cut
function net::is_port_open() {
  nc -zv "$1" 2> /dev/null && return 0
  return 1
}

: <<=cut
=back
=cut
