# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

source ${__MYZSHLIB__}/base.zsh
base::sourced ${0:a} && return

source ${__MYZSHLIB__}/colors.zsh

function io::err() {
  printf "${COLOR_Red}$*\n"
}

function io::warn() {
  printf "${COLOR_Yellow}$*\n"
}

function io::msg() {
  printf "${COLOR_Green}$*\n"
}

function io::yes_or_no() {
  read -q "REPLY?$1?(y/n)"
  echo $REPLY
}
