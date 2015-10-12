# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: os.zsh - Identify OSes

=head1 DESCRIPTION

Identify the current running OS.

=head2 Methods

=over 4
=cut

(( ${+functions[init::sourced]} )) && init::sourced "${0:a}" && return 0

function os::OSX() {
  [[ "$OSTYPE" == "darwin"* ]] && return 0
  return 1
}
function os::LINUX() {
  [[ "$OSTYPE" == "linux-gnu"* ]] && return 0
  return 1
}
function os::CYGWIN() {
  [[ "$OSTYPE" == "cygwin32"* ]] && return 0
  return 1
}
function os::WINDOWS() {
  [[ "$OSTYPE" == "windows"* ]] && return 0
  return 1
}
function os::realpath() {
  if which -s realpath > /dev/null; then
    realpath "$@"
  elif os::OSX; then
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
  fi
}
