#!/usr/bin/env zsh

source "../../lib/init.zsh"
source "../../lib/base.zsh"
source "../../lib/strings.zsh"


set -x

function test::strings::join() {
  local _actual _expected
  _expected=".ip,.hostname"
  _actual=$(strings::join --prefix=. --delim=, ip hostname)
  [[ "${_expected}" == "${_actual}" ]]
}
test::strings::join
