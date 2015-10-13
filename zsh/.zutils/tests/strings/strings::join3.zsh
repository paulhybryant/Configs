#!/usr/bin/env zsh

source "${0:h}/../../lib/base.zsh"
source "${0:h}/../../lib/mode.zsh"
source "${0:h}/../../lib/strings.zsh"


set -x

function test::strings::join() {
  local _actual _expected _ignore
  _ignore=($(cat ./testdata/ignore.lst | xargs echo))
  _expected="io.zsh\|colors.zsh"
  _actual=$(strings::join --delim='\|' ${_ignore})
  [[ "${_expected}" == "${_actual}" ]]
}
test::strings::join
