#!/usr/bin/env zsh

source "../../lib/init.zsh"
source "../../lib/base.zsh"
source "../../lib/strings.zsh"


set -x

function test::strings::join() {
  local _actual _expected _ignore
  _ignore=($(cat ./testdata/ignore.lst | xargs echo))
  _expected="io.zsh\|os.zsh"
  _actual=$(strings::join --delim='\|' ${_ignore})
  [[ "${_expected}" == "${_actual}" ]]
}
test::strings::join
