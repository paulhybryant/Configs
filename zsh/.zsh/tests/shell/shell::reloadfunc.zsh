#!/usr/bin/env zsh

local _dir=${0:h}/../../lib/
fpath+=(${_dir})
autoload -Uz zsh::autoload time::getmtime io::err
declare -Axg FN_REGISTRY
zsh::autoload -d ${_dir} ${_dir}/[^_]*(:t)

set -x

function test::shell::reloadfunc() {
  local _expected
  _expected=$(time::getmtime ${_dir}/shell::reloadfunc)
  _actual="$FN_REGISTRY[shell::reloadfunc]"
  [[ "${_expected}" == "${_actual}" ]]

  touch ${_dir}/shell::reloadfunc
  shell::reloadfunc ${_dir} shell::reloadfunc
  _expected=$(time::getmtime ${_dir}/shell::reloadfunc)
  _actual="$FN_REGISTRY[shell::reloadfunc]"
  [[ "${_expected}" == "${_actual}" ]]

  touch ${_dir}/shell::reloadfunc
  shell::reloadfunc ${_dir}
  _expected=$(time::getmtime ${_dir}/shell::reloadfunc)
  [[ "${_expected}" == "$FN_REGISTRY[shell::reloadfunc]" ]]
}
test::shell::reloadfunc
