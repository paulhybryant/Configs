# vim: set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker filetype=sh nospell:

source ${__MYZSHLIB__}/base.zsh
source ${__MYZSHLIB__}/colors.zsh

base::should_source ${0:a} $__IO__ || return
__IO__=$(base::script_signature ${0:a})

function io::err() {
  printf "${COLOR_Red}$*\n"
}

function io::warn() {
  printf "${COLOR_Yellow}$*\n"
}

function io::msg() {
  printf "${COLOR_Green}$*\n"
}