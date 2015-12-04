#!/usr/bin/env zsh

local _dir=${0:h}/../../lib/
fpath+=(${_dir})
autoload -Uz zsh::autoload time::getmtime io::err
declare -Axg FN_REGISTRY
zsh::autoload -d ${_dir} ${_dir}/[^_]*(:t)

set -x

function test::zsh::autoload() {
  local _expected
  _expected=$(time::getmtime ${_dir}/zsh::autoload)
  _actual="$FN_REGISTRY[zsh::autoload]"
  [[ "${_expected}" == "${_actual}" ]]

  touch ${_dir}/zsh::autoload
  zsh::autoload -r -d ${_dir} zsh::autoload
  _expected=$(time::getmtime ${_dir}/zsh::autoload)
  _actual="$FN_REGISTRY[zsh::autoload]"
  [[ "${_expected}" == "${_actual}" ]]

  touch ${_dir}/zsh::autoload
  zsh::autoload -r -d ${_dir}
  _expected=$(time::getmtime ${_dir}/zsh::autoload)
  [[ "${_expected}" == "$FN_REGISTRY[zsh::autoload]" ]]
}
test::zsh::autoload
