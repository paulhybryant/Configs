# vim: set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker filetype=sh nospell:

source ${__MYZSHLIB__}/base.zsh
base::should_source ${0:a} $__TIME__ || return
__TIME__=$(base::script_signature ${0:a})

source ${__MYZSHLIB__}/os.zsh

function time::human_readable_date() {
  if os::OSX && [[ -z ${CMDPREFIX} ]]; then
    echo $(date -r $1)
  else
    echo $(date --date=@"$1")
  fi
}

function time::seconds() {
  echo $(date +%s)
}
