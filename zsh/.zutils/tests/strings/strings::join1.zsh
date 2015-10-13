#!/usr/bin/env zsh

source "${0:h}/../../lib/base.zsh"
source "${0:h}/../../lib/mode.zsh"
source "${0:h}/../../lib/strings.zsh"


set -x

function test::strings::join() {
  local _actual _expected
  _expected=".ip,.hostname"
  _actual=$(strings::join --prefix=. --delim=, ip hostname)
  [[ "${_expected}" == "${_actual}" ]]
}
test::strings::join
