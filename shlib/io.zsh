# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: io.zsh -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

init::sourced "${0:a}" && return

source "${0:h}/colors.zsh"
source "${0:h}/mode.zsh"

function io::err() {
  printf "${COLOR_Red}$*\n${COLOR_Color_Off}"
}
function io::warn() {
  printf "${COLOR_Yellow}$*\n${COLOR_Color_Off}"
}
function io::msg() {
  printf "${COLOR_Green}$*\n${COLOR_Color_Off}"
}
function io::yes_or_no() {
  read -q "REPLY?$1?(y/n)"
  echo "$REPLY"
}
# Verbose log
# Output log based on current verbose level
# $1 verbose level
# $2 message
function io::vlog() {
  mode::verbose "$1" && io::msg "$2"
  return 0
}

: <<=cut
=back
=cut
