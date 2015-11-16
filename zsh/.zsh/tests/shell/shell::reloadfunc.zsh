#!/usr/bin/env zsh

fpath+=(${0:h}/../../lib/)
autoload -Uz zsh::autoload time::getmtime
declare -Axg FN_REGISTRY
zsh::autoload ${0:h}/../../lib/[^_]*(:t)

set -x

function test::shell::reloadfunc() {
  local _expected
  _expected=$(time::getmtime ${0:h}/../../lib/shell::reloadfunc)
  _actual="$FN_REGISTRY[shell::reloadfunc]"
  [[ "${_expected}" == "${_actual}" ]]

  touch ${0:h}/../../lib/shell::reloadfunc
  shell::reloadfunc shell::reloadfunc
  _expected=$(time::getmtime ${0:h}/../../lib/shell::reloadfunc)
  _actual="$FN_REGISTRY[shell::reloadfunc]"
  [[ "${_expected}" == "${_actual}" ]]

  touch ${0:h}/../../lib/shell::reloadfunc
  shell::reloadfunc
  _expected=$(time::getmtime ${0:h}/../../lib/shell::reloadfunc)
  [[ "${_expected}" == "$FN_REGISTRY[shell::reloadfunc]" ]]
}
test::shell::reloadfunc
