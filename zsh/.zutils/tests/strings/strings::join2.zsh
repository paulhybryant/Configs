#!/usr/bin/env zsh

source "${0:h}/../../lib/init.zsh"
source "${0:h}/../../lib/mode.zsh"
source "${0:h}/../../lib/strings.zsh"


set -x

function test::strings::join() {
  local _actual _expected
  _expected="io.zsh\|os.zsh"
  _actual=$(strings::join --delim='\|' io.zsh os.zsh)
  [[ "${_expected}" == "${_actual}" ]]
}
test::strings::join
