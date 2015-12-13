#!/usr/bin/env zsh

fpath+=(${0:h}/../../lib/)
autoload -Uz -- ${0:h}/../../lib/[^_]*(:t)

set -x

function test::strings::join() {
  local _actual _expected _ignore
  _ignore=($(cat ./testdata/ignore.lst | xargs printf "%s\n"))
  _expected="io.zsh\|colors.zsh"
  _actual=$(strings::join --delim '\|' ${_ignore})
  [[ "${_expected}" == "${_actual}" ]]
}
test::strings::join
