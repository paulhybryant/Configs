#!/usr/bin/env zsh

local _dir=${0:h}/../../lib/
fpath+=(${_dir})
autoload -Uz zsh::autoload time::getmtime io::err
declare -Axg FN_REGISTRY
zsh::autoload -d ${_dir} ${_dir}/[^_]*(:t)

set -x

function test::zsh::reloadfunc() {
  local _expected
  _expected=$(time::getmtime ${_dir}/zsh::reloadfunc)
  _actual="$FN_REGISTRY[zsh::reloadfunc]"
  [[ "${_expected}" == "${_actual}" ]]

  touch ${_dir}/zsh::reloadfunc
  zsh::reloadfunc -d ${_dir} zsh::reloadfunc
  _expected=$(time::getmtime ${_dir}/zsh::reloadfunc)
  _actual="$FN_REGISTRY[zsh::reloadfunc]"
  [[ "${_expected}" == "${_actual}" ]]

  touch ${_dir}/zsh::reloadfunc
  zsh::reloadfunc -d ${_dir}
  _expected=$(time::getmtime ${_dir}/zsh::reloadfunc)
  [[ "${_expected}" == "$FN_REGISTRY[zsh::reloadfunc]" ]]
}
test::zsh::reloadfunc
