# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: io.zsh - IO related utility functions.

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

(( ${+functions[base::sourced]} )) && base::sourced "${0:a}" && return 0

function io::hl() {
  printf "${COLOR_Red}$*\n${COLOR_Color_Off}"
}
function io::err() {
  printf "%-${PREFIXWIDTH}s ${COLOR_Red}$*\n${COLOR_Color_Off}" "[Error]"
  return 1
}
function io::warn() {
  printf "%-${PREFIXWIDTH}s ${COLOR_Yellow}$*\n${COLOR_Color_Off}" "[Warning]"
}
function io::msg() {
  printf "%-${PREFIXWIDTH}s ${COLOR_Green}$*\n${COLOR_Color_Off}" "[Info]"
}

: <<=cut
=item Function C<io::yes_or_no>

Gets yes or no reply from user.

@return 0 if yes, 1 otherwise.
=cut
function io::yes_or_no() {
  read -q "REPLY?$1?(y/n) [n]"
  io::vlog 2 "[${0:t}] ${REPLY}"
  echo -n "\n"
  [[ "$REPLY" =~ y\|Y ]] && return 0
  return 1
}

: <<=cut
=item Function C<io::vlog>

Print log message based on verbose level.

$1 Verbose level
$2 Message

@return NULL
=cut
function io::vlog() {
  mode::verbose "$1" && io::msg "$2"
}

: <<=cut
=back
=cut
