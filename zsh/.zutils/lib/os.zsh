# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: os.zsh - Identify current OS.

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

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

function os::bootstrap() {
  if os::OSX; then
    export BREWVERSION="homebrew"
    export BREWHOME="$HOME/.$BREWVERSION"
    alias updatedb="/usr/libexec/locate.updatedb"
    export CMDPREFIX="g"
    alias ls='${CMDPREFIX}ls'
    alias mktemp='${CMDPREFIX}mktemp'
    alias stat='${CMDPREFIX}stat'
    alias date='${CMDPREFIX}date'
  elif os::LINUX; then
    export BREWVERSION="linuxbrew"
    export BREWHOME="$HOME/.$BREWVERSION"
  fi
}

: <<=cut
=back
=cut
