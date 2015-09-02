# vim: set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker filetype=sh nospell:

source ${__MYZSHLIB__}/base.zsh
source ${__MYZSHLIB__}/colors.zsh

base::defined __IO__ && return
__IO__='__IO__'

function err() {
  printf "${COLOR_Red}$*\n"
}

function warn() {
  printf "${COLOR_Yellow}$*\n"
}

function msg() {
  printf "${COLOR_Green}$*\n"
}
