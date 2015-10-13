# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: colors.zsh - Colorful terminal output.

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

(( ${+functions[base::sourced]} )) && base::sourced "${0:a}" && return 0

source "${0:h}/base.zsh"

[[ -f ~/.dircolors-solarized/dircolors.256dark ]] && \
  eval "$(${CMDPREFIX}dircolors $HOME/.dircolors-solarized/dircolors.256dark)"

: <<=cut
=item Function C<colors::define>

Define color env variables.

@return NULL
=cut
function colors::define() {
  # Reset
  export COLOR_Color_Off='\033[0m'       # Text Reset

  # Regular Colors
  export COLOR_Black='\033[0;30m'        # Black
  export COLOR_Red='\033[0;31m'          # Red
  export COLOR_Green='\033[0;32m'        # Green
  export COLOR_Yellow='\033[0;33m'       # Yellow
  export COLOR_Blue='\033[0;34m'         # Blue
  export COLOR_Purple='\033[0;35m'       # Purple
  export COLOR_Cyan='\033[0;36m'         # Cyan
  export COLOR_White='\033[0;37m'        # White

  # Bold
  export COLOR_BBlack='\033[1;30m'       # Black
  export COLOR_BRed='\033[1;31m'         # Red
  export COLOR_BGreen='\033[1;32m'       # Green
  export COLOR_BYellow='\033[1;33m'      # Yellow
  export COLOR_BBlue='\033[1;34m'        # Blue
  export COLOR_BPurple='\033[1;35m'      # Purple
  export COLOR_BCyan='\033[1;36m'        # Cyan
  export COLOR_BWhite='\033[1;37m'       # White

  # Underline
  export COLOR_UBlack='\033[4;30m'       # Black
  export COLOR_URed='\033[4;31m'         # Red
  export COLOR_UGreen='\033[4;32m'       # Green
  export COLOR_UYellow='\033[4;33m'      # Yellow
  export COLOR_UBlue='\033[4;34m'        # Blue
  export COLOR_UPurple='\033[4;35m'      # Purple
  export COLOR_UCyan='\033[4;36m'        # Cyan
  export COLOR_UWhite='\033[4;37m'       # White

  # Background
  export COLOR_On_Black='\033[40m'       # Black
  export COLOR_On_Red='\033[41m'         # Red
  export COLOR_On_Green='\033[42m'       # Green
  export COLOR_On_Yellow='\033[43m'      # Yellow
  export COLOR_On_Blue='\033[44m'        # Blue
  export COLOR_On_Purple='\033[45m'      # Purple
  export COLOR_On_Cyan='\033[46m'        # Cyan
  export COLOR_On_White='\033[47m'       # White

  # High Intensity
  export COLOR_IBlack='\033[0;90m'       # Black
  export COLOR_IRed='\033[0;91m'         # Red
  export COLOR_IGreen='\033[0;92m'       # Green
  export COLOR_IYellow='\033[0;93m'      # Yellow
  export COLOR_IBlue='\033[0;94m'        # Blue
  export COLOR_IPurple='\033[0;95m'      # Purple
  export COLOR_ICyan='\033[0;96m'        # Cyan
  export COLOR_IWhite='\033[0;97m'       # White

  # Bold High Intensity
  export COLOR_BIBlack='\033[1;90m'      # Black
  export COLOR_BIRed='\033[1;91m'        # Red
  export COLOR_BIGreen='\033[1;92m'      # Green
  export COLOR_BIYellow='\033[1;93m'     # Yellow
  export COLOR_BIBlue='\033[1;94m'       # Blue
  export COLOR_BIPurple='\033[1;95m'     # Purple
  export COLOR_BICyan='\033[1;96m'       # Cyan
  export COLOR_BIWhite='\033[1;97m'      # White

  # High Intensity backgrounds
  export COLOR_On_IBlack='\033[0;100m'   # Black
  export COLOR_On_IRed='\033[0;101m'     # Red
  export COLOR_On_IGreen='\033[0;102m'   # Green
  export COLOR_On_IYellow='\033[0;103m'  # Yellow
  export COLOR_On_IBlue='\033[0;104m'    # Blue
  export COLOR_On_IPurple='\033[0;105m'  # Purple
  export COLOR_On_ICyan='\033[0;106m'    # Cyan
  export COLOR_On_IWhite='\033[0;107m'   # White
}

: <<=cut
=item Function C<colors::manpage>

Make man page colorful.

@return NULL
=cut
function colors::manpage() {
  # The following won't have effect unless less is used (instead of vimpager)
  # http://superuser.com/questions/452034/bash-colorized-man-page
  #
  #   L E S S   C O L O R S   F O R   M A N   P A G E S
  #

  # CHANGE FIRST NUMBER PAIR FOR COMMAND AND FLAG COLOR
  # currently 0;33 a.k.a. brown, which is dark yellow for me
  export LESS_TERMCAP_md=$'\E[0;33;5;74m'                                       # begin bold

  # CHANGE FIRST NUMBER PAIR FOR PARAMETER COLOR
  # currently 0;36 a.k.a. cyan
  export LESS_TERMCAP_us=$'\E[0;36;5;146m'                                      # begin underline

  # don't change anything here
  export LESS_TERMCAP_mb=$'\E[1;31m'                                            # begin blinking
  export LESS_TERMCAP_me=$'\E[0m'                                               # end mode
  export LESS_TERMCAP_se=$'\E[0m'                                               # end standout-mode
  export LESS_TERMCAP_so=$'\E[38;5;246m'                                        # begin standout-mode - info box
  export LESS_TERMCAP_ue=$'\E[0m'                                               # end underline

  #########################################
  # Colorcodes:
  # Black       0;30     Dark Gray     1;30
  # Red         0;31     Light Red     1;31
  # Green       0;32     Light Green   1;32
  # Brown       0;33     Yellow        1;33
  # Blue        0;34     Light Blue    1;34
  # Purple      0;35     Light Purple  1;35
  # Cyan        0;36     Light Cyan    1;36
  # Light Gray  0;37     White         1;37
  #########################################
}

colors::define
colors::manpage

: <<=cut
=back
=cut
