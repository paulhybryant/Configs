#!/usr/bin/env zsh

source "../../lib/init.zsh"
source "../../lib/io.zsh"
source "../../lib/mode.zsh"
source "../../lib/shell.zsh"

set -x

function test::shell::eval() {
  local _cmd _expected _actual
  _cmd='echo "hello world"'
  _expected='echo "hello world"'
  _actual=$(shell::eval ${_cmd})
  [[ "${_expected}" == "${_actual}" ]]

  mode::toggle_dryrun
  _expected='hello world'
  _actual=$(shell::eval ${_cmd})
  [[ "${_expected}" == "${_actual}" ]]
}
test::shell::eval
