#!/usr/bin/env zsh

fpath+=(${0:h}/../../functions/)
autoload -Uz -- ${0:h}/../../functions/[^_]*(:t)

set -x

function test::strings::join() {
  local _actual _expected
  _expected=".ip,.hostname"
  _actual=$(strings::join --prefix . --delim , ip hostname)
  [[ "${_expected}" == "${_actual}" ]]
}
test::strings::join
