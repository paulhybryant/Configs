#!/usr/bin/env zsh

fpath+=(${0:h}/../../functions/)
autoload -Uz -- ${0:h}/../../functions/[^_]*(:t)

set -x

function test::strings::join() {
  local _actual _expected
  _expected="io.zsh\|os.zsh"
  _actual=$(strings::join --delim '\|' io.zsh os.zsh)
  [[ "${_expected}" == "${_actual}" ]]
}
test::strings::join
