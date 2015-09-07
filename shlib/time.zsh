# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

init::sourced ${0:a} && return

source ${0:h}/io.zsh

function time::human_readable_date() {
  if os::OSX && [[ -z ${CMDPREFIX} ]]; then
    io::msg $(date -r $1)
  else
    io::msg $(date --date=@"$1")
  fi
}

function time::seconds() {
  io::msg $(date +%s)
}
