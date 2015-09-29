#!/usr/bin/env zsh

source "../../lib/init.zsh"
source "../../lib/mode.zsh"
source "../../lib/util.zsh"

set -x

function test::util::eval() {
  local _cmd _expected _actual
  _cmd='echo "hello world"'
  _expected='echo "hello world"'
  _actual=$(util::eval ${_cmd})
  [[ "${_expected}" == "${_actual}" ]]

  mode::toggle_dryrun
  _expected='hello world'
  _actual=$(util::eval ${_cmd})
  [[ "${_expected}" == "${_actual}" ]]
}
test::util::eval
